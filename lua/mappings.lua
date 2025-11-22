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