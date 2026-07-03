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
      'neovim/nvim-lspconfig',
      tag = 'v2.5.0',
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
    'SirVer/ultisnips',
    'quangnguyen30192/cmp-nvim-ultisnips',
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
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    {
      'hrsh7th/nvim-cmp',
      dependencies = {
        "quangnguyen30192/cmp-nvim-ultisnips",
        "kdheepak/cmp-latex-symbols",
        config = function()
          require("cmp_nvim_ultisnips").setup{}
        end,
      },
      sources = {
        {name = "latex_symbols"},
      },
    },
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    -- 'hrsh7th/cmp-copilot',
    {'github/copilot.vim', depth=1},
    {
      'CopilotC-Nvim/CopilotChat.nvim',
      dependencies = {
        "github/copilot.vim",
        "nvim-lua/plenary.nvim",
      },
      build = "make tiktoken",
    },
    -- LaTeX
    'lervag/vimtex',
    -- 'herbermqh/vimtex',
    -- 'herbermqh/vim-latex',

    -- Utilities
    'duane9/nvim-rg',
    -- 'rhysd/vim-grammarous',
    -- {'Pocco81/AutoSave.nvim', lazy = true},
    'kevinhwang91/nvim-bqf',
    {
        'AckslD/nvim-neoclip.lua',
        dependencies = {'nvim-telescope/telescope.nvim'},
        config = function()
            require('neoclip').setup()
            require('telescope').load_extension('neoclip')
        end
    },
    -- 'djoshea/vim-autoread', -- recargado automaticio
    -- 'junegunn/fzf.vim',
    'Shougo/denite.nvim',
    {
      'lewis6991/gitsigns.nvim',
      dependencies = {'nvim-lua/plenary.nvim'},
      config = function()
        require('gitsigns').setup()
      end
    },
    'mfussenegger/nvim-dap',

    --[[ {
        'b3nj5m1n/kommentary',
        config = function()
            require('kommentary.config').use_extended_mappings()
        end
    }) ]]
    'rcarriga/nvim-notify',

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
          desc = "Abrir Yazi en el archivo actual",
        },
        {
          "<leader>cw",
          "<cmd>Yazi cwd<cr>",
          desc = "Abrir Yazi en el directorio actual",
        },
        {
          "<c-up>",
          "<cmd>Yazi toggle<cr>",
          desc = "Continuar la última sesión de Yazi",
        },
      },
      opts = {
        open_for_directories = true,
      },
    },
    {
      "vhyrro/luarocks.nvim",
      priority = 1001,
      opts = {
        rocks = { "magick" },
      },
      config = true,
    },
    {
      "3rd/image.nvim",
      lazy = false,
      dependencies = { "vhyrro/luarocks.nvim" },
      opts = {
        backend = "kitty", -- WezTerm entiende perfectamente el protocolo de Kitty
        integrations = {
          markdown = { enabled = true, clear_in_insert_mode = false, download_remote_images = true },
          neorg = { enabled = true, clear_in_insert_mode = false },
        },
        max_width = nil,
        max_height = nil,
        max_width_window_percentage = nil,
        max_height_window_percentage = 50,
        window_overlap_clear_enabled = true,
      }
    },
    -- 'rbgrouleff/bclose.vim',
    -- 'nvim-lua/popup.nvim',
    -- 'nvim-lua/plenary.nvim',
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            -- 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-fzy-native.nvim'
        },
    },
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
    },
    {
      'nvim-tree/nvim-tree.lua',
      dependencies = {
        'nvim-tree/nvim-web-devicons', -- optional
      },
    },
    --typing
    'terryma/vim-multiple-cursors',
    'alvan/vim-closetag',
    'tpope/vim-surround',

    -- Syntax Highlighting
    -- 'airblade/vim-gitgutter',

    -- UI Plugins
    {
      'nvimdev/dashboard-nvim',
      -- event = 'VimEnter',
      -- config = function()
      --   require('dashboard').setup {
      --     theme = 'hyoer',
      --   },
      -- end,
    },
    'goolord/alpha-nvim',
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
    'HiPhish/rainbow-delimiters.nvim', 
    -- 'windwp/nvim-ts-autotag',
    {'nvim-treesitter/nvim-treesitter', branch = 'master', build = ':TSUpdate'},
    -- 'luochen1990/rainbow',
    -- 'akinsho/nvim-bufferline.lua',
    -- 'powerline/fonts',
    {'romgrk/barbar.nvim',},
    'nvim-lualine/lualine.nvim',

    -- Themes
    -- 'mhinz/vim-startify',
    'norcalli/nvim-colorizer.lua',
    -- {'marko-cerovac/material.nvim', lazy = false, as = 'material'},
    'folke/tokyonight.nvim',
    -- 'herbermqh/tokyonight.nvim',
    'Mofiqul/vscode.nvim',
    -- 'bluz71/vim-moonfly-colors',
    -- 'bluz71/vim-nightfly-guicolors',
    'christianchiarulli/nvcode-color-schemes.vim',
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
    'shaunsingh/nord.nvim',
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
    "xiyaowong/transparent.nvim",
    -- 'micha/vim-colors-solarized',
    -- 'mg979/vim-visual-multi',
    -- 'arzg/vim-colors-xcode',
    "lukas-reineke/indent-blankline.nvim",
    'windwp/nvim-autopairs',
    'tpope/vim-sensible',
    'tpope/vim-unimpaired',
    {
      "folke/persistence.nvim",
      event = "BufReadPre", -- starts automatically when opening a file
      opts = { options = {"buffers", "curdir", "tabpages", "winsize"} }
    },
    'tpope/vim-commentary',
    'tpope/vim-repeat',
    -- {
    --   'VonHeikemen/fine-cmdline.nvim',
    --   dependencies = {
    --     {'MunifTanjim/nui.nvim'},
    --   },
    -- },
    {
      'folke/noice.nvim',
      dependencies = {
        'MunifTanjim/nui.nvim',
        'rcarriga/nvim-notify',

      },
    },
    {
      'b0o/incline.nvim'
    },
   {'ray-x/guihua.lua', build = 'cd lua/fzy && make'},
    -- {
    --   'ray-x/navigator.lua',
    -- },
    -- others
    'voldikss/vim-floaterm',
    'liuchengxu/vim-which-key',
    -- 'liuchengxu/vim-clap',
    -- {"akinsho/toggleterm.nvim"},
    -- {"herbermqh/nvim-workbench"},
    -- Ocasional Plugins
    {'kdheepak/lazygit.nvim', lazy = true},
    -- {'Pocco81/TrueZen.nvim', lazy = true},
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

})
