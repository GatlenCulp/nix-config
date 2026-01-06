# This module extends home.file, xdg.configFile and xdg.dataFile with the `mutable` option.
# This will overwrite the file in its place but allows you to mess with the config.
# xdg.configFile is just a shorthand for home.file with the XDG home prefix https://www.reddit.com/r/NixOS/comments/1gh6fh3/xdgconfigfile_vs_homefile_home_manager/
# To symlink instead config.lib.file.mkOutOfStoreSymlink -- https://www.reddit.com/r/NixOS/comments/u09cz9/home_manager_create_my_own_symlinks_automatically/
{ config, lib, ... }:
let
  fileOptionAttrPaths = [
    [
      "home"
      "file"
    ]
    [
      "xdg"
      "configFile"
    ]
    [
      "xdg"
      "dataFile"
    ]
  ];
in
{
  options =
    let

      # mergeAttrsList = builtins.foldl' (lib.mergeAttrs) { };
      mergeAttrsList = builtins.foldl' (lib.recursiveUpdate) { };

      fileAttrsType = lib.types.attrsOf (
        lib.types.submodule (
          { config, ... }:
          {
            options.mutable = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Whether to copy the file without the read-only attribute instead of
                symlinking. If you set this to `true`, you must also set `force` to
                `true`. Mutable files are not removed when you remove them from your
                configuration.

                This option is useful for programs that don't have a very good
                support for read-only configurations.
              '';
            };
          }
        )
      );

    in
    mergeAttrsList (
      map (
        attrPath: lib.setAttrByPath attrPath (lib.mkOption { type = fileAttrsType; })
      ) fileOptionAttrPaths
    );

  config = {
    home.activation.mutableFileGeneration =
      let

        allFiles = (
          builtins.concatLists (
            map (attrPath: builtins.attrValues (lib.getAttrFromPath attrPath config)) fileOptionAttrPaths
          )
        );

        filterMutableFiles = builtins.filter (
          file:
          (file.mutable or false)
          && lib.assertMsg file.force "if you specify `mutable` to `true` on a file, you must also set `force` to `true`"
        );

        mutableFiles = filterMutableFiles allFiles;

        toCommand = (
          file:
          let
            source = lib.escapeShellArg file.source;
            target = lib.escapeShellArg file.target;
          in
          ''
            $VERBOSE_ECHO "${source} -> ${target}"
            $DRY_RUN_CMD cp --remove-destination --no-preserve=mode ${source} ${target}
          ''
        );

        command = ''
          echo "Copying mutable home files for $HOME"
        ''
        + lib.concatLines (map toCommand mutableFiles);

      in
      (lib.hm.dag.entryAfter [ "linkGeneration" ] command);
  };
}
