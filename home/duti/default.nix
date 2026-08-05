{ pkgs, lib, ... }:
let
  # Declarative file association mappings: bundleId -> [extensions]
  associations = {
    "com.adobe.Acrobat.Pro" = [ "pdf" ];
    "io.mpv" = [
      "mp4"
      "mkv"
      "mov"
      "webm"
      "m4v"
      "avi"
      "flv"
      "wmv"
    ];
    "com.microsoft.VSCode" = [
      "json"
      # Do NOT put "html" here: `duti -s ... html all` sets VSCode as handler
      # for the `public.html` UTI in ALL roles, which macOS then promotes to
      # the http/https URL scheme handler — VSCode ends up being the default
      # browser and OAuth flows (e.g. Notion Calendar's "Sign in with Google")
      # try to open in VSCode. `urlSchemes` below explicitly re-pins http/https
      # to Chrome to defend against similar future breakage.
      "css"
      "py"
      "nix"
      "csv"
      "md"
      "js"
      "ts"
      "tsx"
      "jsx"
      "xml"
      "yaml"
      "yml"
      "toml"
      "sh"
      "log"
      "txt"
      "sql"
      "ipynb"
    ];
    "pl.maketheweb.cleanshotx" = [
      "jpg"
      "jpeg"
      "png"
      "heic"
      "gif"
      "webp"
      "tiff"
      "bmp"
      "svg"
    ];
    "org.m0k.transmission" = [ "torrent" ];
    "com.microsoft.Word" = [ "docx" "doc" ];
    "com.microsoft.Excel" = [ "xlsx" "xls" ];
    "com.microsoft.Powerpoint" = [ "pptx" "ppt" ];
    # Notion Calendar's bundle ID is still `com.cron.electron` (from its Cron origins).
    "com.cron.electron" = [ "ics" ];
    "com.lutzroeder.netron" = [
      "onnx"
      "pb"
      "tflite"
      "h5"
      "pt"
    ];
    # `.command` is a macOS-specific "run in Terminal" shell script.
    "com.mitchellh.ghostty" = [ "command" ];
    "com.eteks.sweethome3d.SweetHome3D" = [ "sh3d" "sh3f" ];
  };

  # URL scheme handlers: bundleId -> [schemes]. `duti -s <bundle> <scheme>`
  # sets the default app for a URL scheme (2-arg form, no role). Pinning
  # http/https keeps the default browser stable — otherwise a stray `all`-role
  # association (see the "html" warning above) can silently hijack it.
  urlSchemes = {
    "com.google.Chrome" = [
      "http"
      "https"
    ];
  };

  # Generate duti commands from associations.
  # Each mapping is wrapped so a single failure (e.g. an extension whose UTI
  # isn't registered with LaunchServices because no installed app declares
  # support for it) does not abort the activation script and emits a readable
  # warning instead of the cryptic `error -50` / `error -10822` from duti.
  mkDutiCommands =
    associations:
    lib.concatStringsSep "\n" (
      lib.flatten (
        lib.mapAttrsToList (
          bundleId: exts:
          map (ext: ''
            if ! ${pkgs.duti}/bin/duti -s ${bundleId} ${ext} all >/dev/null 2>&1; then
              echo "warning: duti could not associate .${ext} with ${bundleId} (no LaunchServices UTI registered for this extension; skipping)"
            fi
          '') exts
        ) associations
      )
    );

  mkDutiSchemeCommands =
    schemes:
    lib.concatStringsSep "\n" (
      lib.flatten (
        lib.mapAttrsToList (
          bundleId: schemeList:
          map (scheme: ''
            if ! ${pkgs.duti}/bin/duti -s ${bundleId} ${scheme} >/dev/null 2>&1; then
              echo "warning: duti could not set ${bundleId} as ${scheme}:// handler (app may not be installed; skipping)"
            fi
          '') schemeList
        ) schemes
      )
    );
in
{
  home.packages = [ pkgs.duti ];

  home.activation."configureDutiAppDefaults" = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${mkDutiCommands associations}
    ${mkDutiSchemeCommands urlSchemes}
  '';
}
