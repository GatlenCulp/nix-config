#!/usr/bin/env bash
# tests/run-fastfetch.sh — verify the fastfetch live-editable migration.
#
# 1. Runs the hermetic nix eval test (expects "RESULT: ALL PASS").
# 2. Re-renders config.jsonc from settings.legacy.nix (applying the same
#    logo.source absolute-path rewrite) and diffs it against the committed
#    native file — they must be identical.
# 3. Validates the committed native file parses as JSON.
set -euo pipefail

export NIX_SSL_CERT_FILE="${NIX_SSL_CERT_FILE:-/root/.ccr/ca-bundle.crt}"

# Resolve repo root (parent of this script's dir).
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$ROOT"

GOOSE_ABS="/Users/gat/.config/nix-config/home/fastfetch/goose.txt"

echo "== 1. hermetic nix eval test =="
OUT="$(nix eval --raw -f tests/fastfetch-editable.nix)"
echo "$OUT"
if ! grep -q "RESULT: ALL PASS" <<<"$OUT"; then
  echo "FAIL: hermetic test did not report ALL PASS" >&2
  exit 1
fi

echo
echo "== 2. re-render from settings.legacy.nix and diff =="
TMP_JSON="$(mktemp)"
TMP_RENDER="$(mktemp)"
trap 'rm -f "$TMP_JSON" "$TMP_RENDER"' EXIT
nix eval --impure --json --expr 'import ./home/fastfetch/settings.legacy.nix' > "$TMP_JSON"
jq --arg goose "$GOOSE_ABS" '.logo.source = $goose' "$TMP_JSON" > "$TMP_RENDER"
if ! diff -u home/fastfetch/config.jsonc "$TMP_RENDER"; then
  echo "FAIL: committed config.jsonc differs from re-render of settings.legacy.nix" >&2
  exit 1
fi
echo "OK: committed config.jsonc matches re-render"

echo
echo "== 3. validate native file parses as JSON =="
jq . home/fastfetch/config.jsonc > /dev/null
echo "OK: config.jsonc is valid JSON"

echo
echo "ALL GREEN"
