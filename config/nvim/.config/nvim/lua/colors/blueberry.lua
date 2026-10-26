-- blueberry: a homemade colorscheme for Neovim.
--
-- A complete colorscheme in the modern sense: it clears all
-- highlights (hi clear), defines the classic groups, tree-sitter
-- captures and the plugin-specific groups used by this config
-- (lualine, telescope, fidget, gitsigns, notify), and sets
-- vim.g.colors_name. Loaded from init.lua via require — no
-- colors/ entry point needed.
--
-- Palette: deep indigo background, periwinkle text, magenta
-- keywords, teal preprocessor lines, warm orange numbers.

-- [[ Reset, like every proper colorscheme ]]
vim.cmd('hi clear')
if vim.fn.exists('syntax_on') then
  vim.cmd('syntax reset')
end
vim.o.background = 'dark'
vim.g.colors_name = 'blueberry'

-- [[ Palette ]]
local palette = {
  bg = '#171721',
  bg_soft = '#22172e',
  bg_mid = '#2e2e2e',
  bg_line = '#3e3e5e',
  bg_visual = '#4e4e8f',
  bg_fold = '#4b208f',
  bg_cursor = '#8b8bff',
  bg_search = '#cd8b60',
  bg_error = '#6e2e2e',
  bg_warn = '#ce8e4e',
  bg_diff_add = '#306d30',
  bg_diff_delete = '#6d3030',
  bg_diff_change = '#306b8f',
  bg_diff_text = '#4a2a4a',
  text = '#978aed',
  text_dim = '#543a61',
  text_soft = '#b9b9b9',
  text_bright = '#eeeeee',
  text_diff = '#ffffcd',
  text_match = '#404040',
  keyword = '#ff8bff',
  statement = '#cacde8',
  type = '#963996',
  preproc = '#409090',
  constant = '#ffcd8b',
  number = '#f0ad6d',
  boolean = '#808bed',
  special = '#c080d0',
  underlined = '#df9f2d',
  directory = '#00ff8b',
  nontext = '#8b8bcd',
  todo = '#fafdff',
  question = '#ffcd00',
  green = '#8fff8b',
}

-- [[ Highlights ]]
local hl = {
  -- base
  Normal = { fg = palette.text, bg = palette.bg },
  NormalFloat = { fg = palette.text, bg = palette.bg },
  LineNr = { fg = palette.nontext, bg = palette.bg_soft },
  CursorLineNr = { fg = palette.text_bright, bg = palette.bg_soft },
  SignColumn = { fg = palette.nontext, bg = palette.bg },
  EndOfBuffer = { fg = palette.bg_soft },
  ColorColumn = { bg = palette.bg_soft },
  CursorColumn = { bg = palette.bg_line },
  CursorLine = { bg = palette.bg_soft },
  NonText = { fg = palette.nontext },
  SpecialKey = { fg = palette.special },
  Folded = { fg = palette.text_soft, bg = palette.bg_fold },
  FoldColumn = { fg = palette.nontext, bg = palette.bg_mid },
  Conceal = { fg = palette.text_dim },

  -- syntax, classic groups
  Comment = { fg = palette.text_dim, italic = true },
  SpecialComment = { fg = palette.special },
  Todo = { fg = palette.todo, bold = true, underline = true },
  String = { bold = true },
  Character = { fg = palette.constant },
  Constant = { fg = palette.constant },
  Number = { fg = palette.number },
  Float = { fg = palette.number },
  Boolean = { fg = palette.boolean },
  Keyword = { fg = palette.keyword },
  Statement = { fg = palette.statement, bold = true },
  Identifier = { fg = palette.keyword },
  Function = { fg = palette.keyword },
  Type = { fg = palette.type },
  Typedef = { fg = palette.keyword },
  Structure = { fg = palette.keyword },
  Operator = { fg = palette.keyword },
  PreProc = { fg = palette.preproc },
  Include = { fg = palette.preproc },
  Define = { fg = palette.preproc },
  Macro = { fg = palette.preproc },
  Special = { fg = palette.special },
  SpecialChar = { fg = palette.special, bg = palette.bg_mid },
  Delimiter = { fg = palette.special },
  Conditional = { fg = palette.keyword },
  Repeat = { fg = palette.keyword },
  Exception = { fg = palette.keyword },
  Label = { fg = palette.keyword },
  StorageClass = { fg = palette.keyword },
  Debug = { fg = palette.special },
  Underlined = { fg = palette.underlined, underline = true },
  Directory = { fg = palette.directory },
  Error = { fg = '#ffffff', bg = palette.bg_error },
  ErrorMsg = { fg = '#ffffff', bg = palette.bg_warn },
  WarningMsg = { fg = '#ffffff', bg = palette.bg_warn },
  Question = { fg = palette.question },
  ModeMsg = { fg = palette.nontext },
  MoreMsg = { fg = palette.nontext },
  Cursor = { fg = palette.text_match, bg = palette.bg_cursor },
  lCursor = { fg = palette.text_match, bg = palette.green },
  MatchParen = { fg = palette.text_match, bg = palette.green },
  Visual = { fg = palette.text_bright, bg = palette.bg_visual },
  VisualNOS = { bg = palette.bg_visual },
  Search = { fg = '#303030', bg = palette.bg_search },
  IncSearch = { fg = '#303030', bg = palette.bg_search },
  WildMenu = { fg = palette.text_bright, bg = '#6e6eaf' },

  -- window chrome
  StatusLine = { fg = palette.text_soft, bg = palette.bg_line },
  StatusLineNC = { fg = palette.text_soft, bg = palette.bg_line },
  TabLine = { fg = palette.text_soft, bg = palette.bg_line },
  TabLineFill = { fg = palette.text_soft, bg = palette.bg_line },
  TabLineSel = { fg = palette.text_bright, bg = palette.bg_visual },
  VertSplit = { fg = palette.text_soft, bg = palette.bg_line },
  QuickFix = { fg = palette.text_soft, bg = palette.bg_line },
  FloatBorder = { fg = palette.nontext, bg = palette.bg },
  Terminal = { fg = palette.text, bg = palette.bg },

  -- completion menus
  Pmenu = { fg = palette.text_bright, bg = palette.bg_visual },
  PmenuSel = { fg = palette.text_bright, bg = palette.bg_line },
  PmenuSbar = { fg = palette.text_bright, bg = '#6e6eaf' },
  PmenuThumb = { fg = palette.text_bright, bg = '#6e6eaf' },

  -- diffs
  DiffAdd = { fg = palette.text_diff, bg = palette.bg_diff_add, bold = true },
  DiffDelete = { fg = palette.text_diff, bg = palette.bg_diff_delete, bold = true },
  DiffChange = { fg = palette.text_diff, bg = palette.bg_diff_change, bold = true },
  DiffText = { fg = palette.text_diff, bg = palette.bg_diff_text, bold = true },
}

-- [[ Tree-sitter captures ]]
local ts = {
  TSText = { fg = palette.text },
  TSTitle = { fg = palette.text_bright, bold = true },
  TSComment = { fg = palette.text_dim, italic = true },
  TSStrong = { fg = palette.keyword, bold = true },
  TSEmphasis = { fg = palette.text, italic = true },
  TSUnderline = { underline = true },
  TSEnvironment = { fg = palette.keyword },
  TSKeyword = { fg = palette.keyword },
  TSConditional = { fg = palette.keyword },
  TSRepeat = { fg = palette.keyword },
  TSLabel = { fg = palette.keyword },
  TSException = { fg = palette.keyword },
  TSOperatorWord = { fg = palette.keyword },
  TSTag = { fg = palette.special },
  TSTagDelimiter = { fg = palette.special },
  TSAttribute = { fg = palette.special },
  TSAnnotation = { fg = palette.special },
  TSInclude = { fg = palette.preproc },
  TSMacro = { fg = palette.preproc },
  TSScope = { fg = palette.preproc },
  TSScopeDelimiter = { fg = palette.special },
  TSFunction = { fg = palette.keyword },
  TSFunctionDeclaration = { fg = palette.keyword },
  TSFunctionCall = { fg = palette.keyword },
  TSMethod = { fg = palette.keyword },
  TSMethodCall = { fg = palette.keyword },
  TSConstructor = { fg = palette.keyword },
  TSIdentifier = { fg = palette.keyword },
  TSSelf = { fg = palette.keyword },
  TSParameter = { fg = palette.text },
  TSParameterReference = { fg = palette.text },
  TSConstParameter = { fg = palette.constant },
  TSConstBuiltin = { fg = palette.special },
  TSConstMacro = { fg = palette.preproc },
  TSConstant = { fg = palette.constant },
  TSString = { fg = palette.constant },
  TSStringRegex = { fg = palette.special },
  TSCharacter = { fg = palette.constant },
  TSNumber = { fg = palette.number },
  TSFloat = { fg = palette.number },
  TSBoolean = { fg = palette.boolean },
  TSOperator = { fg = palette.keyword },
  TSPunctuator = { fg = palette.text },
  TSType = { fg = palette.type },
  TSTypeAlias = { fg = palette.type },
  TSTypeDefinition = { fg = palette.type },
  TSTypeBuiltin = { fg = palette.type },
  TSModule = { fg = palette.type },
  TSNamespace = { fg = palette.type },
  TSField = { fg = palette.text },
  TSVariable = { fg = palette.text },
  TSVariableBuiltin = { fg = palette.special },
  TSVariableGlobal = { fg = palette.keyword },
  TSVariableLocal = { fg = palette.text },
  TSVariableParameter = { fg = palette.text },
  TSGlobal = { fg = palette.keyword },
  TSGlobalBuiltin = { fg = palette.special },
  TSGlobalMacro = { fg = palette.preproc },
  TSNote = { fg = palette.question },
  TSWarning = { fg = '#ffffff', bg = palette.bg_warn },
  TSError = { fg = '#ffffff', bg = palette.bg_error },
  TSDebug = { fg = palette.special },
}

-- [[ Plugin-specific groups ]]
local plugins = {
  -- telescope (the config's default picker style)
  TelescopeNormal = { fg = palette.text, bg = palette.bg },
  TelescopePromptNormal = { fg = palette.text, bg = palette.bg },
  TelescopePromptTitle = { fg = palette.text_bright },
  TelescopePromptBorder = { fg = palette.nontext, bg = palette.bg },
  TelescopeResultsNormal = { fg = palette.text, bg = palette.bg },
  TelescopeResultsTitle = { fg = palette.text_bright },
  TelescopeResultsBorder = { fg = palette.nontext, bg = palette.bg },
  TelescopeMatchingNormal = { fg = palette.text, bg = palette.bg },
  TelescopeMatchingTitle = { fg = palette.special },
  TelescopeMatchingIcon = { fg = palette.special },
  TelescopeSelection = { fg = palette.text_bright, bg = palette.bg_visual },
  TelescopeSelectionPlus = { fg = palette.text_bright, bg = palette.bg_visual },
  TelescopeResultsSelection = { fg = palette.text_bright, bg = palette.bg_visual },
  TelescopeResultsSelectionPlus = { fg = palette.text_bright, bg = palette.bg_visual },
  TelescopePromptText = { fg = palette.text },

  -- fidget (status line task progress)
  FidgetNormal = { fg = palette.text, bg = palette.bg },
  FidgetTitle = { fg = palette.text_soft, bg = palette.bg_line },
  FidgetIcon = { fg = palette.special },

  -- gitsigns (git +/- markers in the sign column)
  GitSignsAdd = { fg = palette.directory },
  GitSignsChange = { fg = palette.number },
  GitSignsDelete = { fg = '#ff8b8b' },

  -- notify
  NotifyError = { fg = '#ffffff', bg = palette.bg_error },
  NotifyInfo = { fg = palette.text, bg = palette.bg_line },
  NotifyWarn = { fg = '#ffffff', bg = palette.bg_warn },
  NotifyDebug = { fg = palette.text_soft, bg = palette.bg_line },
  NotifyTrace = { fg = palette.text_soft, bg = palette.bg_line },
}

-- [[ Apply ]]
local function apply(group, attrs)
  vim.api.nvim_set_hl(0, group, {
    fg = attrs.fg,
    bg = attrs.bg,
    italic = attrs.italic and true or nil,
    bold = attrs.bold and true or nil,
    underline = attrs.underline and true or nil,
  })
end

for group, attrs in pairs(hl) do
  apply(group, attrs)
end
for group, attrs in pairs(ts) do
  apply(group, attrs)
end
for group, attrs in pairs(plugins) do
  apply(group, attrs)
end

-- Fire the ColorScheme event so plugins that re-derive their own
-- highlight groups on theme change (mini.statusline, telescope,
-- ...) recompute them against this palette instead of the theme
-- that was active when they initialized.
vim.cmd('doautocmd ColorScheme')
