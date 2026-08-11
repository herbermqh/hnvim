vim.opt.runtimepath:append("/home/userh/.config/nvim/artplugins/arttexconceal.nvim")
local buf = vim.api.nvim_create_buf(false, true)
vim.api.nvim_buf_set_lines(buf, 0, -1, false, {"\\textbf{hello}"})
vim.bo[buf].filetype = "tex"
vim.treesitter.start(buf, "latex")
-- Force a full parse
local parser = vim.treesitter.get_parser(buf, "latex")
parser:parse()
-- Wait a bit for highlights to apply?
vim.defer_fn(function()
  local captures = vim.treesitter.get_captures_at_pos(buf, 0, 8)
  for _, c in ipairs(captures) do
    print("Capture:", c.capture)
  end
  vim.cmd("q")
end, 100)
