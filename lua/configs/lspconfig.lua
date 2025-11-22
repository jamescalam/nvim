local cmp_nvim_lsp = require('cmp_nvim_lsp')

local capabilities = cmp_nvim_lsp.default_capabilities()

-- Define a function to attach keymaps after LSP attaches to a buffer
local on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ruff', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  
  -- Create autocommand to refresh LSP on save for any file type
  vim.api.nvim_create_autocmd("BufWritePost", {
    buffer = bufnr,
    callback = function()
      -- Notify LSP that the document was saved
      if client.server_capabilities.textDocumentSync then
        client.notify('textDocument/didSave', {
          textDocument = vim.lsp.util.make_text_document_params(bufnr)
        })
      end
      -- Force refresh diagnostics
      vim.schedule(function()
        -- Request diagnostics refresh
        if client.server_capabilities.diagnosticProvider then
          vim.lsp.buf.document_highlight()
        end
        -- Clear and re-request diagnostics
        vim.diagnostic.hide(nil, bufnr)
        vim.diagnostic.show(nil, bufnr)
      end)
    end,
  })
end

-- Function to get Python path from uv or other virtual environments
local function get_python_path(workspace)
  -- Check for uv virtual environment
  local uv_python = workspace .. '/.venv/bin/python'
  if vim.fn.executable(uv_python) == 1 then
    return uv_python
  end
  
  -- Check for standard venv
  local venv_python = workspace .. '/venv/bin/python'
  if vim.fn.executable(venv_python) == 1 then
    return venv_python
  end
  
  -- Check for poetry environment
  local poetry_lock = workspace .. '/poetry.lock'
  if vim.fn.filereadable(poetry_lock) == 1 then
    local handle = io.popen('cd ' .. workspace .. ' && poetry env info --path 2>/dev/null')
    if handle then
      local result = handle:read('*a')
      handle:close()
      if result and result ~= '' then
        local poetry_venv = vim.fn.trim(result) .. '/bin/python'
        if vim.fn.executable(poetry_venv) == 1 then
          return poetry_venv
        end
      end
    end
  end
  
  -- Fallback to system python
  return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
end

-- Use vim.lsp.config for server setups (new API)
-- Setup ruff (for linting and formatting)
vim.lsp.config.ruff = {
  default_config = {
    cmd = { 'ruff', 'server' },
    filetypes = { 'python' },
    root_dir = vim.fs.dirname(vim.fs.find({ 'pyproject.toml', 'ruff.toml', '.ruff.toml' }, { upward = true })[1]),
    on_attach = on_attach,
    capabilities = capabilities,
  },
}

-- Setup pyright for Python language features (without type checking since mypy will handle that)
vim.lsp.config.pyright = {
  default_config = {
    cmd = { 'pyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_dir = vim.fs.dirname(vim.fs.find({ 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile' }, { upward = true })[1]),
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      python = {
        analysis = {
          -- Disable pyright's type checking since we'll use mypy
          typeCheckingMode = "off",
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = "workspace",
        }
      }
    },
  },
}

-- Setup HTML server
vim.lsp.config.html = {
  default_config = {
    cmd = { 'vscode-html-language-server', '--stdio' },
    filetypes = { 'html' },
    root_dir = vim.fs.dirname(vim.fs.find({ 'package.json', '.git' }, { upward = true })[1]),
    on_attach = on_attach,
    capabilities = capabilities,
  },
}

-- Setup CSS server
vim.lsp.config.cssls = {
  default_config = {
    cmd = { 'vscode-css-language-server', '--stdio' },
    filetypes = { 'css', 'scss', 'less' },
    root_dir = vim.fs.dirname(vim.fs.find({ 'package.json', '.git' }, { upward = true })[1]),
    on_attach = on_attach,
    capabilities = capabilities,
  },
}

-- Start the configured servers
vim.lsp.enable('ruff')
vim.lsp.enable('pyright')
vim.lsp.enable('html')
vim.lsp.enable('cssls')