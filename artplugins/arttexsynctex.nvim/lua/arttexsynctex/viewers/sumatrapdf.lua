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
    local inv_cmd = string.format('python3 "%s" "%%f" %%l', python_script)
    return "SumatraPDF.exe", { "-reuse-instance", "-inverse-search", inv_cmd, "-forward-search", tex_file, tostring(line), pdf_file }
  end

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
      '    cmd = "wsl python3 ' .. python_script .. ' ""' .. tex_file .. '"" " & line',
      '    objShell.Run cmd, 0, False',
      'End If'
    }
    
    if vim.fn.filereadable(vbs_linux_path) == 0 then
      vim.fn.writefile(vbs_content, vbs_linux_path)
    end
    
    cached_vbs_win_path = vim.fn.system({"wslpath", "-w", vbs_linux_path}):gsub("[\n\r]", "")
  end
  
  local inv_cmd = string.format('wscript.exe //B //Nologo "%s" "%%f" %%l', cached_vbs_win_path)
  
  local tex_file_formatted = vim.fn.system({"wslpath", "-w", tex_file}):gsub("[\n\r]", "")
  local pdf_file_formatted = vim.fn.system({"wslpath", "-w", pdf_file}):gsub("[\n\r]", "")
  
  tex_file_formatted = tex_file_formatted:gsub("([^\\]+)$", ".\\%1")
  
  local args = {
    "-reuse-instance",
    "-inverse-search", inv_cmd,
    "-forward-search", tex_file_formatted, tostring(line),
    pdf_file_formatted
  }
  
  return "SumatraPDF.exe", args
end

return M
