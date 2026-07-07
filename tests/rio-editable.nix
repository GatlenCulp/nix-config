# tests/rio-editable.nix — run: nix eval --raw -f tests/rio-editable.nix
#
# Hermetic unit test for the rio "editable config via mkOutOfStoreSymlink"
# migration. Imports home/rio/default.nix as a plain function with a mocked
# `config`/`lib`/`pkgs`, so it needs only the Nix evaluator — no home-manager,
# no nix-darwin, no flake inputs, no network (runnable on Linux CI).
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
  m = import ../home/rio/default.nix mockArgs;
  try =
    e:
    let
      r = builtins.tryEval e;
    in
    if r.success then r.value else null;

  entry = (m.xdg.configFile or { })."rio/config.toml" or null;
  target = try (entry.source.target or null);
  expected = "${flakeDir}/home/rio/config.toml";

  progs = (m.programs.rio or { });
  settingsGone = !(progs ? settings);
  # rio stays disabled today; assert we preserved that (parity, no file written
  # by HM ⇒ no lib.mkForce needed on the symlink).
  stillDisabled = (progs.enable or true) == false;

  checks = [
    {
      name = "rio: rio/config.toml is an out-of-store symlink to the repo native file";
      ok = target == expected;
      detail = "got=${toString target} expected=${expected}";
    }
    {
      name = "rio: Nix no longer generates the config (settings removed)";
      ok = settingsGone;
      detail = "removed=${toString settingsGone}";
    }
    {
      name = "rio: module stays disabled (enable == false, parity with prior config)";
      ok = stillDisabled;
      detail = "disabled=${toString stillDisabled}";
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
