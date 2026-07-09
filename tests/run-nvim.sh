#!/usr/bin/env bash
# Run the hermetic nixvim -> lazy.nvim migration tests.
# Needs only the Nix evaluator (no flake inputs, no network).
set -euo pipefail
cd "$(dirname "$0")/.."

out="$(nix eval --raw -f tests/nvim-editable.nix)"
echo "$out"
echo
if [[ "$out" == *"RESULT: ALL PASS"* ]]; then
  exit 0
else
  exit 1
fi
