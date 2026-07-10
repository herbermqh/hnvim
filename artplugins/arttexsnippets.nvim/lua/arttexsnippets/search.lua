local M = {}

function M.open_search()
  local has_telescope, pickers = pcall(require, "telescope.pickers")
  if not has_telescope then
    vim.notify("[ArtTex] Telescope no está instalado.", vim.log.levels.ERROR)
    return
  end
  
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local previewers = require("telescope.previewers")
  
  local ls = require("luasnip")
  local ft = vim.bo.filetype
  
  -- Obtener todos los snippets del filetype actual
  local snips = ls.get_snippets(ft)
  
  if not snips or #snips == 0 then
    vim.notify("[ArtTex] No se encontraron snippets para " .. ft, vim.log.levels.WARN)
    return
  end

  -- Formatear resultados para Telescope
  local results = {}
  for _, s in ipairs(snips) do
    local docstring = "Sin previsualización."
    if type(s.get_docstring) == "function" then
      local doc = s:get_docstring()
      if type(doc) == "table" then
        docstring = table.concat(doc, "\n")
      elseif type(doc) == "string" then
        docstring = doc
      end
    end
    
    table.insert(results, {
      trigger = s.trigger or "",
      name = s.name or "Sin Nombre",
      docstring = docstring,
      type = s.hidden and "Auto" or "Manual"
    })
  end

  pickers.new({}, {
    prompt_title = " 󰌵 Buscador de Snippets (" .. ft .. ") ",
    finder = finders.new_table({
      results = results,
      entry_maker = function(entry)
        return {
          value = entry,
          display = string.format(" %-15s │ %s", entry.trigger, entry.name),
          ordinal = entry.trigger .. " " .. entry.name,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    previewer = previewers.new_buffer_previewer({
      title = " 󰈙 Código Generado ",
      define_preview = function(self, entry, status)
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, vim.split(entry.value.docstring, "\n"))
        
        -- Highlighting bonito (dependiendo de treesitter)
        local has_ts, ts_lang = pcall(require, "nvim-treesitter.parsers")
        if has_ts and ts_lang.has_parser("tex") then
          vim.bo[self.state.bufnr].filetype = "tex"
        end
      end,
    }),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        -- Si selecciona, lo insertamos directamente (opcional)
        local trigger = selection.value.trigger
        vim.api.nvim_put({ trigger }, "c", false, true)
        -- Expandir usando luasnip manual
        vim.schedule(function()
          if ls.expandable() then
            ls.expand()
          end
        end)
      end)
      return true
    end,
  }):find()
end

return M
