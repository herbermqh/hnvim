-- Mapping helper
local mapper = function(mode, key, result)
  vim.api.nvim_set_keymap(mode, key, result, { noremap = true, silent = true, expr = false })
end

local expressive_mapper = function(mode, key, result)
  vim.api.nvim_set_keymap(mode, key, result, { silent = true, expr = true })
end

-- Default Mapping helper
local plug_mapper = function(mode, key, result)
  vim.api.nvim_set_keymap(mode, key, result, {})
end

-- Define Mapleader
vim.g.mapleader = ' '

-- save document
plug_mapper('n', '<C-s>', ':w!<CR>')
plug_mapper('i', '<C-s>', '<Esc>:w!<CR>a')

-- exit neovim
mapper('n', 'q', ':x! <CR>')
mapper('n', 'Q', ':q! <CR>')

-- Nice
-- mapper('n', 'ZE', ':qa!<CR>')

-- mayuscula y minuscula la primera letra
mapper('n', 'A-U', 'gewvgUwb')
mapper('n', 'A-u', 'gewvguwb')

-- Duplitcate Line
mapper('n', 'tt', ':t.<CR>$')

--  Toggle Numbers
mapper('n', '<leader>n', ':set nu! rnu!<CR>')

-- use ESC to turn off search highlighting
-- mapper('n', '<Esc>', ':noh<CR>')

-- Get out of the Terminal
-- mapper('t', '<Esc>', '<C-\\><C-n>')

-- Copy to OS clipboard.
mapper('v', 'y', '"+y')
mapper('n', 'yy', '"+yy')

-- delete line to Os clipboard
mapper('v', 'd', '"+d')
mapper('n', 'dd', '"+dd')

-- Paste from OS clipboard
mapper('n', 'p', '"+p')
-- mapper('n', '<Leader>P', '"+P')
mapper('v', 'p', '"+p')
-- mapper('v', '<Leader>P', '"+P"`"`"')
mapper('n', 'J', 'mzJ`z')

-- buffers
mapper('n', '<C-Right>', ':BufferNext<CR>')
mapper('n', '<C-l>', ':BufferNext<CR>')
mapper('n', '<C-Left>', ':BufferPrevious<CR>')
mapper('n', '<C-h', ':BufferPrevious<CR>')

-- start inkscape
vim.cmd([[
  inoremap <A-f> <Esc>:silent exec '.!python -m illustrator-figures crear-editar "'.getline('.').'"' @%<CR><CR>:w<CR>
  nnoremap <A-f> <Esc>:silent exec '.!python -m illustrator-figures crear-editar "'.getline('.').'"' @%<CR><CR>:w<CR>
]])
  -- nnoremap <A-f> <Esc>:silent exec '.!python -m illustrator-figures crear-editar "'.getline('.').'" "'.b:vimtex.tex.'"'<CR><CR>:w<CR>
  -- inoremap <A-f> <Esc>:silent exec '.!python -m illustrator-figures crear-editar "'.getline('.').'" "'.b:vimtex.tex.'"'<CR><CR>:w<CR>
  -- nnoremap <A-fgh> : silent exec '!inkscape-figures edit "'.b:vimtex.tex.'/figures/" > /dev/null 2>&1 &'<CR><CR>:redraw!<CR>

-- identation latex
  -- inoremap <C-A-l> <Esc>:w<CR>:silent execute '!latexindent -w '.b:vimtex.tex.''<CR>i
  -- nnoremap <C-A-l> :w<CR>:silent execute '!latexindent -w '.b:vimtex.tex.''<CR>
vim.cmd([[
  inoremap <C-A-l> <Esc>:w<CR>:silent execute '!latexindent -w '@%<CR>:e<CR>i
  nnoremap <C-A-l> :w<CR>:silent execute '!latexindent -w '@%<CR>:e<CR>
]])

-- Plugins Mappings ↓
-- vim latex
mapper('n', '<F8>', ']sz=') -- error ortorgrafico

-- Telescope
-- mapper('n', '<C-F>', ':Telescope live_grep<CR>')
-- mapper('n', '<C-P>', ':Telescope find_files<CR>')

-- Tree
-- mapper('n', '<C-n>', ':NvimTreeToggle<CR>')

-- Hop.nvim
-- mapper('n', '<Leader>f', ':HopWord<CR>')
-- mapper('n', '<Leader>o', ':HopPattern<CR>')

-- LazyGIT
-- mapper('n', '<Leader>gg', ':LazyGit<CR>')

-- Switch Theme
mapper('n', '<leader>mm', [[<Cmd>lua require('material.functions').toggle_style()<CR>]])

-- Coc.nvim
mapper('n', '<F12>', ':CocCommand terminal.Toggle<CR>')
mapper('n', '<F5>', ':Format<CR>')

-- plug_mapper('n', '<leader>rn', '<Plug>(coc-rename)')

--[[ plug_mapper('n', 'gd', '<Plug>(coc-definition)')
plug_mapper('n', 'gr', '<Plug>(coc-references)')

plug_mapper('n', '<leader>ca', '<Plug>(coc-codeaction)')
plug_mapper('n', '<leader>ga', '<Plug>(coc-codeaction-cursor)')
plug_mapper('x', '<leader>ga', '<Plug>(coc-codeaction-selected)')
plug_mapper('n', '<leader>kf', '<Plug>(coc-fix-current)')
 ]]
-- plug_mapper('n', '<Right>', '<Plug>(coc-diagnostic-prev)')
-- plug_mapper('n', '<Left>', '<Plug>(coc-diagnostic-next)')

-- expressive_mapper('i', '<C-space>', 'coc#refresh()')

-- TODO: Pass to Lua
vim.cmd([[
nnoremap <silent> <M-Up>    :<C-U>exec "exec 'norm m`' \| move -" . (1+v:count1)<CR>``
nnoremap <silent> <M-Down>  :<C-U>exec "exec 'norm m`' \| move +" . (0+v:count1)<CR>``

vnoremap <silent> <M-Up>    :<C-U>exec "'<,'>move '<-" . (1+v:count1)<CR>gv
vnoremap <silent> <M-Down>  :<C-U>exec "'<,'>move '>+" . (0+v:count1)<CR>gv

nnoremap  <silent> <tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bnext<CR>
nnoremap  <silent> <s-tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bprevious<CR>
]])
