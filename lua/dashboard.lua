-- Grep
vim.g.dashboard_default_executive = 'telescope'

-- Custo Footer
vim.g.dashboard_custom_footer = { 'herbermqh@gmail.com' }

-- Custom Header
vim.g.dashboard_custom_header = {
  '██╗  ██╗    ███████╗    ██████╗     ███████╗    ██████╗ ',
  '██║  ██║    ██╔════╝    ██╔══██╗    ██╔════╝    ██╔══██╗',
  '███████║    █████╗      ██████╔╝    █████╗      ██████╔╝',
  '██╔══██║    ██╔══╝      ██╔══██╗    ██╔══╝      ██╔══██╗',
  '██║  ██║    ███████╗    ██████╔╝    ███████╗    ██║  ██║',
  '╚═╝  ╚═╝    ╚══════╝    ╚═════╝     ╚══════╝    ╚═╝  ╚═╝',
}

--[[ vim.g.dashboard_custom_header = {
'                       ```                        ',
'                    ./sssss+-                     ',
'                  `/syyyyyyyys-                   ',
'                 `oyyyyyyyyyyyy+`                 ',
'                -syyyyyyyyyyyyyyo.                ',
'               :syyyyyyyyyyyyyyyys-               ',
'             `+yyyyyyyyso+osyyyyyys:              ',
'            `oyyyyyyys:`   `:syyyyyy+`            ',
'           .syyyyyyyo.       `+yyyyyyo`           ',
'          :syyyyyyy+`     .--../yyyyyys-          ',
'        `/yyyyyyys:     .o+.`:o--syyyyys:         ',
'       `+yyyyyyys-     :s/   .:` .oyyyyyy/`       ',
'      .oyyyyyyyo.     /y/         `+yyyyyy+`      ',
'     -syyyyyyy+`     /y/            /yyyyyyo.     ',
'    /yyyyyyys/     `+y/    ```       :syyyyys-    ',
'  `+yyyyyyys-     `+y/   -+:://`      .syyyyyy/   ',
' .oyyyyyyyo.     `+y/   `s.   :o``...` `oyyyyyy+` ',
'`syyyyyyyo`     `+s:     +/---:so:--:+- `+yyyyyyo`',
'+yyyyyyys`.:`  `+s-       `---..s.   :o   +yyyyyy+',
'syyyyyyy+ :o. .o+.              .+/:/+.   :yyyyyys',
':syyyyyyy/..--:.                  `.`   .:syyyyys-',
' ./ossssssssooooooooooooooooooooooooooosssssso/-` ',
'      `````````````````````````````````````       ',
} ]]


-- Dashboard Sections
vim.g.dashboard_custom_section = {
  a = {
    description = { '  Find File          ' },
    command = 'Telescope find_files',
  },
  b = {
    description = { '  Recently Used Files' },
    command = 'Telescope oldfiles',
  },
  c = {
    description = { '  Find Word          ' },
    command = 'Telescope live_grep',
  },
  d = {
    description = { ' Change Color sheme  ' },
    command = 'Telescope colorscheme',
  },
}
