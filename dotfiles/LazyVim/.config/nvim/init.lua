if vim.g.vscode then
  require("vscode-nvim")
  return
end

-- Prevent msys2 utilities (e.g. certutil) from shadowing Windows system commands on blink.cmp
if vim.fn.has("win32") == 1 then
  local sysroot = vim.fn.getenv("SystemRoot") or "C:\\Windows"
  local sys32 = sysroot .. "\\System32"
  local sys32_lower = sys32:lower()
  local paths = vim.split(vim.env.PATH, ";", { plain = true })
  local keep = {}
  for _, p in ipairs(paths) do
    if p:lower() ~= sys32_lower and p ~= "" then keep[#keep + 1] = p end
  end
  vim.env.PATH = sys32 .. ";" .. table.concat(keep, ";")
end

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
