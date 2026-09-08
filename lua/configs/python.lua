-- Locate the Python interpreter for a project root: uv/standard .venv first,
-- then poetry, then whatever python is on PATH. Cached per root because the
-- poetry lookup shells out.
local M = {}

local cache = {}

function M.venv_python(root)
  root = root or vim.fn.getcwd()
  if cache[root] then
    return cache[root]
  end

  local result
  for _, rel in ipairs({ "/.venv/bin/python", "/venv/bin/python" }) do
    if vim.fn.executable(root .. rel) == 1 then
      result = root .. rel
      break
    end
  end

  if not result and vim.fn.filereadable(root .. "/poetry.lock") == 1 then
    local out = vim.fn.system({ "sh", "-c", "cd " .. vim.fn.shellescape(root) .. " && poetry env info --path 2>/dev/null" })
    local venv = vim.trim(out or "")
    if venv ~= "" and vim.fn.executable(venv .. "/bin/python") == 1 then
      result = venv .. "/bin/python"
    end
  end

  result = result or vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
  cache[root] = result
  return result
end

-- Path to a tool (e.g. "mypy") inside the project venv, or nil if absent.
function M.venv_tool(name, root)
  local py = M.venv_python(root)
  local tool = vim.fs.dirname(py) .. "/" .. name
  if vim.fn.executable(tool) == 1 then
    return tool
  end
  return nil
end


-- Build a vim.lsp `cmd` that runs the project venv's copy of a tool when it
-- exists, otherwise the one on PATH. Warns once per project when a venv
-- exists but lacks the tool, as a nudge to `uv add --dev <tool>`.
local warned = {}
function M.venv_cmd(tool, args)
  return function(dispatchers, config)
    local root = config.root_dir
    local exe = M.venv_tool(tool, root)
    if not exe then
      exe = tool
      local key = tostring(root) .. ":" .. tool
      if root and not warned[key] and vim.fn.isdirectory(root .. "/.venv") == 1 then
        warned[key] = true
        vim.schedule(function()
          vim.notify(tool .. " not in " .. vim.fn.fnamemodify(root, ":~") .. "/.venv, using PATH copy", vim.log.levels.WARN)
        end)
      end
    end
    local cmd = vim.list_extend({ exe }, args or {})
    return vim.lsp.rpc.start(cmd, dispatchers, { cwd = root })
  end
end

return M
