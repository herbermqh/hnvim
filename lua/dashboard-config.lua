local home = os.getenv('HOME')
local db = require('dashboard')
db.setup({
  theme = 'doom',
  config = {
    header = {
    '',
    '',
    ' █████  ██████  ████████     ███    ██ ██    ██ ██ ███    ███',
    '██   ██ ██   ██    ██        ████   ██ ██    ██ ██ ████  ████',
    '███████ ██████     ██        ██ ██  ██ ██    ██ ██ ██ ████ ██',
    '██   ██ ██   ██    ██        ██  ██ ██  ██  ██  ██ ██  ██  ██',
    '██   ██ ██   ██    ██        ██   ████   ████   ██ ██      ██',
    '',
    '',
    }, --your header
    center = {
      {icon = '  ',
      desc = 'Restore Local Session                   ',
      shortcut = 'SPC s l',
      action ='lua require("persistence").load()'},
      {icon = '󱞛  ',
      desc = 'Recently opened files                   ',
      action =  'Telescope oldfiles',
      shortcut = 'SPC f h'},
      {icon = '  ',
      desc = 'Find  File                              ',
      action = 'Telescope find_files',
      shortcut = 'SPC f f'},
      {icon = '  ',
      desc ='File Browser                            ',
      action =  'NvimTreeToggle',
      shortcut = 'SPC f b'},
      {icon = '  ',
      desc = 'Find  word                              ',
      action = 'Telescope live_grep',
      shortcut = 'SPC f w'},
    },
    footer = {'neovim plus'},  --your footer
  },
  hide = {
    statusline = true,
    tabline = true,
    winbar = true,
  },
})

-- Configurar el plugin genérico de resaltado de píldora
require('pill-highlighter').setup({
  hl_group = "DashboardTextSelect",
  bg_color = "#292e42",
  hide_cursor = true,
  rounded = true
})

-- Consumir el API del plugin al cargar el dashboard
vim.api.nvim_create_autocmd("FileType", {
  pattern = "dashboard",
  callback = function()
    require('pill-highlighter').attach()
  end,
})


-- db.preview_command = 'cat | lolcat -F 0.3'
-- db.preview_file_path = home .. '/.config/nvim/static/neovim.cat'
-- db.preview_file_height = 5
-- db.preview_file_width = 63
-- db.custom_center = {
--       {icon = '  ',
--       desc = 'Recently latest session                 ',
--       shortcut = 'SPC s l',
--       action ='Telescope oldfiles'},
--       -- {icon = '  ',
--       -- desc = 'Recently opened files                   ',
--       -- action =  'DashboardFindHistory',
--       -- shortcut = 'SPC f h'},
--       {icon = '  ',
--       desc = 'Find  File                              ',
--       action = 'Telescope find_files',
--       shortcut = 'SPC f f'},
--       -- {icon = '  ',
--       -- desc ='File Browser                            ',
--       -- action =  'Telescope file_browser',
--       -- shortcut = 'SPC f b'},
--       {icon = '  ',
--       desc = 'Find  word                              ',
--       action = 'Telescope live_grep',
--       shortcut = 'SPC f w'},
--     }
-- db.custom_footer = {'herbermqh@gmail.com'}
-- db.hide_statusline = true
-- db.hide_tabline = true

---- Custom Header
---- vim.g.dashboard_custom_header = {
----   '██╗  ██╗    ███████╗    ██████╗     ███████╗    ██████╗ ',
----   '██║  ██║    ██╔════╝    ██╔══██╗    ██╔════╝    ██╔══██╗',
----   '███████║    █████╗      ██████╔╝    █████╗      ██████╔╝',
----   '██╔══██║    ██╔══╝      ██╔══██╗    ██╔══╝      ██╔══██╗',
----   '██║  ██║    ███████╗    ██████╔╝    ███████╗    ██║  ██║',
----   '╚═╝  ╚═╝    ╚══════╝    ╚═════╝     ╚══════╝    ╚═╝  ╚═╝',
---- }


-- db.dashboard_custom_header = {
-- ' █████  ██████  ████████     ███    ██ ██    ██ ██ ███    ███',
-- '██   ██ ██   ██    ██        ████   ██ ██    ██ ██ ████  ████',
-- '███████ ██████     ██        ██ ██  ██ ██    ██ ██ ██ ████ ██',
-- '██   ██ ██   ██    ██        ██  ██ ██  ██  ██  ██ ██  ██  ██',
-- '██   ██ ██   ██    ██        ██   ████   ████   ██ ██      ██'
-- }



----[[ vim.g.dashboard_custom_header = {
--'                       ```                        ',
--'                    ./sssss+-                     ',
--'                  `/syyyyyyyys-                   ',
--'                 `oyyyyyyyyyyyy+`                 ',
--'                -syyyyyyyyyyyyyyo.                ',
--'               :syyyyyyyyyyyyyyyys-               ',
--'             `+yyyyyyyyso+osyyyyyys:              ',
--'            `oyyyyyyys:`   `:syyyyyy+`            ',
--'           .syyyyyyyo.       `+yyyyyyo`           ',
--'          :syyyyyyy+`     .--../yyyyyys-          ',
--'        `/yyyyyyys:     .o+.`:o--syyyyys:         ',
--'       `+yyyyyyys-     :s/   .:` .oyyyyyy/`       ',
--'      .oyyyyyyyo.     /y/         `+yyyyyy+`      ',
--'     -syyyyyyy+`     /y/            /yyyyyyo.     ',
--'    /yyyyyyys/     `+y/    ```       :syyyyys-    ',
--'  `+yyyyyyys-     `+y/   -+:://`      .syyyyyy/   ',
--' .oyyyyyyyo.     `+y/   `s.   :o``...` `oyyyyyy+` ',
--'`syyyyyyyo`     `+s:     +/---:so:--:+- `+yyyyyyo`',
--'+yyyyyyys`.:`  `+s-       `---..s.   :o   +yyyyyy+',
--'syyyyyyy+ :o. .o+.              .+/:/+.   :yyyyyys',
--':syyyyyyy/..--:.                  `.`   .:syyyyys-',
--' ./ossssssssooooooooooooooooooooooooooosssssso/-` ',
--'      `````````````````````````````````````       ',
--} ]]


---- Dashboard Sections
--vim.g.dashboard_custom_section = {
--  a = {
--    description = { '  Recently Used Files' },
--    command = 'Telescope oldfiles',
--  },
--  b = {
--    description = { '  Find File          ' },
--    command = 'Telescope find_files',
--  },
--  c = {
--    description = { '  Find Word          ' },
--    command = 'Telescope live_grep',
--  },
--  d = {
--    description = { ' Change Color sheme  ' },
--    command = 'Telescope colorscheme',
--  },
--}
