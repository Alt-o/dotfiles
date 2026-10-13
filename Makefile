# ============================================================================
# dotfiles — bootstrap Makefile.
#
# Installs the true OS-level deps, sets up nix + the tool set from
# flake.nix, then distributes the dotfiles with stow.
#
# ============================================================================

.DEFAULT_GOAL := help

CURL := curl --proto '=https' --tlsv1.2 -LsSf
FONT_URL := \
	https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/install.sh
# Quoted for the shell: make expands variables without quote protection,
# so the space-carrying feature list must arrive as one shell word.
NIX_FLAGS := --extra-experimental-features "nix-command flakes"
PACKAGE_MGR := sudo apt install

# True OS-level bootstrap deps; everything else comes from the flake.
PACKAGES :=
PACKAGES += curl
PACKAGES += stow

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
banner = @printf "$(BOLD)==> $(1)/3] $(2)$(RESET)\n"
ok = @printf "  $(GREEN)✓ $(1)$(RESET)\n"
fail = printf "  $(RED)✗ $(1)$(RESET)\n"
warn = @printf "  $(YELLOW)▲ $(1)$(RESET)\n"

# --- Target -----------------------------------------------------------------
.PHONY: help install install-deps install-nix install-dotfiles tips

help:
	@echo "dotfiles bootstrap — targets:"
	@echo "  install             full bootstrap (deps -> nix -> dotfiles)"
	@echo "  install-deps        OS deps (stow) + Nerd Fonts"
	@echo "  install-nix         nix + flake tool set"
	@echo "  install-dotfiles    submodules, stow, local seed"
	@echo "  tips                post-install advisory notes (runs after install)"
	@echo "  help                this list (default goal)"

install-deps:
	$(call banner,1,OS packages + Nerd Fonts)
	@if command -v curl >/dev/null && command -v stow >/dev/null; then \
		echo "  OS packages already installed — skipping"; \
	else \
		$(PACKAGE_MGR) $(PACKAGES) \
			|| { $(call fail,OS packages install failed); exit 1; } \
		&& printf "  $(GREEN)✓ OS packages installed (%s)$(RESET)\n" "$(PACKAGES)"; \
	fi
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
	$(call banner,2,Nix + flake tool set)
	@if command -v nix >/dev/null; then \
		echo "  nix already installed — skipping installer"; \
	else \
		$(CURL) https://nixos.org/nix/install | sh -s -- --daemon \
			|| { $(call fail,nix installer failed); exit 1; } \
		&& printf "  $(GREEN)✓ nix installed (multi-user, daemon)$(RESET)\n"; \
	fi
	@if nix $(NIX_FLAGS) profile list | grep -qF "$$(basename "$$PWD")"; then \
		nix $(NIX_FLAGS) profile upgrade "$$(basename "$$PWD")" \
			|| { $(call fail,flake tool set upgrade failed); exit 1; } \
		&& printf "  $(GREEN)✓ flake tool set upgraded$(RESET)\n"; \
	else \
		nix $(NIX_FLAGS) profile add . \
			|| { $(call fail,flake tool set install failed); exit 1; } \
		&& printf "  $(GREEN)✓ flake tool set installed via nix profile$(RESET)\n"; \
	fi

install-dotfiles:
	$(call banner,3,Dotfiles (stow) + local seed)
	@git submodule update --init --recursive \
		|| { $(call fail,submodule update failed); exit 1; }
	$(call ok,submodules up to date)
	@if [ -e ~/.zshrc ] && [ ! -L ~/.zshrc ]; then \
		mv ~/.zshrc ~/.zshrc.backup; \
		echo "  backed up existing ~/.zshrc to ~/.zshrc.backup"; fi
	@cd config && stow * \
		|| { $(call fail,stow failed); exit 1; }
	$(call ok,all packages stowed into ~/)
	@cp --update=none ~/.config/zsh/.zshrc_local.example ~/.config/zsh/.zshrc_local \
		|| { $(call fail,.zshrc_local seed failed); exit 1; }
	$(call ok,.zshrc_local seeded (only if missing))

# --- Tips ----------------------------------------------------------------------
# Advisory notes, printed at the end of `install`. Each is guarded so
# re-runs stay quiet. New tips go here.
HISTORY_TIP := old shell history at ~/.zsh_history — one-time: atuin import zsh

tips:
	@if [ -s "$$HOME/.zsh_history" ]; then \
		printf "  $(YELLOW)▲ $(HISTORY_TIP)$(RESET)\n"; \
	fi

install: install-deps install-nix install-dotfiles tips
	@echo ""
	@printf "$(GREEN)✓ dotfiles bootstrap complete — open a new \
	shell to apply.$(RESET)\n"
