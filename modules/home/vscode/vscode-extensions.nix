{ pkgs }:

with pkgs.vscode-marketplace;
let
  # Profiles organized into logical groups for easy access
  profiles = {

    general = {
      core = [
        aaron-bond.better-comments # There is a fork but doesn't work as well still.
        alefragnani.project-manager
        ibm.output-colorizer
        mohammadbaqer.better-folding
        usernamehw.errorlens
        # Anthropic.claude-code # Doesn't work :/
      ];

      debugging = [
        hediet.debug-visualizer
        ms-vscode.hexeditor
      ];

      explorer = [ peterschmalfeldt.explorer-exclude ];

      file-ops = [
        christian-kohler.path-intellisense
        ionutvmi.path-autocomplete
        kisstkondoros.vscode-gutter-preview
        mrmlnc.vscode-duplicate
        shinotatwu-ds.file-tree-generator
        # YuTengjing.vscode-archive # Not available
      ];

      fonts = [
        ctcuff.font-preview
        janne252.fontawesome-autocomplete
        # SeyyedKhandon.firacode
      ];

      remote = [
        ms-vscode-remote.remote-containers
        ms-vscode-remote.remote-ssh
        ms-vscode-remote.remote-ssh-edit
        ms-vscode.remote-explorer
        ms-vscode.remote-repositories
        ms-vscode.remote-server
      ];

      testing = [ ms-vscode.test-adapter-converter ];

      themes = [
        dracula-theme.theme-dracula
        pkief.material-icon-theme
        pkief.material-product-icons
      ];

      ui-ux = [
        alefragnani.bookmarks
        antfu.iconify
        exodiusstudios.comment-anchors
        stackbreak.comment-divider
        xiaoluoboding.vscode-folder-size
        # johnpapa.vscode-peacock
      ];

      utilities = [
        # Recording
        adpyke.codesnap
        griimick.vhs
        # Misc
        atishay-jain.all-autocomplete
        liamhammett.inline-parameters
        louiswt.regexp-preview
        salbert.copy-text
        stkb.rewrap
      ];
    };

    tools = {
      cloud = [
        amazonwebservices.aws-toolkit-vscode
        aws-scripting-guy.cform
        # GitHub.codespaces
        github.remotehub
        ms-vsliveshare.vsliveshare
      ];

      code-quality = [
        # lmcarreiro.vscode-smart-column-indenter
        # trunk.io
      ];

      containers = [
        # Docker
        exiasr.hadolint
        formulahendry.docker-explorer
        jeff-hykin.better-dockerfile-syntax
        ms-azuretools.vscode-docker
        # Kubernetes
        ipedrazas.kubernetes-snippets
        ms-kubernetes-tools.vscode-kubernetes-tools
      ];

      devops = [
        # hashicorp.terraform # Results in an error after updating nixpkgs to unstable.
        philnash.ngrok-for-vscode
        redhat.ansible
        streetsidesoftware.code-spell-checker
        # anysphere.remote-containers # Doesn't work on cursor
        # elagil.pre-commit-helper
        # Postman.postman-for-vscode # Not in vscode-extensions
      ];

      git = [
        codezombiech.gitignore
        eamodio.gitlens
        github.vscode-github-actions
        github.vscode-pull-request-github
        pflannery.vscode-versionlens
        # SanjulaGanepola.github-local-actions # Not in vscode-extensions
      ];

      security = [
        wscats.cors-browser
      ];

      snippets-templates = [

        helixquar.asciidecorator
      ];
    };

    langs = {
      cpp = [
        cschlosser.doxdocgen
        jeff-hykin.better-cpp-syntax
        ms-vscode.cpptools-themes
      ];

      csharp = [ ];

      css = [
        bradlc.vscode-tailwindcss
        # zignd.html-css-class-completion
      ];

      duckyscript = [
        cvbenur.ducky-script-lang-vscode
        xqua.ducky-script-lang-vscode-flipper
      ];

      html = [
        ecmel.vscode-html-css
        formulahendry.auto-rename-tag
        mkaufman.htmlhint
        tht13.html-preview-vscode
        zignd.html-css-class-completion
        abusaidm.html-snippets
        # prettier.prettier-vscode
      ];

      jinja = [
        samuelcolvin.jinjahtml
        wholroyd.jinja
      ];

      js = [
        biomejs.biome
        christian-kohler.npm-intellisense
        dsznajder.es7-react-js-snippets
        ms-vscode.vscode-typescript-next
        svelte.svelte-vscode
        vitest.explorer
        pmneo.tsimporter
        # YoavBls.pretty-ts-errors # not available
      ];

      julia = [ julialang.language-julia ];

      lean = [
        leanprover.lean4
      ];

      lisp = [
        evzen-wybitul.magic-racket
        sjhuangx.vscode-scheme
      ];

      makefile = [
        ms-vscode.makefile-tools
      ];

      nix = [ jnoortheen.nix-ide ];

      powershell = [ ms-vscode.powershell ];

      python = [
        charliermarsh.ruff # redundant?
        kevinrose.vsc-python-indent
        ms-python.debugpy
        ms-python.gather
        ms-python.python
        ms-python.vscode-python-envs
        njpwerner.autodocstring
        rodolphebarbanneau.python-docstring-highlighter
        sbsnippets.pytorch-snippets
        batisteo.vscode-django
        # ms-pyright.pyright # Redundant, anysphere has their own version
        # ms-python.vscode-pylance # Redundant, anysphere has their own version
        # twixes.pypi-assistant
      ];

      r = [
        REditorSupport.r
        REditorSupport.r-syntax
      ];
      latex = [
        james-yu.latex-workshop
        # mathematic.vscode-latex Redundant?
      ];
      typst = [
        myriad-dreamin.tinymist
        # OrangeX4.vscode-typst-sympy-calculator
        # surv.typst-math # Don't use atm
      ];
      ruby = [
        rubocop.vscode-rubocop
        sorbet.sorbet-vscode-extension
        # Shopify.ruby-lsp # Not available
      ];

      rust = [ rust-lang.rust-analyzer ];

      shell = [
        foxundermoon.shell-format
        jetmartin.bats
        mads-hartmann.bash-ide-vscode
        rogalmic.bash-debug
        timonwong.shellcheck
        # xjnoortheen.xonsh # Not available
      ];

      vim = [
        vscodevim.vim
        xadillax.viml
        vintharas.learn-vim
      ];
    };

    ### DATA & DOCUMENTS
    data = {
      config = [
        # CSV
        mechatroner.rainbow-csv
        # Dotenv
        dotenv.dotenv-vscode
        # Excel
        grapecity.gc-excelviewer
        # Json
        remcohaszing.schemastore
        richie5um2.vscode-sort-json
        # ZainChen.json # Not available
        # Parquet
        dvirtz.parquet-viewer
        # TOML
        tamasfe.even-better-toml
        # XML
        redhat.vscode-xml
        # YAML
        redhat.vscode-yaml
        # Other
        ms-toolsai.datawrangler
        # quarto.quarto # Idk if I need this
      ];

      docs = [
        davidanson.vscode-markdownlint
        shd101wyy.markdown-preview-enhanced
        # yzhang.markdown-all-in-one # prob don't need
      ];

      ds-ml = [
        ms-toolsai.jupyter
        ms-toolsai.jupyter-renderers
        ms-toolsai.vscode-jupyter-cell-tags
        ms-toolsai.vscode-jupyter-powertoys
        ms-toolsai.vscode-jupyter-slideshow
        ukaisi.inspect-ai
        vincent-templier.vscode-netron
        ms-toolsai.tensorboard
      ];

      sql = [
        ckolkman.vscode-postgres
        mtxr.sqltools
        randomfractalsinc.duckdb-sql-tools
      ];

    };

    misc = {
      fun = [
        arthurlobo.vscode-doom
        tonybaloney.vscode-pets
        ttoowa.in-your-face-incredible
        hoovercj.vscode-power-mode
      ];

      specialized = [
        ban.troff # troff lang, niche.
        cweijan.vscode-office # MS Office
        editorconfig.editorconfig # niche devops tool
        humao.rest-client
        kdl-org.kdl # KDL (niche lang)
        mathematic.vscode-pdf # preview pdfs
        vitaliymaz.vscode-svg-previewer # preview svgs
        # hediet.vscode-drawio # drawio files
        # jan-dolejsi.pddl # pddl niche lang
        # ms-vscode.live-server
        # WakaTime.vscode-wakatime # Not available
        # tyriar.luna-paint
        lov3.sagemath-enhanced
        sharat.vscode-brewfile
      ];

      windows = [
        ms-vscode-remote.remote-wsl
      ];
    };

  };

  # Flatten nested attribute sets into a list
  flattenProfiles =
    attrSet:
    builtins.concatLists (
      builtins.attrValues (
        builtins.mapAttrs (_: v: if builtins.isList v then v else flattenProfiles v) attrSet
      )
    );

  # Default selection: include all profiles to preserve current behavior.
  selected = with profiles; [
    general.core
    general.debugging
    general.file-ops
    general.fonts
    general.remote
    general.testing
    general.themes
    general.ui-ux
    general.utilities

    tools.cloud
    tools.code-quality
    tools.containers
    tools.devops
    tools.git
    # tools.security
    # tools.snippets-templates

    langs.css
    # langs.cpp
    # langs.csharp
    # langs.duckyscript
    langs.html
    langs.js
    # langs.julia
    # langs.lean
    # langs.lisp
    langs.nix
    # langs.powershell
    langs.python
    # langs.r
    # langs.ruby
    # langs.rust
    langs.shell
    langs.vim

    data.config
    data.docs
    data.ds-ml
    langs.latex
    data.sql
    langs.typst

    misc.specialized
    # misc.fun
    # misc.windows
  ];
in
builtins.concatLists selected

# Unable to import 54 extensions: abusaidm.html-snippets, adpyke.codesnap, alefragnani.bookmarks, atishay-jain.all-autocomplete, aws-scripting-guy.cform, batisteo.vscode-django, christian-kohler.npm-intellisense, christian-kohler.path-intellisense, ctcuff.font-preview, cweijan.vscode-office, dsznajder.es7-react-js-snippets, ecmel.vscode-html-css, exiasr.hadolint, exodiusstudios.comment-anchors, formulahendry.auto-rename-tag, github.remotehub, griimick.vhs, ipedrazas.kubernetes-snippets, jeff-hykin.better-dockerfile-syntax, jetmartin.bats, kdl-org.kdl, kisstkondoros.vscode-gutter-preview, liamhammett.inline-parameters, louiswt.regexp-preview, lov3.sagemath-enhanced, mkaufman.htmlhint, mrmlnc.vscode-duplicate, ms-python.gather, ms-toolsai.datawrangler, ms-toolsai.tensorboard, ms-toolsai.vscode-jupyter-powertoys, ms-vscode-remote.remote-containers, ms-vscode-remote.remote-ssh, ms-vscode-remote.remote-ssh-edit, ms-vscode.hexeditor, ms-vscode.remote-explorer, ms-vscode.vscode-typescript-next, philnash.ngrok-for-vscode, pmneo.tsimporter, randomfractalsinc.duckdb-sql-tools, redhat.ansible, salbert.copy-text, sharat.vscode-brewfile, stackbreak.comment-divider, stkb.rewrap, tht13.html-preview-vscode, ukaisi.inspect-ai, vincent-templier.vscode-netron, vintharas.learn-vim, vitaliymaz.vscode-svg-previewer, vscodevim.vim, xadillax.viml, xiaoluoboding.vscode-folder-size, zignd.html-css-class-completion.  Only extensions that are available in the Cursor Marketplace can be imported.
