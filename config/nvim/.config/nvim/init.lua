-- ============================================================================
-- init.lua — dotfiles-local Neovim config.
--
-- The base config is upstream kickstart.nvim, kept as a git submodule in
-- kickstart/ and loaded verbatim below. All dotfiles-local decisions
-- (palette, relative numbers, extra plugins) live in this file only, so
-- the submodule can be bumped to a newer upstream commit without
-- local patches.
--
-- Plugin/LSP state lives in ~/.local/share/nvim — never in this directory.
-- ============================================================================

local function gh(repo) return 'https://github.com/' .. repo end

-- [[ Base config ]]
-- Load the untouched upstream kickstart: options, keymaps, completion,
-- LSP + Mason, formatting.
local kickstart_init = vim.fn.stdpath 'config' .. '/kickstart/init.lua'
if vim.fn.filereadable(kickstart_init) ~= 1 then
  vim.notify(
    'kickstart.nvim not found at ' .. kickstart_init
    .. ' — run `git submodule update --init` in the dotfiles repo',
    vim.log.levels.ERROR
  )
end
dofile(kickstart_init)

-- [[ Dotfiles overrides ]]
do
  -- Relative line numbers: upstream ships this commented out; keep the
  -- local preference.
  vim.o.relativenumber = true

  -- Soft column ruler at 85: wide enough for most prose and code,
  -- still keeps wrapped lines under the typical 80-col terminal row.
  -- (String: the option is a comma-separated column list.)
  vim.o.colorcolumn = '85'

  -- Indentation: spaces, 4-wide — the Python/PEP-8 standard.
  -- (kickstart ships tabs off with 2-space indent; no per-language
  -- overrides, keep one simple rule.)
  vim.o.expandtab = true
  vim.o.shiftwidth = 4
  vim.o.tabstop = 4

  -- Spell-check by default (toggle per-buffer with :set nospell).
  vim.o.spell = true

  -- Palette: blueberry, a local colorscheme module (lua/colors/
  -- blueberry.lua, no plugin to install). Required directly after the
  -- base config so it overrides kickstart's own theme without
  -- touching the upstream file. Dracula stays the repo-wide palette
  -- outside the editor and is kept installed here as a fallback:
  -- `:colorscheme dracula` switches to it, `:colorscheme blueberry`
  -- ... doesn't — the local one has no colors/ entry, so reload it
  -- with `:source $MYVIMRC` or just restart.
  vim.pack.add { gh 'dracula/vim' }
  require('colors.blueberry')

  -- Quick visual jumps: `s` marks words ahead, `S` marks treesitter
  -- nodes behind; type the label to jump. Pairs with telescope for
  -- longer navigation. Keymaps per the plugin docs (no defaults).
  vim.pack.add { gh 'folke/flash.nvim' }
  require('flash').setup {}
  vim.keymap.set({ 'n', 'x', 'o' }, 's', function()
    require('flash').jump()
  end, { desc = 'Flash (jump forward)' })
  vim.keymap.set({ 'n', 'x', 'o' }, 'S', function()
    require('flash').treesitter()
  end, { desc = 'Flash (treesitter)' })

  -- Completion menu trigger: blink's default is <C-space>, but our
  -- tmux prefix is C-space too — tmux intercepts it before nvim ever
  -- sees it. Ctrl+/ passes through tmux; in nvim's key notation that
  -- byte (0x1f) is written <C-_> — NOT <C-/> (that notation
  -- compiles to byte 128, so a <C-/> mapping never fires).
  -- <C-space> still works outside tmux.
  vim.keymap.set('i', '<C-_>', function()
    require('blink.cmp').show()
  end, { desc = 'Blink: show completion menu (Ctrl+/)' })

  -- tmux pane navigation: the tmux side (vim-tmux-navigator in
  -- tmux.conf) already binds <C-hjkl>; this is the vim-side half that
  -- lets nvim hand those keys to tmux when the window cannot move
  -- further (vimscript plugin, no setup needed).
  vim.pack.add { gh 'christoomey/vim-tmux-navigator' }
end
