#!/usr/bin/env bash
# tests/run-starship.sh — verify the starship editable-config migration.
#
# 1. runs the hermetic nix eval test (expects "RESULT: ALL PASS")
# 2. re-renders starship.toml from settings.legacy.nix and diffs it against the
#    committed native file (must be byte-identical)
# 3. validates the committed native file parses as TOML
set -euo pipefail

export NIX_SSL_CERT_FILE="${NIX_SSL_CERT_FILE:-/root/.ccr/ca-bundle.crt}"

# repo root = parent of this script's dir
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${ROOT}"

NATIVE="home/starship/starship.toml"
LEGACY="home/starship/settings.legacy.nix"
TMPDIR_R="$(mktemp -d)"
trap 'rm -rf "${TMPDIR_R}"' EXIT

echo "== 1. hermetic nix eval test =="
OUT="$(nix eval --raw -f tests/starship-editable.nix)"
echo "${OUT}"
if ! grep -q "RESULT: ALL PASS" <<<"${OUT}"; then
  echo "FAIL: hermetic test did not report ALL PASS" >&2
  exit 1
fi

echo
echo "== 2. re-render from legacy and diff against committed native =="
nix eval --impure --json --expr "import ./${LEGACY}" > "${TMPDIR_R}/starship.json"
python3 -c 'import json,tomli_w,sys; d=json.load(open(sys.argv[1])); open(sys.argv[2],"wb").write(tomli_w.dumps(d).encode())' \
  "${TMPDIR_R}/starship.json" "${TMPDIR_R}/starship.toml"
# Normalize the fresh render through taplo (the committed file's canonical
# format) so the diff compares content, not tomli_w vs taplo array styling.
nix run nixpkgs#taplo -- fmt "${TMPDIR_R}/starship.toml" >/dev/null 2>&1
if diff -u "${NATIVE}" "${TMPDIR_R}/starship.toml"; then
  echo "OK: committed ${NATIVE} matches a fresh render of ${LEGACY}"
else
  echo "FAIL: ${NATIVE} is out of sync with ${LEGACY}" >&2
  exit 1
fi

echo
echo "== 3. validate native file parses as TOML =="
python3 -c 'import tomllib,sys; tomllib.load(open(sys.argv[1],"rb")); print("OK: valid TOML")' "${NATIVE}"

echo
echo "ALL GREEN"
