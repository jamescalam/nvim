vim.api.nvim_create_user_command("Ruff", function()
  vim.lsp.buf.code_action()
end, { desc = "Run ruff code action" })

-- :Fr <old> <new> <file> [file...]
-- Literal find-and-replace across files, confirming each match.
vim.api.nvim_create_user_command("Fr", function(opts)
  local args = opts.fargs
  if #args < 3 then
    vim.notify("Usage: :Fr <old> <new> <file> [file...]", vim.log.levels.WARN)
    return
  end
  local old = vim.fn.escape(args[1], "\\/")
  local new = vim.fn.escape(args[2], "\\/&~")
  local files = vim.tbl_map(vim.fn.fnameescape, vim.list_slice(args, 3))
  vim.cmd("args " .. table.concat(files, " "))
  -- \V = very nomagic, so <old> matches literally; e = no error on files without a match
  vim.cmd(string.format([[argdo %%s/\V%s/%s/gce | update]], old, new))
end, { nargs = "+", complete = "file", desc = "Find and replace across multiple files" })
