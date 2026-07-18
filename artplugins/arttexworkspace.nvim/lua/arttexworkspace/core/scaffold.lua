local M = {}

function M.create_project()
  local cwd = vim.fn.getcwd()
  
  -- Paso 1: Elegir el tipo de proyecto
  local templates = {
    { label = "󰈙 Artículo Básico", class = "article", dirs = {"figuras", "secciones"} },
    { label = " Libro / Tesis", class = "book", dirs = {"figuras", "capitulos", "anexos"} },
    { label = " Examen / Práctica (FIS100)", class = "article", dirs = {"figuras", "preguntas", "soluciones"} },
    { label = "󰏗 Proyecto Vacío", class = "article", dirs = {} }
  }

  local options = {}
  for i, t in ipairs(templates) do
    table.insert(options, string.format("%d. %s", i, t.label))
  end

  vim.ui.select(options, { prompt = "ArtTeX: Selecciona el tipo de plantilla:" }, function(choice, idx)
    if not choice or not idx then return end
    local tmpl = templates[idx]

    -- Paso 2: Pedir la ruta
    vim.ui.input({ prompt = "Ruta o nombre del nuevo proyecto: ", default = cwd .. "/" }, function(input)
      if not input or input == "" then return end
      
      local path = vim.fn.expand(input)
      
      -- Crear directorio principal
      vim.fn.mkdir(path, "p")
      
      -- Crear subdirectorios de la plantilla
      for _, dir in ipairs(tmpl.dirs) do
        vim.fn.mkdir(path .. "/" .. dir, "p")
      end
      
      -- Crear main.tex
      local main_file = path .. "/main.tex"
      local f_main = io.open(main_file, "w")
      if f_main then
        if tmpl.label:match("Examen") then
          f_main:write("% Proyecto de Examen / Práctica generado por ArtTeX Workspace\n")
          f_main:write("\\documentclass[12pt,letterpaper]{" .. tmpl.class .. "}\n")
          f_main:write("\\usepackage[utf8]{inputenc}\n")
          f_main:write("\\usepackage{amsmath, amssymb, amsfonts}\n")
          f_main:write("\\usepackage{graphicx}\n\n")
          f_main:write("\\begin{document}\n\n")
          f_main:write("\\begin{center}\n")
          f_main:write("  {\\Large \\textbf{Examen / Práctica}}\\\\\n")
          f_main:write("  \\vspace{0.5cm}\n")
          f_main:write("\\end{center}\n\n")
          f_main:write("% \\input{preguntas/pregunta1.tex}\n\n")
          f_main:write("\\end{document}\n")
        else
          f_main:write("% Proyecto generado por ArtTeX Workspace\n")
          f_main:write("\\documentclass{" .. tmpl.class .. "}\n")
          f_main:write("\\usepackage[utf8]{inputenc}\n")
          f_main:write("\\usepackage{amsmath}\n")
          f_main:write("\\usepackage{graphicx}\n\n")
          f_main:write("\\begin{document}\n\n")
          f_main:write("\\title{Nuevo Proyecto}\n")
          f_main:write("\\author{Autor}\n")
          f_main:write("\\maketitle\n\n")
          f_main:write("% Escribe aquí...\n\n")
          f_main:write("\\end{document}\n")
        end
        f_main:close()
      end
      
      -- Crear .texlabroot
      local f_root = io.open(path .. "/.texlabroot", "w")
      if f_root then f_root:close() end
      
      vim.notify("ArtTeX: Proyecto '" .. tmpl.label .. "' creado en " .. path, vim.log.levels.INFO)
      
      -- Abrir el archivo main.tex
      vim.cmd("edit " .. vim.fn.fnameescape(main_file))
    end)
  end)
end

return M
