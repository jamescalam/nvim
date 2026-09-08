-- Set leader key BEFORE loading lazy
vim.g.mapleader = " "

-- Colorscheme lives in ./colors, so it is available before any plugin loads.
-- Applying it first lets plugins derive their highlights from it at setup.
vim.cmd.colorscheme("charon-dark")

-- Set up lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins
require("lazy").setup("plugins")

-- Load custom options
require("options")

-- Load custom keymappings
require("mappings")

-- Load custom commands
require("commands")
