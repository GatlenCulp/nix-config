#!/usr/bin/env bash
# Re-pin pkgs/uv to the latest upstream uv release.
#
# uv ships several releases a week; nixpkgs (even unstable) trails by a day or
# more, and nixpkgs-25.11 -- which this config actually evaluates against, since
# home-manager runs with useGlobalPkgs -- is frozen many minor versions behind.
# This script asks GitHub for the newest astral-sh/uv tag, records the official
# darwin tarballs + their published SHA-256 digests into sources.json, and
# leaves the result for `darwin-rebuild` to build. Same artifact Astral ships to
# `uv self update` users, just pinned so nix stays reproducible.
#
# Run it directly, or let `upgrade` (topgrade) call it -- see home/topgrade.
# Exits 0 with no changes when the pin is already current.
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

# Platforms to pin. Keys are nix system doubles, values are the corresponding
# rust target triple in Astral's asset names.
declare -a SYSTEMS=(aarch64-darwin x86_64-darwin)
declare -A TRIPLES=(
  [aarch64-darwin]=aarch64-apple-darwin
  [x86_64-darwin]=x86_64-apple-darwin
)

api="https://api.github.com/repos/astral-sh/uv/releases/latest"
# GITHUB_TOKEN lifts the 60 req/hr anonymous rate limit when one is present.
auth=()
[[ -n "${GITHUB_TOKEN:-}" ]] && auth=(-H "Authorization: Bearer ${GITHUB_TOKEN}")

latest="$(curl -fsSL "${auth[@]}" "$api" | jq -r .tag_name)"
if [[ -z "$latest" || "$latest" == "null" ]]; then
  echo "uv-update: could not resolve latest release from $api" >&2
  exit 1
fi

current="$(jq -r .version sources.json 2>/dev/null || echo "")"
if [[ "$latest" == "$current" ]]; then
  echo "uv-update: already at $current"
  exit 0
fi

echo "uv-update: $current -> $latest"

platforms="{}"
for sys in "${SYSTEMS[@]}"; do
  triple="${TRIPLES[$sys]}"
  url="https://github.com/astral-sh/uv/releases/download/${latest}/uv-${triple}.tar.gz"

  # Astral publishes a .sha256 sidecar per asset, so we take the digest from
  # upstream rather than downloading the tarball just to hash it ourselves.
  hex="$(curl -fsSL "${auth[@]}" "${url}.sha256" | awk '{print $1}')"
  if [[ ! "$hex" =~ ^[0-9a-f]{64}$ ]]; then
    echo "uv-update: bad sha256 for $sys: '$hex'" >&2
    exit 1
  fi
  # Done in python rather than via `nix hash`: Lix spells it `to-sri` while
  # upstream Nix spells it `convert --to sri`, and this script has to run under
  # both (Lix locally, whatever the CI runner installs).
  sri="sha256-$(python3 -c \
    'import base64,binascii,sys; print(base64.b64encode(binascii.unhexlify(sys.argv[1])).decode())' \
    "$hex")"

  platforms="$(jq --arg sys "$sys" --arg url "$url" --arg hash "$sri" \
    '.[$sys] = {url: $url, hash: $hash}' <<<"$platforms")"
done

jq -n --arg version "$latest" --argjson platforms "$platforms" \
  '{version: $version, platforms: $platforms}' >sources.json

echo "uv-update: wrote sources.json for $latest"
