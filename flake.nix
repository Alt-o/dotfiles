{
  description = "Toolset shared across machines";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: let
    supported = [
      "x86_64-linux" "aarch64-linux" "aarch64-darwin"
    ];
    forAllSystems = f: nixpkgs.lib.genAttrs supported (system: f nixpkgs.legacyPackages.${system});
  in {
    packages = forAllSystems (pkgs: rec {
      # CLI / terminal tooling. Language runtimes (go, node, python)
      # stay with mise; OS services (git, gpg, docker) stay with the
      # distro. The ssh *client* is included here because a bare OS
      # install may lack it.
      cli = pkgs.buildEnv {
        name = "dot-cli";
        paths = with pkgs; [
          # Session / shell
          atuin               # shell history (SQLite, synced)
          direnv              # per-directory environment (envrc)
          fzf                 # general-purpose fuzzy finder
          starship            # cross-shell prompt
          stow                # symlink-based dotfile installer
          television          # channel-based fuzzy finder (tv)
          tmux                # terminal multiplexer
          zsh                 # login shell (not on all base images, e.g. WSL)
          # File & code navigation
          bat                 # cat with syntax highlighting
          eza                 # ls/tree with icons
          fd                  # simple, fast find
          ripgrep             # fast recursive grep
          xclip               # X clipboard (needed by fzf/jq pipelines)
          yazi                # terminal file manager
          zoxide              # frecency-aware cd
          # Review / output
          delta               # syntax-aware git diff pager
          jq                  # fast JSON processor
          man                 # manual pages; buildEnv wrappers set MANPATH
          tldr                # community man pages (TLDR)
          # Build
          cmake               # build system generator
          mise                # language runtime/tool version manager
          # Code stats & network
          cloc                # count lines of code by language
          httpie              # friendly HTTP client (curl alternative)
          iftop               # per-host bandwidth monitor
          openssh             # ssh client + ssh-keygen
          mtr                 # traceroute + ping combined
          nmap                # network scanner
          shellcheck          # shell script linter
          # Misc dev
          gita                # git repo manager (bulk operations)
          htop                # interactive process viewer
          just                # command runner (make replacement)
          uv                  # fast Python package/project manager
          yq                  # YAML/JSON processor
          # Editor + its file previews (yazi)
          neovim              # editor
          imagemagick         # image preview (magick)
          poppler             # PDF preview (pdftoppm)
          resvg               # SVG preview (rsvg-convert)
          # Terminal
          ghostty             # GPU-accelerated terminal emulator
        ];
      };
      # Desktop apps (GUI). Grown separately from the CLI set so a
      # CLI-only machine can `nix profile add .#cli` without them.
      apps = pkgs.buildEnv {
        name = "dot-apps";
        paths = with pkgs; [
          firefox             # web browser
          element-desktop     # Matrix client
        ];
      };
      # so `nix profile add .` (default package) installs everything
      default = pkgs.buildEnv {
        name = "dot-tools";
        paths = [ cli apps ];
      };
    });
  };
}
