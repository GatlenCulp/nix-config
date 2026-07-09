# Hermetic test for the cmux + orca additions. Runs on `nix eval` only
# (mocked config, no home-manager/darwin/network).
#
#   nix eval --raw -f tests/cmux-editable.nix
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

  cmux = import ../home/cmux/default.nix { config = mockConfig; };
  brew = (import ../modules/darwin/homebrew.nix).homebrew;

  try =
    e:
    let
      r = builtins.tryEval e;
    in
    if r.success then r.value else null;

  entry = (cmux.xdg.configFile or { })."cmux/cmux.json" or null;
  target = try (entry.source.target or null);
  expected = "${flakeDir}/home/cmux/cmux.json";

  has = xs: x: builtins.elem x xs;

  checks = [
    {
      name = "cmux: ~/.config/cmux/cmux.json is an out-of-store symlink to the repo";
      ok = target == expected;
      detail = "got=${toString target} expected=${expected}";
    }
    {
      name = "cmux: symlink uses force=true (cmux rewrites the file at runtime)";
      ok = (try (entry.force or false)) == true;
      detail = "";
    }
    {
      name = "homebrew: cmux cask present";
      ok = has brew.casks "manaflow-ai/cmux/cmux";
      detail = "";
    }
    {
      name = "homebrew: orca cask present";
      ok = has brew.casks "stablyai/orca/orca";
      detail = "";
    }
    {
      name = "homebrew: manaflow-ai/cmux tap present";
      ok = has brew.taps "manaflow-ai/cmux";
      detail = "";
    }
    {
      name = "homebrew: stablyai/orca tap present";
      ok = has brew.taps "stablyai/orca";
      detail = "";
    }
  ];

  fmt =
    c:
    "  [${if c.ok then "PASS" else "FAIL"}] ${c.name}"
    + (if c.ok || c.detail == "" then "" else "\n         ${c.detail}");
  lines = builtins.concatStringsSep "\n" (map fmt checks);
  passed = builtins.length (builtins.filter (c: c.ok) checks);
  total = builtins.length checks;
in
lines
+ "\n\n${toString passed}/${toString total} passed"
+ (if passed == total then "\nRESULT: ALL PASS" else "\nRESULT: SOME FAIL")
