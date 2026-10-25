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

  -- Palette: Dracula everywhere (repo-wide convention). Kickstart
  -- installs and loads tokyonight inside its own init; load dracula
  -- right after so the final look is Dracula without touching the
  -- upstream file.
  vim.pack.add { gh 'dracula/vim' }
  vim.cmd.colorscheme 'dracula'

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
