let g:vimtex_view_general_viewer = 'zathura'
let g:vimtex_view_general_options = '--unique @pdf\#src:@line@tex'
" let g:vimtex_view_general_options_latexmk = '--unique'
let g:vimtex_compiler_progname = 'nvr'
let g:vimtex_compiler_latexmk = {
      \ 'backend' : 'nvim',
      \ 'background' : 1,
      \ 'callback' : 1,
      \ 'continuous' : 0,
      \ 'executable' : 'latexmk',
      \ 'hooks' : [],
      \ 'options' : [
      \   '-verbose',
      \   '--shell-escape',
      \   '-enable-write18',
      \   '-verbose',
      \   '-file-line-error',
      \   '-synctex=1',
      \   '-interaction=nonstopmode',
      \ ],
      \}

let g:vimtex_compiler_latexmk_engines = {
        \ '_'                : '-xelatex',
        \ 'pdflatex'         : '-pdf',
        \ 'dvipdfex'         : '-pdfdvi',
        \ 'lualatex'         : '-lualatex',
        \ 'xelatex-dev -synctex=1 -interaction=nonstopmode --enable-write18 --shell-escape %O %S' : '-xelatex',
        \ 'context (pdftex)' : '-pdf -pdflatex=texexec',
        \ 'context (luatex)' : '-pdf -pdflatex=context',
        \ 'context (xetex)'  : '-pdf -pdflatex=''texexec --xtx''',
        \}


if has('win32')
  let g:vimtex_view_general_viewer = 'SumatraPDF.exe'
  let g:vimtex_view_general_options
        \ = '-reuse-instance -forward-search @tex @line @pdf'
  " let g:vimtex_view_general_options_latexmk = '-reuse-instance'
else
  " let g:xwindow_id = system('xdotool getactivewindow') 
  let g:vimtex_view_method = 'zathura'
  " let g:vimtex_view_zathura_hook_view = 'MyHook'
  " let g:vimtex_view_zathura_hook_callback = 'MyHook'
  " function! MyHook()
  "   silent call system('xdotool windowactivate ' . g:xwindow_id . ' --sync')
  " endfunction
endif


let g:vimtex_quickfix_open_on_warning = 0
let g:vimtex_syntax_enabled = 1
let g:vimtex_fold_enabled=1
let g:vimtex_imaps_enabled=0
let g:vimtex_mappings_enabled=0
let g:vimtex_syntax_conceal_disable=1


let g:vimtex_indent_enabled=0
 

let g:tex_superscripts= "[0-9a-zA-W.,:;+-<>/()=]"
let g:tex_subscripts= "[0-9aehijklmnoprstuvx,+-/().]"
let g:tex_conceal_frac=1
set conceallevel=2
let g:tex_conceal="abdgm"



