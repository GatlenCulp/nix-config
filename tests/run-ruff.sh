#!/usr/bin/env bash
# Runs the ruff editable-config migration tests. Exits non-zero if any check
# fails, if the committed native TOML drifts from settings.legacy.nix, or if
# the native file does not parse. Needs only `nix` + `python3` (no network).
set -uo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
repo="$(cd "$here/.." && pwd)"

: "${NIX_SSL_CERT_FILE:=/root/.ccr/ca-bundle.crt}"
export NIX_SSL_CERT_FILE

fail=0

echo "== ruff editable-config unit test =="
out="$(nix eval --raw -f "$here/ruff-editable.nix" 2>&1)"
rc=$?
echo "$out"
echo
if [ $rc -ne 0 ]; then
  echo "RESULT: EVAL ERROR (rc=$rc)"
  fail=1
elif ! printf '%s\n' "$out" | grep -q "RESULT: ALL PASS"; then
  fail=1
fi

echo "== re-render from settings.legacy.nix and diff against committed ruff.toml =="
# Render legacy Nix -> JSON -> TOML, then normalise the fresh render with the
# same formatter used on the committed file (taplo) so the diff compares
# content, not whitespace/array-wrapping style. taplo is idempotent, so a
# content-identical config yields a byte-identical file.
tmpjson="$(mktemp)"
tmptoml="$(mktemp --suffix=.toml)"
if nix eval --impure --json --expr "import $repo/home/ruff/settings.legacy.nix" > "$tmpjson" 2>&1; then
  python3 -c 'import json,tomli_w,sys; d=json.load(open(sys.argv[1])); open(sys.argv[2],"wb").write(tomli_w.dumps(d).encode())' "$tmpjson" "$tmptoml"
  nix run nixpkgs#taplo -- fmt "$tmptoml" >/dev/null 2>&1 || true
  if diff -u "$repo/home/ruff/ruff.toml" "$tmptoml"; then
    echo "  [PASS] committed ruff.toml matches a fresh render of settings.legacy.nix"
  else
    echo "  [FAIL] ruff.toml drifted from settings.legacy.nix"
    fail=1
  fi
else
  echo "  [FAIL] could not eval settings.legacy.nix"
  cat "$tmpjson"
  fail=1
fi

echo "== validate committed ruff.toml parses =="
if python3 -c 'import tomllib,sys; tomllib.load(open(sys.argv[1],"rb")); print("  [PASS] ruff.toml is valid TOML")' "$repo/home/ruff/ruff.toml"; then
  :
else
  echo "  [FAIL] ruff.toml is not valid TOML"
  fail=1
fi

rm -f "$tmpjson" "$tmptoml"
echo
if [ $fail -eq 0 ]; then
  echo "RESULT: ALL PASS"
  exit 0
fi
echo "RESULT: SOME FAIL"
exit 1
