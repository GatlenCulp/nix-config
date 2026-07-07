# tests/ruff-editable.nix — run: nix eval --raw -f tests/ruff-editable.nix
#
# Hermetic unit test for the ruff "editable config via mkOutOfStoreSymlink"
# migration. Imports the ruff home module as a plain function with a mocked
# `config`/`lib`, so it needs only the Nix evaluator (no home-manager, no
# nix-darwin, no flake inputs, no network) and runs on Linux CI.
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
  m = import ../home/ruff/default.nix mockArgs;
  try =
    e:
    let
      r = builtins.tryEval e;
    in
    if r.success then r.value else null;
  entry = (m.xdg.configFile or { })."ruff/ruff.toml" or null;
  target = try (entry.source.target or null);
  expected = "${flakeDir}/home/ruff/ruff.toml";
  progs = (m.programs.ruff or { });
  enabledKept = (progs.enable or false) == true;
  settingsGone = !(progs ? settings);
  checks = [
    {
      name = "ruff: ruff/ruff.toml is an out-of-store symlink to the repo native file";
      ok = target == expected;
      detail = "got=${toString target} expected=${expected}";
    }
    {
      name = "ruff: Nix no longer generates the config (settings removed)";
      ok = settingsGone;
      detail = "removed=${toString settingsGone}";
    }
    {
      name = "ruff: program stays enabled (package / integrations preserved)";
      ok = enabledKept;
      detail = "enable=${toString enabledKept}";
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
