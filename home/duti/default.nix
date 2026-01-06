{ pkgs, lib, ... }:
{
  home.packages = [ pkgs.duti ];

  home.activation."configureDutiAppDefaults" = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # Office
    duti -s com.adobe.Acrobat.Pro pdf all

    # Code
    duti -s com.microsoft.VSCode json all
    duti -s com.microsoft.VSCode html all
    duti -s com.microsoft.VSCode css all
    duti -s com.microsoft.VSCode py all
    duti -s com.microsoft.VSCode nix all
    duti -s com.microsoft.VSCode csv all

    # Images
    duti -s pl.maketheweb.cleanshotx jpg all
    duti -s pl.maketheweb.cleanshotx jpeg all
    duti -s pl.maketheweb.cleanshotx png all

    # Misc
    duti -s org.m0k.transmission torrent all
  '';
}
