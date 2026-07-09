#!/usr/bin/env bash
# Aggregate test/lint runner for CI and local use.
#
# What it CAN check on a Linux runner (no macOS, no secrets, and flake.nix has
# local-path inputs, so `nix flake check` / `darwin-rebuild` are out of reach):
#   [1] every *.nix file parses                             (blocking)
#   [2] the hermetic test suite (tests/run*.sh) passes      (blocking)
#   [3] nixfmt formatting                                   (advisory only)
#
# The hermetic tests are the real "does it work as intended" signal: they
# evaluate the home-manager modules with a mocked config and assert the
# mkOutOfStoreSymlink wiring, that Nix no longer generates the migrated files,
# that each rendered native config round-trips from its *.legacy.nix source,
# and that homebrew casks/taps are declared.
#
# Requirements: nix (flakes enabled), jq, and python3 with `tomli_w`
# (for the TOML render-match checks). Formatters are fetched via `nix run`.
set -uo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root="$(cd "$here/.." && pwd)"
cd "$root"

# Only keep a caller-provided NIX_SSL_CERT_FILE if it actually exists; otherwise
# leave it unset so nix falls back to nix.conf / the system trust store.
if [ -n "${NIX_SSL_CERT_FILE:-}" ] && [ ! -e "${NIX_SSL_CERT_FILE}" ]; then
  unset NIX_SSL_CERT_FILE
fi

rc=0
bar() { printf '\n\033[1m== %s ==\033[0m\n' "$1"; }

# ---- [1] parse every .nix (blocking) --------------------------------------
bar "[1/3] nix parse — all .nix files"
mapfile -t nixfiles < <(find . -path ./.git -prune -o -name '*.nix' -print | sort)
parse_fail=0
for f in "${nixfiles[@]}"; do
  if ! err="$(nix-instantiate --parse "$f" 2>&1 >/dev/null)"; then
    echo "  PARSE FAIL: $f"
    printf '%s\n' "$err" | sed 's/^/      /'
    parse_fail=1
  fi
done
if [ "$parse_fail" -eq 0 ]; then
  echo "  ${#nixfiles[@]} files parse OK"
else
  rc=1
fi

# ---- [2] hermetic test runners (blocking) ---------------------------------
bar "[2/3] hermetic test runners — tests/run*.sh"
shopt -s nullglob
runners=("$here"/run*.sh)
if [ "${#runners[@]}" -eq 0 ]; then
  echo "  no test runners found"
else
  for r in "${runners[@]}"; do
    b="$(basename "$r")"
    [ "$b" = "ci.sh" ] && continue
    printf '  --- %s ---\n' "$b"
    if bash "$r" > "/tmp/$b.log" 2>&1; then
      echo "      PASS"
    else
      echo "      FAIL (output below)"
      sed 's/^/        /' "/tmp/$b.log"
      rc=1
    fi
  done
fi

# ---- [3] nixfmt formatting (advisory, never fails the build) ---------------
bar "[3/3] nixfmt --check (advisory)"
if unformatted="$(nix run nixpkgs#nixfmt-rfc-style -- --check "${nixfiles[@]}" 2>&1 >/dev/null)"; then
  echo "  all ${#nixfiles[@]} files are nixfmt-clean"
else
  n="$(printf '%s\n' "$unformatted" | grep -c 'not formatted')"
  echo "  advisory: ${n} file(s) are not nixfmt-formatted (not blocking CI):"
  printf '%s\n' "$unformatted" | grep 'not formatted' | sed 's/^/      /'
fi

printf '\n'
if [ "$rc" -eq 0 ]; then
  echo "CI RESULT: ALL PASS"
else
  echo "CI RESULT: FAILURES (see [1]/[2] above)"
fi
exit "$rc"
