vim.cmd("colorscheme tokyonight")
local hls = vim.api.nvim_get_hl(0, {})
for name, val in pairs(hls) do
  if name:match("^tex") then
    print(name, vim.inspect(val))
  end
end
