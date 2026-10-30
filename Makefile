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
	@# f stays empty for "n" below: no arg means the script
	@# prints its selection menu instead of installing a default.
	@if [ -d ~/.local/share/fonts/NerdFonts ] && \
		[ -n "$$(ls -A ~/.local/share/fonts/NerdFonts 2>/dev/null)" ]; then \
		echo "  Nerd Fonts already installed — skipping"; \
	else \
		printf "  install the default font (JetBrainsMono)? [Y/n] "; \
		read -r ans || ans=""; \
		if [ "$$ans" != "n" ] && [ "$$ans" != "N" ]; then \
			f=JetBrainsMono; \
		fi; \
		/tmp/nerd-fonts.sh install $$f \
			|| { $(call fail,Nerd Fonts install failed); exit 1; } \
		&& printf "  $(GREEN)✓ Nerd Fonts installed$(RESET)\n" \
		&& printf "  $(YELLOW)▲ don't forget: if you picked another font,\n    set font-family in ~/.config/ghostty/config.ghostty to match$(RESET)\n"; \
	fi

# First-run nix install: the installer writes its PATH hook into shell
# profiles only, so within this make run the binary is found via the
# fixed ~/.nix-profile location (see NIX resolution below). Its
# banner output is silenced on success; stderr still surfaces.
install-nix:
	$(call banner,2/3,Nix + flake CLI tool set)
	@if command -v nix >/dev/null; then \
		echo "  nix already installed — skipping installer"; \
	elif [ -x ~/.nix-profile/bin/nix ]; then \
		echo "  nix installed (not on this shell's PATH) — skipping installer"; \
	else \
		$(CURL) https://nixos.org/nix/install | sh -s -- --daemon >/dev/null \
			|| { $(call fail,nix installer failed); exit 1; } \
		&& printf "  $(GREEN)✓ nix installed (multi-user, daemon)$(RESET)\n"; \
	fi
	@NIX=$$(command -v nix 2>/dev/null || echo "$$HOME/.nix-profile/bin/nix"); \
	if [ ! -x "$$NIX" ]; then \
		$(call fail,nix not found — open a new shell and re-run); exit 1; \
	fi; \
	if "$$NIX" $(NIX_FLAGS) profile list | \
		grep -qE 'Flake attribute:.*\.cli'; then \
		"$$NIX" $(NIX_FLAGS) profile upgrade cli \
			|| { $(call fail,CLI tool set upgrade failed); exit 1; } \
		&& printf "  $(GREEN)✓ CLI tool set upgraded$(RESET)\n"; \
	else \
		"$$NIX" $(NIX_FLAGS) profile add .#cli \
			|| { $(call fail,CLI tool set install failed); exit 1; } \
		&& printf "  $(GREEN)✓ CLI tool set installed via nix profile$(RESET)\n"; \
	fi
	@# Login shell: the dotfiles assume zsh; base images (e.g. WSL)
	@# may not ship it. Resolve it from PATH or the nix profile,
	@# register it in /etc/shells, and set it via passwordless
	@# sudo chsh when available (WSL); otherwise print manual steps.
	@ZSH=$$(command -v zsh 2>/dev/null || \
		echo "$$HOME/.nix-profile/bin/zsh"); \
	if [ ! -x "$$ZSH" ]; then \
		echo "  $(YELLOW)▲ zsh not found (PATH or ~/.nix-profile/bin)."; \
		echo "  Once the nix CLI set is in, set it manually:"; \
		echo "  $(BOLD)echo $$ZSH | sudo tee -a /etc/shells$(RESET)\n"; \
		echo "  $(BOLD)chsh -s $$ZSH$(RESET)"; \
	elif readlink -f "$$SHELL" | grep -q '/zsh'; then \
		echo "  login shell is already zsh"; \
	elif sudo -n sh -c "grep -qxF '$$ZSH' /etc/shells || \
		echo '$$ZSH' >> /etc/shells" 2>/dev/null \
		&& sudo -n chsh -s "$$ZSH" "$$(id -un)" 2>/dev/null; then \
		printf "  $(GREEN)✓ login shell set to $$ZSH$(RESET)\n"; \
	else \
		echo "  $(YELLOW)▲ set your login shell manually:"; \
		echo "  $(BOLD)echo $$ZSH | sudo tee -a /etc/shells$(RESET)\n"; \
		echo "  $(BOLD)chsh -s $$ZSH$(RESET)"; \
	fi

# GUI apps from the flake (firefox, element-desktop). Desktop machines
# only: run as part of `install-full` or standalone. Idempotent, like
# install-nix — upgrades the dot-apps profile when it exists.
install-apps:
	$(call banner,+,GUI apps (desktop machines))
	@NIX=$$(command -v nix 2>/dev/null || echo "$$HOME/.nix-profile/bin/nix"); \
	if [ ! -x "$$NIX" ]; then \
		$(call fail,nix not found — run `make install` first); exit 1; \
	fi; \
	if "$$NIX" $(NIX_FLAGS) profile list | \
		grep -qE 'Flake attribute:.*\.apps'; then \
		"$$NIX" $(NIX_FLAGS) profile upgrade apps \
			|| { $(call fail,GUI apps upgrade failed); exit 1; } \
		&& printf "  $(GREEN)✓ GUI apps upgraded$(RESET)\n"; \
	else \
		"$$NIX" $(NIX_FLAGS) profile add .#apps \
			|| { $(call fail,GUI apps install failed); exit 1; } \
		&& printf "  $(GREEN)✓ GUI apps installed via nix profile$(RESET)\n"; \
	fi

install-dotfiles:
	$(call banner,3/3,Dotfiles (stow) + local seed)
	@git submodule update --init --recursive \
		|| { $(call fail,submodule update failed); exit 1; }
	$(call ok,submodules up to date)
	@# stow refuses to symlink over existing files: back up any stow
	@# target that is still a real (non-symlink) file. git ls-files
	@# (not find) so untracked leftovers in the repo tree — e.g. a
	@# stale tpm clone from when it was a submodule — are never
	@# treated as stow targets. The readlink guard skips targets
	@# that resolve into the stow root: when stow stows a whole
	@# directory as one symlink, the target path IS the source
	@# file, and backing it up would delete tracked files. Dangling
	@# links are stale leftovers (e.g. the repo moved): stow links
	@# each config package as one directory symlink (e.g. 
	@# ~/.config/zsh), so those package dirs are checked too, and
	@# any dangling link is removed. Live foreign links are left
	@# for stow's conflict warning to name. Re-runs are safe: our
	@# own stow symlinks are left in place.
	@for f in $$(git ls-files config | \
		grep -vE '\.example$$|^config/\.stowrc$$'); do \
		t="$$HOME/$${f#config/*/}"; \
		if [ -L "$$t" ]; then \
			if [ ! -e "$$t" ]; then \
				rm -f "$$t" && echo "  removed dangling link $$t"; \
			fi; \
		elif [ -e "$$t" ]; then \
			case "$$(readlink -f "$$t")" in \
				"$$(pwd)/config"/*) ;; \
				*) mv "$$t" "$$t.stow-backup" \
					&& echo "  backed up $$t -> $$t.stow-backup";; \
			esac; \
		fi; \
	done
	@# Stow links a package's .config dir (e.g. ~/.config/zsh) as a
	@# single symlink; if the repo moved since, that link dangles
	@# while the per-file targets above still "exist" through it,
	@# so remove dangling package-dir links explicitly.
	@for d in config/*/; do \
		p="$$d"; p="$$p"; p="$${p#config/}"; p="$${p%/}"; \
		if [ -d "$$d/.config" ]; then \
			t="$$HOME/.config/$$p"; \
			if [ -L "$$t" ] && [ ! -e "$$t" ]; then \
				rm -f "$$t" && echo "  removed dangling link $$t"; \
			fi; \
		fi; \
	done
	@# stow exits non-zero on conflict, but older versions may skip
	@# a package with only a WARNING line, so treat any warning as
	@# failure too: a skipped package is a broken install.
	@if ! out=$$(cd config && $(STOW) * 2>&1); then \
		printf '%s\n' "$$out"; \
		if printf '%s\n' "$$out" | grep -q '^WARNING'; then \
			$(call fail,stow skipped packages due to conflicts); \
		else \
			$(call fail,stow failed); \
		fi; \
		echo "  for each target named above (relative to ~):"; \
		echo "    ls -l <path>             # inspect what it is"; \
		echo "    mv <path> <path>.keep    # move it aside (rm if dangling)"; \
		echo "  then re-run: make install-dotfiles"; \
		exit 1; \
	fi; printf '%s\n' "$$out"; \
	if printf '%s\n' "$$out" | grep -q '^WARNING'; then \
		$(call fail,stow skipped packages due to conflicts); \
		echo "  for each target named above (relative to ~):"; \
		echo "    ls -l <path>             # inspect what it is"; \
		echo "    mv <path> <path>.keep    # move it aside (rm if dangling)"; \
		echo "  then re-run: make install-dotfiles"; \
		exit 1; \
	fi
	$(call ok,all packages stowed into ~/)
	@# bat/delta load custom syntax themes only through bat's asset
	@# cache (~/.cache/bat), so repack it now that the stowed
	@# Blueberry.tmTheme is in place. A failure only costs the
	@# custom theme (built-ins still work), so warn rather than abort.
	@if command -v bat >/dev/null; then \
		bat cache --build >/dev/null 2>&1 \
			&& printf '  $(GREEN)✓ bat theme cache built$(RESET)\n' \
			|| $(call warn,bat cache build failed — delta falls back to built-in themes); \
	fi
	@# tpm is machine-local (not stowed). The `run '.../tpm'` line in
	@# tmux.conf auto-installs the configured plugins on first tmux
	@# start, so the Makefile only needs tpm itself to be present.
	@mkdir -p "$$HOME/.config/tmux/plugins"; \
	if [ ! -d "$$HOME/.config/tmux/plugins/tpm" ]; then \
		git clone --quiet https://github.com/tmux-plugins/tpm \
			"$$HOME/.config/tmux/plugins/tpm" \
			&& printf "  $(GREEN)✓ tpm cloned — plugins auto-install\n" \
			"on first tmux start$(RESET)\n"; \
	else \
		echo "  tpm already present — plugins auto-install on first tmux start"; \
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
HISTORY_TIP := old history at ~/.zsh_history — one-time: atuin import zsh

ZSHRC_TIP := .zshrc_local is still the template — review it
GITID_TIP := set user.name/email in ~/.gitconfig_local (still placeholder)
TMUX_TIP := start tmux once so tpm can install the configured plugins

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
	@NP=$$(grep -cE "@plugin[[:space:]]+'" \
		"$$HOME/.config/tmux/tmux.conf" 2>/dev/null); \
	ND=$$(find "$$HOME/.config/tmux/plugins" -mindepth 1 -maxdepth 1 \
		-type d 2>/dev/null | wc -l); \
	if [ -n "$$NP" ] && [ "$$ND" -lt "$$NP" ]; then \
		printf "  $(YELLOW)▲ $(TMUX_TIP)$(RESET)\n"; \
	fi

install: install-deps install-nix install-dotfiles tips
	@echo ""
	@printf "$(GREEN)✓ dotfiles bootstrap complete — open a new \
shell to apply.$(RESET)\n"

install-full: install install-apps
	@echo ""
	@printf "$(GREEN)✓ full bootstrap complete (CLI + GUI) — open a \
new shell to apply.$(RESET)\n"
