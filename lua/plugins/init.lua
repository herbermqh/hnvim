local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- Packer Itself
    -- LSP
    --[[ {
        'neoclide/coc.nvim',
        branch = 'master',
        build = 'yarn install --frozen-lockfile'
    }) ]]
    {
      "neovim/nvim-lspconfig",
      event = {"BufReadPre", "BufNewFile"},
      dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
      },
      config = function() require("lsp") end,
    },


    -- 'hrsh7th/nvim-compe',
    -- 'onsails/lspkind-nvim',
    -- {
    -- 'williamboman/nvim-lsp-installer',
    -- },
    'hura/vim-asymptote',
    -- menu
    -- 'sharkdp/fd',
    -- 'nixprime/cpsm',
    -- 'romgrk/fzy-lua-native',
    -- 'gelguy/wilder.nvim',
    'ryanoasis/vim-devicons',
    'kyazdani42/nvim-web-devicons',
    --autocomplete
  -- 'SirVer/ultisnips',
  -- 'quangnguyen30192/cmp-nvim-ultisnips',

    -- {
    --   "jackMort/ChatGPT.nvim",
    --   config = function()
    --     require("chatgpt").setup()
    --   end,
    --   dependencies = {
    --     "MunifTanjim/nui.nvim",
    --     "nvim-lua/plenary.nvim",
    --     "nvim-telescope/telescope.nvim"
    --   },
    -- },
    -- 'herbermqh/vim-snippets',
    -- 'honza/vim-snippets',
    -- 'dcampos/nvim-snippy',
    -- 'hrsh7th/vim-vsnip',
    -- 'hrsh7th/vim-vsnip-integ',

    {
      'hrsh7th/nvim-cmp',
      event = { "InsertEnter", "CmdlineEnter" },
      dependencies = {
        {
          "L3MON4D3/LuaSnip",
          version = "v2.*",
          build = "make install_jsregexp"
        },
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lsp",
        "kdheepak/cmp-latex-symbols",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-path",
      },
      config = function()
        require("cmp-config")
      end,
    },

    -- {
    --   'github/copilot.vim',
    --   depth = 1,
    --   event = "InsertEnter",
    -- },
    -- {
    --   'CopilotC-Nvim/CopilotChat.nvim',
    --   cmd = {
    --     "CopilotChat",
    --     "CopilotChatOpen",
    --     "CopilotChatToggle",
    --   },
    --   dependencies = {
    --     "github/copilot.vim",
    --     "nvim-lua/plenary.nvim",
    --   },
    --   build = "make tiktoken",
    --   config = function() require('config.copilot') end,
    -- },

    -- Utilities
    'duane9/nvim-rg',
    -- 'rhysd/vim-grammarous',
    -- {'Pocco81/AutoSave.nvim', lazy = true},
    {
      'kevinhwang91/nvim-bqf',
      ft = "qf",
      config = function() require('config-bqf') end
    },
    {
        'AckslD/nvim-neoclip.lua',
        event = "VeryLazy",
        dependencies = {'nvim-telescope/telescope.nvim'},
        config = function()
            require('neoclip').setup()
            require('telescope').load_extension('neoclip')
        end
    },
    -- 'djoshea/vim-autoread', -- recargado automaticio
    -- 'junegunn/fzf.vim',
    {
      'Shougo/denite.nvim',
      cmd = "Denite",
    },
    {
      "lewis6991/gitsigns.nvim",
      event = {"BufReadPre", "BufNewFile"},
      dependencies = {'nvim-lua/plenary.nvim'},
      config = function()
        require('gitsigns-config')
      end
    },
    'mfussenegger/nvim-dap',

    --[[ {
        'b3nj5m1n/kommentary',
        config = function()
            require('kommentary.config').use_extended_mappings()
        end
    }) ]]
    {
      'rcarriga/nvim-notify',
      config = function() require('config-notify') end,
    },

    -- {'nacro90/numb.nvim', config = function() require('numb').setup() end},
    -- folders
    -- 'francoiscabrol/ranger.vim',
    {
      "mikavilpas/yazi.nvim",
      event = "VeryLazy",
      keys = {
        {
          "<leader>y",
          "<cmd>Yazi<cr>",
          desc = "Yazi File",
        },
        {
          "<leader>cw",
          "<cmd>Yazi cwd<cr>",
          desc = "Yazi Dir",
        },
        {
          "<c-up>",
          "<cmd>Yazi toggle<cr>",
          desc = "Yazi Resume",
        },
      },
      opts = {
        open_for_directories = true,
      },
    },
    -- {
    --   "vhyrro/luarocks.nvim",
    --   priority = 1001,
    --   opts = {
    --     rocks = { "magick" },
    --   },
    --   config = true,
    -- },
    -- {
    --   "3rd/image.nvim",
    --   event = "VeryLazy",
    --   dependencies = { "vhyrro/luarocks.nvim" },
    --   opts = {
    --     backend = "kitty", -- WezTerm entiende perfectamente el protocolo de Kitty
    --     integrations = {
    --       markdown = { enabled = true, clear_in_insert_mode = false, download_remote_images = true },
    --       neorg = { enabled = true, clear_in_insert_mode = false },
    --     },
    --     max_width = nil,
    --     max_height = nil,
    --     max_width_window_percentage = nil,
    --     max_height_window_percentage = 50,
    --     window_overlap_clear_enabled = true,
    --   }
    -- },
    -- 'rbgrouleff/bclose.vim',
    -- 'nvim-lua/popup.nvim',
    -- 'nvim-lua/plenary.nvim',
    -- HERRAMIENTA VISUAL PARA ERRORES (Trouble)
    {
      "romgrk/barbar.nvim",
      event = "VeryLazy",
      config = function()
        require("babar")
        if vim.bo.filetype == "dashboard" or vim.bo.filetype == "alpha" then
          vim.opt.showtabline = 0
        end
        vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
          callback = function()
            if vim.bo.filetype == "dashboard" or vim.bo.filetype == "alpha" then
              vim.opt.showtabline = 0
            elseif vim.bo.buftype == "" or vim.bo.buftype == "terminal" then
              vim.opt.showtabline = 2
            end
          end
        })
      end
    },
    {
      "folke/trouble.nvim",
      config = function() require("config-trouble") end,
      cmd = "Trouble",
    },
    {
        'nvim-telescope/telescope.nvim',
        cmd = "Telescope",
        dependencies = {
            -- 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-fzy-native.nvim',
            'nvim-telescope/telescope-live-grep-args.nvim'
        },
        config = function()
          require("telescope-config")
        end
    },

    {
      'nvim-tree/nvim-tree.lua',
      cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFileToggle" },
      dependencies = {
        'nvim-tree/nvim-web-devicons', -- optional
      },
      config = function()
        require("nvim-tree-config")
      end
    },
    --typing
    { 'terryma/vim-multiple-cursors', event = "VeryLazy" },
    { 'alvan/vim-closetag', event = "InsertEnter" },
    { 'tpope/vim-surround', event = "VeryLazy" },

    -- Syntax Highlighting
    -- 'airblade/vim-gitgutter',

    -- UI Plugins
    -- {
    --   'nvimdev/dashboard-nvim',
    --   event = 'VimEnter',
    --   config = function()
    --     require('dashboard-config')
    --   end,
    -- },
    {
      'goolord/alpha-nvim',
      event = 'VimEnter',
      config = function()
        require('alpha-nvim-config')
      end
    },
    --{
    --    'glepnir/galaxyline.nvim',
    --    branch = 'main',
    --    -- your statusline
    --    config = function() require'hgalaxyline' end,
    --},
    --[[ {
      'herbermqh/spaceline.vim',
      config = function()
        vim.g.spaceline_seperate_style = "curve"
      end,
      dependencies = {'kyazdani42/nvim-web-devicons', lazy = true},
    }) ]]
    -- modules ts
    -- 'p00f/nvim-ts-rainbow', -- discontinuado en vez de esto se utiliza nvim-ts-rainbow2
    -- 'HiPhish/nvim-ts-rainbow2',
    { "HiPhish/rainbow-delimiters.nvim", event = "BufReadPre", config = function() require("rainbow") end }, 
    -- 'windwp/nvim-ts-autotag',
    {
      "nvim-treesitter/nvim-treesitter",
      event = {"BufReadPost", "BufNewFile"},
      config = function() require("treesitter-config") end,
      branch = 'master',
      build = ':TSUpdate'
    },
    -- 'luochen1990/rainbow',
    -- 'akinsho/nvim-bufferline.lua',
    -- 'powerline/fonts',

    {
      "stevearc/conform.nvim",
      event = { "BufWritePre" },
      cmd = { "ConformInfo" },
      config = function() require("conform-config") end
    },
    { "nvim-lualine/lualine.nvim", event = "VeryLazy", config = function() require("lualine-config") end },

    -- Themes
    -- 'mhinz/vim-startify',
    { "norcalli/nvim-colorizer.lua", event = "BufReadPre", config = function() require("colorizer-config") end },
    -- {'marko-cerovac/material.nvim', lazy = false, as = 'material'},
    {
      'folke/tokyonight.nvim',
      config = function() require('tokyonight-config') end
    },
    {
      dir = vim.fn.stdpath("config") .. "/artplugins/tknvivid",
      config = function() require('tknvivid-config') end
    },
    -- 'herbermqh/tokyonight.nvim',
    -- 'Mofiqul/vscode.nvim',
    -- 'bluz71/vim-moonfly-colors',
    -- 'bluz71/vim-nightfly-guicolors',
    -- 'christianchiarulli/nvcode-color-schemes.vim',
    --[[ {
      'PHSix/nvim-hybrid',
      config = function()
        require('hybrid')
      end
    } ]]
    -- 'Th3Whit3Wolf/space-nvim',
    -- 'yonlu/omni.vim',
    -- 'ray-x/aurora',
    -- 'nekonako/xresources-nvim',
    -- 'shaunsingh/nord.nvim',
    -- {'MordechaiHadad/nvim-papadark', dependencies = {'rktjmp/lush.nvim'}},
    -- 'shaunsingh/moonlight.nvim',
    -- 'navarasu/onedark.nvim',
    -- 'olimorris/onedarkpro.nvim',
    -- 'yashguptaz/calvera-dark.nvim',
    -- {'nxvu699134/vn-night.nvim'},
    -- "projekt0n/github-nvim-theme",
    -- 'rose-pine/neovim',
    --[[ {
	"catppuccin/nvim",
	as = "catppuccin"
    }) ]]
    -- 'frenzyexists/aquarium-vim',
    -- 'EdenEast/nightfox.nvim',
    -- { 'mangeshrex/uwu.vim' },
    -- 'olimorris/onedark.nvim',

    -- IDE
    {
      "xiyaowong/transparent.nvim",
      config = function()
        require("transparent-config")
      end
    },
    -- 'micha/vim-colors-solarized',
    -- 'mg979/vim-visual-multi',
    -- 'arzg/vim-colors-xcode',
    { "lukas-reineke/indent-blankline.nvim", event = "BufReadPre", config = function() require("indentline") end },
    { "windwp/nvim-autopairs", event = "InsertEnter", config = function() require("autopairs-config") end },
    { 'tpope/vim-sensible', event = "VeryLazy" },
    { 'tpope/vim-unimpaired', event = "VeryLazy" },
    {
      "folke/persistence.nvim",
      event = { "BufReadPre", "BufNewFile" }, -- starts automatically when opening or creating a file
      config = function(_, opts)
        require("persistence").setup(opts)
        -- Evitar que NvimTree corrompa la sesión al guardar
        vim.api.nvim_create_autocmd("VimLeavePre", {
          callback = function()
            local nvim_tree_view_loaded, view = pcall(require, "nvim-tree.view")
            if nvim_tree_view_loaded and view.is_visible() then
              vim.cmd("NvimTreeClose")
            end
          end,
        })
      end,
      opts = { options = {"buffers", "curdir", "tabpages", "winsize", "globals"} }
    },
    { 'tpope/vim-commentary', event = "VeryLazy" },
    { 'tpope/vim-repeat', event = "VeryLazy" },
    -- {
    --   'VonHeikemen/fine-cmdline.nvim',
    --   dependencies = {
    --     {'MunifTanjim/nui.nvim'},
    --   },
    -- },
    {
      "folke/noice.nvim",
      event = "VeryLazy",
      config = function() require("config-noice") end,
      dependencies = {
        'MunifTanjim/nui.nvim',
        'rcarriga/nvim-notify',
      },
    },

   {'ray-x/guihua.lua', build = 'cd lua/fzy && make'},
    -- {
    --   'ray-x/navigator.lua',
    -- },
    -- others
    -- 'voldikss/vim-floaterm',
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      config = function() require("whichkey-config") end,
      keys = {
        { "<leader>", mode = { "n", "v" } },
      },
    },
    -- 'liuchengxu/vim-clap',
    {"akinsho/toggleterm.nvim", config = function() require("config-toggleterm") end},
    -- {"herbermqh/nvim-workbench"},
    -- Ocasional Plugins
    {'kdheepak/lazygit.nvim', lazy = true},
    { "folke/zen-mode.nvim", config = function() require("zen-mode").setup({}) end },
    { "folke/twilight.nvim", config = function() require("twilight").setup({}) end },
    'propet/toggle-fullscreen.nvim',
  

    --- dev web
    -- {
    --   'brianhuster/live-preview.nvim',
    --   dependencies = {
    --       -- 'brianhuster/autosave.nvim'  -- Not required, but recomended for autosaving and sync scrolling

    --       -- You can choose one of the following pickers
    --       -- 'nvim-telescope/telescope.nvim',
    --       'ibhagwan/fzf-lua',
    --       'echasnovski/mini.pick',
    --   },
    --   opts = {},
    -- },
    -- {'weilbith/nvim-lsp-smag'},
    'ibhagwan/fzf-lua',
    {
      'weilbith/nvim-floating-tag-preview',
      cmd = {'Ptag', 'Ptselect', 'Ptjump', 'Psearch', 'Pedit' },
    },
    
    -- ==========================================
    -- NUEVOS PLUGINS PREMIUM (Flash, Neoscroll, Todo, Zen)
    -- ==========================================
    {
      "folke/flash.nvim",
      event = "VeryLazy",
      opts = {},
      keys = {
        { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash Jump" },
        { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      },
    },
    {
      "karb94/neoscroll.nvim",
      event = "VeryLazy",
      config = function()
        require('neoscroll').setup({
          mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
          hide_cursor = true,
          stop_eof = true,
          respect_scrolloff = false,
          cursor_scrolls_alone = true,
          easing_function = "quadratic", -- Animación súper suave
        })
      end
    },
    {
      "folke/todo-comments.nvim",
      event = "VeryLazy",
      dependencies = { "nvim-lua/plenary.nvim" },
      opts = {
        signs = true, -- Mostrar íconos en el Gutter
      }
    },
    {
      "MeanderingProgrammer/render-markdown.nvim",
      dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
      config = function()
        require("render-markdown").setup({
          heading = { sign = false },
          code = { sign = false, style = "normal" },
          table = { cell = "normal" },
        })

        -- BRUTE FORCE TRANSPARENCY (Delayed to override dynamic plugin themes)
        local function clear_bgs()
          local groups = {
            "RenderMarkdownH1Bg", "RenderMarkdownH2Bg", "RenderMarkdownH3Bg",
            "RenderMarkdownH4Bg", "RenderMarkdownH5Bg", "RenderMarkdownH6Bg",
            "RenderMarkdownCode", "RenderMarkdownCodeInline",
            "@markup.raw.markdown_inline", "markdownCode", "markdownCodeBlock",
            "RenderMarkdownTableHead", "RenderMarkdownTableRow", "RenderMarkdownTableFill",
            
            -- Añadimos los grupos base de Markdown que Tokyonight suele pintar
            "markdownH1", "markdownH2", "markdownH3", 
            "markdownH4", "markdownH5", "markdownH6",
            "@markup.heading.1.markdown", "@markup.heading.2.markdown", "@markup.heading.3.markdown",
            "@markup.heading.4.markdown", "@markup.heading.5.markdown", "@markup.heading.6.markdown",
            "Headline1", "Headline2", "Headline3", "Headline4", "Headline5", "Headline6"
          }
          for _, group in ipairs(groups) do
            pcall(vim.cmd, "hi " .. group .. " guibg=NONE ctermbg=NONE")
          end
        end

        vim.api.nvim_create_autocmd({ "ColorScheme", "BufEnter" }, {
          pattern = "*",
          callback = function()
            vim.defer_fn(clear_bgs, 100) -- Espera 100ms para asegurar que el tema ya pintó
          end,
        })
        -- Run once immediately just in case
        vim.defer_fn(clear_bgs, 200)
      end,
    },
    {
      "stevearc/aerial.nvim",
      cmd = { "AerialToggle", "AerialNavToggle", "AerialOpen", "AerialInfo" },
      opts = {},
      dependencies = {
         "nvim-treesitter/nvim-treesitter",
         "nvim-tree/nvim-web-devicons",
         "nvim-telescope/telescope.nvim"
      },
      config = function()
        require('aerial').setup({
          layout = {
            default_direction = "float",
          },
          backends = { "treesitter", "lsp", "markdown", "asciidoc", "man" },
        })
        require('telescope').load_extension('aerial')
      end,
    },
    
    -- PLUGIN PROPIO PARA LATEX (Desarrollado para la comunidad y cargado localmente)
    {
      dir = vim.fn.stdpath("config") .. "/artplugins/arttexsourcecolor.nvim",
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      ft = { "tex", "sty", "cls", "dtx" },
      config = function()
        require("arttexsourcecolor").setup()
      end,
    },
    
    -- PLUGIN DE CONCEAL MÁGICO PARA LATEX
    {
      dir = "~/.config/nvim/artplugins/arttexworkspace.nvim",
      name = "arttexworkspace",
      config = function()
        require("arttexworkspace").setup({
          library_paths = {
            "~/Documents/LaTeX/paquetes", -- Ruta relativa sugerida por la IA
            "~/Documents/LaTeX/devclass", -- Ruta relativa sugerida por la IA
          },
          verbatim_envs = {
            "verbatim", "Verbatim", "lstlisting", "minted",
            "codetex", "codetexlong", "codetexcommentlong", "codexetexcommentlong",
            "plaintex", "code", "texcode", "pseudocode"
          }
        })
      end
    },
    {
      dir = "~/.config/nvim/artplugins/arttexcompiler.nvim",
      name = "arttexcompiler",
      ft = "tex",
      dependencies = { "arttexworkspace" },
      config = function()
        require("arttexcompiler").setup({
          use_latexmk = true
        })
      end
    },
    -- {
    --   dir = vim.fn.stdpath("config") .. "/artplugins/arttexconceal.nvim",
    --   ft = { "tex", "sty", "cls", "dtx" },
    --   config = function()
    --     require("arttexconceal").setup({
    --       enable_script_conceal = false,
    --       enable_env_conceal = false,
    --       custom_symbols = {
    --         -- Inclusión y Referencia
    --         { pattern = "\\includegraphics", char = " ", hl = "ArtTexConcealImage", is_regex = false, env = "text" },
    --         { pattern = "\\image",          char = " ", hl = "ArtTexConcealImage", is_regex = false, env = "text" },
    --         -- Estructura
    --         { pattern = "\\item",           char = " ", hl = "ArtTexConcealNote", is_regex = false, env = "text" },
    --         -- Motores
    --         { pattern = "\\LaTeX",          char = " ", hl = "ArtTexConcealSection", is_regex = false, env = "text" },
    --         { pattern = "\\TeX",            char = " ", hl = "ArtTexConcealSection", is_regex = false, env = "text" },
    --         -- TikZ
    --         { pattern = "\\draw",           char = "󰌒 ", hl = "ArtTexConcealRef", is_regex = false, env = "text" },
    --         { pattern = "\\node",           char = "󰆼 ", hl = "ArtTexConcealRef", is_regex = false, env = "text" },
    --         -- Código (Expresión regular para atrapar el lenguaje, ej: \mintinline{latex})
    --         { pattern = "\\mintinline%{[^}]+%}", char = " ", hl = "ArtTexConcealSpecial", is_regex = true, env = "text" },
    --       }
    --     })
    --   end,
    -- },

    -- ART-TEX MODULAR PLUGINS
    { dir = vim.fn.stdpath("config") .. "/artplugins/arttexsynctex.nvim", ft = "tex", dependencies = { "arttexworkspace" }, config = function() require("arttexsynctex").setup() end },
    { dir = vim.fn.stdpath("config") .. "/artplugins/arttexfolding.nvim", ft = "tex", config = function() require("arttexfolding").setup() end },
    { dir = vim.fn.stdpath("config") .. "/artplugins/arttexhover.nvim", ft = "tex", dependencies = { "arttexworkspace" }, config = function() require("arttexhover").setup() end },
    { dir = vim.fn.stdpath("config") .. "/artplugins/arttexsnippets.nvim", ft = "tex", config = function() require("arttexsnippets").setup() end },
    { dir = vim.fn.stdpath("config") .. "/artplugins/arttexformat.nvim", ft = "tex", config = function() require("arttexformat").setup() end },
    { dir = vim.fn.stdpath("config") .. "/artplugins/arttextoc.nvim", ft = "tex", config = function() require("arttextoc").setup() end },
    { dir = vim.fn.stdpath("config") .. "/artplugins/arttexcmp.nvim", ft = "tex", dependencies = { "arttexworkspace" }, config = function() require("arttexcmp").setup() end },
    { dir = vim.fn.stdpath("config") .. "/artplugins/arttexlinter.nvim", ft = "tex", dependencies = { "arttexworkspace" }, config = function() require("arttexlinter").setup() end },
    
    {
      "jbyuki/nabla.nvim",
      config = function()
        -- Nabla doesn't require setup by default, but it's good to declare it
      end
    },
    { 
      dir = vim.fn.stdpath("config") .. "/artplugins/arttexpreview.nvim", 
      ft = "tex", 
      dependencies = { "jbyuki/nabla.nvim", "arttexworkspace" },
      config = function() require("arttexpreview").setup() end 
    },
    
    -- MONITOREO DE RECURSOS
    { 
      dir = vim.fn.stdpath("config") .. "/artplugins/resourcemon.nvim", 
      cmd = "MonitorRecursos",
      config = function() require("resourcemon").setup() end 
    },

})
