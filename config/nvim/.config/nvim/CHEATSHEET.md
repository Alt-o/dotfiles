# Neovim keymap cheatsheet

Notation: `Space` is the leader key (press it, then the rest).
`C-x` = Ctrl+x, `S-x` = Shift+x (e.g. capital X).
Every keymap below shows its which-key description in brackets.

## Getting around

| Keys | What |
| --- | --- |
| `s` / `S` | flash: label words ahead / treesitter nodes, type label to jump |
| `C-h` `C-j` `C-k` `C-l` | move split, then cross into tmux panes (navigator) |
| `C-\` | toggle previously focused split / tmux pane |
| `]c` / `[c` | next / previous git change (hunk) |

## Completion (blink.cmp, preset `default`)

The menu opens automatically while typing.

| Keys | What |
| --- | --- |
| `C-y` | **accept** the highlighted completion ([y]es) |
| `C-/` | open the menu manually / show docs (**tmux-safe**: see below) |
| `C-Space` | open the menu (only outside tmux — `C-space` is the tmux prefix) |
| `C-n` `C-p` or `Up` `Down` | next / previous item |
| `C-e` | hide the menu |
| `C-k` | toggle signature help |
| `Tab` / `S-Tab` | next / previous snippet placeholder (after accepting) |

Enter and Tab intentionally do NOT accept: they keep their normal
"insert newline" / snippet role (see `:help ins-completion`).

## Telescope search (`Space s …`)

| Keys | What |
| --- | --- |
| `Space s f` | find files |
| `Space s g` | live grep |
| `Space s w` | grep current word |
| `Space s d` | diagnostics |
| `Space s r` | resume last picker |
| `Space s .` | recent files |
| `Space s c` | search commands |
| `Space s h` | search help |
| `Space s k` | search keymaps |
| `Space s s` | pick a telescope picker |
| `Space Space` | find existing buffers |

## Git (`Space h …` — gitsigns)

| Keys | What |
| --- | --- |
| `Space h s` / `Space h r` | stage / reset hunk under cursor |
| `Space h S` / `Space h R` | stage / reset whole buffer |
| `Space h p` | preview hunk |
| `Space h i` | preview hunk inline |
| `Space h b` | blame line |
| `Space h d` | diff against index |
| `Space h q` | quickfix list of changes in this file |
| `v i h` | visual: select hunk as text object |
| `Space t b` | toggle blame for current line |

## LSP (active when a language server is attached)

| Keys | What |
| --- | --- |
| `grd` | goto definition |
| `grt` | goto type definition |
| `grr` | goto references |
| `gri` | goto implementations |
| `grD` | goto declaration |
| `grn` | rename symbol |
| `gra` | code action (also visual mode) |
| `gO` | document symbols |
| `gW` | workspace symbols |
| `Space q` | diagnostic quickfix list |
| `C-]` | goto definition (builtin) |

## Commands worth knowing

```
:Mason            open the tool/server manager UI
:MasonInstall X   install a server or formatter by name
:TSInstall        install treesitter parsers
:checkhealth      doctor for the setup (pack, mason, treesitter, …)
:Telescope keymaps   find any keymap in prose
:help ins-completion   why Tab/Enter don't accept completions
```
