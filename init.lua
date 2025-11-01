-- Set leader key BEFORE loading lazy
vim.g.mapleader = " "

-- Set up lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

-- Ensure line numbers are set (in case a plugin overrides them)
vim.o.number = true
vim.o.relativenumber = true
