#!/bin/bash
# Script to fix Nix registry to prevent unnecessary copying of nixpkgs to store
# Based on https://github.com/NixOS/nix/issues/11228

echo "Fixing Nix registry to prevent unnecessary store copying..."

# Get the current nixpkgs path from the flake lock
NIXPKGS_REV=$(nix flake metadata --json ~/.config/nix-darwin | jq -r '.locks.nodes.nixpkgs.locked.rev')
NIXPKGS_NARH=$(nix flake metadata --json ~/.config/nix-darwin | jq -r '.locks.nodes.nixpkgs.locked.narHash')

if [ -z "$NIXPKGS_REV" ] || [ -z "$NIXPKGS_NARH" ]; then
    echo "Error: Could not extract nixpkgs revision or narHash from flake.lock"
    exit 1
fi

echo "Found nixpkgs revision: $NIXPKGS_REV"
echo "Found nixpkgs narHash: $NIXPKGS_NARH"

# Update the user registry to use the flake reference instead of path
echo "Updating nix registry..."
nix registry pin nixpkgs "github:NixOS/nixpkgs/$NIXPKGS_REV"

echo "Registry updated. The copying issue should be reduced."
echo ""
echo "Additional steps you can try if the issue persists:"
echo "1. Clear Nix eval cache: rm -rf ~/.cache/nix"
echo "2. Use the optimized flake: mv flake.nix flake.nix.backup && mv flake-optimized.nix flake.nix"
echo "3. Run: darwin-rebuild switch --flake ~/.config/nix-darwin"