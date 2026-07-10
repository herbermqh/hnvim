local wk = require("which-key")

wk.setup({
  preset = "modern",
  win = {
    border = "rounded",
    padding = { 0, 0, 0, 0 },
    title = true,
    title_pos = "center",
    -- Al redimensionar, permitir overlap y maximizar altura para que no se oculten opciones
    no_overlap = false,
    height = { min = 4, max = 0.9 },
  },
  layout = {
    align = "left", -- "left" aprovecha mejor el espacio que "center"
    spacing = 2, -- Menos espacio entre columnas (antes 4)
  },
  icons = {
    breadcrumb = "»",
    separator = "➜",
    group = "󰉖 ", -- icon for groups
  },
  plugins = {
    marks = true,
    registers = true,
    spelling = { enabled = true, suggestions = 20 },
    presets = {
      operators = true,
      motions = true,
      text_objects = true,
      windows = true,
      nav = true,
      z = true,
      g = true,
    },
  },
})

wk.add({
  -- Root Level
  { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer", icon = "󰙅" },
  { "<leader>/", "<Plug>NERDCommenterToggle", desc = "Comment", icon = "󰆈" },
  { "<leader>.", vim.lsp.buf.code_action, desc = "Action", icon = "󰌵" },
  { "<leader>m", "<cmd>e ~/.config/nvim/artplugins/arttexsnippets.nvim/manual_completo.md<cr>", desc = "Snippets Manual", icon = "󰈙" },
  { "<leader>o", "<cmd>Telescope aerial<cr>", desc = "Outline / Sections", icon = "󰠘" },

  -- [a] AI
  { "<leader>a", group = "Copilot", icon = "" },
  { "<leader>ac", "<cmd>CopilotChat<cr>", desc = "Chat" },
  { "<leader>ao", "<cmd>CopilotChatOpen<cr>", desc = "Open" },
  { "<leader>aC", "<cmd>CopilotChatClose<cr>", desc = "Close" },
  { "<leader>at", "<cmd>CopilotChatToggle<cr>", desc = "Toggle" },
  { "<leader>as", "<cmd>CopilotChatStop<cr>", desc = "Stop" },
  { "<leader>ar", "<cmd>CopilotChatReset<cr>", desc = "Reset" },
  { "<leader>aS", "<cmd>CopilotChatSave<cr>", desc = "Save" },
  { "<leader>aL", "<cmd>CopilotChatLoad<cr>", desc = "Load" },
  { "<leader>ad", "<cmd>CopilotChatDebugInfo<cr>", desc = "Debug" },
  { "<leader>am", "<cmd>CopilotChatModels<cr>", desc = "Models" },
  { "<leader>aa", "<cmd>CopilotChatAgents<cr>", desc = "Agents" },
  { "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "Explain" },
  { "<leader>ag", "<cmd>CopilotChatGenerate<cr>", desc = "Generate" },
  { "<leader>ai", "<cmd>CopilotChatImage<cr>", desc = "Image" },
  { "<leader>al", "<cmd>CopilotChatList<cr>", desc = "List" },
  { "<leader>ap", "<cmd>CopilotChatPrompt<cr>", desc = "Prompt" },

  -- [b] Buffers
  { "<leader>b", group = "Buffer", icon = "󰓩" },
  { "<leader>bn", "<cmd>tabnew<cr>", desc = "New", icon = "󰐕" },
  { "<leader>bb", "<cmd>Telescope buffers<cr>", desc = "List", icon = "󰕰" },
  { "<leader>bd", "<cmd>BufferClose<cr>", desc = "Close", icon = "󰅖" },
  { "<leader>bO", "<cmd>BufferCloseAllButCurrent<cr>", desc = "Close Other", icon = "󰅙" },
  { "<leader>b1", "<cmd>BufferGoto 1<cr>", desc = "1", hidden = true },
  { "<leader>b2", "<cmd>BufferGoto 2<cr>", desc = "2", hidden = true },
  { "<leader>b3", "<cmd>BufferGoto 3<cr>", desc = "3", hidden = true },
  { "<leader>b4", "<cmd>BufferGoto 4<cr>", desc = "4", hidden = true },
  { "<leader>b5", "<cmd>BufferGoto 5<cr>", desc = "5", hidden = true },
  { "<leader>b6", "<cmd>BufferGoto 6<cr>", desc = "6", hidden = true },
  { "<leader>b7", "<cmd>BufferGoto 7<cr>", desc = "7", hidden = true },
  { "<leader>b8", "<cmd>BufferGoto 8<cr>", desc = "8", hidden = true },
  { "<leader>b9", "<cmd>BufferGoto 9<cr>", desc = "9", hidden = true },
  { "<leader>b0", "<cmd>BufferGoto 10<cr>", desc = "10", hidden = true },

  -- [c] Code
  { "<leader>c", group = "Code", icon = "󰉨" },
  { "<leader>ca", vim.lsp.buf.code_action, desc = "Action", icon = "󰌵" },
  { "<leader>cf", function() require("conform").format({ lsp_fallback = true, async = false, timeout_ms = 500 }) end, desc = "Format", icon = "󰉨" },
  { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", icon = "󰑕" },
  { "<leader>cd", vim.diagnostic.open_float, desc = "Line Diag", icon = "󱖫" },
  { "<leader>cD", "<cmd>Telescope diagnostics<cr>", desc = "Proj Diag", icon = "󰋑" },

  -- [f] Find
  { "<leader>f", group = "Find", icon = "" },
  { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Files", icon = "󰈔" },
  { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep", icon = "󰊄" },
  { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Word", icon = "󰈭" },
  { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent", icon = "󰄉" },
  { "<leader>fy", "<cmd>Yazi<cr>", desc = "Yazi", icon = "󰇥" },
  { "<leader>fc", "<cmd>Telescope colorscheme<cr>", desc = "Themes", icon = "󰏘" },

  -- [g] Git
  { "<leader>g", group = "Git", icon = "󰊢" },
  { "<leader>gg", "<cmd>FloatermNew lazygit<cr>", desc = "LazyGit", icon = "󰊢" },
  { "<leader>gc", "<cmd>Commits<cr>", desc = "Commits", icon = "󰜘" },
  { "<leader>gb", "<cmd>BCommits<cr>", desc = "BCommits", icon = "󰓒" },

  -- [l] LaTeX (ArtTeX Ecosystem)
  { "<leader>l", group = "LaTeX (ArtTeX)", icon = "" },
  { "<leader>lc", "<cmd>ArtTexCompile<cr>", desc = "Compile (Auto)", icon = "󰑐" },
  { "<leader>lC", "<cmd>ArtTexCompilePlain<cr>", desc = "Compile (PlainTeX)", icon = "󰑐" },
  { "<leader>ls", "<cmd>ArtTexStop<cr>", desc = "Stop Job", icon = "󰓛" },
  { "<leader>lS", "<cmd>ArtTexStopAll<cr>", desc = "Stop All Jobs", icon = "󰓛" },
  { "<leader>le", "<cmd>ArtTexErrors<cr>", desc = "Errors (Trouble)", icon = "󰒡" },
  { "<leader>ll", "<cmd>ArtTexViewLog<cr>", desc = "View .log File", icon = "󰈙" },
  { "<leader>ld", "<cmd>ArtTexClean<cr>", desc = "Clean Aux Files", icon = "󰃢" },
  { "<leader>lo", "<cmd>ArtTexOutput<cr>", desc = "Toggle Output", icon = "󰍔" },
  { "<leader>lO", "<cmd>ArtTexOutputClose<cr>", desc = "Close Output", icon = "󰅖" },
  { "<leader>lI", "<cmd>ArtTexStatus<cr>", desc = "Compiler Status", icon = "󰋽" },
  { "<leader>lw", "<cmd>ArtTexWorkspaceTree<cr>", desc = "Workspace Tree", icon = "󰙅" },
  { "<leader>lv", "<cmd>ArtTexForwardSearch<cr>", desc = "PDF (Synctex)", icon = "󰈙" },
  { "<leader>lV", "<cmd>ArtTexSelectViewer<cr>", desc = "Select PDF Viewer", icon = "󰈙" },
  { "<leader>li", "<cmd>ToggleFileTexIllustrator<cr>", desc = "Illustrator", icon = "󰽉" },
  { "<leader>lm", "<cmd>ArtTexMenuCompilatorConfig<cr>", desc = "Menu Compiler Config", icon = "" },
  { "<leader>ln", group = "Snippets", icon = "󰩫" },
  { "<leader>lne", "<cmd>ArtTexSnippetsEdit<cr>", desc = "Edit Módulos", icon = "󰏫" },
  { "<leader>lns", "<cmd>ArtTexSnippetsSearch<cr>", desc = "Buscar Snippets", icon = "󰌵" },
  { "<leader>lnc", "<cmd>ArtTexSnippetsConfig<cr>", desc = "Configuración", icon = "" },
  { "<leader>lW", group = "Visual Wizards (UI)", icon = "󰕷" },
  { "<leader>lWt", "<cmd>ArtTexVisualTable<cr>", desc = "Tablas (Grid)", icon = "󰓫" },
  { "<leader>lWm", "<cmd>ArtTexVisualMath<cr>", desc = "Ecuaciones (RPC)", icon = "󰪚" },
  { "<leader>lWg", "<cmd>ArtTexVisualGraph<cr>", desc = "Gráficas TikZ", icon = "󰱨" },
  { "<leader>lT", group = "Tabla de Contenidos", icon = "󰧮" },
  { "<leader>lTt", "<cmd>ArtTexTOCToggle<cr>", desc = "Abrir/Cerrar TOC", icon = "󰧮" },
  { "<leader>lTc", "<cmd>ArtTexTOCConfig<cr>", desc = "Configuración (Reglas)", icon = "" },
  { "<leader>lp", desc = "Preview", icon = "󰇩" },
  { "<leader>lt", function() require('arttexconceal').toggle() end, desc = "Toggle Conceal", icon = "󰈈" },

  -- [q] Quit
  { "<leader>q", group = "Quit", icon = "󰗼" },
  { "<leader>qq", "<cmd>qa<cr>", desc = "Quit All", icon = "󰩈" },
  { "<leader>qw", "<cmd>wq<cr>", desc = "Save", icon = "󰆓" },
  { "<leader>qc", "<cmd>close<cr>", desc = "Close", icon = "󰅖" },

  -- [s] Search
  { "<leader>s", group = "Search", icon = "󰍉" },
  { "<leader>s/", "<cmd>Telescope search_history<cr>", desc = "Search Hist" },
  { "<leader>s;", "<cmd>Telescope command_history<cr>", desc = "Cmd Hist" },
  { "<leader>sa", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
  { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
  { "<leader>sc", "<cmd>Telescope commands<cr>", desc = "Cmds" },
  { "<leader>sC", "<cmd>Telescope git_bcommits<cr>", desc = "BCommits" },
  { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Files" },
  { "<leader>sg", "<cmd>Telescope git_files<cr>", desc = "Git Files" },
  { "<leader>sG", "<cmd>Telescope git_status<cr>", desc = "Status" },
  { "<leader>sh", "<cmd>Telescope oldfiles<cr>", desc = "History" },
  { "<leader>sl", "<cmd>Telescope live_grep<cr>", desc = "Lines" },
  { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Marks" },
  { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keys" },
  { "<leader>sp", "<cmd>Telescope help_tags<cr>", desc = "Help" },
  { "<leader>sS", "<cmd>Telescope colorscheme<cr>", desc = "Colors" },
  { "<leader>sw", "<cmd>Telescope buffers<cr>", desc = "Windows" },
  { "<leader>sy", "<cmd>Telescope filetypes<cr>", desc = "Filetype" },
  { "<leader>sz", "<cmd>Telescope<cr>", desc = "Builtin" },

  -- [t] Terminal
  { "<leader>t", group = "Terminal", icon = "" },
  { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle" },
  { "<leader>tn", "<cmd>1ToggleTerm<cr>", desc = "Term 1" },
  { "<leader>t2", "<cmd>2ToggleTerm<cr>", desc = "Term 2" },
  { "<leader>t3", "<cmd>3ToggleTerm<cr>", desc = "Term 3" },
  { "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", desc = "Vertical" },
  { "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Horizontal" },
  { "<leader>tp", "<cmd>TermExec cmd='python3'<cr>", desc = "Python", icon = "󰌠" },
  { "<leader>td", "<cmd>TermExec cmd='lazydocker'<cr>", desc = "Docker", icon = "" },
  { "<leader>tj", "<cmd>TermExec cmd='node'<cr>", desc = "Node", icon = "󰎙" },
  { "<leader>tr", "<cmd>TermExec cmd='ranger'<cr>", desc = "Ranger" },
  { "<leader>tu", "<cmd>TermExec cmd='ncdu'<cr>", desc = "Ncdu" },

  -- [u] UI
  { "<leader>u", group = "UI", icon = "󰏘" },
  { "<leader>uc", "<cmd>Telescope colorscheme<cr>", desc = "Theme", icon = "󰸌" },
  { "<leader>uz", "<cmd>ZenMode<cr>", desc = "Zen", icon = "󰘖" },
  { "<leader>us", "<cmd>Dashboard<cr>", desc = "Start", icon = "󰋜" },

  -- [w] Window
  { "<leader>w", group = "Window", icon = "󰖲" },
  { "<leader>ws", "<C-W>s", desc = "Split H", icon = "󰤼" },
  { "<leader>wv", "<C-W>v", desc = "Split V", icon = "󰤽" },
  { "<leader>wc", "<cmd>close<cr>", desc = "Close", icon = "󰅖" },
  { "<leader>w=", "<C-W>=", desc = "Balance", icon = "󰡡" },

  -- [x] Diagnostics/Trouble
  { "<leader>x", group = "Diagnostics", icon = "󰒡" },
  { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics", icon = "󰒡" },
  { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics", icon = "󰈙" },
  { "<leader>xs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols", icon = "󰌗" },
  { "<leader>xr", "<cmd>Trouble lsp_references toggle<cr>", desc = "LSP References", icon = "󰈙" },
  { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location List", icon = "󰋽" },
  { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List", icon = "󰒡" },
})
