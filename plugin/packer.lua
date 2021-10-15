require('packer').startup(function(use)
    -- Packer Itself
    use('wbthomason/packer.nvim')

    -- LSP Provider
    use({
        'neoclide/coc.nvim',
        branch = 'master',
        run = 'yarn install --frozen-lockfile'
    })

    --autocomplete
    use('sirver/ultisnips')
    use('herbermqh/vim-snippets')

    -- LaTeX
    use({'lervag/vimtex'})
    -- use('herbermqh/vim-latex')
    -- use({'KeitaNakamura/tex-conceal.vim'})

    -- Utilities
    use({'Pocco81/AutoSave.nvim', opt = true})

    use({
        'AckslD/nvim-neoclip.lua',
        config = function()
            require('neoclip').setup()
            require('telescope').load_extension('neoclip')
        end
    })

    use({
      'lewis6991/gitsigns.nvim',
      requires = {'nvim-lua/plenary.nvim'},
    -- tag = 'release' -- To use the latest release
    })

    use({
        'b3nj5m1n/kommentary',
        config = function()
            require('kommentary.config').use_extended_mappings()
        end
    })

    -- use({'nacro90/numb.nvim', config = function() require('numb').setup() end})

    -- folders
    use({'francoiscabrol/ranger.vim'})
    use({'rbgrouleff/bclose.vim'})
    use({'nvim-lua/popup.nvim'})
    use({'nvim-lua/plenary.nvim'})
    use({
        'nvim-telescope/telescope.nvim',
        requires = {
            'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-fzy-native.nvim'
        }
    })
    use({
      'kyazdani42/nvim-tree.lua',
      requires = 'kyazdani42/nvim-web-devicons',
      config = function() require'nvim-tree'.setup {} end
    })


    --typing
    use({'alvan/vim-closetag'})
    use({'tpope/vim-surround'})

    -- Syntax Highlighting
    use({'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'})
    -- use({'airblade/vim-gitgutter'})


    -- UI Plugins
    use('glepnir/dashboard-nvim')
    use({
        'glepnir/galaxyline.nvim',
        branch = 'main',
        -- your statusline
        -- config = function() require 'my_statusline' end,
        -- some optional icons
        requires = {'kyazdani42/nvim-web-devicons', opt = true}
    })

    --[[ use({
      'herbermqh/spaceline.vim',
      config = function()
        vim.g.spaceline_seperate_style = "curve"
      end,
      requires = {'kyazdani42/nvim-web-devicons', opt = true}
    }) ]]
    use({'ryanoasis/vim-devicons'})
    use('p00f/nvim-ts-rainbow')
    -- use('akinsho/nvim-bufferline.lua')
    -- use('powerline/fonts')
    use {
      'romgrk/barbar.nvim',
      requires = {'kyazdani42/nvim-web-devicons'}
    }

    -- Themes
    use({'marko-cerovac/material.nvim', opt = false, as = 'material'})
    use({'morhetz/gruvbox'})
    use({'shinchu/lightline-gruvbox.vim'})
    use({'romgrk/doom-one.vim'})
    use({'shaunsingh/moonlight.nvim'})
    use({'folke/tokyonight.nvim'})
    use({'navarasu/onedark.nvim'})
    use({'sainnhe/edge'})
    use({'sonph/onehalf'})
    use({'arcticicestudio/nord-vim'})
    use({'dylanaraps/wal'})

    -- IDE
    use({'frazrepo/vim-rainbow'})
    use({'luochen1990/rainbow'})
    use({'micha/vim-colors-solarized'})
    use({'mg979/vim-visual-multi'})
    use({'arzg/vim-colors-xcode'})
    use({'Yggdroot/indentLine'})
    use({'windwp/nvim-autopairs'})
    use({'tpope/vim-sensible'})
    use({'tpope/vim-unimpaired'})
    use({'tpope/vim-obsession'})

    -- others
    use({'voldikss/vim-floaterm'})
    use({'liuchengxu/vim-which-key'})
    use({'liuchengxu/vim-clap'})
    use({'christianchiarulli/nvcode-color-schemes.vim'})

    -- Ocasional Plugins
    use({'kdheepak/lazygit.nvim', opt = true})

    use({
        'lukas-reineke/indent-blankline.nvim',
        opt = true,
        config = function()
            require('indent_blankline').setup({
                char = '|',
                buftype_exclude = {'terminal', 'dashboard'}
            })
        end
    })

    use({'Pocco81/TrueZen.nvim', opt = true})

    use({
        'pwntester/octo.nvim',
        opt = true,
        config = function() require('octo').setup() end
    })
end)
