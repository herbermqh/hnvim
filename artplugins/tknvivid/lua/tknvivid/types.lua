---@class tknvivid.Highlight: vim.api.keyset.highlight
---@field style? vim.api.keyset.highlight

---@alias tknvivid.Highlights table<string,tknvivid.Highlight|string>

---@alias tknvivid.HighlightsFn fun(colors: ColorScheme, opts:tknvivid.Config):tknvivid.Highlights

---@class tknvivid.Cache
---@field groups tknvivid.Highlights
---@field inputs table
