# uv, pinned to the newest upstream release rather than whatever the channel
# carries. See ./update.sh for the why and for how sources.json is refreshed.
#
# This is Astral's own prebuilt binary (the exact artifact `uv self update`
# would fetch), so there is nothing to compile and no wait on a nixpkgs bump --
# the same trade the claude-code-nix input makes for `claude`.
{
  lib,
  stdenvNoCC,
  fetchurl,
  installShellFiles,
}:
let
  sources = lib.importJSON ./sources.json;
  inherit (stdenvNoCC.hostPlatform) system;
  source =
    sources.platforms.${system}
      or (throw "pkgs/uv: no pinned uv binary for ${system}; add it to update.sh");
in
stdenvNoCC.mkDerivation {
  pname = "uv";
  version = sources.version;

  src = fetchurl { inherit (source) url hash; };

  nativeBuildInputs = [ installShellFiles ];

  # Tarball is just `uv-<triple>/{uv,uvx}` -- no build step, only install.
  installPhase = ''
    runHook preInstall
    install -Dm755 uv "$out/bin/uv"
    install -Dm755 uvx "$out/bin/uvx"
    runHook postInstall
  '';

  # Completions come from the binary itself, so they can only be generated on a
  # machine that can execute it (i.e. not when cross-building).
  postInstall = lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
    installShellCompletion --cmd uv \
      --bash <("$out/bin/uv" generate-shell-completion bash) \
      --fish <("$out/bin/uv" generate-shell-completion fish) \
      --zsh  <("$out/bin/uv" generate-shell-completion zsh)
    installShellCompletion --cmd uvx \
      --bash <("$out/bin/uvx" --generate-shell-completion bash) \
      --fish <("$out/bin/uvx" --generate-shell-completion fish) \
      --zsh  <("$out/bin/uvx" --generate-shell-completion zsh)
  '';

  doInstallCheck = stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform;
  installCheckPhase = ''
    runHook preInstallCheck
    # Guards against a sources.json whose version and tarball disagree.
    "$out/bin/uv" --version | grep -qF "${sources.version}"
    runHook postInstallCheck
  '';

  meta = {
    description = "Extremely fast Python package installer and resolver, written in Rust";
    homepage = "https://github.com/astral-sh/uv";
    changelog = "https://github.com/astral-sh/uv/releases/tag/${sources.version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "uv";
    platforms = builtins.attrNames sources.platforms;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
