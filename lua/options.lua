vim.o.number = true
vim.o.relativenumber = true

-- Keep the gutter width stable so gitsigns/diagnostic signs don't shift text
vim.o.signcolumn = "yes"

-- Tab settings
vim.o.tabstop = 4        -- Number of spaces a tab displays as
vim.o.shiftwidth = 4     -- Number of spaces for auto-indent
vim.o.softtabstop = 4    -- Number of spaces inserted when pressing tab
vim.o.expandtab = true   -- Convert tabs to spaces

-- Obsidian UI features need conceallevel >= 1, but only in markdown.
-- Setting it globally hides quotes in JSON and similar.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.conceallevel = 2
  end,
})
