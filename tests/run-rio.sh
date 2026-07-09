#!/usr/bin/env bash
# tests/run-rio.sh — verify the rio editable-config migration.
#
# 1. Run the hermetic nix test (expect "RESULT: ALL PASS").
# 2. Re-render config.toml from settings.legacy.nix and diff against the
#    committed native file (must be byte-identical).
# 3. Validate the committed native file parses as TOML.
set -euo pipefail


cd "$(dirname "$0")/.."
repo="$(pwd)"

echo "== 1/3: hermetic nix test =="
out="$(nix eval --raw -f tests/rio-editable.nix)"
echo "$out"
grep -q "RESULT: ALL PASS" <<<"$out" || { echo "FAIL: nix test did not report ALL PASS"; exit 1; }

echo
echo "== 2/3: re-render from settings.legacy.nix and diff =="
tmpjson="$(mktemp)"
tmptoml="$(mktemp --suffix=.toml)"
trap 'rm -f "$tmpjson" "$tmptoml"' EXIT
nix eval --impure --json --expr "(import ${repo}/home/rio/settings.legacy.nix).settings" >"$tmpjson"
python3 -c 'import json,tomli_w,tomllib,sys
d=json.load(open(sys.argv[1]))
open(sys.argv[2],"wb").write(tomli_w.dumps(d).encode())
tomllib.load(open(sys.argv[2],"rb"))' "$tmpjson" "$tmptoml"
# The committed config.toml is taplo-formatted, so canonicalise the fresh
# render the same way before comparing (keeps the diff byte-identical).
nix run nixpkgs#taplo -- fmt "$tmptoml" >/dev/null 2>&1
if diff -u home/rio/config.toml "$tmptoml"; then
  echo "OK: committed config.toml matches a fresh render"
else
  echo "FAIL: committed config.toml drifted from settings.legacy.nix"; exit 1
fi

echo
echo "== 3/3: validate committed config.toml parses =="
python3 -c 'import tomllib; tomllib.load(open("home/rio/config.toml","rb")); print("toml ok")'

echo
echo "ALL GREEN"
