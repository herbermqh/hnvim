local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
  return
end

toggleterm.setup({
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  open_mapping = [[<F1>]],
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  direction = "float",
  close_on_exit = true,
  shell = vim.o.shell,
  float_opts = {
    border = "rounded",
    winblend = 0,
    highlights = {
      border = "Normal",
      background = "Normal",
    },
  },
})

-- Recrear el comportamiento de Floaterm con F1-F4
-- F1: Alternar terminal actual (Hecho arriba)
-- F2: Renombrar terminal actual (ToggleTerm no itera de forma lineal tan fácil, esto es más útil)
vim.keymap.set({ "n", "v", "t" }, "<F2>", "<cmd>ToggleTermSetName<cr>", { noremap = true, silent = true, desc = "Rename Terminal" })
-- F3: Alternar todas las terminales
vim.keymap.set({ "n", "v", "t" }, "<F3>", "<cmd>ToggleTermToggleAll<cr>", { noremap = true, silent = true, desc = "Toggle All Terminals" })
-- F4: Abrir una nueva terminal flotante secundaria (o abrir Terminal 2 explícitamente)
vim.keymap.set({ "n", "v", "t" }, "<F4>", "<cmd>2ToggleTerm<cr>", { noremap = true, silent = true, desc = "Open Terminal 2" })

-- Atajos útiles exclusivos DENTRO de la terminal abierta
function _G.set_terminal_keymaps()
  local opts = {buffer = 0, noremap = true, silent = true}
  -- Salir del modo inserción en la terminal (volver a modo normal)
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)

  -- Navegación para salir de la terminal a otros buffers usando hjkl
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

-- Forzar siempre el modo de inserción al entrar a una terminal
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
  pattern = "term://*",
  callback = function()
    vim.schedule(function()
      vim.cmd("startinsert")
    end)
  end,
})

-- Integración con Lazygit
local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({
  cmd = "lazygit",
  dir = "git_dir",
  direction = "float",
  float_opts = {
    border = "double",
  },
  -- Opcional: Evitar mapeos conflictivos
  on_open = function(term)
    vim.cmd("startinsert!")
    -- Remove the global <Esc> terminal mapping so lazygit can use it to go back
    pcall(vim.keymap.del, "t", "<esc>", { buffer = term.bufnr })
  end,
  -- Evitar que lazygit se cierre o borre al ocultarlo
  hidden = true,
})

function _G._lazygit_toggle()
  lazygit:toggle()
end
