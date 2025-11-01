-- charon-dark: Custom dark theme based on Ayu colors with #030712 background
vim.cmd('hi clear')
if vim.fn.exists('syntax_on') then
  vim.cmd('syntax reset')
end

vim.o.background = 'dark'
vim.g.colors_name = 'charon-dark'

-- Color palette based on Ayu Dark
local colors = {
  -- Core colors
  bg = '#030712',
  fg = '#e5e7eb',
  accent = '#ccfbf1',
  ui = '#565B66',

  -- Syntax colors
  tag = '#39BAE6',
  func = '#fbbf24',
  entity = '#59C2FF',
  string = '#5eead4',
  regexp = '#95E6CB',
  markup = '#F07178',
  keyword = '#818cf8',
  special = '#E6B673',
  comment = '#4b5563',
  constant = '#D2A6FF',
  operator = '#F29668',
  error = '#ef4444',
  warning = '#fb923c',

  -- UI colors
  line = '#070b16',
  panel_bg = '#020610',
  panel_shadow = '#01040a',
  panel_border = '#000000',
  gutter_normal = '#454B55',
  gutter_active = '#626975',
  selection_bg = '#1B3A5B',
  selection_inactive = '#122132',
  selection_border = '#304357',
  guide_active = '#3C414A',
  guide_normal = '#1E222A',

  -- VCS colors
  vcs_added = '#4ade80',
  vcs_modified = '#73B8FF',
  vcs_removed = '#f87171',
  vcs_added_bg = '#1D2214',
  vcs_removed_bg = '#2D2220',

  -- Additional colors
  white = '#FFFFFF',
  black = '#000000',
  fg_idle = '#565B66',
}

-- Helper function to set highlight groups
local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Basic UI
hl('Normal', { fg = colors.fg, bg = 'NONE' })
hl('NormalNC', { fg = colors.fg, bg = 'NONE' })
hl('Cursor', { fg = colors.bg, bg = colors.accent })
hl('CursorLine', { bg = colors.line })
hl('CursorColumn', { bg = colors.line })
hl('CursorLineNr', { fg = colors.accent, bg = 'NONE' })
hl('LineNr', { fg = colors.gutter_normal, bg = 'NONE' })
hl('SignColumn', { fg = colors.gutter_normal, bg = 'NONE' })
hl('Visual', { bg = colors.selection_bg })
hl('VisualNOS', { bg = colors.selection_inactive })
hl('Search', { fg = colors.bg, bg = colors.accent })
hl('IncSearch', { fg = colors.bg, bg = colors.accent })
hl('MatchParen', { fg = colors.accent, bold = true })

-- Windows and splits
hl('VertSplit', { fg = colors.panel_border, bg = 'NONE' })
hl('WinSeparator', { fg = colors.panel_border, bg = 'NONE' })
hl('ColorColumn', { bg = colors.line })
hl('Folded', { fg = colors.comment, bg = colors.panel_bg })
hl('FoldColumn', { fg = colors.gutter_normal, bg = 'NONE' })

-- Status line
hl('StatusLine', { fg = colors.fg, bg = colors.panel_bg })
hl('StatusLineNC', { fg = colors.comment, bg = colors.panel_bg })

-- Tabs
hl('TabLine', { fg = colors.comment, bg = colors.panel_bg })
hl('TabLineFill', { bg = 'NONE' })
hl('TabLineSel', { fg = colors.fg, bg = 'NONE' })

-- Popup menu
hl('Pmenu', { fg = colors.fg, bg = colors.panel_bg })
hl('PmenuSel', { fg = colors.bg, bg = colors.accent })
hl('PmenuSbar', { bg = colors.panel_bg })
hl('PmenuThumb', { bg = colors.ui })

-- Messages
hl('ErrorMsg', { fg = colors.error })
hl('WarningMsg', { fg = colors.warning })
hl('MoreMsg', { fg = colors.string })
hl('Question', { fg = colors.string })

-- Syntax highlighting
hl('Comment', { fg = colors.comment, italic = true })
hl('Constant', { fg = colors.constant })
hl('String', { fg = colors.string })
hl('Character', { fg = colors.string })
hl('Number', { fg = colors.constant })
hl('Boolean', { fg = colors.constant })
hl('Float', { fg = colors.constant })
hl('Identifier', { fg = colors.entity })
hl('Function', { fg = colors.func })
hl('Statement', { fg = colors.keyword })
hl('Conditional', { fg = colors.keyword })
hl('Repeat', { fg = colors.keyword })
hl('Label', { fg = colors.keyword })
hl('Operator', { fg = colors.operator })
hl('Keyword', { fg = colors.keyword })
hl('Exception', { fg = colors.keyword })
hl('PreProc', { fg = colors.special })
hl('Include', { fg = colors.keyword })
hl('Define', { fg = colors.special })
hl('Macro', { fg = colors.special })
hl('PreCondit', { fg = colors.special })
hl('Type', { fg = colors.entity })
hl('StorageClass', { fg = colors.keyword })
hl('Structure', { fg = colors.entity })
hl('Typedef', { fg = colors.entity })
hl('Special', { fg = colors.special })
hl('SpecialChar', { fg = colors.special })
hl('Tag', { fg = colors.tag })
hl('Delimiter', { fg = colors.fg })
hl('SpecialComment', { fg = colors.special })
hl('Debug', { fg = colors.special })
hl('Underlined', { fg = colors.tag, underline = true })
hl('Ignore', { fg = colors.comment })
hl('Error', { fg = colors.error })
hl('Todo', { fg = colors.markup, bold = true })

-- Diff
hl('DiffAdd', { fg = colors.vcs_added, bg = colors.vcs_added_bg })
hl('DiffChange', { fg = colors.vcs_modified })
hl('DiffDelete', { fg = colors.vcs_removed, bg = colors.vcs_removed_bg })
hl('DiffText', { fg = colors.vcs_modified, bg = colors.selection_bg })

-- Git signs
hl('GitSignsAdd', { fg = colors.vcs_added })
hl('GitSignsChange', { fg = colors.vcs_modified })
hl('GitSignsDelete', { fg = colors.vcs_removed })

-- LSP
hl('DiagnosticError', { fg = colors.error })
hl('DiagnosticWarn', { fg = colors.warning })
hl('DiagnosticInfo', { fg = colors.tag })
hl('DiagnosticHint', { fg = colors.special })

-- Tree-sitter (basic groups)
hl('@comment', { fg = colors.comment, italic = true })
hl('@constant', { fg = colors.constant })
hl('@string', { fg = colors.string })
hl('@number', { fg = colors.constant })
hl('@boolean', { fg = colors.constant })
hl('@function', { fg = colors.func })
hl('@keyword', { fg = colors.keyword })
hl('@operator', { fg = colors.operator })
hl('@type', { fg = colors.entity })
hl('@variable', { fg = colors.fg })
hl('@tag', { fg = colors.tag })
hl('@attribute', { fg = colors.special })

