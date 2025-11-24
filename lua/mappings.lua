local keymap = vim.keymap

-- Neo-tree
keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { silent = true, desc = "Toggle Neo-tree" })
keymap.set("n", "<leader>nr", ":Neotree refresh<CR>", { silent = true, desc = "Refresh Neo-tree" })

-- Telescope
keymap.set("n", "<leader>rg", ":Telescope live_grep<CR>", { silent = true, desc = "Live Grep with Telescope" })

-- Git
keymap.set("n", "<leader>gb", ":Gitsigns toggle_current_line_blame<CR>", { silent = true, desc = "Toggle line-level git blame" })

-- Bufferline
keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", { silent = true, desc = "Next buffer" })
keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { silent = true, desc = "Previous buffer" })

-- Custom buffer close function that preserves window layout
local function close_buffer()
  local buf = vim.api.nvim_get_current_buf()

  -- Check if buffer is modified
  if vim.api.nvim_buf_get_option(buf, 'modified') then
    vim.notify("Buffer has unsaved changes. Save first or use :bd! to force close.", vim.log.levels.WARN)
    return
  end

  -- Get list of all buffers
  local buffers = vim.fn.getbufinfo({buflisted = 1})

  -- If this is the only buffer, create a new empty one
  if #buffers <= 1 then
    vim.cmd('enew')
    vim.cmd('bdelete ' .. buf)
  else
    -- Switch to the previous buffer, then delete the current one
    vim.cmd('bprevious')
    vim.cmd('bdelete ' .. buf)
  end
end

keymap.set("n", "<leader>x", close_buffer, { silent = true, desc = "Close buffer" })