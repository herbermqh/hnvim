" Función para ir a directorio actual del archivo
function! Get_dir()
    return expand('%:p:h')
endfunction

" Comando que ejecuta el siguiente proceso:
" - entrar modo normal
" - Ir al directorio actual del archivo y dentro de ese directorio ejecutar "latexmk -c".
" - mostrar mensaje "Cleaned log files"
command! LatexmkCleanLogFiles call system("cd " . Get_dir() . " && latexmk -c") | echo "Cleaned log files"
