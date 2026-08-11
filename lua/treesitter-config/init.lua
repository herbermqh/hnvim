require('nvim-treesitter.configs').setup({
  ensure_installed = { "python", "lua", "latex", "html", "css", "javascript", "markdown" },
  sync_install = false,
  auto_install = true, -- Automatically install missing parsers when entering buffer
  incremental_selection = {
    enable = true,
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { "latex", "tex" },
    -- Desactivar Treesitter en archivos gigantes para salvar RAM y CPU
    disable = function(lang, buf)
      local max_filesize = 1500 * 1024 -- 1.5 MB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
      -- También desactivar si el archivo tiene más de 10,000 líneas
      local max_lines = 10000
      local line_count = vim.api.nvim_buf_line_count(buf)
      if line_count > max_lines then
        return true
      end
    end,
  },
  indent = { 
    enable = true, 
    disable = {"yaml"} 
  },
})
