{ self, config }:
let
  # Dracula Color Palette
  # https://draculatheme.com/contribute
  dracula = {
    background = "#282a36";
    currentLine = "#44475a";
    selection = "#44475a";
    foreground = "#f8f8f2";
    comment = "#6272a4";
    cyan = "#8be9fd";
    green = "#50fa7b";
    orange = "#ffb86c";
    pink = "#ff79c6";
    purple = "#bd93f9";
    red = "#ff5555";
    yellow = "#f1fa8c";
    # Additional variants with transparency
    withAlpha = alpha: color: "${color}${alpha}";
  };

  profiles = {
    themes = {
      "material-icon-theme.activeIconPack" = "react";
      "material-icon-theme.files.color" = "#90a4ae";
      "material-icon-theme.hidesExplorerArrows" = true;
      "material-icon-theme.opacity" = 1;
      "workbench.colorCustomizations" = {
        "titleBar.activeBackground" = "#692E33";
      };
      "workbench.colorTheme" = "Dracula Theme";
      "workbench.iconTheme" = "material-icon-theme";
      "workbench.productIconTheme" = "material-product-icons";
    };

    general = {
      "chat.mcp.gallery.enabled" = true;
      "cSpell.customDictionaries" = {
        "custom-dictionary-user" = {
          "name" = "custom-dictionary-user";
          "path" = "${self}/assets/.cspell/custom-dictionary-user.txt";
          "addWords" = true;
          "scope" = "user";
        };
      };
      "cSpell.diagnosticLevel" = "Hint";
      "cSpell.dictionaries" = [ "vim" ];
      "cSpell.enabledNotifications" = {
        "Average Word Length too Long" = false;
        "Lines too Long" = false;
        "Maximum Word Length Exceeded" = false;
      };
      "debug.console.fontFamily" = "FiraCode Nerd Font";
      "debug.console.fontSize" = 10;
      "debug.hideLauncherWhileDebugging" = true;
      "workbench.welcomePage.walkthroughs.openOnInstall" = false;
      "workbench.startupEditor" = "readme";
      "debug.internalConsoleOptions" = "openOnSessionStart";
      "debug.showSubSessionsInToolBar" = true;
      "debug.showVariableTypes" = true;
      "diffEditor.wordWrap" = "off";
      "dotenv.enableAutocloaking" = false;
      "editor.acceptSuggestionOnEnter" = "off";
      "editor.accessibilityPageSize" = 11;
      "editor.codeLensFontFamily" = "FiraCode Nerd Font";
      "editor.cursorSmoothCaretAnimation" = "on";
      "editor.gotoLocation.multipleDefinitions" = "gotoAndPeek";
      "editor.gotoLocation.multipleImplementations" = "gotoAndPeek";
      "editor.gotoLocation.multipleReferences" = "gotoAndPeek";
      "editor.gotoLocation.multipleTypeDefinitions" = "gotoAndPeek";
      "editor.guides.bracketPairs" = true;
      "editor.inlayHints.enabled" = "off";
      "editor.inlayHints.fontFamily" = "FiraCode Nerd Font";
      "editor.inlineSuggest.enabled" = true;
      "editor.largeFileOptimizations" = false;
      "editor.minimap.autohide" = true;
      "editor.minimap.enabled" = false;
      "editor.minimap.renderCharacters" = false;
      "editor.minimap.side" = "left";
      "editor.peekWidgetDefaultFocus" = "editor";
      "editor.unicodeHighlight.ambiguousCharacters" = false;
      "editor.wordWrap" = "bounded";
      "editor.wordWrapColumn" = 100;
      "files.associations" = {
        # Weird errors with opening vscode and it sorting.
        # "flake.lock" = "json";
        # "*.env*" = "dotenv";
        # "*.toml.tmpl" = "toml";
        # "*Brewfile*" = "ruby";
        # ".aliases" = "shellscript";
        # ".bashrc" = "shellscript";
        # ".envrc" = "shellscript";
        # ".zshrc" = "shellscript";
        # ".env*" = "dotenv";
      };
      "files.autoSave" = "afterDelay";
      "files.exclude" = {
        "**/.DS_Store" = true;
        "**/.git" = true;
        "**/.hg" = true;
        "**/.ruby-lsp" = true;
        "**/.svn" = true;
        "**/.trunk/*actions/" = true;
        "**/.trunk/*logs/" = true;
        "**/.trunk/*notifications/" = true;
        "**/.trunk/*out/" = true;
        "**/.trunk/*plugins/" = true;
        "**/CVS" = true;
        "**/Thumbs.db" = true;
      };
      "projectManager.cacheProjectsBetweenSessions" = false;
      "projectManager.confirmSwitchOnActiveWindow" = "always";
      "projectManager.git.baseFolders" = [ "${config.home.homeDirectory}/work/" ];
      "projectManager.sortList" = "Saved";
      "projectManager.tags" = [
        "Personal"
        "Work"
        "Mantis"
        "FlipperZero"
      ];
      # Starship config helps
      "window.commandCenter" = false;
      "window.density.editorTabHeight" = "compact";
      "window.openFilesInNewWindow" = "default";
      "window.title" =
        "🪿 \${separator} 🌳 \${activeRepositoryName} (\${activeRepositoryBranchName}) \${separator} 📁 \${activeEditorMedium}";
      "workbench.activityBar.location" = "top";
      "workbench.editor.customLabels.enabled" = true;
      "workbench.editor.customLabels.patterns" = {
        "**/__init__.py" = "📦 \${dirname}/\${filename}";
        "**/admin.py" = "🔒 \${dirname}/\${filename}";
        "**/apps.py" = "📦 \${dirname}/\${filename}";
        "**/extensions.json" = "🧩 \${dirname}/\${filename}";
        "**/forms.py" = "📝 \${dirname}/\${filename}";
        "**/keybindings.json" = "⌨️ \${dirname}/\${filename}";
        "**/models.py" = "📁 \${dirname}/\${filename}";
        "**/serializers.py" = "👍 \${dirname}/\${filename}";
        "**/settings.json" = "⚙️ \${dirname}/\${filename}";
        "**/snippets/*.json" = "📝 \${dirname}/\${filename}";
        "**/test_*.py" = "🧪 \${filename}";
        "**/tests.py" = "🧪 \${dirname}/\${filename}";
        "**/urls.py" = "🔗 \${dirname}/\${filename}";
        "**/views.py" = "👁️ \${dirname}/\${filename}";
        "*/.vscode/launch.json" = "🚀 \${dirname}/\${filename}";
      };
      "workbench.editor.labelFormat" = "default";
      "workbench.editor.limit.value" = 4;
      "workbench.editorAssociations" = {
        "{git,gitlens}:/**/*.{md,csv,svg}" = "default";
      };
      "workbench.list.smoothScrolling" = true;
      "workbench.panel.opensMaximized" = "never";
      "workbench.panel.showLabels" = false;
    };

    code-cursor = {
      "cursor.composer.collapsePaneInputBoxPills" = true;
      "cursor.composer.shouldChimeAfterChatFinishes" = true;
      "cursor.composer.textSizeScale" = 1.15;
      "cursor.cpp.disabledLanguages" = [
        "plaintext"
        "markdown"
        "scminput"
      ];
      "cursor.cpp.enablePartialAccepts" = true;
      "cursor.general.enableShadowWorkspace" = true;
    };

    better-comments = {
      # Note: Uses better-comments next for more features
      "better-comments.highlightPlainText" = false;
      "better-comments.tags" = [
        ### TAGS
        {
          bold = true;
          color = dracula.red;
          italic = true;
          tag = "!!";
        }
        {
          bold = true;
          color = dracula.red;
          italic = true;
          tag = "warning";
        }
        {
          bold = true;
          color = dracula.pink;
          italic = true;
          tag = "??";
        }
        {
          bold = true;
          color = dracula.pink;
          italic = true;
          tag = "question";
        }
        {
          bold = true;
          color = dracula.cyan;
          italic = true;
          tag = "info";
        }
        {
          color = dracula.comment;
          italic = true;
          strikethrough = true;
          tag = "//";
        }
        {
          bold = true;
          color = dracula.orange;
          italic = true;
          tag = "fixme";
        }
        {
          bold = true;
          color = dracula.foreground;
          italic = true;
          tag = "━";
        }
        {
          bold = true;
          color = dracula.foreground;
          italic = true;
          tag = "─";
        }
        {
          color = dracula.foreground;
          italic = true;
          tag = "##";
          underline = true;
        }
        ### PYTHON (Python Interactive Specifically)
        # Would provide backgroud but does not cover full line :/
        {
          bold = true;
          color = dracula.green;
          italic = true;
          tag = "%%";
        }
        {
          bold = true;
          color = dracula.green;
          italic = true;
          tag = ">>";
        }
      ];
    };

    fonts = {
      "editor.fontFamily" = "FiraCode Nerd Font";
      "editor.fontLigatures" = true;
      "terminal.integrated.fontFamily" = "FiraCode Nerd Font";
      "terminal.integrated.fontSize" = 10;
    };

    shell = {
      "[shellscript]"."editor.defaultFormatter" = "mads-hartmann.bash-ide-vscode";
      # OSX Settings
      "terminal.external.osxExec" = "Ghostty.app";
      "terminal.integrated.cursorBlinking" = true;
      "terminal.integrated.cursorStyle" = "line";
      "terminal.integrated.defaultProfile.osx" = "Gatlen";
      "terminal.integrated.enableImages" = true;
      "terminal.integrated.hideOnStartup" = "whenEmpty";
      "terminal.integrated.lineHeight" = 1.05;
      "terminal.integrated.profiles.osx" = {
        "Gatlen" = {
          "args" = [ "-l" ];
          "color" = "terminal.ansiBlue";
          "env" = {
            "value" = "\${workspaceFolder}/secrets/.env";
          };
          "icon" = "robot";
          "overrideName" = true;
          "path" = "zsh";
        };
      };
      "terminal.integrated.rightClickBehavior" = "default";
      "terminal.integrated.shellIntegration.enabled" = true;
      "terminal.integrated.smoothScrolling" = true;
      "terminal.integrated.splitCwd" = "workspaceRoot";
      "terminal.integrated.stickyScroll.enabled" = true;
      "terminal.integrated.suggest.enabled" = true;
      "terminal.integrated.tabs.enabled" = true;
      "terminal.integrated.tabs.location" = "left";
    };

    git = {
      "git.autofetch" = true;
      "git.openRepositoryInParentFolders" = "never";
      "gitlens.ai.gitkraken.model" = "gemini:gemini-2.0-flash";
      "gitlens.ai.model" = "gitkraken";
      "gitlens.blame.fontFamily" = "FiraCode Nerd Font";
      "gitlens.currentLine.fontFamily" = "FiraCode Nerd Font";
      "gitlens.graph.dateFormat" = null;
      "gitlens.graph.dimMergeCommits" = true;
      "gitlens.graph.minimap.additionalTypes" = [ "stashes" ];
      "gitlens.graph.minimap.enabled" = false;
      "gitlens.heatmap.locations" = [
        "gutter"
        "overview"
      ];
      "gitlens.statusBar.enabled" = false;
      "gitlens.views.commitDetails.files.layout" = "list";
    };

    file_ops = {

    };

    python = {
      "[python]" = {
        "editor.codeActionsOnSave" = {
          "source.fixAll" = "explicit";
          "source.organizeImports" = "explicit";
        };
        "editor.defaultFormatter" = "charliermarsh.ruff";
        # Worth disabling for repos that are not my own
        "editor.formatOnSave" = true;
      };
      "autoDocstring.docstringFormat" = "google-notypes";
      "autoDocstring.startOnNewLine" = true;
      "python.REPL.sendToNativeREPL" = true;
      "python.testing.pytestEnabled" = true;
      "ruff.codeAction.fixViolation" = {
        enable = false;
      };
      "ruff.configuration" = "~/.config/ruff/ruff.toml";
    };

    nix = {
      "[nix]" = {
        "editor.defaultFormatter" = "jnoortheen.nix-ide";
        "editor.formatOnSave" = true;
        "editor.insertSpaces" = true;
        "editor.tabSize" = 2;
      };
      "nix.enableLanguageServer" = true;
      # Fallback formatter
      "nix.formatterPath" = "nixfmt";
      "nix.serverPath" = "nixd";
      "nix.serverSettings" = {
        "nixd" = {
          "formatting" = {
            "command" = [ "/run/current-system/sw/bin/nixfmt" ];
          };
          "options" = {
            "home-manager" = {
              "expr" = ''(builtins.getFlake "${self}").darwinConfigurations.gatty.options'';
            };
            "nix-config" = {
              "expr" = ''(builtins.getFlake "${self}").darwinConfigurations.gatty.options'';
            };
            "nixos" = {
              "expr" = ''(builtins.getFlake "${self}").darwinConfigurations.gatty.options'';
            };
          };
        };
      };
    };

    typst = {
      "[typst]" = {
        "editor.defaultFormatter" = "myriad-dreamin.tinymist";
        "editor.formatOnSave" = true;
        "editor.wordSeparators" = ''`~!@#$%^&*()=+[{]}\|;:'",.<>/?'';
      };
      "[typst-code]"."editor.wordSeparators" = ''`~!@#$%^&*()=+[{]}\|;:'",.<>/?'';
      "tinymist.formatterMode" = "typstyle";
      "typst-math.renderingMode" = "nothing";
      "typst-math.renderSpaces" = true;
    };

    latex = {
      "[latex]" = {
        "editor.defaultFormatter" = "James-Yu.latex-workshop";
        "editor.tabSize" = 2;
        "editor.insertSpaces" = true;
        "editor.wordWrap" = "on";
      };
      "[tex]" = {
        "editor.tabSize" = 2;
        "editor.insertSpaces" = true;
        "editor.wordWrap" = "on";
      };
      "latex-workshop.bibtex-format.sort.enabled" = true;
      "latex-workshop.formatting.latex" = "tex-fmt";
      "latex-workshop.intellisense.subsuperscript.enabled" = true;
      "latex-workshop.showContextMenu" = true;
      "latex-workshop.synctex.indicator" = "circle";
      "latex-workshop.view.autoFocus.enabled" = true;
      "latex-workshop.view.outline.sync.viewer" = true;
      "latex-workshop.view.pdf.color.dark.backgroundColor" = "#333333";
    };

    web = {
      "[css]"."editor.defaultFormatter" = "prettier.prettier-vscode";
      "[html]"."editor.defaultFormatter" = "prettier.prettier-vscode";
      "[javascript]"."editor.defaultFormatter" = "biomejs.biome";
      "[svelte]"."editor.defaultFormatter" = "svelte.svelte-vscode";
      "[typescript]"."editor.defaultFormatter" = "biomejs.biome";
    };

    data_config = {
      # YAML Configs
      "[dockercompose]" = {
        "editor.defaultFormatter" = "redhat.vscode-yaml";
      };
      "[github-actions-workflow]"."editor.defaultFormatter" = "redhat.vscode-yaml";
      # JSON Configs
      "[json][jsonc][jsonl]" = {
        "editor.defaultFormatter" = "biomejs.biome";
        "editor.tabSize" = 2;
        "editor.wordWrap" = "on";
      };
      "[yaml]"."editor.defaultFormatter" = "redhat.vscode-yaml";
      "json.format.enable" = true;
      "json.schemaDownload.enable" = true;
      "json.schemas" = [
        {
          "fileMatch" = [ ".cursor/hooks.json" ];
          "url" = "https://unpkg.com/cursor-hooks/schema/hooks.schema.json";
        }
      ];
      "json.validate.enable" = true;
    };

    docs = {
      "[markdown]" = {
        "editor.defaultFormatter" = "prettier.prettier-vscode";
        "editor.snippetSuggestions" = "inline";
        "editor.suggest.showSnippets" = true;
      };
    };

    ds_ml = {
      "jupyter.askForKernelRestart" = false;
      "jupyter.themeMatplotlibPlots" = false;
      ### NOTEBOOKS
      # Layout
      "notebook.cellFocusIndicator" = "border";
      "notebook.cellToolbarLocation" = {
        "default" = "right";
        "jupyter-notebook" = "right";
      };
      "notebook.codeActionsOnSave" = {
        "notebook.source.fixAll" = "explicit";
        "notebook.source.organizeImports" = "explicit";
      };
      "notebook.consolidatedRunButton" = true;
      "notebook.defaultFormatter" = "charliermarsh.ruff";
      "notebook.diff.overviewRuler" = true;
      "notebook.formatOnSave.enabled" = true;
      "notebook.lineNumbers" = "on";
      "notebook.output.fontFamily" = "FiraCode Nerd Font";
      "notebook.output.fontSize" = 9;
      "notebook.output.scrolling" = true;
      "notebook.stickyScroll.enabled" = true;
    };

    devops = {
      # "remote.SSH.showLoginTerminal" = true; # true for debugging
      # "remote.SSH.localServerDownload" = "always"; # issues in special cases
      "remote.SSH.defaultExtensions" = [
        "ms-python.vscode-pylance"
        "ms-python.debugpy"
        "charliermarsh.ruff"
        "njpwerner.autodocstring"
        "rodolphebarbanneau.python-docstring-highlighter"
        "kevinrose.vsc-python-indent"
        "ms-toolsai.jupyter"
        "ms-toolsai.jupyter-renderers"
        "mechatroner.rainbow-csv"
        "sbsnippets.pytorch-snippets"
        "mads-hartmann.bash-ide-vscode"
        "timonwong.shellcheck"
        "foxundermoon.shell-format"
        "mathematic.vscode-pdf"
        "vitaliymaz.vscode-svg-previewer"
        "ctcuff.font-preview"
        "james-yu.latex-workshop"
        "shd101wyy.markdown-preview-enhanced"
        "prettier.prettier-vscode"
        "mrmlnc.vscode-attrs-sorter"
        "richie5um2.vscode-sort-json"
        "2gua.rainbow-brackets"
        "aaron-bond.better-comments"
        "alefragnani.project-manager"
        "peterschmalfeldt.explorer-exclude"
        "christian-kohler.path-intellisense"
        "kisstkondoros.vscode-gutter-preview"
        "eamodio.gitlens"
        "humao.rest-client"
        "ms-vscode.makefile-tools"
        "task.vscode-task"
        "tamasfe.even-better-toml"
        "dotenv.dotenv-vscode"
        "redhat.vscode-yaml"
        "redhat.vscode-xml"
        "ibm.output-colorizer"
        "usernamehw.errorlens"
        "spmeesseman.vscode-taskexplorer"
      ];
      "remote.SSH.logLevel" = "trace";
      "remote.SSH.useExecServer" = false;
    };

    vim = {
      "vim.disableExtension" = true;
      "vim.cursorStylePerMode.insert" = "line";
      "vim.cursorStylePerMode.normal" = "block-outline";
      "vim.cursorStylePerMode.replace" = "underline";
      "vim.cursorStylePerMode.visual" = "block";
      "vim.cursorStylePerMode.visualblock" = "block";
      "vim.cursorStylePerMode.visualline" = "block";
      "vim.enableNeovim" = true;
      "vim.highlightedyank.enable" = true;
      "vim.neovimConfigPath" = "~/.config/nvim/init.vim";
      "vim.neovimUseConfigFile" = false;
      "vim.smartRelativeLine" = true;
      "vim.sneak" = true;
      "vim.statusBarColorControl" = true;
    };

    lisp = {
      "[racket]" = {
        "editor.defaultFormatter" = "evzen-wybitul.magic-racket";
      };
    };

    ruby = {
      "[ruby]" = {
        "editor.defaultFormatter" = "Shopify.ruby-lsp";
        "editor.formatOnSave" = true;
        "editor.insertSpaces" = true;
        "editor.semanticHighlighting.enabled" = true;
        "editor.tabSize" = 2;
        "editor.wordSeparators" = ''`~@#$%^&*()-=+[{]}\|;:'",.<>/'';
      };
    };

    general_additional_languages = {
      "[eval-log]" = { };
      "[pddl]"."editor.defaultFormatter" = "jan-dolejsi.pddl";
      "pddl.selectedPlanner" = "Planning as a service (solver.planning.domains)";
    };

    misc = {
      # Error lens docs: https://github.com/usernamehw/vscode-error-lens/blob/master/docs/docs.md#errorlensfontsize
      "errorLens.borderRadius" = "";
      "errorLens.codeLensEnabled" = false;
      "errorLens.codeLensOnClick" = "showProblemsView";
      # To match dracula theme (looks ugly otherwise)
      "errorLens.decorations" = {
        "errorMessage" = {
          "backgroundColor" = dracula.withAlpha "20" dracula.red;
          "color" = dracula.red;
        };
        "hintMessage" = {
          "backgroundColor" = dracula.withAlpha "20" dracula.comment;
          "color" = dracula.comment;
        };
        "infoMessage" = {
          "backgroundColor" = dracula.withAlpha "20" dracula.yellow;
          "color" = dracula.yellow;
        };
        "warningMessage" = {
          "backgroundColor" = dracula.withAlpha "20" dracula.cyan;
          "color" = dracula.cyan;
        };
      };
      "errorLens.enabledDiagnosticLevels" = [
        "error"
        # Low-key a bit distracting
        # "warning"
        # "info"
        # "hint"
      ];
      "errorLens.followCursor" = "allLines";
      "errorLens.fontFamily" = "FiraCode Nerd Font";
      "errorLens.fontSize" = "0.8em";
      "errorLens.messageBackgroundMode" = "message";
      "errorLens.messageEnabled" = true;
      "errorLens.padding" = "2px 1ch";
      # "indentRainbow.colors" = [
      #   "rgba(255,255,64,0.03)"
      #   "rgba(127,255,127,0.03)"
      #   "rgba(255,127,255,0.03)"
      #   "rgba(79,236,236,0.03)"
      # ];
      # "indentRainbow.errorColor" = "rgba(128,32,32,0.3)";
      # "indentRainbow.tabmixColor" = "rgba(128,32,96,0.3)";
      "powermode.combo.counterSize" = 1;
      "powermode.combo.location" = "editor";
      "powermode.combo.threshold" = 5;
      "powermode.explosions.gifMode" = "restart";
      "powermode.explosions.maxExplosions" = 3;
      "powermode.explosions.size" = 10;
      # https://code.visualstudio.com/docs/copilot/reference/copilot-settings
      "chat.commandCenter.enabled" = false;
      "github.copilot.enable" = {
        "*" = false;
        "comments" = false;
        "markdown" = false;
        "plaintext" = false;
        "scminput" = false;
      };
      "github.copilot.nextEditSuggestions.enabled" = false;
    };

    claude-code = {
      "claudeCode.useTerminal" = true;
    };
  };

  selected = with profiles; [
    themes
    general
    fonts
    shell
    git
    file_ops
    python
    nix
    typst
    latex
    code-cursor
    better-comments
    lisp
    web
    data_config
    docs
    ds_ml
    devops
    vim
    general_additional_languages
    ruby
    misc
    claude-code
  ];
in
builtins.foldl' (acc: next: acc // next) { } selected
