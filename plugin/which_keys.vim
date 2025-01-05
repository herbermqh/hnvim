"set notimeout
  let g:mapleader = "\<Space>"
  nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
  nnoremap <silent> <localleader> :<c-u>WhichKey  '<Space>'<CR>
  " vnoremap <silent> <leader> :silent <c-u> :silent WhichKeyVisual '<Space>'<CR>

  " Create map to add keys to
  let g:which_key_map =  {}
  " Define a separator
  let g:which_key_sep = '→'
  set timeoutlen=300


  " Not a fan of floating windows for this
  let g:which_key_use_floating_win = 0

  " Change the colors if you want
  highlight default link WhichKey          Operator
  highlight default link WhichKeySeperator DiffAdded
  highlight default link WhichKeyGroup     Identifier
  highlight default link WhichKeyDesc      Function

  " Hide status line
  autocmd! FileType which_key
  autocmd  FileType which_key set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler

  " Single mappings
  let g:which_key_map['/'] = [ '<Plug>NERDCommenterToggle'  , 'comment' ]
  let g:which_key_map['e'] = [ ':NvimTreeToggle'       , 'explorer' ]
  let g:which_key_map['f'] = [ ':Telescope find_files'                     , 'search files' ]
  let g:which_key_map['h'] = [ '<C-W>s'                     , 'split below']
  " let g:which_key_map['r'] = [ ':Ranger'                    , 'ranger' ]
  let g:which_key_map['S'] = [ ':Startify'                  , 'start screen' ]
  let g:which_key_map['T'] = [ ':Rg'                        , 'search text' ]
  let g:which_key_map['v'] = [ '<C-W>v'                     , 'split right']
  let g:which_key_map['z'] = [ 'Goyo'                       , 'zen' ]

  " s is for search
  let g:which_key_map.s = {
        \ 'name' : '+search' ,
        \ '/' : [':History/'     , 'history'],
        \ ';' : [':Commands'     , 'commands'],
        \ 'a' : [':Ag'           , 'text Ag'],
        \ 'b' : [':BLines'       , 'current buffer'],
        \ 'B' : [':Telescope buffers'      , 'open buffers'],
        \ 'c' : [':Commits'      , 'commits'],
        \ 'C' : [':BCommits'     , 'buffer commits'],
        \ 'f' : [':Files'        , 'files'],
        \ 'g' : [':GFiles'       , 'git files'],
        \ 'G' : [':GFiles?'      , 'modified git files'],
        \ 'h' : [':History'      , 'file history'],
        \ 'H' : [':History:'     , 'command history'],
        \ 'l' : [':Lines'        , 'lines'] ,
        \ 'm' : [':Marks'        , 'marks'] ,
        \ 'M' : [':Maps'         , 'normal maps'] ,
        \ 'p' : [':Helptags'     , 'help tags'] ,
        \ 'P' : [':Tags'         , 'project tags'],
        \ 's' : [':Snippets'     , 'snippets'],
        \ 'S' : [':Colors'       , 'color schemes'],
        \ 't' : [':Rg'           , 'text Rg'],
        \ 'T' : [':BTags'        , 'buffer tags'],
        \ 'w' : [':Windows'      , 'search windows'],
        \ 'y' : [':Filetypes'    , 'file types'],
        \ 'z' : [':FZF'          , 'FZF'],
        \ }
  let g:which_key_map.t = {
        \ 'name' : '+terminal' ,
        \ ';' : [':FloatermNew --wintype=popup --height=6'        , 'terminal'],
        \ 'f' : [':FloatermNew fzf'                               , 'fzf'],
        \ 'g' : [':FloatermNew lazygit'                           , 'git'],
   \ 'd' : [':FloatermNew lazydocker'                        , 'docker'],
        \ 'n' : [':FloatermNew node'                              , 'node'],
        \ 'N' : [':FloatermNew nnn'                               , 'nnn'],
        \ 'p' : [':FloatermNew python'                            , 'python'],
        \ 'r' : [':FloatermNew ranger'                            , 'ranger'],
        \ 't' : [':FloatermToggle'                                , 'toggle'],
        \ 'y' : [':FloatermNew ytop'                              , 'ytop'],
        \ 's' : [':FloatermNew ncdu'                              , 'ncdu'],
        \ }
  let g:which_key_map.b = {
    \ 'name'  :   'buffers',
    \ 'n'    :[':tabnew'         , 'newtab'],
    \ 'b'    :[':Telescope buffers'       , 'buffers'],
    \ 'c'    :[':BufferClose', 'buffer close'],
    \ '1'    :['BufferGoto 1'            , 'pestaña 1'],
    \ '2'    :['BufferGoto 2'            , 'pestaña 2'],
    \ '3'    :['BufferGoto 3'            , 'pestaña 3'],
    \ '4'    :['BufferGoto 4'            , 'pestaña 4'],
    \ '5'    :['BufferGoto 5'            , 'pestaña 5'],
    \ '6'    :['BufferGoto 6'            , 'pestaña 6'],
    \ '7'    :['BufferGoto 7'            , 'pestaña 7'],
    \ '8'    :['BufferGoto 8'            , 'pestaña 8'],
    \ '9'    :['BufferGoto 9'            , 'pestaña 9'],
    \ '10'    :['BufferGoto 10'            , 'pestaña 10'],
    \ '11'    :['BufferGoto 11'            , 'pestaña 11'],
    \ '12'    :['BufferGoto 12'            , 'pestaña 12'],
    \ '13'    :['BufferGoto 13'            , 'pestaña 13'],
    \ '14'    :['BufferGoto 14'            , 'pestaña 14'],
    \ '15'    :['BufferGoto 15'            , 'pestaña 15'],
    \ '16'    :['BufferGoto 16'            , 'pestaña 16'],
    \ '17'    :['BufferGoto 17'            , 'pestaña 17'],
    \ '18'    :['BufferGoto 18'            , 'pestaña 18'],
    \ '19'    :['BufferGoto 19'            , 'pestaña 19'],
    \ }
  let g:which_key_map.l = {
      \ 'name'  : 'LaTeX',
      \ 'c' :   [':VimtexCompile'  ,   'compile'],
      \ 's' :   [':VimtexStop'  ,   'stop compile'],
      \ 'e' :   [':VimtexErrors'  ,   'errors'],
      \ 'd' :   [':LatexmkCleanLogFiles'  ,   'clean tmp files'],
      \ 'v' :   [':VimtexView'  ,   'view pdf'],
      \ 'i' :   [':ToggleFileTexIllustrator'  ,   'LaTeX output in illustrator'],
      \ }
  " let g:which_key_map.w = {
  "     \ 'name'  : 'web',
  "     \ 's' :   [':LivePreview start',   'live preview start'],
  "     \ 'c' :   [':LivePreview close',   'live preview close'],
  "     \ 'p' :   [':LivePreview pick',   'live preview picker'],
  "     \ }
  "
let g:which_key_map.c = {
  \ 'name'  : 'copilot chat',
  \ 'c' :   [':CopilotChat',   'chat'],
  \ 'o' :   [':CopilotChatOpen',   'open'],
  \ 'C' :   [':CopilotChatClose',   'close'],
  \ 't' :   [':CopilotChatToggle',   'toggle'],
  \ 's' :   [':CopilotChatStop',   'stop'],
  \ 'r' :   [':CopilotChatReset',   'reset'],
  \ 'S' :   [':CopilotChatSave',   'save'],
  \ 'L' :   [':CopilotChatLoad',   'load'],
  \ 'd' :   [':CopilotChatDebugInfo',   'debug'],
  \ 'm' :   [':CopilotChatModels',   'models'],
  \ 'a' :   [':CopilotChatAgents',   'agents'],
  \ 'e' :   [':CopilotChatExplain',   'explain'],
  \ 'g' :   [':CopilotChatGenerate',   'generate'],
  \ 'i' :   [':CopilotChatImage',   'image'],
  \ 'l' :   [':CopilotChatList',   'list'],
  \ 'p' :   [':CopilotChatPrompt',   'prompt'],
  \}


" Register which key map
  call which_key#register('<Space>', "g:which_key_map")

  "---------------------------------
  let g:which_key_map.fa = 'which_key_ignore'
  let g:which_key_map.fb = 'which_key_ignore'
  let g:which_key_map.ff = 'which_key_ignore'
  let g:which_key_map.fh = 'which_key_ignore'

  "------------------floaterm
  let g:floaterm_keymap_toggle = '<F1>'
  let g:floaterm_keymap_next   = '<F2>'
  let g:floaterm_keymap_new    = '<F3>'

  " Floaterm
  let g:floaterm_gitcommit='floaterm'
  let g:floaterm_autoinsert=1
  let g:floaterm_width=0.8
  let g:floaterm_height=0.8
  let g:floaterm_wintitle=0
  let g:floaterm_autoclose=1
  
