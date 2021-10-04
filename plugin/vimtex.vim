let g:vimtex_view_general_viewer = 'zathura'
let g:vimtex_view_general_options = '--unique @pdf\#src:@line@tex'
let g:vimtex_view_general_options_latexmk = '--unique'
let g:vimtex_compiler_progname = 'nvr'
let g:vimtex_compiler_latexmk = {
      \ 'backend' : 'nvim',
      \ 'background' : 1,
      \ 'callback' : 1,
      \ 'continuous' : 1,
      \ 'executable' : 'latexmk',
      \ 'options' : [
      \   '-shell-escape',
      \   '-pdf',
      \   '-enable-write18',
      \   '-verbose',
      \   '-file-line-error',
      \   '-synctex=1',
      \   '-interaction=nonstopmode',
      \ ],
      \}

let g:vimtex_syntax_enabled = 1
let g:vimtex_quickfix_open_on_warning = 0
       " let g:xwindow_id = system('xdotool getactivewindow')
let g:vimtex_view_method = 'zathura'
" let g:vimtex_view_zathura_hook_view = 'MyHook'
" let g:vimtex_view_zathura_hook_callback = 'MyHook'
" function! MyHook()
" silent call system('xdotool windowactivate ' . g:xwindow_id . ' --sync')
" endfunction
let g:vimtex_fold_enabled=1

let g:vimtex_syntax_conceal_default = 0
