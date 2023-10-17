" -- Buffers
nnoremap <C-Right> :BufferNext<CR>
nnoremap <C-l> :BufferNext<CR>
nnoremap <C-Left> :BufferPrevious<CR>
nnoremap <C-h> :BufferPrevious<CR>

inoremap <A-g> <Esc>:silent execute '!python -m pdf2img convert %:p'<CR><CR>:w<CR>
nnoremap <A-g> <Esc>:silent execute '!python -m pdf2img convert %:p'<CR><CR>:w<CR>
" -- start inkscape
inoremap <A-f> <Esc>:silent execute '!python -m illustrator-figures crear-editar "'.getline('.').'"' '%:p'<CR><CR>:w<CR>
nnoremap <A-f> <Esc>:silent execute '!python -m illustrator-figures crear-editar "'.getline('.').'"' '%:p'<CR><CR>:w<CR>
" -- NOTA: el comando @% (imprime directorio actual) no funciona de manera correcta con telescope por lo que se reemplza por '%:p'
"   -- nnoremap <A-f> <Esc>:silent exec '.!python -m illustrator-figures crear-editar "'.getline('.').'" "'.b:vimtex.tex.'"'<CR><CR>:w<CR>
"   -- inoremap <A-f> <Esc>:silent exec '.!python -m illustrator-figures crear-editar "'.getline('.').'" "'.b:vimtex.tex.'"'<CR><CR>:w<CR>
"   -- nnoremap <A-fgh> : silent exec '!inkscape-figures edit "'.b:vimtex.tex.'/figures/" > /dev/null 2>&1 &'<CR><CR>:redraw!<CR>

" -- identation latex
"   -- inoremap <C-A-l> <Esc>:w<CR>:silent execute '!latexindent -w '.b:vimtex.tex.''<CR>i
"   -- nnoremap <C-A-l> :w<CR>:silent execute '!latexindent -w '.b:vimtex.tex.''<CR>
inoremap <C-A-l> <Esc>:w<CR>:silent exec '!latexindent -w' '%:p'<CR>:e<CR>i
nnoremap <C-A-l> :w<CR>:silent exec '!latexindent -w' '%:p'<CR>:e<CR>

" -- create files latex
nnoremap <A-c> <Esc>:silent exec '.!python -m gestor-archivos-latex create "'.getline('.').'"' '%:p:h'<CR><CR>:w<CR>
nnoremap <A-e> <Esc>:silent exec '!python -m gestor-archivos-latex edit "'.getline('.').'"' '%:p:h'<CR><CR>:w<CR>

" -- preabulo precompilador
nnoremap <A-m> :w<Esc>:execute '!python -m gestor-archivos-latex compilepreamble ' '%:p'<CR>





