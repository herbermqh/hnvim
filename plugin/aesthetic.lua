-- Print the line number in front of each line
vim.wo.number = true
vim.o.number = true

-- Show the line number relative to the line with the cursor in front of each line
vim.wo.relativenumber = true
vim.o.relativenumber = true

-- Lines longer than the width of the window will wrap and displaying continues on the next line
vim.wo.wrap = false
vim.o.wrap = false

-- But don't break words, only 'by words'
vim.wo.linebreak = true

-- Will put the new window below the currentone
vim.o.splitbelow = true

-- Will put the new window right of the current one
vim.o.splitright = true

-- Enables 24-bit RGB color in TUI
vim.o.termguicolors = true

-- Dark Background
-- vim.o.background = 'dark'

-- Use Emoji
vim.o.emoji = true

-- Highlight the screen line of the cursor with CursorLine
vim.wo.cursorline = true
vim.wo.cursorcolumn = false


-- colorscheme
vim.cmd('colorscheme material')
vim.cmd[[lua require('material.functions').change_style("darker")]]
vim.cmd[[
  augroup vim-colors-xcode
    autocmd!
  augroup END
  autocmd vim-colors-xcode ColorScheme * hi Comment        cterm=italic gui=italic
  autocmd vim-colors-xcode ColorScheme * hi SpecialComment cterm=italic gui=italic
  if !has('nvim')
    let &t_ZH="\e[3m"
    let &t_ZR="\e[23m"
  endif
]]
--lightline
vim.cmd('set noshowmode')

-- others
vim.cmd('set encoding=utf8')
