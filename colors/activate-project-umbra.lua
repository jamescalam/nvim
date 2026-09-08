-- activate-project-umbra: Cyberpunk theme based on VS Code "Activate UMBRA Protocol"
vim.cmd('hi clear')
if vim.fn.exists('syntax_on') then
  vim.cmd('syntax reset')
end

vim.o.background = 'dark'
vim.g.colors_name = 'activate-project-umbra'

-- Color palette from Cyberpunk UMBRA Protocol
local colors = {
  -- Core editor colors
  bg = '#100d23',
  fg = '#00FF9C',
  fg_alt = '#EEFFFF',

  -- Syntax colors
  comment = '#6766b3',
  variable = '#EEFFFF',
  block_variable = '#b4baff',
  keyword = '#d57bff',
  operator = '#00b0ff',
  tag = '#ff5680',
  func = '#00b0ff',
  string = '#76c1ff',
  number = '#fffc58',
  constant = '#fffc58',
  class = '#00FF9C',
  type = '#00FF9C',
  attribute = '#ee6dff',
  html_attribute = '#00FF9C',
  regexp = '#89DDFF',
  escape = '#89DDFF',
  method = '#6095ff',
  language_variable = '#ff5680',
  css_property = '#98e3ff',
  invalid = '#FF5370',
  link = '#3d5afe',

  -- UI colors
  line_highlight = '#1a2040',
  selection = '#311b92',
  selection_highlight = '#5e35b1',
  cursor = '#00ff6a',
  line_nr = '#3D5AFE',
  line_nr_active = '#00ffc8',
  gutter_bg = '#050513',
  indent_guide = '#1E1E44',
  indent_guide_active = '#00ffc8',
  whitespace = '#2B3E5A',

  -- Window/Panel colors
  title_bar = '#100D23',
  title_bar_inactive = '#1E1D45',
  activity_bar = '#100d23',
  sidebar = '#1e1d45',
  sidebar_fg = '#8b96ff',
  panel = '#131341',
  panel_border = '#00e676',
  tab_active = '#100d23',
  tab_inactive = '#1e1d45',
  tab_inactive_fg = '#7877b3',
  tab_border = '#372963',
  statusbar_bg = '#002212',
  statusbar_fg = '#00FF9C',
  widget_bg = '#002212',
  widget_border = '#00FF9C',

  -- Popup/Menu colors
  popup_bg = '#002212',
  popup_border = '#00FF9C',
  popup_selected = '#002f6d',
  popup_highlight = '#00c3ff',

  -- Search/Match colors
  search = '#283593',
  match_paren_bg = '#ff0055',
  match_paren_border = '#ff004c',
  word_highlight = '#42557B',

  -- VCS/Git colors
  vcs_added = '#3c9f4a',
  vcs_deleted = '#a22929',
  vcs_modified = '#26506d',
  git_added = '#00ff6a',
  git_deleted = '#ff004c',
  git_modified = '#00c3ff',
  git_untracked = '#00ff6a',
  git_conflict = '#ffff00',
  git_ignored = '#6196f7',

  -- Diff colors
  diff_add_bg = '#0a3a1a',
  diff_delete_bg = '#3a1a1a',
  diff_add_text = '#C3E88D',
  diff_delete_text = '#FF5370',
  diff_change_text = '#C792EA',

  -- Merge colors
  merge_common_bg = '#3a1a2a',
  merge_current_bg = '#0a3a1a',
  merge_incoming_bg = '#1a1a3a',

  -- Diagnostic colors
  error = '#ff1865',
  error_fg = '#ff235a',
  warning = '#009550',
  info = '#00c3ff',
  hint = '#b267e6',

  -- Debugging
  debug_bg = '#1a0a2a',
  debug_fg = '#c566fc',
  debug_border = '#b700ff',

  -- Terminal
  terminal_fg = '#00ff6a',
  terminal_cursor = '#9dff00',

  -- Button/Badge
  button_bg = '#00ff9d',
  button_fg = '#00140b',
  badge_bg = '#00ff6a',
  badge_fg = '#001107',

  -- Scrollbar
  scrollbar = '#5c35b1',
  scrollbar_hover = '#6a3ecf',

  -- Notification
  notification_bg = '#002212',
  notification_border = '#3d5afe',

  -- Progress
  progress = '#ff4081',

  -- Peek view
  peek_bg = '#131341',
  peek_border = '#00e676',
  peek_fg = '#00e676',
  peek_inactive = '#7877b3',
  peek_match = '#6a3ecf',

  -- JSON level colors
  json_1 = '#C792EA',
  json_2 = '#FFCB6B',
  json_3 = '#F78C6C',
  json_4 = '#FF5370',
  json_5 = '#C17E70',
  json_6 = '#82AAFF',
  json_7 = '#f07178',
  json_8 = '#C3E88D',

  -- Markdown colors
  md_plain = '#EEFFFF',
  md_heading = '#C3E88D',
  md_bold = '#f07178',
  md_italic = '#f07178',
  md_underline = '#F78C6C',
  md_link = '#82AAFF',
  md_link_desc = '#C792EA',
  md_link_anchor = '#FFCB6B',
  md_raw = '#C792EA',
  md_quote = '#65737E',

  -- Decorators
  decorator = '#82AAFF',
}

-- Helper function to set highlight groups
local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Basic UI
hl('Normal', { fg = colors.fg, bg = colors.bg })
hl('NormalNC', { fg = colors.fg, bg = colors.bg })
hl('NormalFloat', { fg = colors.fg, bg = colors.popup_bg })
hl('FloatBorder', { fg = colors.popup_border, bg = colors.popup_bg })
hl('Cursor', { fg = colors.bg, bg = colors.cursor })
hl('CursorLine', { bg = colors.line_highlight })
hl('CursorColumn', { bg = colors.line_highlight })
hl('CursorLineNr', { fg = colors.line_nr_active, bg = 'NONE' })
hl('LineNr', { fg = colors.line_nr, bg = 'NONE' })
hl('SignColumn', { fg = colors.line_nr, bg = 'NONE' })
hl('Visual', { bg = colors.selection })
hl('VisualNOS', { bg = colors.selection_highlight })
hl('Search', { bg = colors.search })
hl('IncSearch', { fg = colors.bg, bg = colors.cursor })
hl('CurSearch', { fg = colors.bg, bg = colors.cursor })
hl('Substitute', { fg = colors.bg, bg = colors.tag })
hl('MatchParen', { fg = colors.match_paren_border, bg = colors.match_paren_bg, bold = true })

-- Windows and splits
hl('VertSplit', { fg = colors.panel_border, bg = 'NONE' })
hl('WinSeparator', { fg = colors.panel_border, bg = 'NONE' })
hl('ColorColumn', { bg = colors.line_highlight })
hl('Folded', { fg = colors.comment, bg = colors.panel })
hl('FoldColumn', { fg = colors.line_nr, bg = 'NONE' })
hl('NonText', { fg = colors.whitespace })
hl('Whitespace', { fg = colors.whitespace })
hl('SpecialKey', { fg = colors.whitespace })
hl('EndOfBuffer', { fg = colors.bg })

-- Status line
hl('StatusLine', { fg = colors.statusbar_fg, bg = colors.statusbar_bg })
hl('StatusLineNC', { fg = colors.tab_inactive_fg, bg = colors.sidebar })

-- Tabs
hl('TabLine', { fg = colors.tab_inactive_fg, bg = colors.tab_inactive })
hl('TabLineFill', { bg = colors.tab_border })
hl('TabLineSel', { fg = colors.fg, bg = colors.tab_active })

-- Popup menu
hl('Pmenu', { fg = colors.fg, bg = colors.popup_bg })
hl('PmenuSel', { fg = colors.fg, bg = colors.popup_selected })
hl('PmenuSbar', { bg = colors.popup_bg })
hl('PmenuThumb', { bg = colors.scrollbar_hover })

-- Messages
hl('ErrorMsg', { fg = colors.error })
hl('WarningMsg', { fg = colors.warning })
hl('MoreMsg', { fg = colors.panel_border })
hl('Question', { fg = colors.panel_border })
hl('ModeMsg', { fg = colors.fg, bold = true })
hl('Title', { fg = colors.fg, bold = true })

-- Syntax highlighting
hl('Comment', { fg = colors.comment, italic = true })
hl('Constant', { fg = colors.constant })
hl('String', { fg = colors.string })
hl('Character', { fg = colors.string })
hl('Number', { fg = colors.number })
hl('Boolean', { fg = colors.constant })
hl('Float', { fg = colors.number })
hl('Identifier', { fg = colors.variable })
hl('Function', { fg = colors.func })
hl('Statement', { fg = colors.keyword })
hl('Conditional', { fg = colors.operator })
hl('Repeat', { fg = colors.operator })
hl('Label', { fg = colors.keyword })
hl('Operator', { fg = colors.operator })
hl('Keyword', { fg = colors.keyword })
hl('Exception', { fg = colors.keyword })
hl('PreProc', { fg = colors.operator })
hl('Include', { fg = colors.operator })
hl('Define', { fg = colors.operator })
hl('Macro', { fg = colors.operator })
hl('PreCondit', { fg = colors.operator })
hl('Type', { fg = colors.type })
hl('StorageClass', { fg = colors.keyword })
hl('Structure', { fg = colors.type })
hl('Typedef', { fg = colors.type })
hl('Special', { fg = colors.escape })
hl('SpecialChar', { fg = colors.escape })
hl('Tag', { fg = colors.tag })
hl('Delimiter', { fg = colors.operator })
hl('SpecialComment', { fg = colors.comment, bold = true })
hl('Debug', { fg = colors.hint })
hl('Underlined', { fg = colors.link, underline = true })
hl('Ignore', { fg = colors.comment })
hl('Error', { fg = colors.invalid })
hl('Todo', { fg = colors.number, bold = true })

-- Diff
hl('DiffAdd', { bg = colors.diff_add_bg })
hl('DiffChange', { fg = colors.diff_change_text })
hl('DiffDelete', { bg = colors.diff_delete_bg })
hl('DiffText', { fg = colors.git_modified, bg = colors.selection })
hl('Added', { fg = colors.diff_add_text })
hl('Changed', { fg = colors.diff_change_text })
hl('Removed', { fg = colors.diff_delete_text })

-- Git signs
hl('GitSignsAdd', { fg = colors.vcs_added })
hl('GitSignsChange', { fg = colors.vcs_modified })
hl('GitSignsDelete', { fg = colors.vcs_deleted })

-- LSP
hl('DiagnosticError', { fg = colors.error })
hl('DiagnosticWarn', { fg = colors.warning })
hl('DiagnosticInfo', { fg = colors.info })
hl('DiagnosticHint', { fg = colors.hint })
hl('DiagnosticUnderlineError', { undercurl = true, sp = colors.error })
hl('DiagnosticUnderlineWarn', { undercurl = true, sp = colors.warning })
hl('DiagnosticUnderlineInfo', { undercurl = true, sp = colors.info })
hl('DiagnosticUnderlineHint', { undercurl = true, sp = colors.hint })
hl('LspReferenceText', { bg = colors.word_highlight })
hl('LspReferenceRead', { bg = colors.word_highlight })
hl('LspReferenceWrite', { bg = colors.word_highlight })

-- Tree-sitter highlights
hl('@comment', { fg = colors.comment, italic = true })
hl('@constant', { fg = colors.constant })
hl('@constant.builtin', { fg = colors.constant })
hl('@constant.macro', { fg = colors.constant })
hl('@string', { fg = colors.string })
hl('@string.escape', { fg = colors.escape })
hl('@string.regex', { fg = colors.regexp })
hl('@string.special', { fg = colors.escape })
hl('@character', { fg = colors.string })
hl('@number', { fg = colors.number })
hl('@boolean', { fg = colors.constant })
hl('@float', { fg = colors.number })
hl('@function', { fg = colors.func })
hl('@function.builtin', { fg = colors.func })
hl('@function.macro', { fg = colors.func })
hl('@function.call', { fg = colors.func })
hl('@function.method', { fg = colors.method, italic = true })
hl('@function.method.call', { fg = colors.method })
hl('@method', { fg = colors.method, italic = true })
hl('@method.call', { fg = colors.method })
hl('@constructor', { fg = colors.method })
hl('@parameter', { fg = colors.constant })
hl('@keyword', { fg = colors.keyword })
hl('@keyword.function', { fg = colors.keyword })
hl('@keyword.operator', { fg = colors.operator })
hl('@keyword.return', { fg = colors.keyword })
hl('@keyword.conditional', { fg = colors.operator })
hl('@keyword.repeat', { fg = colors.operator })
hl('@keyword.import', { fg = colors.operator })
hl('@keyword.exception', { fg = colors.keyword })
hl('@conditional', { fg = colors.operator })
hl('@repeat', { fg = colors.operator })
hl('@label', { fg = colors.keyword })
hl('@operator', { fg = colors.operator })
hl('@exception', { fg = colors.keyword })
hl('@variable', { fg = colors.variable })
hl('@variable.builtin', { fg = colors.language_variable, italic = true })
hl('@variable.parameter', { fg = colors.constant })
hl('@variable.member', { fg = colors.block_variable })
hl('@type', { fg = colors.type })
hl('@type.builtin', { fg = colors.type })
hl('@type.definition', { fg = colors.type })
hl('@type.qualifier', { fg = colors.keyword })
hl('@storageclass', { fg = colors.keyword })
hl('@namespace', { fg = colors.type })
hl('@module', { fg = colors.tag })
hl('@include', { fg = colors.operator })
hl('@preproc', { fg = colors.operator })
hl('@define', { fg = colors.operator })
hl('@attribute', { fg = colors.attribute, italic = true })
hl('@property', { fg = colors.block_variable })
hl('@field', { fg = colors.block_variable })
hl('@punctuation', { fg = colors.operator })
hl('@punctuation.delimiter', { fg = colors.operator })
hl('@punctuation.bracket', { fg = colors.operator })
hl('@punctuation.special', { fg = colors.operator })
hl('@tag', { fg = colors.tag })
hl('@tag.attribute', { fg = colors.html_attribute, italic = true })
hl('@tag.delimiter', { fg = colors.operator })
hl('@text', { fg = colors.md_plain })
hl('@text.strong', { fg = colors.md_bold, bold = true })
hl('@text.emphasis', { fg = colors.md_italic, italic = true })
hl('@text.underline', { fg = colors.md_underline, underline = true })
hl('@text.strike', { strikethrough = true })
hl('@text.title', { fg = colors.md_heading, bold = true })
hl('@text.literal', { fg = colors.md_raw })
hl('@text.uri', { fg = colors.link, underline = true })
hl('@text.reference', { fg = colors.md_link })

-- Semantic tokens
hl('@lsp.type.class', { fg = colors.type })
hl('@lsp.type.decorator', { fg = colors.decorator, italic = true })
hl('@lsp.type.enum', { fg = colors.type })
hl('@lsp.type.enumMember', { fg = colors.constant })
hl('@lsp.type.function', { fg = colors.func })
hl('@lsp.type.interface', { fg = colors.type })
hl('@lsp.type.macro', { fg = colors.func })
hl('@lsp.type.method', { fg = colors.method })
hl('@lsp.type.namespace', { fg = colors.type })
hl('@lsp.type.parameter', { fg = colors.constant })
hl('@lsp.type.property', { fg = colors.block_variable })
hl('@lsp.type.struct', { fg = colors.type })
hl('@lsp.type.type', { fg = colors.type })
hl('@lsp.type.typeParameter', { fg = colors.type })
hl('@lsp.type.variable', { fg = colors.variable })

-- CSS
hl('@property.css', { fg = colors.css_property })
hl('@property.scss', { fg = colors.css_property })
hl('@property.sass', { fg = colors.css_property })

-- JSON rainbow keys
hl('jsonKeyword', { fg = colors.json_1 })
hl('@property.json', { fg = colors.json_1 })

-- Indent guides (indent-blankline)
hl('IndentBlanklineChar', { fg = colors.indent_guide })
hl('IndentBlanklineContextChar', { fg = colors.indent_guide_active })
hl('IblIndent', { fg = colors.indent_guide })
hl('IblScope', { fg = colors.indent_guide_active })

-- Telescope
hl('TelescopeBorder', { fg = colors.popup_border })
hl('TelescopePromptBorder', { fg = colors.popup_border })
hl('TelescopeResultsBorder', { fg = colors.popup_border })
hl('TelescopePreviewBorder', { fg = colors.popup_border })
hl('TelescopeSelection', { bg = colors.popup_selected })
hl('TelescopeSelectionCaret', { fg = colors.cursor })
hl('TelescopeMatching', { fg = colors.popup_highlight })

-- nvim-cmp
hl('CmpItemAbbrMatch', { fg = colors.popup_highlight })
hl('CmpItemAbbrMatchFuzzy', { fg = colors.popup_highlight })
hl('CmpItemKindVariable', { fg = colors.variable })
hl('CmpItemKindFunction', { fg = colors.func })
hl('CmpItemKindMethod', { fg = colors.method })
hl('CmpItemKindKeyword', { fg = colors.keyword })
hl('CmpItemKindProperty', { fg = colors.block_variable })
hl('CmpItemKindUnit', { fg = colors.constant })

-- NvimTree / Neo-tree
hl('NvimTreeNormal', { fg = colors.sidebar_fg, bg = colors.sidebar })
hl('NvimTreeFolderName', { fg = colors.sidebar_fg })
hl('NvimTreeFolderIcon', { fg = colors.line_nr })
hl('NvimTreeOpenedFolderName', { fg = colors.fg })
hl('NvimTreeRootFolder', { fg = colors.keyword })
hl('NvimTreeGitDirty', { fg = colors.git_modified })
hl('NvimTreeGitNew', { fg = colors.git_added })
hl('NvimTreeGitDeleted', { fg = colors.git_deleted })

hl('NeoTreeNormal', { fg = colors.sidebar_fg, bg = colors.sidebar })
hl('NeoTreeNormalNC', { fg = colors.sidebar_fg, bg = colors.sidebar })
hl('NeoTreeDirectoryName', { fg = colors.sidebar_fg })
hl('NeoTreeDirectoryIcon', { fg = colors.line_nr })
hl('NeoTreeRootName', { fg = colors.keyword, bold = true })
hl('NeoTreeGitModified', { fg = colors.git_modified })
hl('NeoTreeGitAdded', { fg = colors.git_added })
hl('NeoTreeGitDeleted', { fg = colors.git_deleted })
hl('NeoTreeGitConflict', { fg = colors.git_conflict })
hl('NeoTreeGitUntracked', { fg = colors.git_untracked })

-- Fugitive
hl('fugitiveHeader', { fg = colors.keyword, bold = true })
hl('fugitiveHeading', { fg = colors.keyword, bold = true })
hl('fugitiveUntrackedHeading', { fg = colors.git_untracked, bold = true })
hl('fugitiveUnstagedHeading', { fg = colors.git_modified, bold = true })
hl('fugitiveStagedHeading', { fg = colors.git_added, bold = true })
hl('fugitiveUntrackedModifier', { fg = colors.git_untracked })
hl('fugitiveUnstagedModifier', { fg = colors.git_modified })
hl('fugitiveStagedModifier', { fg = colors.git_added })
hl('fugitiveUntrackedSection', { fg = colors.git_untracked })
hl('fugitiveUnstagedSection', { fg = colors.git_modified })
hl('fugitiveStagedSection', { fg = colors.git_added })
hl('fugitiveHash', { fg = colors.json_1 })
hl('fugitiveSymbolicRef', { fg = colors.func })
hl('fugitiveCount', { fg = colors.constant })

-- GitSigns
hl('GitSignsAddLn', { bg = colors.diff_add_bg })
hl('GitSignsChangeLn', { fg = colors.git_modified })
hl('GitSignsDeleteLn', { bg = colors.diff_delete_bg })

-- Gitsigns inline blame
hl('GitSignsCurrentLineBlame', { fg = colors.comment, italic = true })

-- Lazy.nvim
hl('LazyNormal', { fg = colors.fg, bg = colors.popup_bg })
hl('LazyButton', { fg = colors.button_fg, bg = colors.button_bg })
hl('LazyButtonActive', { fg = colors.button_fg, bg = colors.fg })
hl('LazyH1', { fg = colors.bg, bg = colors.fg, bold = true })

-- Mason
hl('MasonNormal', { fg = colors.fg, bg = colors.popup_bg })
hl('MasonHeader', { fg = colors.bg, bg = colors.fg, bold = true })
hl('MasonHighlight', { fg = colors.popup_highlight })
hl('MasonHighlightBlock', { fg = colors.bg, bg = colors.popup_highlight })

-- Notify
hl('NotifyERRORBorder', { fg = colors.error })
hl('NotifyWARNBorder', { fg = colors.warning })
hl('NotifyINFOBorder', { fg = colors.info })
hl('NotifyDEBUGBorder', { fg = colors.hint })
hl('NotifyTRACEBorder', { fg = colors.comment })
hl('NotifyERRORIcon', { fg = colors.error })
hl('NotifyWARNIcon', { fg = colors.warning })
hl('NotifyINFOIcon', { fg = colors.info })
hl('NotifyDEBUGIcon', { fg = colors.hint })
hl('NotifyTRACEIcon', { fg = colors.comment })
hl('NotifyERRORTitle', { fg = colors.error })
hl('NotifyWARNTitle', { fg = colors.warning })
hl('NotifyINFOTitle', { fg = colors.info })
hl('NotifyDEBUGTitle', { fg = colors.hint })
hl('NotifyTRACETitle', { fg = colors.comment })

-- Which-key
hl('WhichKey', { fg = colors.fg })
hl('WhichKeyGroup', { fg = colors.keyword })
hl('WhichKeyDesc', { fg = colors.sidebar_fg })
hl('WhichKeySeparator', { fg = colors.comment })
hl('WhichKeyFloat', { bg = colors.popup_bg })

-- Dashboard / Alpha
hl('DashboardHeader', { fg = colors.fg })
hl('DashboardCenter', { fg = colors.func })
hl('DashboardFooter', { fg = colors.comment, italic = true })
hl('AlphaHeader', { fg = colors.fg })
hl('AlphaButtons', { fg = colors.func })
hl('AlphaFooter', { fg = colors.comment, italic = true })

-- Bufferline
hl('BufferLineFill', { bg = colors.tab_border })
hl('BufferLineBackground', { fg = colors.tab_inactive_fg, bg = colors.tab_inactive })
hl('BufferLineBufferSelected', { fg = colors.fg, bg = colors.tab_active, bold = true })
hl('BufferLineBufferVisible', { fg = colors.tab_inactive_fg, bg = colors.tab_inactive })
hl('BufferLineSeparator', { fg = colors.tab_border, bg = colors.tab_inactive })
hl('BufferLineSeparatorSelected', { fg = colors.tab_border, bg = colors.tab_active })
hl('BufferLineSeparatorVisible', { fg = colors.tab_border, bg = colors.tab_inactive })

-- Lualine colors (for reference in lualine config)
-- Normal: bg = colors.statusbar_bg, fg = colors.statusbar_fg
-- Insert: bg = colors.cursor, fg = colors.bg
-- Visual: bg = colors.selection, fg = colors.fg
-- Command: bg = colors.keyword, fg = colors.bg

-- Scrollbar
hl('ScrollbarHandle', { bg = colors.scrollbar })
hl('ScrollbarSearchHandle', { bg = colors.search })
hl('ScrollbarErrorHandle', { fg = colors.error })
hl('ScrollbarWarnHandle', { fg = colors.warning })
hl('ScrollbarInfoHandle', { fg = colors.info })
hl('ScrollbarHintHandle', { fg = colors.hint })

-- Mini plugins
hl('MiniStatuslineModeNormal', { fg = colors.bg, bg = colors.fg, bold = true })
hl('MiniStatuslineModeInsert', { fg = colors.bg, bg = colors.cursor, bold = true })
hl('MiniStatuslineModeVisual', { fg = colors.fg, bg = colors.selection, bold = true })
hl('MiniStatuslineModeCommand', { fg = colors.bg, bg = colors.keyword, bold = true })
hl('MiniStatuslineModeReplace', { fg = colors.bg, bg = colors.tag, bold = true })

-- Trouble
hl('TroubleNormal', { fg = colors.fg, bg = colors.sidebar })
hl('TroubleText', { fg = colors.fg })
hl('TroubleCount', { fg = colors.constant, bg = colors.selection })
