require('packer').startup(function()
    -- Packer Itself
    use('wbthomason/packer.nvim')
    -- LSP
    --[[ use({
        'neoclide/coc.nvim',
        branch = 'master',
        run = 'yarn install --frozen-lockfile'
    }) ]]
    use 'neovim/nvim-lspconfig'
    -- use 'hrsh7th/nvim-compe'
    -- use 'onsails/lspkind-nvim'
    -- use {
    -- 'williamboman/nvim-lsp-installer',
    -- }
    use 'hura/vim-asymptote'
    -- menu
    -- use 'sharkdp/fd'
    -- use 'nixprime/cpsm'
    -- use 'romgrk/fzy-lua-native'
    -- use 'gelguy/wilder.nvim'
    use 'ryanoasis/vim-devicons'
    use 'kyazdani42/nvim-web-devicons'
    --autocomplete
    use('SirVer/ultisnips')
    use('quangnguyen30192/cmp-nvim-ultisnips')
    -- use({
    --   "jackMort/ChatGPT.nvim",
    --   config = function()
    --     require("chatgpt").setup()
    --   end,
    --   requires = {
    --     "MunifTanjim/nui.nvim",
    --     "nvim-lua/plenary.nvim",
    --     "nvim-telescope/telescope.nvim"
    --   }
    -- })
    -- use('herbermqh/vim-snippets')
    -- use('honza/vim-snippets')
    -- use 'dcampos/nvim-snippy'
    -- use 'hrsh7th/vim-vsnip'
    -- use 'hrsh7th/vim-vsnip-integ'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use({
      'hrsh7th/nvim-cmp',
      requires = {
        "quangnguyen30192/cmp-nvim-ultisnips",
        "kdheepak/cmp-latex-symbols",
        config = function()
          require("cmp_nvim_ultisnips").setup{}
        end,
      },
      sources = {
        {name = "latex_symbols"}
      }
    })
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    -- use 'hrsh7th/cmp-copilot'
    use {'github/copilot.vim'}
    -- LaTeX
    use({'lervag/vimtex'})
    -- use({'herbermqh/vimtex'})
    -- use('herbermqh/vim-latex')

    -- Utilities
    use 'duane9/nvim-rg'
    -- use 'rhysd/vim-grammarous'
    -- use({'Pocco81/AutoSave.nvim', opt = true})
    -- use 'kevinhwang91/nvim-bqf'
    use({
        'AckslD/nvim-neoclip.lua',
        config = function()
            require('neoclip').setup()
            require('telescope').load_extension('neoclip')
        end
    })
    -- use 'djoshea/vim-autoread' -- recargado automaticio
    -- use 'junegunn/fzf.vim'
    use 'Shougo/denite.nvim'
    use({
      'lewis6991/gitsigns.nvim',
      requires = {'nvim-lua/plenary.nvim'},
      config = function()
        require('gitsigns').setup()
      end
    })
    use 'mfussenegger/nvim-dap'

    --[[ use({
        'b3nj5m1n/kommentary',
        config = function()
            require('kommentary.config').use_extended_mappings()
        end
    }) ]]
    use 'rcarriga/nvim-notify'

    -- use({'nacro90/numb.nvim', config = function() require('numb').setup() end})

    -- folders
    -- use({'francoiscabrol/ranger.vim'})
    -- use({'rbgrouleff/bclose.vim'})
    -- use({'nvim-lua/popup.nvim'})
    -- use({'nvim-lua/plenary.nvim'})
    use({
        'nvim-telescope/telescope.nvim',
        --[[ requires = {
            'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-fzy-native.nvim'
        } ]]
    })
    use({
      'kyazdani42/nvim-tree.lua',
      requires = 'kyazdani42/nvim-web-devicons',
      -- tag = 'nightly',
      -- config = function() require('nvim-tree').setup {} end
    })


    --typing
    use('terryma/vim-multiple-cursors')
    use({'alvan/vim-closetag'})
    use({'tpope/vim-surround'})

    -- Syntax Highlighting
    use({'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'})
    -- use({'airblade/vim-gitgutter'})

    -- UI Plugins
    use {
      'glepnir/dashboard-nvim',
      -- event = 'VimEnter',
      -- config = function()
      --   require('dashboard').setup {
      --     theme = 'hyoer',
      --   }
      -- end,
    }
    use('goolord/alpha-nvim')
    --use({
    --    'glepnir/galaxyline.nvim',
    --    branch = 'main',
    --    -- your statusline
    --    config = function() require'hgalaxyline' end,
    --})

    --[[ use({
      'herbermqh/spaceline.vim',
      config = function()
        vim.g.spaceline_seperate_style = "curve"
      end,
      requires = {'kyazdani42/nvim-web-devicons', opt = true}
    }) ]]
    -- modules ts
    -- use('p00f/nvim-ts-rainbow') -- discontinuado en vez de esto se utiliza nvim-ts-rainbow2
    use 'HiPhish/nvim-ts-rainbow2'
    -- use 'windwp/nvim-ts-autotag'
    use 'nvim-treesitter/playground'
    use 'tree-sitter/tree-sitter-regex'

    -- use({'frazrepo/vim-rainbow'})
    -- use({'luochen1990/rainbow'})
    -- use('akinsho/nvim-bufferline.lua')
    -- use('powerline/fonts')
    use {'romgrk/barbar.nvim',}
    use 'nvim-lualine/lualine.nvim'

    -- Themes
    -- use 'mhinz/vim-startify'
    use 'norcalli/nvim-colorizer.lua'
    -- use({'marko-cerovac/material.nvim', opt = false, as = 'material'})
    use({'folke/tokyonight.nvim'})
    -- use 'herbermqh/tokyonight.nvim'
    use 'Mofiqul/vscode.nvim'
    -- use 'bluz71/vim-moonfly-colors'
    -- use 'bluz71/vim-nightfly-guicolors'
    use({'christianchiarulli/nvcode-color-schemes.vim'})
    --[[ use{
      'PHSix/nvim-hybrid',
      config = function()
        require('hybrid')
      end
    } ]]
    -- use 'Th3Whit3Wolf/space-nvim'
    -- use 'yonlu/omni.vim'
    -- use 'ray-x/aurora'
    -- use 'nekonako/xresources-nvim'
    use 'shaunsingh/nord.nvim'
    -- use {'MordechaiHadad/nvim-papadark', requires = {'rktjmp/lush.nvim'}}
    -- use 'shaunsingh/moonlight.nvim'
    -- use 'navarasu/onedark.nvim'
    -- use 'olimorris/onedarkpro.nvim'
    -- use 'yashguptaz/calvera-dark.nvim'
    -- use {'nxvu699134/vn-night.nvim'}
    -- use "projekt0n/github-nvim-theme"
    -- use({'rose-pine/neovim'})
    --[[ use({
	"catppuccin/nvim",
	as = "catppuccin"
    }) ]]
    -- use 'frenzyexists/aquarium-vim'
    -- use 'EdenEast/nightfox.nvim'
    -- use { 'mangeshrex/uwu.vim' }
    -- use 'olimorris/onedark.nvim'

    -- IDE
    use "xiyaowong/transparent.nvim"
    -- use({'micha/vim-colors-solarized'})
    -- use({'mg979/vim-visual-multi'})
    -- use({'arzg/vim-colors-xcode'})
    use "lukas-reineke/indent-blankline.nvim"
    use({'windwp/nvim-autopairs'})
    use({'tpope/vim-sensible'})
    use({'tpope/vim-unimpaired'})
    use({'tpope/vim-obsession'})
    use({'tpope/vim-commentary'})
    use 'tpope/vim-repeat'
    -- use {
    --   'VonHeikemen/fine-cmdline.nvim',
    --   requires = {
    --     {'MunifTanjim/nui.nvim'}
    --   }
    -- }
    use {
      'folke/noice.nvim',
      requires = {
        'MunifTanjim/nui.nvim',
        'rcarriga/nvim-notify',
        ''
      }
    }

    -- others
    use({'voldikss/vim-floaterm'})
    use({'liuchengxu/vim-which-key'})
    -- use({'liuchengxu/vim-clap'})
    use {"akinsho/toggleterm.nvim"}
    -- use {"herbermqh/nvim-workbench"}
    -- Ocasional Plugins
    use({'kdheepak/lazygit.nvim', opt = true})
    -- use({'Pocco81/TrueZen.nvim', opt = true})
end)

