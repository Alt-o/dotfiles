# ============================================================================
# dotfiles — bootstrap Makefile.
#
# Sets up nix + the tool set from flake.nix (which includes stow
# itself), then distributes the dotfiles with stow. No apt anywhere.
#
# ============================================================================

.DEFAULT_GOAL := help

CURL := curl --proto '=https' --tlsv1.2 -LsSf
FONT_URL := \
	https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/install.sh
# Quoted for the shell: make expands variables without quote protection,
# so the space-carrying feature list must arrive as one shell word.
NIX_FLAGS := --extra-experimental-features "nix-command flakes"
# stow ships in the flake profile. Prepend the profile bin to PATH so it
# is found even in non-interactive make shells where the nix PATH hook
# (the zshrc env block) has not run.
STOW := env PATH="$HOME/.nix-profile/bin:$$PATH" stow

# --- Output -----------------------------------------------------------------
ESC := \033
BOLD := $(ESC)[1m
GREEN := $(ESC)[32m
RED := $(ESC)[31m
YELLOW := $(ESC)[33m
RESET := $(ESC)[0m

# Output helpers, used as $(call helper, text):
#   banner <n> <text>  step header, e.g. "==> [2/3] ..."
#   ok <text>          green check, printed after a step succeeded
#   fail <text>        red cross, printed right before `exit 1`
#   warn <text>        yellow triangle, advisory note (tips target)
# text may not contain commas (make call argument separator).
# Every real command in a recipe ends with an explicit failure branch:
#   @cmd || { $(call fail, what went wrong); exit 1; }
# so a broken run names the step that died instead of aborting silently.
# shellcheck disable=SC2283 # make macro assignment, not shell syntax
banner = @printf "$(BOLD)==> $(1) $(2)$(RESET)\n"
ok = @printf "  $(GREEN)✓ $(1)$(RESET)\n"
fail = printf "  $(RED)✗ $(1)$(RESET)\n"
warn = @printf "  $(YELLOW)▲ $(1)$(RESET)\n"

# --- Target -----------------------------------------------------------------
.PHONY: help install install-apps install-full \
	install-deps install-nix install-dotfiles tips

help:
	@echo "dotfiles bootstrap — targets:"
	@echo "  install             base bootstrap (fonts -> nix CLI set -> dotfiles)"
	@echo "  install-apps        add GUI apps (firefox, element) — desktop only"
	@echo "  install-full        install + install-apps in one go"
	@echo "  install-deps        Nerd Fonts (curl installer)"
	@echo "  install-nix         nix + flake CLI tool set (includes stow)"
	@echo "  install-dotfiles    submodules, stow, tmux plugins, local seed"
	@echo "  tips                post-install advisory notes (runs after install)"
	@echo "  help                this list (default goal)"

install-deps:
	$(call banner,1/3,Nerd Fonts)
	@$(CURL) $(FONT_URL) -o /tmp/nerd-fonts.sh && chmod u+x /tmp/nerd-fonts.sh \
		|| { $(call fail,Nerd Fonts installer download failed); exit 1; }
	@if [ -d ~/.local/share/fonts/NerdFonts ] && \
		[ -n "$$(ls -A ~/.local/share/fonts/NerdFonts 2>/dev/null)" ]; then \
		echo "  Nerd Fonts already installed — skipping"; \
	else \
		/tmp/nerd-fonts.sh install all \
			|| { $(call fail,Nerd Fonts install failed); exit 1; } \
		&& printf "  $(GREEN)✓ Nerd Fonts installed$(RESET)\n"; \
	fi

install-nix:
	$(call banner,2/3,Nix + flake CLI tool set)
	@if command -v nix >/dev/null; then \
		echo "  nix already installed — skipping installer"; \
	else \
		$(CURL) https://nixos.org/nix/install | sh -s -- --daemon \
			|| { $(call fail,nix installer failed); exit 1; } \
		&& printf "  $(GREEN)✓ nix installed (multi-user, daemon)$(RESET)\n"; \
	fi
	@if nix $(NIX_FLAGS) profile list | grep -qE 'Flake attribute:.*\.cli'; then \
		nix $(NIX_FLAGS) profile upgrade cli \
			|| { $(call fail,CLI tool set upgrade failed); exit 1; } \
		&& printf "  $(GREEN)✓ CLI tool set upgraded$(RESET)\n"; \
	else \
		nix $(NIX_FLAGS) profile add .#cli \
			|| { $(call fail,CLI tool set install failed); exit 1; } \
		&& printf "  $(GREEN)✓ CLI tool set installed via nix profile$(RESET)\n"; \
	fi

# GUI apps from the flake (firefox, element-desktop). Desktop machines
# only: run as part of `install-full` or standalone. Idempotent, like
# install-nix — upgrades the dot-apps profile when it exists.
install-apps:
	$(call banner,+,GUI apps (desktop machines))
	@if ! command -v nix >/dev/null; then \
		$(call fail,nix not found — run `make install` first); exit 1; \
	fi
	@if nix $(NIX_FLAGS) profile list | grep -qE 'Flake attribute:.*\.apps'; then \
		nix $(NIX_FLAGS) profile upgrade apps \
			|| { $(call fail,GUI apps upgrade failed); exit 1; } \
		&& printf "  $(GREEN)✓ GUI apps upgraded$(RESET)\n"; \
	else \
		nix $(NIX_FLAGS) profile add .#apps \
			|| { $(call fail,GUI apps install failed); exit 1; } \
		&& printf "  $(GREEN)✓ GUI apps installed via nix profile$(RESET)\n"; \
	fi

install-dotfiles:
	$(call banner,3/3,Dotfiles (stow) + local seed)
	@git submodule update --init --recursive \
		|| { $(call fail,submodule update failed); exit 1; }
	$(call ok,submodules up to date)
	@if [ -e ~/.zshrc ] && [ ! -L ~/.zshrc ]; then \
		mv ~/.zshrc ~/.zshrc.backup; \
		echo "  backed up existing ~/.zshrc to ~/.zshrc.backup"; fi
	@cd config && $(STOW) * \
		|| { $(call fail,stow failed); exit 1; }
	$(call ok,all packages stowed into ~/)
	@if [ -x ~/.config/tmux/plugins/tpm/tpm ]; then \
		~/.config/tmux/plugins/tpm/bindings/install_plugins >/dev/null \
			|| { $(call fail,tmux plugin install failed); exit 1; } \
		&& printf "  $(GREEN)✓ tmux plugins installed$(RESET)\n"; \
	else \
		git clone --quiet https://github.com/tmux-plugins/tpm \
			~/.config/tmux/plugins/tpm \
			&& ~/.config/tmux/plugins/tpm/bindings/install_plugins >/dev/null \
			|| { $(call fail,tmux plugin install failed); exit 1; } \
		&& printf "  $(GREEN)✓ tmux plugins installed (tpm cloned)$(RESET)\n"; \
	fi
	@cp --update=none "$$PWD/config/zsh/.config/zsh/.zshrc_local.example" \
		~/.config/zsh/.zshrc_local \
		|| { $(call fail,.zshrc_local seed failed); exit 1; }
	$(call ok,.zshrc_local seeded (only if missing))
	@cp --update=none "$$PWD/config/git/.gitconfig_local.example" \
		~/.gitconfig_local \
		|| { $(call fail,.gitconfig_local seed failed); exit 1; }
	$(call ok,.gitconfig_local seeded (only if missing))

# --- Tips ----------------------------------------------------------------------
# Advisory notes, printed at the end of `install`. Each is guarded so
# re-runs stay quiet. New tips go here.
HISTORY_TIP := old shell history at ~/.zsh_history — one-time: atuin import zsh

ZSHRC_TIP := .zshrc_local is still the template — review it
GITID_TIP := git identity still the placeholder — set user.name/email in ~/.gitconfig_local

tips:
	@if [ -s "$$HOME/.zsh_history" ]; then \
		printf "  $(YELLOW)▲ $(HISTORY_TIP)$(RESET)\n"; \
	fi
	@if cmp -s "$$PWD/config/zsh/.config/zsh/.zshrc_local.example" \
		"$$HOME/.config/zsh/.zshrc_local"; then \
		printf "  $(YELLOW)▲ $(ZSHRC_TIP)$(RESET)\n"; \
	fi
	@if [ -f "$$HOME/.gitconfig_local" ] && \
		grep -q "you@example.com" "$$HOME/.gitconfig_local"; then \
		printf "  $(YELLOW)▲ $(GITID_TIP)$(RESET)\n"; \
	fi

install: install-deps install-nix install-dotfiles tips
	@echo ""
	@printf "$(GREEN)✓ dotfiles bootstrap complete — open a new \
shell to apply.$(RESET)\n"

install-full: install install-apps
	@echo ""
	@printf "$(GREEN)✓ full bootstrap complete (CLI + GUI) — open a \
new shell to apply.$(RESET)\n"
