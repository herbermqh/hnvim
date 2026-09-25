local monitor = require("resourcemon.monitor")

local M = {}

local win_id = nil
local buf_id = nil
local timer = nil
local ns_id = vim.api.nvim_create_namespace("resourcemon_ui")

local function format_mem(kb)
  if kb > 1024 * 1024 then
    return string.format("%.2f GB", kb / (1024 * 1024))
  elseif kb > 1024 then
    return string.format("%.1f MB", kb / 1024)
  else
    return string.format("%d KB", kb)
  end
end

local function make_bar(percent, width)
  percent = math.max(0, math.min(100, percent))
  local filled = math.floor((percent / 100) * width + 0.5)
  local empty = width - filled
  return string.rep("■", filled) .. string.rep("·", empty)
end

local function update_window()
  if not win_id or not vim.api.nvim_win_is_valid(win_id) then
    if timer then
      timer:stop()
      timer:close()
      timer = nil
    end
    return
  end

  monitor.get_stats(function(tree)
    if not buf_id or not vim.api.nvim_buf_is_valid(buf_id) then return end
    
    local lines = {}
    local highlights = {}
    
    local function add_line(text)
      table.insert(lines, text)
      return #lines - 1
    end

    local function add_hl(line_idx, hl_group, start_col, end_col)
      table.insert(highlights, {line_idx, hl_group, start_col, end_col})
    end

    -- Cabecera estilizada
    add_line(" ╭────────────────────────────────────────────────────────────────────────╮")
    local title_idx = add_line(" │  🚀 NEOVIM PROCESS MONITOR                                             │")
    add_hl(title_idx, "Keyword", 4, 29)
    add_line(" ╰────────────────────────────────────────────────────────────────────────╯")
    
    local header_idx = add_line(string.format("   %-6s %-25s %-7s %-12s %-10s", "PID", "PROCESS", "CPU%", "CPU BAR", "RAM"))
    add_hl(header_idx, "Comment", 0, -1)
    add_line(" ─" .. string.rep("─", 72))

    local total_rss = 0
    local total_cpu = 0

    for _, proc in ipairs(tree) do
      local is_root = proc.level == 0
      local prefix = is_root and "" or (string.rep("  ", proc.level - 1) .. "|_ ")
      local name = prefix .. proc.comm
      if string.len(name) > 23 then
        name = string.sub(name, 1, 20) .. "..."
      end
      
      local cpu_bar = make_bar(proc.cpu, 10)
      
      -- Construcción por partes para evitar problemas de bytes con caracteres Unicode
      local p1 = string.format("   %-6d %-25s %5.1f%% [", proc.pid, name, proc.cpu)
      local p2 = cpu_bar
      local p3 = string.format("] %10s", format_mem(proc.rss))
      
      local l_idx = add_line(p1 .. p2 .. p3)
      
      -- Colores base
      add_hl(l_idx, "Type", 3, 9) -- PID
      add_hl(l_idx, is_root and "String" or "Function", 10, 35) -- Process Name
      
      -- Color semántico para CPU
      local cpu_hl = "DiagnosticOk"
      if proc.cpu > 50 then cpu_hl = "DiagnosticError"
      elseif proc.cpu > 15 then cpu_hl = "DiagnosticWarn" end
      add_hl(l_idx, cpu_hl, 36, #p1 + #p2 + 1)
      
      -- Color semántico para RAM
      local mem_hl = "DiagnosticOk"
      if proc.rss > 1024 * 500 then mem_hl = "DiagnosticError"
      elseif proc.rss > 1024 * 100 then mem_hl = "DiagnosticWarn" end
      add_hl(l_idx, mem_hl, #p1 + #p2 + 1, -1)

      total_rss = total_rss + proc.rss
      total_cpu = total_cpu + proc.cpu
    end

    add_line(" ─" .. string.rep("─", 72))
    
    local sum_cpu_bar = make_bar(total_cpu, 10)
    local s1 = string.format("   %-6s %-25s %5.1f%% [", "TOTAL", "System Footprint", total_cpu)
    local s2 = sum_cpu_bar
    local s3 = string.format("] %10s", format_mem(total_rss))
    local sum_idx = add_line(s1 .. s2 .. s3)
    add_hl(sum_idx, "Number", 0, -1)

    add_line("")
    local footer_idx = add_line("   (Press 'q' or <Esc> to close)")
    add_hl(footer_idx, "Comment", 0, -1)

    vim.api.nvim_buf_set_option(buf_id, "modifiable", true)
    vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf_id, "modifiable", false)

    vim.api.nvim_buf_clear_namespace(buf_id, ns_id, 0, -1)
    for _, hl in ipairs(highlights) do
      pcall(vim.api.nvim_buf_add_highlight, buf_id, ns_id, hl[2], hl[1], hl[3], hl[4])
    end
  end)
end

function M.open()
  if win_id and vim.api.nvim_win_is_valid(win_id) then
    vim.api.nvim_set_current_win(win_id)
    return
  end

  buf_id = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf_id, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(buf_id, "filetype", "resourcemon")

  vim.keymap.set('n', 'q', '<cmd>q<cr>', { buffer = buf_id, silent = true })
  vim.keymap.set('n', '<Esc>', '<cmd>q<cr>', { buffer = buf_id, silent = true })

  local width = 76
  local height = 24
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local opts = {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    border = "rounded",
  }

  win_id = vim.api.nvim_open_win(buf_id, true, opts)
  
  -- Actualización más rápida para sensación fluida
  timer = vim.loop.new_timer()
  timer:start(0, 1500, vim.schedule_wrap(update_window))
end

return M
