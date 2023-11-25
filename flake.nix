{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # additional flakes
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

    # note: i'm only using lazy.nvim to manage lazy loading and configuration.
    # it has package management features, but since i'm using nix there's no need!
    lazy-nvim = {
      url = "github:folke/lazy.nvim?submodules=1";
      flake = false;
    };

    # nvim plugins! not managed by lazy.nvim! cause that's impure and for scrubs!
    bufferline-nvim = {
      url = "github:akinsho/bufferline.nvim/v4.4.0";
      flake = false;
    };

    cmp-nvim-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };

    cmp-vsnip = {
      url = "github:hrsh7th/cmp-vsnip";
      flake = false;
    };

    neo-tree-nvim = {
      url = "github:nvim-neo-tree/neo-tree.nvim";
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

    nvim-web-devicons = {
      url = "github:nvim-tree/nvim-web-devicons";
      flake = false;
    };

    plenary-nvim = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };

    vim-vsnip = {
      url = "github:hrsh7th/vim-vsnip";
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
            inputs.neovim-nightly-overlay.overlay
            inputs.nixd.overlays.default
          ];
        };

        formatter = pkgs.alejandra;

        packages.default = config.packages.neovim;
        packages.neovim = let
          plugins = {
            inherit (inputs)
              cmp-nvim-lsp
              cmp-vsnip
              nvim-cmp
              nvim-lspconfig
              nvim-web-devicons
              vim-vsnip;

            "bufferline.nvim" = inputs.bufferline-nvim;
            "lazy.nvim" = inputs.lazy-nvim;
            "neo-tree.nvim" = inputs.neo-tree-nvim;
            "nui.nvim" = inputs.nui-nvim;
            "plenary.nvim" = inputs.plenary-nvim;
          };

          tools = {
            "lua-language-server" = pkgs.lua-language-server;
            "nixd" = pkgs.nixd;
          };

          nix-paths = pkgs.writeText "nvim-nix-paths.lua" ''
            vim.g.nixplugins = {
            ${lib.concatLines (lib.mapAttrsToList (name: path: "\t[\"${name}\"] = \"${path}\",") plugins)}
            }

            vim.g.nixtools = {
            ${lib.concatLines (lib.mapAttrsToList (name: path: "\t[\"${name}\"] = \"${path}/bin/${name}\",") tools)}
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
