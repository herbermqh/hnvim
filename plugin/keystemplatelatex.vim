" autoload myconfig
nnoremap conf :source ~/.config/nvim/plugin/myconfig.vim<cr>

function! Construct_directory_chapterfile(namechapter,typearchive)
  let _file = expand('%:p:h') . '/' . a:namechapter . '/' . a:typearchive . '-' . a:namechapter . '.tex'
  return _file
endfunction

function! Setvardirectoryarchive(namechapter,typearchive)
  let pathchapterteoria = Construct_directory_chapterfile(a:namechapter,a:typearchive)
  let pathchapterpr = Construct_directory_chapterfile(a:namechapter, a:typearchive)
  let pathchapterpp = Construct_directory_chapterfile(a:namechapter, a:typearchive)
  let pathchapterformulario = Construct_directory_chapterfile(a:namechapter, a:typearchive)
  let dictdirectory = {
        \ 'TEORIA': pathchapterteoria,
        \ 'PR': pathchapterpr,
        \ 'PP': pathchapterpp,
        \ 'FORMULARIO': pathchapterformulario
        \}
  return dictdirectory[a:typearchive]
endfunction

function! Get_arguments_usarproblema(line_text)
  let name_book =  a:line_text[match(a:line_text, '{')+1:match(a:line_text, '}')-1]
  let name_chapter =  a:line_text[match(a:line_text, '{', match(a:line_text, '{')+1)+1:match(a:line_text, '}', match(a:line_text, '}')+1)-1]
  let name_exercise =  a:line_text[match(a:line_text, '{', match(a:line_text, '{', match(a:line_text, '{')+1)+1)+1:match(a:line_text, '}', match(a:line_text, '}', match(a:line_text, '}')+1)+1)-1]
  let _dict_arguments_usarproblem = {
        \ 'name_book': name_book,
        \ 'name_chapter': name_chapter,
        \ 'name_exercise': name_exercise
        \}
  return _dict_arguments_usarproblem
endfunction

function! Construct_directory_usarproblem(name_book,name_chapter)
  " ir al directorio superior dos veces y luego ir al directorio problems-book/name_book/a:name_chapter.tex
  let _file = expand('%:p:h:h:h') . '/problems-book/' . a:name_book . '/' . a:name_chapter . '.tex'
  return _file
endfunction

function! Construct_directory_usarexamen(line_text)
" guardar la cadena de la primera llave en un variable \usarexamen{UMSA-FIS-1-2008-II-C-cpf}{2}
  let name_examen = a:line_text[match(a:line_text, '{')+1:match(a:line_text, '}')-1]
  let name_problem = a:line_text[match(a:line_text, '{', match(a:line_text, '{')+1)+1:match(a:line_text, '}', match(a:line_text, '}')+1)-1]
  let name_examen_list = split(name_examen, '-')
  let university = name_examen_list[0]
  let subject = name_examen_list[1]
  let partial = name_examen_list[2]
  let year = name_examen_list[3]
  let semester = name_examen_list[4]
  let row = name_examen_list[5]
  let other = name_examen_list[6]
  " Construir nombre del directorio padre del examan de acuerdo a las variables university, subject, partial, year, semester, row, other, y establecer en variable name_parent_exam
  if partial ==# ""
    let name_parent_exam = university . '_' . subject . '_' . semester . '_' . other
  else
    let name_parent_exam = university . '_' . subject . '_' . partial . '_' . semester . '_' . other
  endif
  " Construir nombre del examen y establecer en variable name_exam_internal de acuerdo a las variables university, subject, partial, year, semester, row, other
  if partial ==# ""
    let name_exam_internal = university . '_' . subject . '_' . year . semester . '_' . row . '_' . other
  else
    let name_exam_internal = university . '_' . subject . '_' . partial . '_' . year . semester . '_' . row . '_' . other
  endif
  " ir tres veces al directorio superior y luego ir al directorio problems-exam/name_parent_exam
  let _file = expand('%:p:h:h:h') . '/problems-exam/' . name_parent_exam . '/' . name_exam_internal . '/EJERCICIOS.tex'
  return {
        \ 'name_problem': name_problem,
        \ 'file': _file
        \}
endfunction

function! Get_arguments_usarpractica(line_text)
  let name_practice = a:line_text[match(a:line_text, '{')+1:match(a:line_text, '}')-1]
  let name_exercise = a:line_text[match(a:line_text, '{', match(a:line_text, '{')+1)+1:match(a:line_text, '}', match(a:line_text, '}')+1)-1]
  let _dict_arguments_usarpractica = {
        \ 'name_practice': name_practice,
        \ 'name_exercise': name_exercise
        \}
  return _dict_arguments_usarpractica
endfunction

function! Construct_directory_usarpractica(name_practice)
  let _file = expand('%:p:h:h:h') . '/problems-practice/' . a:name_practice . '/EJERCICIOS.tex'
  return _file
endfunction

function! Xsearch(wordsearch)
  let @/='\\newproblem{' . a:wordsearch . '}'
endfunction

function! Openfile_search_word(file,word)
  execute "find" a:file
  call Xsearch(a:word)
  execute "normal! zRn"
endfunction

function! Getline(typearchive)
  let linetext = getline('.')
  let namecommand = linetext[match(linetext, '\\')+1:match(linetext, '{')-1]
  if namecommand ==? "chapterfile"
    let namechapter = linetext[match(linetext, '{')+1:match(linetext, '}')-1]
    let _directory= Setvardirectoryarchive(namechapter,a:typearchive)
    execute "find" _directory
  elseif namecommand ==? "usarproblema"
    let name_book = Get_arguments_usarproblema(linetext).name_book
    let name_chapter = Get_arguments_usarproblema(linetext).name_chapter
    let name_exercise = Get_arguments_usarproblema(linetext).name_exercise
    let _directory = Construct_directory_usarproblem(name_book,name_chapter)
    call Openfile_search_word(_directory,name_exercise)
  elseif namecommand ==? "usarexamen"
    let _directory = Construct_directory_usarexamen(linetext).file
    let name_exercise = Construct_directory_usarexamen(linetext).name_problem
    call Openfile_search_word(_directory,name_exercise)
  elseif namecommand ==? "usarpractica"
    let name_practice = Get_arguments_usarpractica(linetext).name_practice
    let name_exercise = Get_arguments_usarpractica(linetext).name_exercise
    let _directory = Construct_directory_usarpractica(name_practice)
    call Openfile_search_word(_directory,name_exercise)
  endif
endfunction

nnoremap lp :call Getline("PP")<cr>
nnoremap ld :call Getline("TEORIA")<cr>
nnoremap lr :call Getline("PR")<cr>
nnoremap lf :call Getline("FORMULARIO")<cr>
