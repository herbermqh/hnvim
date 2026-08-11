local dashboard = require'alpha.themes.dashboard'

-- Definir los colores del gradiente (Dinámico por ColorScheme)
local function set_alpha_colors()
  local is_vivid = vim.g.colors_name == "tknvivid"
  vim.api.nvim_set_hl(0, "AlphaArt1", { fg = is_vivid and "#4fd6ff" or "#7dcfff", bold = true })
  vim.api.nvim_set_hl(0, "AlphaArt2", { fg = is_vivid and "#689dff" or "#7aa2f7", bold = true })
  vim.api.nvim_set_hl(0, "AlphaArt3", { fg = is_vivid and "#c89eff" or "#bb9af7", bold = true })
  vim.api.nvim_set_hl(0, "AlphaArt4", { fg = is_vivid and "#ff607f" or "#f7768e", bold = true })
  vim.api.nvim_set_hl(0, "AlphaArt5", { fg = is_vivid and "#f6b85c" or "#ff9e64", bold = true })
end
vim.api.nvim_create_autocmd({"UIEnter", "ColorScheme"}, { pattern = "*", callback = set_alpha_colors })
set_alpha_colors()

-- Asegurar que los colores de botones existan
vim.cmd([[
  hi default link DashboardIcon Identifier
  hi default link DashboardCenter Normal
  hi default link DashboardShortCut Keyword
  hi default link DashboardFooter Comment
]])

dashboard.section.header.val = {
  '',
  '',
  [[ █████  ██████  ████████     ███    ██ ██    ██ ██ ███    ███]],
  [[██   ██ ██   ██    ██        ████   ██ ██    ██ ██ ████  ████]],
  [[███████ ██████     ██        ██ ██  ██ ██    ██ ██ ██ ████ ██]],
  [[██   ██ ██   ██    ██        ██  ██ ██  ██  ██  ██ ██  ██  ██]],
  [[██   ██ ██   ██    ██        ██   ████   ████   ██ ██      ██]],
  '',
  ''
}

-- Asignar el color instantáneamente a cada línea de forma nativa en Alpha
dashboard.section.header.opts.hl = {
  { { "AlphaArt1", 0, 0 } }, { { "AlphaArt1", 0, 0 } }, -- Líneas vacías (dummy hl para evitar error de nil en Alpha)
  { { "AlphaArt1", 0, -1 } },
  { { "AlphaArt2", 0, -1 } },
  { { "AlphaArt3", 0, -1 } },
  { { "AlphaArt4", 0, -1 } },
  { { "AlphaArt5", 0, -1 } },
  { { "AlphaArt1", 0, 0 } }, { { "AlphaArt1", 0, 0 } }
}

-- Función para imitar el tema DOOM de dashboard-nvim
local function my_button(icon, desc, sc, action)
  local sc_ = sc:gsub("%%s", ""):gsub("SPC", "<leader>")
  -- Añadimos espacios al final. Esto es VITAL porque pill-highlighter 
  -- necesita al menos un espacio en blanco al final de la línea para usar "overlay"
  -- y dibujar el borde derecho () pegado a la última letra sin dejar huecos.
  local txt = icon .. desc .. sc .. "  " 
  local icon_len = #icon
  local desc_len = #desc
  local map_action = action:sub(1,4) == "lua " and (":" .. action .. "<CR>") or ("<cmd>" .. action .. "<CR>")
  return {
    type = "button",
    val = txt,
    on_press = function()
      local key = vim.api.nvim_replace_termcodes(sc_ .. "<Ignore>", true, false, true)
      vim.api.nvim_feedkeys(key, "t", false)
    end,
    opts = {
      position = "center",
      cursor = 3,
      width = 50,
      hl = {
        { "DashboardIcon", 0, icon_len },
        { "DashboardCenter", icon_len, icon_len + desc_len },
        { "DashboardShortCut", icon_len + desc_len, -1 }
      },
      keymap = { "n", sc_, map_action, { noremap = true, silent = true, nowait = true } }
    }
  }
end

-- Migrar los botones del dashboard original con el mismo espaciado
dashboard.section.buttons.val = {
    my_button('  ', 'Restore Local Session                   ', 'SPC s l', 'lua require("persistence").load()'),
    my_button('󱞛  ', 'Recently opened files                   ', 'SPC f h', 'Telescope oldfiles'),
    my_button('  ', 'Find  File                              ', 'SPC f f', 'Telescope find_files'),
    my_button('  ', 'File Browser                            ', 'SPC f b', 'NvimTreeToggle'),
    my_button('  ', 'Find  word                              ', 'SPC f w', 'Telescope live_grep'),
}

dashboard.section.footer.val = { 'neovim plus' }
dashboard.section.footer.opts.hl = "DashboardFooter"

-- Añadir espaciado entre secciones para imitar el dashboard
dashboard.config.layout = {
  { type = "padding", val = 0 },
  dashboard.section.header,
  { type = "padding", val = 0 },
  dashboard.section.buttons,
  { type = "padding", val = 2 },
  dashboard.section.footer,
}

require'alpha'.setup(dashboard.opts)

-- Configurar el plugin de resaltado de píldora
require('pill-highlighter').setup({
  hl_group = "DashboardTextSelect",
  bg_color = "#292e42",
  hide_cursor = true,
  rounded = true
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "alpha",
  callback = function()
    require('pill-highlighter').attach()
    -- Guardar valores anteriores
    local old_laststatus = vim.opt.laststatus:get()
    local old_showtabline = vim.opt.showtabline:get()
    
    -- Ocultar elementos de la interfaz para que quede limpio como dashboard
    vim.opt.showtabline = 0
    vim.opt.laststatus = 0
    
    -- Restaurar al salir del buffer
    vim.api.nvim_create_autocmd({"BufUnload", "BufLeave"}, {
      buffer = 0,
      callback = function()
        vim.opt.showtabline = old_showtabline
        vim.opt.laststatus = old_laststatus
      end,
    })
  end,
})
