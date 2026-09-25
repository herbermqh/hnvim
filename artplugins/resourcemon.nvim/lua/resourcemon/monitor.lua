local M = {}

local function parse_ps_output(output)
  local lines = vim.split(output, "\n")
  local processes = {}
  for i, line in ipairs(lines) do
    if i > 1 and line:match("%S") then -- saltar la cabecera
      -- Formato: PID PPID %CPU RSS COMMAND
      local pid_str, ppid_str, cpu_str, rss_str, comm = line:match("^%s*(%d+)%s+(%d+)%s+([%d%.]+)%s+(%d+)%s+(.+)$")
      if pid_str then
        local process_name = vim.trim(comm)
        processes[tonumber(pid_str)] = {
          pid = tonumber(pid_str),
          ppid = tonumber(ppid_str),
          cpu = tonumber(cpu_str),
          rss = tonumber(rss_str), -- en KB
          comm = process_name
        }
      end
    end
  end
  return processes
end

local function get_process_tree(processes, root_pid)
  local tree = {}
  local function add_children(pid, level)
    if not processes[pid] then return end
    processes[pid].level = level
    table.insert(tree, processes[pid])
    for child_pid, proc in pairs(processes) do
      if proc.ppid == pid then
        add_children(child_pid, level + 1)
      end
    end
  end
  add_children(root_pid, 0)
  return tree
end

function M.get_stats(callback)
  -- Ejecuta 'ps' en el sistema operativo para obtener todos los procesos
  vim.fn.jobstart({"ps", "-eo", "pid,ppid,%cpu,rss,comm"}, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        local output = table.concat(data, "\n")
        local processes = parse_ps_output(output)
        local nvim_pid = vim.fn.getpid()
        local tree = get_process_tree(processes, nvim_pid)
        callback(tree)
      end
    end
  })
end

return M
