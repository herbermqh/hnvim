require'alpha'.setup(require'alpha.themes.dashboard'.config)
local dashboard = require'alpha.themes.dashboard'
dashboard.section.header.val = {
[[ █████  ██████  ████████     ███    ██ ██    ██ ██ ███    ███]],
[[██   ██ ██   ██    ██        ████   ██ ██    ██ ██ ████  ████]],
[[███████ ██████     ██        ██ ██  ██ ██    ██ ██ ██ ████ ██]],
[[██   ██ ██   ██    ██        ██  ██ ██  ██  ██  ██ ██  ██  ██]],
[[██   ██ ██   ██    ██        ██   ████   ████   ██ ██      ██]]
}

-- Aplicar el efecto visual de bloque ancho al Dashboard (Alpha)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "alpha",
  callback = function()
    vim.api.nvim_set_hl(0, "AlphaCursorLine", { bg = "#292e42", bold = true })
    vim.api.nvim_set_hl(0, "AlphaHiddenCursor", { blend = 100, nocombine = true })
    
    vim.wo.cursorline = true
    vim.wo.cursorlineopt = "both"
    vim.cmd("setlocal winhl=CursorLine:AlphaCursorLine")
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  pattern = "*",
  callback = function()
    if vim.bo.filetype == "alpha" then
      if vim.opt.guicursor:get()[1] ~= "n-v-c:ver1-AlphaHiddenCursor" then
        vim.g.old_guicursor_alpha = vim.opt.guicursor:get()
        vim.opt.guicursor = "n-v-c:ver1-AlphaHiddenCursor"
      end
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
  pattern = "*",
  callback = function()
    if vim.bo.filetype == "alpha" then
      if vim.g.old_guicursor_alpha then
        vim.opt.guicursor = vim.g.old_guicursor_alpha
      else
        vim.cmd("set guicursor&")
      end
    end
  end,
})
