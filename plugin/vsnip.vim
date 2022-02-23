" NOTE: You can use other key to expand snippet.

" Expand
imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'

" Expand or jump
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

" Jump forward or backward
imap <expr> <C-n>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<C-n>'
smap <expr> <C-n>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<C-n>'
imap <expr> <C-b> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<C-b>'
smap <expr> <C-b> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<C-b>'

" Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
" See https://github.com/hrsh7th/vim-vsnip/pull/50
nmap        s   <Plug>(vsnip-select-text)
xmap        s   <Plug>(vsnip-select-text)
nmap        S   <Plug>(vsnip-cut-text)
xmap        S   <Plug>(vsnip-cut-text)

" If you want to use snippet for multiple filetypes, you can `g:vsnip_filetypes` for it.
let g:vsnip_filetypes = {}
let g:vsnip_filetypes.javascriptreact = ['javascript']
let g:vsnip_filetypes.typescriptreact = ['typescript']

if has('win32')
  let g:vsnip_snippet_dir = get(g:, 'vsnip_snippet_dir', expand('~/Documents/nvim/vsnip'))
else
  let g:vsnip_snippet_dir = get(g:, 'vsnip_snippet_dir', expand('/home/userh/.config/nvim/vsnip'))
endif


