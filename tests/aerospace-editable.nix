# tests/aerospace-editable.nix — run: nix eval --raw -f tests/aerospace-editable.nix
#
# Hermetic unit test for the aerospace "editable config via mkOutOfStoreSymlink"
# migration. Imports the aerospace home module as a plain function with a mocked
# `config`/`lib`, so it needs only the Nix evaluator — no home-manager, no
# nix-darwin, no flake inputs, no network. Runnable on Linux CI even though the
# real system config is darwin-only.
let
  homeDir = "/home/gattest";
  flakeDir = "${homeDir}/.config/nix-config";
  mockConfig = {
    home.homeDirectory = homeDir;
    lib.file.mkOutOfStoreSymlink = path: {
      __sym = true;
      target = toString path;
    };
  };
  mockArgs = {
    config = mockConfig;
    pkgs = {
      stdenv.hostPlatform.isDarwin = true;
    };
    lib = {
      mkForce = x: x;
      mkIf = _c: x: x;
      optional = _c: _x: [ ];
      optionals = _c: _x: [ ];
    };
    self = null;
    inputs = { };
  };
  m = import ../home/aerospace/default.nix mockArgs;
  try =
    e:
    let
      r = builtins.tryEval e;
    in
    if r.success then r.value else null;
  entry = (m.xdg.configFile or { })."aerospace/aerospace.toml" or null;
  target = try (entry.source.target or null);
  expected = "${flakeDir}/home/aerospace/aerospace.toml";
  progs = (m.programs.aerospace or { });
  settingsGone = !(progs ? userSettings);
  enableKept = (progs.enable or false) == true;
  launchdKept = (progs.launchd.enable or false) == true;
  pip = (m.xdg.configFile or { })."aerospace/pip-move.sh" or null;
  pipKept = pip != null && (try (pip.executable or false)) == true;
  checks = [
    {
      name = "aerospace: aerospace/aerospace.toml is an out-of-store symlink to the repo native file";
      ok = target == expected;
      detail = "got=${toString target} expected=${expected}";
    }
    {
      name = "aerospace: Nix no longer generates the config (userSettings removed)";
      ok = settingsGone;
      detail = "removed=${toString settingsGone}";
    }
    {
      name = "aerospace: programs.aerospace.enable kept true";
      ok = enableKept;
      detail = "enable=${toString enableKept}";
    }
    {
      name = "aerospace: programs.aerospace.launchd.enable kept true";
      ok = launchdKept;
      detail = "launchd=${toString launchdKept}";
    }
    {
      name = "aerospace: pip-move.sh still managed by Nix (untouched)";
      ok = pipKept;
      detail = "pipKept=${toString pipKept}";
    }
  ];
  fmt =
    c:
    "  [${if c.ok then "PASS" else "FAIL"}] ${c.name}"
    + (if c.ok || c.detail == "" then "" else "\n         ${c.detail}");
  lines = builtins.concatStringsSep "\n" (map fmt checks);
  passed = builtins.length (builtins.filter (c: c.ok) checks);
in
lines
+ "\n\n${toString passed}/${toString (builtins.length checks)} passed"
+ (if passed == builtins.length checks then "\nRESULT: ALL PASS" else "\nRESULT: SOME FAIL")
