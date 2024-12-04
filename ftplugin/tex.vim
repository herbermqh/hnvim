" MAPPINGS
" text bfseries
xmap bf S}<Esc>a\bfseries 
" text itshape
xmap it S}<Esc>a\itshape 


" crear un xmap  que al presionar ans cuando esté seleccionado "a-z+-\;[]^_$" con todo tipo de caracteres reemplace por \answerinline{a-z+-\;[]^_$}
" xmap ans <Esc>`>a}<Esc>`<i\answerinline{<Esc>

xmap a y:let @z=@"<CR>gvc\answerinline{<C-R>z}<Esc>
xmap t y:let @z=@"<CR>gvc\mintinline{tex}{<C-R>z}<Esc>
