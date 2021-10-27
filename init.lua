vim.cmd[[
function! ConfigStatusLine()
  lua require('plugins.status-line')
endfunction
augroup status_line_init
  autocmd!
  autocmd VimEnter * call ConfigStatusLine()
  augroup END


"set t_Co=256

"habilita transparencia
" set t_8f=\[[38;2;%lu;%lu;%lum 
" set t_8b=\[[48;2;%lu;%lu;%lum

" set termguicolors
""color desert
" hi! Normal ctermbg=NONE guibg=NONE
" hi Normal ctermbg=NONE guibg=000000
" hi! NonText ctermbg=NONE guibg=NONE

"color tabs
" hi tablinefill ctermfg=lightgreen ctermbg=darkgreen
" hi TabLine ctermfg=Blue ctermbg=Yellow
" hi TabLineSel ctermfg=Red ctermbg=Yellow
" hi Title ctermfg=LightBlue ctermbg=Magenta
]]
