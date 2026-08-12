local ret = vim.deepcopy(require("tknvivid.colors.storm"))

---@type Palette
return vim.tbl_deep_extend("force", ret, {
  bg = "#161722",
  bg_dark = "#0e1017",
  bg_dark1 = "#090a10",
})
