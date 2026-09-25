local M = {}
local vim = vim

-- Cache para no regenerar/traducir el VBScript en cada búsqueda (ahorro de recursos)
local cached_vbs_win_path = nil

function M.build_forward_search(pdf_file, tex_file, line, col)
  local is_wsl = vim.fn.has("wsl") == 1
  local is_win = vim.fn.has("win32") == 1
  
  -- Si el usuario está en Linux puro (sin WSL) y por alguna razón eligió SumatraPDF,
  -- simplemente le pasamos las rutas limpias (posiblemente esté usando Wine).
  if not is_wsl and not is_win then
    return "sumatrapdf.exe", { "-forward-search", tex_file, tostring(line), pdf_file }
  end

  -- Si estamos en Windows nativo puro, pasamos las rutas directamente
  if is_win and not is_wsl then
    local python_script = vim.fn.stdpath("config") .. "/artplugins/arttexsynctex.nvim/scripts/inverse_search.py"
    local reg_file = require("arttexsynctex.config").options.registry_file
    local inv_cmd = string.format('python3 "%s" "%%f" %%l "%s"', python_script, reg_file)
    return "cmd.exe", { "/c", "start", "", "SumatraPDF.exe", "-reuse-instance", "-inverse-search", inv_cmd, "-forward-search", tex_file, tostring(line), pdf_file }
  end

  local path_utils = require("arttexsynctex.utils.path")
  
  -- Lógica exclusiva para WSL (Interop)
  if not cached_vbs_win_path then
    local vbs_linux_path = vim.fn.stdpath("cache") .. "/arttex_inverse_search.vbs"
    local python_script = vim.fn.stdpath("config") .. "/artplugins/arttexsynctex.nvim/scripts/inverse_search.py"
    
    local vbs_content = {
      'Set objShell = CreateObject("WScript.Shell")',
      'Set args = WScript.Arguments',
      'If args.Count >= 2 Then',
      '    tex_file = args(0)',
      '    line = args(1)',
      '    cmd = "wsl -d Arch python3 ' .. python_script .. ' """ & tex_file & """ " & line & " ""' .. require("arttexsynctex.config").options.registry_file .. '"""',
      '    objShell.Run cmd, 0, False',
      'End If'
    }
    
    local f = io.open(vbs_linux_path, "w")
    if f then
      f:write(table.concat(vbs_content, "\n"))
      f:close()
    end
    
    cached_vbs_win_path = path_utils.to_windows(vbs_linux_path)
  end
  
  local inv_cmd = string.format('wscript.exe //B //Nologo "%s" "%%f" %%l', cached_vbs_win_path)
  
  local tex_file_formatted = path_utils.to_windows(tex_file)
  local pdf_file_formatted = path_utils.to_windows(pdf_file)
  
  tex_file_formatted = tex_file_formatted:gsub("([^\\]+)$", ".\\%1")
  
  local args = {
    "/c", "start", "", "SumatraPDF.exe",
    "-reuse-instance",
    "-inverse-search", inv_cmd,
    "-forward-search", tex_file_formatted, tostring(line),
    pdf_file_formatted
  }
  
  return "cmd.exe", args
end

return M
