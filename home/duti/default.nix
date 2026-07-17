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
      "html"
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
in
{
  home.packages = [ pkgs.duti ];

  home.activation."configureDutiAppDefaults" = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${mkDutiCommands associations}
  '';
}
