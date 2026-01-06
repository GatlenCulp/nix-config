{ pkgs, lib, ... }:
let
  # Declarative file association mappings: bundleId -> [extensions]
  associations = {
    "com.adobe.Acrobat.Pro" = [ "pdf" ];
    "com.microsoft.VSCode" = [
      "json"
      "html"
      "css"
      "py"
      "nix"
      "csv"
    ];
    "pl.maketheweb.cleanshotx" = [
      "jpg"
      "jpeg"
      "png"
    ];
    "org.m0k.transmission" = [ "torrent" ];
  };

  # Generate duti commands from associations
  mkDutiCommands =
    associations:
    lib.concatStringsSep "\n" (
      lib.flatten (
        lib.mapAttrsToList (
          bundleId: exts: map (ext: "${pkgs.duti}/bin/duti -s ${bundleId} ${ext} all") exts
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
