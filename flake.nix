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
    "aerial.nvim" = {
      url = "github:stevearc/aerial.nvim";
      flake = false;
    };

    "bufferline.nvim" = {
      url = "github:akinsho/bufferline.nvim/v4.4.0";
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

    "copilot.lua" = {
      url = "github:zbirenbaum/copilot.lua";
      flake = false;
    };

    copilot-cmp = {
      url = "github:zbirenbaum/copilot-cmp";
      flake = false;
    };

    "direnv.vim" = {
      url = "github:direnv/direnv.vim";
      flake = false;
    };

    "flash.nvim" = {
      url = "github:folke/flash.nvim";
      flake = false;
    };

    "hydra.nvim" = {
      url = "github:anuvyklack/hydra.nvim";
      flake = false;
    };

    "lazy.nvim" = {
      url = "github:folke/lazy.nvim?submodules=1";
      flake = false;
    };

    "neoscroll.nvim" = {
      url = "github:karb94/neoscroll.nvim";
      flake = false;
    };

    "neo-tree.nvim" = {
      url = "github:nvim-neo-tree/neo-tree.nvim?ref=3.13";
      flake = false;
    };

    "noice.nvim" = {
      url = "github:folke/noice.nvim";
      flake = false;
    };

    "nui.nvim" = {
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

    "peek.nvim" = {
      url = "github:toppair/peek.nvim";
      flake = false;
    };

    "persistence.nvim" = {
      url = "github:folke/persistence.nvim";
      flake = false;
    };

    "plenary.nvim" = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };

    "rust-tools.nvim" = {
      url = "github:simrat39/rust-tools.nvim";
      flake = false;
    };

    "substitute.nvim" = {
      url = "github:gbprod/substitute.nvim";
      flake = false;
    };

    "telescope.nvim" = {
      url = "github:nvim-telescope/telescope.nvim?ref=0.1.4";
      flake = false;
    };

    "todo-comments.nvim" = {
      url = "github:folke/todo-comments.nvim";
      flake = false;
    };

    "tokyonight.nvim" = {
      url = "github:folke/tokyonight.nvim";
      flake = false;
    };

    vim-vsnip = {
      url = "github:hrsh7th/vim-vsnip";
      flake = false;
    };

    "yanky.nvim" = {
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

        packages.default = config.packages.neovim;
        packages.neovim = let
          plugins = {
            inherit
              (inputs)
              "aerial.nvim"
              "bufferline.nvim"
              cmp-buffer
              cmp-nvim-lsp
              cmp-nvim-lsp-document-symbol
              cmp-nvim-lsp-signature-help
              cmp-vsnip
              "copilot.lua"
              copilot-cmp
              "direnv.vim"
              "flash.nvim"
              "hydra.nvim"
              "lazy.nvim"
              "neoscroll.nvim"
              "neo-tree.nvim"
              "noice.nvim"
              "nui.nvim"
              nvim-cmp
              nvim-lspconfig
              nvim-notify
              nvim-treesitter-context
              nvim-web-devicons
              "peek.nvim"
              "persistence.nvim"
              "plenary.nvim"
              "rust-tools.nvim"
              "substitute.nvim"
              "telescope.nvim"
              "todo-comments.nvim"
              "tokyonight.nvim"
              vim-vsnip
              "yanky.nvim"
              ;
          };

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

          mkNixPath = paths: lib.concatLines (lib.mapAttrsToList (name: path: "\t[\"${name}\"] = \"${path}\",") paths);

          nix-paths = pkgs.writeText "nvim-nix-paths.lua" ''
            vim.g.nixpkgs = {
            ${mkNixPath tools}
            }

            vim.g.nixplugins = {
            ${mkNixPath plugins}
            }
          '';

          nvim-with-plugins-config = pkgs.neovimUtils.makeNeovimConfig {
            withNodejs = true;
            withPython3 = true;
            withRuby = true;

            plugins = [
              pkgs.vimPlugins.nvim-treesitter.withAllGrammars
            ];
          };

          nvim-with-plugins =
            pkgs.wrapNeovimUnstable
            pkgs.neovim-unwrapped
            nvim-with-plugins-config;
        in
          pkgs.stdenvNoCC.mkDerivation {
            name = "neovim";

            buildInputs = [
              pkgs.makeWrapper
            ];

            dontBuild = true;
            dontUnpack = true;

            installPhase = ''
              runHook preInstall

              mkdir -p $out/bin
              makeWrapper ${nvim-with-plugins}/bin/nvim $out/bin/nvim \
                --add-flags "--cmd 'lua vim.opt.runtimepath:append(\"${./.}\")'" \
                --add-flags "--cmd 'lua dofile(\"${nix-paths}\")'" \
                --add-flags "-u ${./.}/init.lua"

              runHook postInstall
            '';

            meta = {
              mainProgram = "nvim";
            };
          };
      };
    };
}
