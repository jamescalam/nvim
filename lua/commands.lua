vim.api.nvim_create_user_command('Fr', function(opts)
  local args = opts.fargs
  if #args < 3 then
    print("Usage: :Fr <old_pattern> <new_pattern> <filepath1> [filepath2...]")
    return
  end

  local old_pattern = args[1]
  local new_pattern = args[2]
  local filepath = args[3]
  -- construct the :args command to load specified files
  local args_cmd = string.format("args %s", filepath)
  vim.cmd(args_cmd)
  -- construct :argdo command for find and replace
  -- we use vim.fn.escape to handle special characters
  -- we escape common regex special characters in the old_pattern
  local regex_chars = ".*+?[]{}()^$\\/"
  local escaped_old = vim.fn.escape(old_pattern, regex_chars)
  local escaped_new = vim.fn.escape(new_pattern, '/')
  local sub_cmd = string.format("argdo setlocal modifiable | %%s/%s/%s/gc | update | setlocal nomodifiable", old_pattern, escaped_new)
  print("DEBUG: " .. sub_cmd)
  vim.cmd(sub_cmd)
end, { nargs = '+', complete = 'file', desc = 'Find and replace across multiple files' })
