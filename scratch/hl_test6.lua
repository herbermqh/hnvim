local buf = vim.api.nvim_create_buf(false, true)
vim.api.nvim_buf_set_lines(buf, 0, -1, false, {"hello"})
local ns1 = vim.api.nvim_create_namespace("ns1")
local ns2 = vim.api.nvim_create_namespace("ns2")

-- Background highlight (Red)
vim.api.nvim_set_hl(0, "RedHL", { fg = "#ff0000" })
vim.api.nvim_buf_set_extmark(buf, ns1, 0, 0, { end_col = 5, hl_group = "RedHL", priority = 100 })

-- Foreground highlight (Bold, NO fg)
vim.api.nvim_set_hl(0, "BoldHL", { bold = true })
vim.api.nvim_buf_set_extmark(buf, ns2, 0, 0, { end_col = 5, hl_group = "BoldHL", priority = 200 })

-- Inspect
local hl = vim.api.nvim_get_hl(0, {name = "BoldHL"})
print("BoldHL:", vim.inspect(hl))

-- Foreground highlight (Bold, fg = "NONE")
vim.api.nvim_set_hl(0, "BoldNoneHL", { fg = "NONE", bold = true })
local hl2 = vim.api.nvim_get_hl(0, {name = "BoldNoneHL"})
print("BoldNoneHL:", vim.inspect(hl2))
