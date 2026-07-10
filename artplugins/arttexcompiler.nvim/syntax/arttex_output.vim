if exists("b:current_syntax")
  finish
endif

" === TITULOS Y SISTEMA ===
syntax match ArtTexHeader "^===\sIniciando Compilación.*"
syntax match ArtTexSeparator "^================================================$"
syntax match ArtTexCommand "^\$\s.*"
syntax match ArtTexSuccess "^===\sCompilación Finalizada con Éxito\s==="
syntax match ArtTexFailure "^===\sFalló la compilación.*"
syntax match ArtTexAbort "^===\sPROCESO ABORTADO POR EL USUARIO\s==="

" === ERRORES Y ADVERTENCIAS (TEX) ===
syntax match ArtTexError "^!.*"
syntax match ArtTexError ".*Error:.*"
syntax match ArtTexError ".*Fatal error.*"
syntax match ArtTexWarning ".*Warning:.*"
syntax match ArtTexWarning ".*Warning.*"
syntax match ArtTexOverfull ".*Overfull.*"
syntax match ArtTexUnderfull ".*Underfull.*"
syntax match ArtTexLine "^l\.\d\+.*"

" === ELEMENTOS DEL LENGUAJE LATEX EN EL LOG ===
syntax match ArtTexMacro "\\\w\+"
syntax match ArtTexFile "(\/[^ )]*\.\w\+)"
syntax match ArtTexFile "(\.\/[^ )]*\.\w\+)"
syntax match ArtTexFile "\/[^ ]*\.\w\+"
syntax match ArtTexPackage "Package: \w\+"
syntax match ArtTexClass "Document Class: \w\+"
syntax match ArtTexPage "\[\d\+\]"
syntax match ArtTexDimension "\d\+\.\d\+pt"
syntax match ArtTexDimension "\d\+pt"
syntax match ArtTexDimension "\d\+mm"
syntax match ArtTexDimension "\d\+cm"

" === MENSAJES DE LATEXMK ===
syntax match ArtTexLatexmk "^Latexmk:.*"
syntax match ArtTexRule "^Rule '.*':"
syntax match ArtTexRun "^Run number \d\+ of rule.*"

" ===================================================================
" ENLACES A GRUPOS DE COLOR MODERNOS DE NEOVIM
" ===================================================================

" Sistema
highlight default link ArtTexHeader DiagnosticInfo
highlight default link ArtTexSeparator Comment
highlight default link ArtTexCommand Function
highlight default link ArtTexSuccess DiagnosticOk
highlight default link ArtTexFailure DiagnosticError
highlight default link ArtTexAbort DiagnosticWarn

" Errores y Advertencias (Forzados a destacar)
highlight default link ArtTexError Error
highlight default link ArtTexWarning WarningMsg
highlight default link ArtTexOverfull WarningMsg
highlight default link ArtTexUnderfull WarningMsg
highlight default link ArtTexLine Number

" Sintaxis TeX dentro del Log
highlight default link ArtTexMacro Statement
highlight default link ArtTexFile String
highlight default link ArtTexPackage Type
highlight default link ArtTexClass Type
highlight default link ArtTexPage Constant
highlight default link ArtTexDimension Number

" Orquestador (Latexmk)
highlight default link ArtTexLatexmk Keyword
highlight default link ArtTexRule Special
highlight default link ArtTexRun Special


let b:current_syntax = "arttex_output"
