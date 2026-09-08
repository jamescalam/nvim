-- LSP setup on the Neovim 0.11 vim.lsp.config API.
-- nvim-lspconfig ships cmd / filetypes / root_markers for every server under
-- its lsp/ directory; we only layer capabilities and settings on top.

local python = require("configs.python")

-- Applied to every server
vim.lsp.config("*", {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

-- Buffer-local keymaps for any buffer that gets an LSP client
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user.lsp", { clear = true }),
  callback = function(ev)
    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, silent = true, desc = desc })
    end
    map("gD", vim.lsp.buf.declaration, "Go to declaration")
    map("gd", vim.lsp.buf.definition, "Go to definition")
    map("K", vim.lsp.buf.hover, "Hover")
    map("gi", vim.lsp.buf.implementation, "Go to implementation")
    map("gr", vim.lsp.buf.references, "References")
    map("<C-k>", vim.lsp.buf.signature_help, "Signature help")
    map("<space>D", vim.lsp.buf.type_definition, "Type definition")
    map("<space>rn", vim.lsp.buf.rename, "Rename symbol")
    map("<space>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
    map("<space>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
    map("<space>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "List workspace folders")
    map("[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Previous diagnostic")
    map("]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next diagnostic")
  end,
})

-- Python: ruff for lint/format, pyright for language features. Type checking
-- is left to mypy (see nvim-lint), so pyright's checker is off.
vim.lsp.config("pyright", {
  before_init = function(_, config)
    -- Point pyright at the project's venv so it resolves installed packages
    config.settings.python.pythonPath = python.venv_python(config.root_dir)
  end,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "off",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
      },
    },
  },
})

vim.lsp.config("gopls", {
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        shadow = true,
      },
      staticcheck = true, -- enables staticcheck linting
      gofumpt = true,     -- stricter formatting
    },
  },
})

vim.lsp.enable({ "ruff", "pyright", "html", "cssls", "gopls" })
