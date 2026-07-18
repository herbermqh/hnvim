--- @module arttexsourcecolor.highlights
--- @description Administra la paleta de colores y la aplicación de los Highlight Groups.
--- Separado para aislar el estilo de la lógica, facilitando temas y configuraciones de usuario.
local M = {}
local config = require("arttexsourcecolor.config")

function M.apply_globals()
  if not config.options.enabled then return end

  local c = config.options.colors

  -- 1. Bases Dinámicas
  vim.api.nvim_set_hl(0, "ArtTexCustomCommand", { fg = c.custom_command, bold = true })
  vim.api.nvim_set_hl(0, "ArtTexCustomEnv", { fg = c.custom_env, italic = true })
  
  -- UI del Editor (Sobrescribir default globalmente si está habilitado)
  if c.cursor_line_nr then
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = c.cursor_line_nr, bold = true })
  end
  
  -- 2. Globales (Treesitter)
  vim.api.nvim_set_hl(0, "@function.macro.latex", { fg = c.macro, bold = true })
  vim.api.nvim_set_hl(0, "@markup.environment.name.latex", { fg = c.env_name })
  vim.api.nvim_set_hl(0, "ArtTexEnvName", { fg = c.env_name })
  vim.api.nvim_set_hl(0, "@function.builtin.latex", { fg = c.env_kw })
  vim.api.nvim_set_hl(0, "@keyword.directive.latex", { fg = c.env_kw })
  vim.api.nvim_set_hl(0, "@markup.math.latex", { fg = c.math }) 
  vim.api.nvim_set_hl(0, "@punctuation.special.latex", { fg = c.math_oper, bold = true })
  vim.api.nvim_set_hl(0, "@markup.link.latex", { fg = c.link, underline = true })
  
  -- Forzar a que negrita/cursiva no tengan color y hereden el color circundante
  vim.api.nvim_set_hl(0, "@markup.strong", { bold = true })
  vim.api.nvim_set_hl(0, "@markup.italic", { italic = true })
  vim.api.nvim_set_hl(0, "texStyleBold", { bold = true })
  vim.api.nvim_set_hl(0, "texStyleItal", { italic = true })

  -- 3. Kernel & Expl3
  vim.api.nvim_set_hl(0, "ArtTexKernelMacro", { fg = c.kernel_macro, italic = true })
  vim.api.nvim_set_hl(0, "ArtTexExpl3Macro", { fg = c.expl3_macro, bold = true, italic = true })
  vim.api.nvim_set_hl(0, "ArtTexStructCmd", { fg = c.struct_cmd, bold = true })

  -- 4. Semántica de Entornos
  vim.api.nvim_set_hl(0, "ArtTexEnvTheorem", { fg = c.env_theorem, bg = "#292e42", bold = true })
  vim.api.nvim_set_hl(0, "ArtTexEnvMathBlock", { fg = c.env_math_block, bg = "#1f2335", italic = true })
  vim.api.nvim_set_hl(0, "ArtTexEnvBox", { fg = c.env_box, bold = true })

  -- 5. Validación y Errores
  vim.api.nvim_set_hl(0, "ArtTexRefValid", { fg = c.ref_valid, underline = true })
  vim.api.nvim_set_hl(0, "ArtTexRefInvalid", { fg = c.ref_invalid, undercurl = true, sp = c.ref_invalid })
  vim.api.nvim_set_hl(0, "ArtTexError", { undercurl = true, sp = c.error_color })
  vim.api.nvim_set_hl(0, "ArtTexMatchParen", { bg = c.match_paren, bold = true })
  vim.api.nvim_set_hl(0, "ArtTexResourceVirt", { fg = c.resource_virt, italic = true })

  -- 4. Rainbow Brackets
  vim.api.nvim_set_hl(0, "ArtTexRainbow1", { fg = c.rainbow1 })
  vim.api.nvim_set_hl(0, "ArtTexRainbow2", { fg = c.rainbow2 })
  vim.api.nvim_set_hl(0, "ArtTexRainbow3", { fg = c.rainbow3 })
  vim.api.nvim_set_hl(0, "ArtTexRainbow4", { fg = c.rainbow4 })
  vim.api.nvim_set_hl(0, "ArtTexRainbow5", { fg = c.rainbow5 })
  vim.api.nvim_set_hl(0, "ArtTexRainbow6", { fg = c.rainbow6 })
  -- 6. Grupos Personalizados del Usuario
  if config.options.custom_groups then
    for _, group in ipairs(config.options.custom_groups) do
      if group.name and group.color then
        local hl_name = "ArtTexCustomGroup_" .. group.name
        vim.api.nvim_set_hl(0, hl_name, { 
          fg = group.color, 
          bold = group.bold, 
          italic = group.italic 
        })
      end
    end
  end
end

function M.clear_globals()
  if vim.g.colors_name then
    pcall(vim.cmd, "colorscheme " .. vim.g.colors_name)
  end
end

return M
