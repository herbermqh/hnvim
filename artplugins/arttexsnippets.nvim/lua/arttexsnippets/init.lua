local M = {}

M.default_opts = {
  use_treesitter = true,
  allow_on_markdown = true,
  load_core_math = true,
  load_custom = true,
  load_project_local = true,
  disabled_modules = {},
}

M.opts = {}

M.setup = function(opts)
  M.opts = vim.tbl_deep_extend("force", M.default_opts, opts or {})

  local augroup = vim.api.nvim_create_augroup("arttexsnippets", {})
  
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "tex",
    group = augroup,
    once = true,
    callback = function()
      local utils = require("arttexsnippets.util.utils")
      local is_math = utils.with_opts(utils.is_math, M.opts.use_treesitter)
      local not_math = utils.with_opts(utils.not_math, M.opts.use_treesitter)
      
      require("arttexsnippets.core.engine").setup_tex(is_math, not_math, M.opts)
    end,
  })

  if M.opts.allow_on_markdown then
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "markdown", "quarto" },
      group = augroup,
      once = true,
      callback = function()
        local utils = require("arttexsnippets.util.utils")
        local is_math = utils.with_opts(utils.is_math, M.opts.use_treesitter)
        local not_math = utils.with_opts(utils.not_math, M.opts.use_treesitter)

        require("arttexsnippets.core.engine").setup_markdown(is_math, not_math, M.opts)
      end,
    })
  end

  vim.api.nvim_create_user_command("ArtTexSnippetsReload", function()
    require("arttexsnippets.core.engine").reload()
  end, {})

  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = {
      "*/arttexsnippets/custom/*.lua",
      "*/arttexsnippets/math/*.lua",
      "*/.arttex/snippets/*.lua"
    },
    group = augroup,
    callback = function()
      require("arttexsnippets.core.engine").reload()
    end,
  })
end

return M
