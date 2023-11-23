{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    bufferline-nvim = {
      url = "github:akinsho/bufferline.nvim/v4.4.0";
      flake = false;
    };

    lazy-nvim = {
      url = "github:folke/lazy.nvim";
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
        ...
      }: {
        formatter = pkgs.alejandra;

        packages.default = config.packages.neovim;
        packages.neovim = let
          plugins = {
            "bufferline.nvim" = inputs.bufferline-nvim;
          };

          tools = {};

          mkNixPaths = attrs: lib.concatLines (lib.mapAttrsToList (name: path: "[\"${name}\"] = \"${path}\",") attrs);

          nix-paths = pkgs.writeText "nvim-nix-paths" ''
            vim.g.nixplugins = {
              ${mkNixPaths plugins}
            }

            vim.g.nixtools = {
              ${mkNixPaths tools}
            }
          '';

          nvim-with-plugins-config = pkgs.neovimUtils.makeNeovimConfig {
            withNodejs = true;
            withPython3 = true;
            withRuby = true;

            plugins = [
              pkgs.vimPlugins.nvim-treesitter.withAllGrammars

              (pkgs.vimUtils.buildVimPlugin {
                name = "lazy.nvim";
                src = inputs.lazy-nvim;
              })
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
