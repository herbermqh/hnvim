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
  },
  indent = { 
    enable = true, 
    disable = {"yaml"} 
  },
})
