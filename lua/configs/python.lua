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

return M
