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
  { "<leader>gg", "<cmd>lua _lazygit_toggle()<cr>", desc = "LazyGit", icon = "󰊢" },
  { "<leader>gc", "<cmd>Commits<cr>", desc = "Commits", icon = "󰜘" },
  { "<leader>gb", "<cmd>BCommits<cr>", desc = "BCommits", icon = "󰓒" },

  -- [l] LaTeX (ArtTeX Ecosystem)
  { "<leader>l", group = "LaTeX (ArtTeX)", icon = "" },
  
  -- Rápidos / Muy Frecuentes (Root)
  { "<leader>lc", "<cmd>ArtTexCompile<cr>", desc = "Compilar (Auto)", icon = "󰑐" },
  { "<leader>lv", "<cmd>ArtTexForwardSearch<cr>", desc = "Ver PDF (SyncTeX)", icon = "󰈙" },
  { "<leader>lf", "<cmd>ArtTexFormat<cr>", desc = "Formatear Documento", icon = "󰉨" },
  { "<leader>lT", "<cmd>ArtTexTOCToggle<cr>", desc = "Alternar Índice (TOC)", icon = "󰧮" },
  { "<leader>li", "<cmd>ToggleFileTexIllustrator<cr>", desc = "Figura Illustrator", icon = "󰽉" },
  { "<leader>lh", "<cmd>ArtTexHover<cr>", desc = "Info Comando (Hover)", icon = "󰋽" },
  { "<leader>ld", "<cmd>ArtTexDocCTAN<cr>", desc = "Doc CTAN Paquete", icon = "󰈙" },

  -- Grupo [p]: Procesos y Compilación
  { "<leader>lp", group = "Procesos", icon = "󰓛" },
  { "<leader>lpC", "<cmd>ArtTexCompilePlain<cr>", desc = "Compilar (PlainTeX)", icon = "󰑐" },
  { "<leader>lps", "<cmd>ArtTexStop<cr>", desc = "Detener Trabajo", icon = "󰓛" },
  { "<leader>lpS", "<cmd>ArtTexStopAll<cr>", desc = "Detener Todos", icon = "󰓛" },
  { "<leader>lpi", "<cmd>ArtTexStatus<cr>", desc = "Estado Procesos", icon = "󰋽" },
  { "<leader>lpx", "<cmd>ArtTexClean<cr>", desc = "Limpiar Auxiliares", icon = "󰃢" },
  { "<leader>lpo", "<cmd>ArtTexOutput<cr>", desc = "Consola de Salida", icon = "󰍔" },
  { "<leader>lpO", "<cmd>ArtTexOutputClose<cr>", desc = "Cerrar Consola Forzada", icon = "󰅖" },
  { "<leader>lpl", "<cmd>ArtTexViewLog<cr>", desc = "Ver Archivo .log", icon = "󰈙" },
  { "<leader>lpd", "<cmd>ArtTexDebugCommand<cr>", desc = "Ver Comando Shell", icon = "󰘚" },
  { "<leader>lpe", "<cmd>ArtTexErrors<cr>", desc = "Ver Errores Quickfix", icon = "󰒡" },

  -- Grupo [w]: Workspace y Sistema
  { "<leader>lw", group = "Workspace", icon = "󰙅" },
  { "<leader>lwt", "<cmd>ArtTexWorkspaceTree<cr>", desc = "Árbol Workspace", icon = "󰙅" },
  { "<leader>lwv", "<cmd>ArtTexVerbatimEnvs<cr>", desc = "Entornos Verbatim", icon = "󰘚" },
  { "<leader>lwn", "<cmd>ArtTexCreateProject<cr>", desc = "Crear Proyecto", icon = "󰏋" },
  { "<leader>lwg", "<cmd>ArtTexVisualizeGraph<cr>", desc = "Grafo Dependencias", icon = "󰠘" },
  { "<leader>lwc", "<cmd>ArtTexClearLog<cr>", desc = "Limpiar BD Interna", icon = "󰃢" },
  { "<leader>lwr", "<cmd>ArtSourceColorSync<cr>", desc = "Refrescar Sintaxis", icon = "󰑐" },
  { "<leader>lwl", "<cmd>ArtTexLint<cr>", desc = "Analizar Linter (ChkTeX)", icon = "󰃢" },
  { "<leader>lwC", function() require('arttexconceal').toggle() end, desc = "Alternar Conceal", icon = "󰈈" },

  -- Grupo [s]: Snippets
  { "<leader>ls", group = "Snippets", icon = "󰩫" },
  { "<leader>lse", "<cmd>ArtTexSnippetsEdit<cr>", desc = "Editar Módulos", icon = "󰏫" },
  { "<leader>lss", "<cmd>ArtTexSnippetsSearch<cr>", desc = "Buscar Snippets", icon = "󰌵" },
  { "<leader>lsc", "<cmd>ArtTexSnippetsConfig<cr>", desc = "Activar/Desactivar", icon = "" },

  -- Grupo [W]: Visual Wizards
  { "<leader>lW", group = "Visual Wizards", icon = "󰕷" },
  { "<leader>lWt", "<cmd>ArtTexVisualTable<cr>", desc = "Tablas (Grid)", icon = "󰓫" },
  { "<leader>lWm", "<cmd>ArtTexVisualMath<cr>", desc = "Matemáticas (Editor)", icon = "󰪚" },
  { "<leader>lWg", "<cmd>ArtTexVisualGraph<cr>", desc = "Gráficas TikZ", icon = "󰱨" },

  -- Grupo [O]: Opciones y Configuración
  { "<leader>lO", group = "Configuraciones", icon = "" },
  { "<leader>lOc", "<cmd>ArtTexMenuCompilatorConfig<cr>", desc = "Compilador", icon = "󰑐" },
  { "<leader>lOa", "<cmd>ArtCmpConfig<cr>", desc = "Autocompletado", icon = "󰌌" },
  { "<leader>lOC", "<cmd>ArtTeXConcealMenu<cr>", desc = "Conceal (Símbolos)", icon = "󰈈" },
  { "<leader>lOh", "<cmd>ArtHoverConfig<cr>", desc = "Hover (Emergentes)", icon = "󰋽" },
  { "<leader>lOl", "<cmd>ArtLinterConfig<cr>", desc = "Linter (ChkTeX)", icon = "󰃢" },
  { "<leader>lOf", "<cmd>ArtFormatConfig<cr>", desc = "Formateador", icon = "󰉢" },
  { "<leader>lOt", "<cmd>ArtTexTOCConfig<cr>", desc = "Índice (TOC)", icon = "󰧮" },
  { "<leader>lOv", "<cmd>ArtTexSelectViewer<cr>", desc = "Visor PDF", icon = "󰈙" },
  { "<leader>lOs", "<cmd>ArtSourceColorConfig<cr>", desc = "Source Color", icon = "󰏘" },
  { "<leader>lOp", "<cmd>ArtTexPreviewConfig<cr>", desc = "Previsualizador", icon = "󰇩" },
  { "<leader>lOr", "<cmd>ArtFormatEditRules<cr>", desc = "Editar Reglas YAML", icon = "󰏫" },


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
