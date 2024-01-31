{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # additional flakes
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixd = {
      url = "github:nix-community/nixd";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nvim plugins! not managed by lazy.nvim! cause that's impure and for scrubs!
    aerial-nvim = {
      url = "github:stevearc/aerial.nvim";
      flake = false;
    };

    bufferline-nvim = {
      url = "github:akinsho/bufferline.nvim/v4.5.0";
      flake = false;
    };

    cmp-buffer = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };

    cmp-nvim-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };

    cmp-nvim-lsp-document-symbol = {
      url = "github:hrsh7th/cmp-nvim-lsp-document-symbol";
      flake = false;
    };

    cmp-nvim-lsp-signature-help = {
      url = "github:hrsh7th/cmp-nvim-lsp-signature-help";
      flake = false;
    };

    cmp-vsnip = {
      url = "github:hrsh7th/cmp-vsnip";
      flake = false;
    };

    comment-nvim = {
      url = "github:numToStr/Comment.nvim";
      flake = false;
    };

    copilot-lua = {
      url = "github:zbirenbaum/copilot.lua";
      flake = false;
    };

    copilot-cmp = {
      url = "github:zbirenbaum/copilot-cmp";
      flake = false;
    };

    direnv-vim = {
      url = "github:direnv/direnv.vim";
      flake = false;
    };

    flash-nvim = {
      url = "github:folke/flash.nvim";
      flake = false;
    };

    hydra-nvim = {
      url = "github:anuvyklack/hydra.nvim";
      flake = false;
    };

    neoscroll-nvim = {
      url = "github:karb94/neoscroll.nvim";
      flake = false;
    };

    neo-tree-nvim = {
      url = "github:nvim-neo-tree/neo-tree.nvim?ref=3.16";
      flake = false;
    };

    noice-nvim = {
      url = "github:folke/noice.nvim";
      flake = false;
    };

    nui-nvim = {
      url = "github:MunifTanjim/nui.nvim";
      flake = false;
    };

    nvim-cmp = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };

    nvim-lspconfig = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };

    nvim-notify = {
      url = "github:rcarriga/nvim-notify";
      flake = false;
    };

    nvim-treesitter-context = {
      url = "github:nvim-treesitter/nvim-treesitter-context";
      flake = false;
    };

    nvim-web-devicons = {
      url = "github:nvim-tree/nvim-web-devicons";
      flake = false;
    };

    peek-nvim = {
      url = "github:toppair/peek.nvim";
      flake = false;
    };

    persistence-nvim = {
      url = "github:folke/persistence.nvim";
      flake = false;
    };

    plenary-nvim = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };

    rustaceanvim = {
      url = "github:mrcjkb/rustaceanvim";
      flake = false;
    };

    startup-nvim = {
      url = "github:cdmistman/startup.nvim/patch-1";
      flake = false;
    };

    substitute-nvim = {
      url = "github:gbprod/substitute.nvim";
      flake = false;
    };

    telescope-nvim = {
      url = "github:nvim-telescope/telescope.nvim?ref=0.1.5";
      flake = false;
    };

    todo-comments-nvim = {
      url = "github:folke/todo-comments.nvim";
      flake = false;
    };

    tokyonight-nvim = {
      url = "github:folke/tokyonight.nvim";
      flake = false;
    };

    vim-vsnip = {
      url = "github:hrsh7th/vim-vsnip";
      flake = false;
    };

    which-key-nvim = {
      url = "github:folke/which-key.nvim";
      flake = false;
    };

    yanky-nvim = {
      url = "github:gbprod/yanky.nvim";
      flake = false;
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "aarch64-darwin"
        "x86_64-linux"
      ];

      perSystem = {
        config,
        inputs',
        lib,
        pkgs,
        system,
        ...
      }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            inputs.fenix.overlays.default
            inputs.neovim-nightly-overlay.overlay
            inputs.nixd.overlays.default
          ];
        };

        formatter = pkgs.alejandra;

        packages.config-dir = let
          tools = {
            inherit
              (pkgs)
              gopls
              haskell-language-server
              lua-language-server
              marksman
              nixd
              nodejs_20
              nushell
              tailwindcss-language-server
              taplo
              vscode-langservers-extracted
              ;

            inherit (pkgs.fenix) rust-analyzer;

            inherit
              (pkgs.nodePackages_latest)
              graphql-language-service-cli
              svelte-language-server
              typescript-language-server
              ;
          };

          nixpkgs-lua-file-text = lib.concatLines (
            ["return {"]
            ++ lib.mapAttrsToList (name: path: "\t[\"${name}\"] = \"${path}\",") tools
            ++ ["}"]
          );

          config-dir-src = builtins.path {
            name = "neovim-config-dir-src";
            path = ./.;
            filter = path: type: type == "directory" || lib.hasSuffix ".lua" path;
          };
        in
          pkgs.symlinkJoin {
            name = "neovim-config-dir";
            paths = [
              config-dir-src
              (pkgs.writeTextDir "lua/nixpkgs.lua" nixpkgs-lua-file-text)
            ];
          };

        packages.neovim-with-plugins = let
          plugins = {
            inherit
              (inputs)
              cmp-buffer
              cmp-nvim-lsp
              cmp-nvim-lsp-document-symbol
              cmp-nvim-lsp-signature-help
              cmp-vsnip
              copilot-cmp
              nvim-cmp
              nvim-lspconfig
              nvim-notify
              nvim-treesitter-context
              nvim-web-devicons
              vim-vsnip
              ;

            "aerial.nvim" = inputs.aerial-nvim;
            "bufferline.nvim" = inputs.bufferline-nvim;
            "comment.nvim" = inputs.comment-nvim;
            "copilot.lua" = inputs.copilot-lua;
            "direnv.vim" = inputs.direnv-vim;
            "flash.nvim" = inputs.flash-nvim;
            "hydra.nvim" = inputs.hydra-nvim;
            "neoscroll.nvim" = inputs.neoscroll-nvim;
            "neo-tree.nvim" = inputs.neo-tree-nvim;
            "noice.nvim" = inputs.noice-nvim;
            "nui.nvim" = inputs.nui-nvim;
            "peek.nvim" = inputs.peek-nvim;
            "persistence.nvim" = inputs.persistence-nvim;
            "plenary.nvim" = inputs.plenary-nvim;
            "rustaceanvim" = inputs.rustaceanvim;
            "startup.nvim" = inputs.startup-nvim;
            "substitute.nvim" = inputs.substitute-nvim;
            "telescope.nvim" = inputs.telescope-nvim;
            "todo-comments.nvim" = inputs.todo-comments-nvim;
            "tokyonight.nvim" = inputs.tokyonight-nvim;
            "which-key.nvim" = inputs.which-key-nvim;
            "yanky.nvim" = inputs.yanky-nvim;
          };

          nvim-config = pkgs.neovimUtils.makeNeovimConfig {
            withNodejs = true;
            withPython3 = true;
            withRuby = true;

            plugins =
              [
                pkgs.vimPlugins.nvim-treesitter.withAllGrammars
              ]
              ++ lib.mapAttrsToList
              (name: plugin:
                pkgs.vimUtils.buildVimPlugin {
                  inherit name;
                  src = plugin;
                })
              plugins;
          };
        in
          pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped (nvim-config // { wrapRc = false; });

        packages.default = config.packages.neovim;
        packages.neovim = pkgs.stdenvNoCC.mkDerivation {
          name = "neovim";

          buildInputs = [
            pkgs.makeWrapper
          ];

          dontBuild = true;
          dontUnpack = true;

          installPhase = ''
            runHook preInstall

            mkdir -p $out/bin
            makeWrapper ${config.packages.neovim-with-plugins}/bin/nvim $out/bin/nvim \
              --add-flags "--cmd 'lua vim.opt.runtimepath:append(\"${config.packages.config-dir}\")'" \
              --add-flags "--clean" \
              --add-flags "-u ${config.packages.config-dir}/init.lua"

            runHook postInstall
          '';

          meta = {
            mainProgram = "nvim";
          };
        };
      };
    };
}
