#!/usr/bin/env bash
# ============================================================================
# install.sh — headless dotfiles hook.
#
# Entry point for servers / remote workspaces: run it manually, or let
# a workspace provider execute it as the dotfiles setup script
# (such tools look for an executable install.sh in the repo root).
#
# Runs the full base install (make install) minus Nerd Fonts — nothing
# headless renders them, and the font installer prompts. Prerequisite:
# make. Idempotent: every step is a skip-or-upgrade, so re-runs on
# restart stay cheap.
# ============================================================================
set -euo pipefail
cd "$(dirname "$0")"

exec make install-nix install-dotfiles tips
