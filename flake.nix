{
  description = "CLI toolset shared across machines";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: let
    supported = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
    forAllSystems = f: nixpkgs.lib.genAttrs supported (system: f nixpkgs.legacyPackages.${system});
  in {
    packages = forAllSystems (pkgs: rec {
      dot-tools = pkgs.buildEnv {
        name = "dot-tools";
        paths = with pkgs; [
          atuin
          bat
          direnv
          eza
          fd
          fzf
          delta
          imagemagick
          jq
          mise
          neovim
          poppler
          resvg
          ripgrep
          starship
          stow
          tree
          xclip
          yazi
          zoxide
        ];
      };
      # so `nix profile add .` (default package) works
      default = dot-tools;
    });
  };
}
