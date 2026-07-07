#!/usr/bin/env bash
# tests/run-zellij.sh — verify the zellij layouts dir is a live-editable out-of-store symlink.
set -euo pipefail

export NIX_SSL_CERT_FILE="${NIX_SSL_CERT_FILE:-/root/.ccr/ca-bundle.crt}"

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

echo "== zellij: hermetic symlink test =="
out="$(nix eval --raw -f tests/zellij-editable.nix)"
echo "$out"
if ! grep -q "RESULT: ALL PASS" <<<"$out"; then
  echo "FAILED: hermetic test did not report ALL PASS" >&2
  exit 1
fi

echo
echo "== zellij: layouts dir exists in repo =="
if [[ ! -d home/zellij/layouts ]]; then
  echo "FAILED: home/zellij/layouts is missing" >&2
  exit 1
fi
echo "OK: home/zellij/layouts present"

echo
echo "ALL GOOD"
