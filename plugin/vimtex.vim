"------------------------------------USAGE
"OPTIONS
let g:vimtex_enabled = 1
let g:vimtex_compiler_enable = 1
let g:vimtex_compiler_method = 'latexmk'
let g:vimtex_compiler_latexmk = {
        \ 'out_dir' : 'build',
        \}
" let g:vimtex_compiler_latexmk_engines = {
"         \ '_'                : 'hlatex',
"         \ 'pdflatex'       : 'hlatex',
"         \}
"note: no está definido latexmk_engines por que en el arhicov .latexmkrc se
"define $pdf_mode=5; 5 para xelatex, 4 para lualatex y 0 para pdflatex.
let g:vimtex_delim_list = {
        \ 'delim_tex' : {
        \   'name' : [
        \     ['[', ']'],
        \     ['{', '}'],
        \     ['\glq', '\grq'],
        \     ['\glqq', '\grqq'],
        \     ['\flq', '\frq'],
        \     ['\flqq', '\frqq'],
        \    ]
        \  }
        \}
let g:vimtex_imaps_enabled=0
let g:vimtex_include_indicators=['input','include','subfile','includeonly', 'chapterfile']
let g:vimtex_include_search_enabled=1
let g:vimtex_quickfix_mode=1
let g:vimtex_quickfix_autoclose_after_keystrokes=0
let g:vimtex_quickfix_open_on_warning=0
let g:vimtex_syntax_enabled=1
let g:vimtex_syntax_conceal_disable=0
let g:vimtex_syntax_custom_cmds = [
      \ {'name': 'unit', 'mathmode': 1, 'conceal': 1, 'concealchar': ''},
      \ {'name': 'vect', 'mathmode': 1, 'argstyle': 'bold', 'conceal': 1},
      \ {'name': 'vec', 'mathmode': 1, 'argstyle': 'bold', 'conceal': 1},
      \ {'name': 'mat' , 'mathmode': 1, 'argstyle': 'bold', 'conceal': 1},
      \ {'name': 'bm'  , 'mathmode': 1, 'argstyle': 'bold', 'conceal': 1},
      \ {'name': 'pmb' , 'mathmode': 1, 'argstyle': 'bold', 'conceal': 1},
      \ {'name': 'textbf', 'mathmode': 0, 'argstyle': 'bold', 'conceal': 1},
      \ {'name': 'keyw', 'mathmode': 0, 'argstyle': 'boldital' , 'conceal': 1},
      \ {'name': 'Prob'    , 'mathmode': 1, 'concealchar': 'ℙ'},
      \ {'name': 'ce'    , 'mathmode': 1, 'concealchar': ''},
      \ {'name': 'ce'    , 'mathmode': 0, 'concealchar': ''},
      \ {'name': 'limits'  , 'mathmode': 1, 'concealchar': ''},
      \ {'name': 'Expect'  , 'mathmode': 1, 'concealchar': '𝔼'},
      \ {'name': 'Var'     , 'mathmode': 1, 'concealchar': '𝕍'},
      \ {'name': 'pdf'     , 'mathmode': 1, 'concealchar': '𝕡'},
      \ {'name': 'qdf'     , 'mathmode': 1, 'concealchar': '𝕢'},
      \ {'name': 'NormDist', 'mathmode': 1, 'concealchar': '𝒩'},
      \ {'name': 'Reals'   , 'mathmode': 1, 'concealchar': 'ℝ'},
      \ {'name': 'Imags'   , 'mathmode': 1, 'concealchar': '𝕀'},
      \ {'name': 'Naturals', 'mathmode': 1, 'concealchar': 'ℕ'},
      \ {'name': 'Integers', 'mathmode': 1, 'concealchar': 'ℤ'},
      \ {'name': 'ones'    , 'mathmode': 1, 'concealchar': '𝟙'},
      \ {'name': 'bigO'    , 'mathmode': 1, 'concealchar': '𝒪'},
      \]
let g:vimtex_fold_enabled=1
let g:vimtex_toc_enabled=1
let g:vimtex_mappings_enabled=1
let g:vimtex_indent_enabled=1
"------------------------------------COMPLETION
"------------------------------------FOLDING
"------------------------------------IDENTATION
"------------------------------------SYNTAX HIGHLIGHTING
"SYNTAX CONCEAL
let g:tex_superscripts= "[0-9a-zA-W.,:;+-<>/()=]"
let g:tex_subscripts= "[0-9aehijklmnoprstuvx,+-/().]"
let g:tex_conceal_frac=1
set conceallevel=2
let g:tex_conceal="abdgm"
hi Conceal guifg=white
"SYNTAC CORE ESPECIFICATION
"------------------------------------NAVIGATION
"INCLUDE EXPRESSION
"TABLE OF CONTENTS
"FZF INTEGRATION
nnoremap <localleader>lt :call vimtex#fzf#run()<cr>"
"------------------------------------COMPILATION
"------------------------------------SYNTAX CHECKING
"------------------------------------GRAMMAR CHECKING
"------------------------------------VIEW
"VIEWER CONFIGURATION
" if has('win32')
"   " let g:vimtex_view_general_viewer='okular'
"   " let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
" else
"   let g:xwindow_id = system('xdotool getactivewindow') 
"   " let g:vimtex_view_method = 'SumatraPDF.exe'
"   " function! ZathuraHook() dict abort
"   " if self.xwin_id <= 0 | return | endif
"   " silent call system('xdotool windowactivate ' . self.xwin_id . ' --sync')
"   " silent call system('xdotool windowraise ' . self.xwin_id)
"   " endfunction
"   " let g:vimtex_view_zathura_hook_view = 'MyHook'
"   " let g:vimtex_view_zathura_hook_callback = 'MyHook'
"   " function! MyHook()
"   "   silent call system('xdotool windowactivate ' . g:xwindow_id . ' --sync')
"   " endfunction
" endif
"
if has('win32') || (has('unix') && exists('$WSLENV'))
  let g:vimtex_view_general_viewer = 'SumatraPDF.exe'
  let g:vimtex_view_general_options = '-reuse-instance -forward-search @tex @line @pdf'
else
  " let g:vimtex_view_general_viewer = 'zathura'
  " let g:vimtex_view_general_viewer = 'SumatraPDF.exe'
  " let g:vimtex_view_general_options
  "   \ = '-reuse-instance -forward-search @tex @line @pdf'
endif

"------------------------------------DOCUMENTATION
"------------------------------------CONTEXT MENU
"------------------------------------API
let g:vimtex_syntax_custom_envs = [
          \ {
          \   'name': 'empheq',
          \   'math': v:true
          \ },
          \ {
          \   'name': 'answer',
          \   'math': v:true
          \ },
          \ {
          \   'name': 'formula',
          \   'math': v:true
          \ },
          \ {
          \   'name': 'python_code',
          \   'region': 'texPythonCodeZone',
          \   'nested': 'python',
          \ },
          \ {
          \   'name': 'codetexcommentlong',
          \   'region': 'texCodeZone',
          \   'nested': {
          \     'python': 'language=python',
          \     'c': 'language=C',
          \     'rust': 'language=rust',
          \   },
          \ },
          \]
let g:vimtex_syntax_nested = {
          \ 'aliases' : {
          \   'C' : 'c',
          \   'csharp' : 'cs',
          \ },
          \ 'ignored' : {
          \   'sh' : ['shSpecial'],
          \   'bash' : ['shSpecial'],
          \   'cs' : [
          \     'csBraces',
          \   ],
          \   'python' : [
          \     'pythonEscape',
          \     'pythonBEscape',
          \     'pythonBytesEscape',
          \   ],
          \   'java' : [
          \     'javaError',
          \   ],
          \   'haskell' : [
          \     'hsVarSym',
          \   ],
          \ }
          \}
