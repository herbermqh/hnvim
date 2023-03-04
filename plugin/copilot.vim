imap <silent><script><expr> <C-j> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true
" copilot#Next
imap <Plug>(copilot-next)     <Cmd>call copilot#Next()<CR>
imap <Plug>(copilot-previous) <Cmd>call copilot#Previous()<CR>
imap <Plug>(copilot-suggest)  <Cmd>call copilot#Suggest()<CR>


imap <silent> <C-t> <Plug>(copilot-next)
imap <silent> <C-g> <Plug>(copilot-previous)
imap <silent> <C-A-\> <Plug>(copilot-dismiss)













