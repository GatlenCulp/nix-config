# tests/machine-profiles.nix
#
# Evaluation tests for the personal (gatty) / work machine-profile split.
# Run with `nix flake check` on the Mac (the configs are aarch64-darwin and pull
# the local git+file: inputs, so they can't be evaluated in the Linux CI box).
#
# Each assertion below reads a value straight out of the *evaluated* darwin
# configuration, so the whole thing doubles as a smoke test: if any profile
# fails to evaluate, the check fails. What we prove:
#   * all three hosts (gatty / work / server) evaluate
#   * git identity is wired per-host
#   * the `rebuild` alias targets the correct flake attr per machine
#   * Homebrew is MDM-safe on work (cleanup = "none") but zaps on personal
#   * work strips personal apps (spotify) while keeping shared dev tooling (uv)
{
  self,
  pkgs,
  lib,
}:
let
  cfgOf = name: self.darwinConfigurations.${name}.config;
  # The home-manager user config for a host, resolved via its own primaryUser
  # so this keeps working after the work username is filled in.
  hmOf =
    name:
    let
      c = cfgOf name;
    in
    c.home-manager.users.${c.system.primaryUser};

  gattyHM = hmOf "gatty";
  workHM = hmOf "work";

  assertions = [
    # ── all three hosts evaluate ────────────────────────────────────────────
    {
      name = "gatty evaluates with primaryUser gat";
      cond = (cfgOf "gatty").system.primaryUser == "gat";
    }
    {
      name = "work evaluates and exposes a primaryUser";
      cond = builtins.isString (cfgOf "work").system.primaryUser;
    }
    {
      name = "server evaluates (compat shim intact)";
      cond = (cfgOf "server").system.primaryUser == "gat";
    }

    # ── git identity is wired per host ──────────────────────────────────────
    {
      name = "gatty git email is the personal address";
      cond = gattyHM.programs.git.settings.user.email == "GatlenCulp@gmail.com";
    }
    {
      name = "work git email is set (placeholder until work address issued)";
      cond = workHM.programs.git.settings.user.email == "GatlenCulp@gmail.com";
    }
    {
      name = "git name is set on both hosts";
      cond =
        gattyHM.programs.git.settings.user.name == "GatlenCulp"
        && workHM.programs.git.settings.user.name == "GatlenCulp";
    }

    # ── rebuild alias targets the right flake attr per machine ──────────────
    {
      name = "gatty rebuild alias targets #gatty";
      cond = lib.hasInfix "nix-config#gatty" gattyHM.home.sessionVariables.rebuild;
    }
    {
      name = "work rebuild alias targets #work";
      cond = lib.hasInfix "nix-config#work" workHM.home.sessionVariables.rebuild;
    }

    # ── Homebrew: personal zaps, work is MDM-safe ───────────────────────────
    {
      name = "gatty Homebrew cleanup = zap";
      cond = (cfgOf "gatty").homebrew.onActivation.cleanup == "zap";
    }
    {
      name = "work Homebrew cleanup = none (never removes MDM-managed apps)";
      cond = (cfgOf "work").homebrew.onActivation.cleanup == "none";
    }

    # ── module divergence: personal apps stripped on work ───────────────────
    {
      name = "gatty includes spotify (personal media)";
      cond = gattyHM.programs.spotify-player.enable == true;
    }
    {
      name = "work excludes spotify";
      cond = workHM.programs.spotify-player.enable == false;
    }

    # ── shared dev tooling retained on both ─────────────────────────────────
    {
      name = "gatty keeps python/uv tooling";
      cond = gattyHM.programs.uv.enable == true;
    }
    {
      name = "work keeps python/uv tooling";
      cond = workHM.programs.uv.enable == true;
    }
  ];

  failures = builtins.filter (a: !a.cond) assertions;
  failureReport = lib.concatMapStringsSep "\n" (a: "  ✗ ${a.name}") failures;
  passCount = toString (builtins.length assertions - builtins.length failures);
  total = toString (builtins.length assertions);
in
pkgs.runCommand "machine-profiles-tests"
  {
    passthru.failures = failures;
  }
  (
    if failures == [ ] then
      ''
        echo "machine-profiles: ${passCount}/${total} assertions passed"
        touch $out
      ''
    else
      ''
        echo "machine-profiles: ${passCount}/${total} assertions passed — FAILURES:"
        echo "${failureReport}"
        exit 1
      ''
  )
