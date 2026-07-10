--- Módulo UI para el Menú de Configuración Interactiva.
--- Depende de `arttexworkspace.ui.menu_builder` para renderizar el menú interactivo con Telescope.
--- Permite al usuario configurar el compilador (motores, latexmk, output dirs) sin tocar código.
--- @class arttexcompiler.ui.menu
local M = {}
local config = require("arttexcompiler.config")
local workspace = require("arttexworkspace")
local menu_builder = require("arttexworkspace.ui.menu_builder")

--- Construye dinámicamente y abre el menú principal iterativo.
--- Dicha función se invoca recursivamente para actualizar la UI en vivo tras cambiar una opción.
--- @param bufnr number ID del buffer para determinar la raíz del proyecto.
--- @param target_path string Ruta absoluta del archivo raíz detectado.
local function build_main_menu(bufnr, target_path)
  local current_opts = config.get_options(target_path)
  local filename = vim.fn.fnamemodify(target_path, ":t")
  
  local function rebuild()
    build_main_menu(bufnr, target_path)
  end
  
  local menu_options = {}
  
  local filetype = vim.bo[bufnr].filetype
  
  local is_plaintex = (filetype == "plaintex")
  
  -- Búsqueda agresiva de \bye en las últimas 50 líneas
  if not is_plaintex then
    local lines = vim.fn.readfile(target_path, "", -50)
    if lines then
      for _, line in ipairs(lines) do
        if line:match("\\bye%s*$") or line:match("\\bye%s*%%") or line == "\\bye" then
          is_plaintex = true
          break
        end
      end
    end
  end

  local proj = workspace.api.get_project_state(bufnr)
  if not is_plaintex then
    if proj then
      if not proj.document_class then is_plaintex = true end
    else
      -- Fallback: leer las primeras 150 líneas de la raíz
      local root_file = workspace.api.get_root_file(bufnr) or target_path
      local lines = vim.fn.readfile(root_file, "", 150)
      local has_doc = false
      if lines then
        for _, line in ipairs(lines) do
          if line:match("\\documentclass") or line:match("\\begin{document}") then 
            has_doc = true 
            break 
          end
        end
        if not has_doc then is_plaintex = true end
      end
    end
  end
  
  -- Lógica de FileType
  if is_plaintex then
    table.insert(menu_options, {
      text = "1. Motor: [" .. (current_opts.plain_engine or "pdftex") .. "]",
      action = function()
        menu_builder.create_menu({
          title = "Motor",
          prompt = "Selecciona motor PlainTeX:",
          options = {
            {
              text = "  pdftex",
              action = function()
                menu_builder.create_menu({
                  title = "pdftex",
                  prompt = "¿Qué deseas hacer?",
                  options = {
                    {
                      text = "  Activar",
                      action = function() config.set_project_option(target_path, "plain_engine", "pdftex"); rebuild() end
                    },
                    {
                      text = "  Personalizar opción",
                      action = function()
                        local def = current_opts.plain_cmds and current_opts.plain_cmds["pdftex"] or ""
                        menu_builder.create_input({ prompt = "Ops pdftex: ", default = def }, function(input)
                          if input then
                            local cmds = vim.tbl_deep_extend("force", {}, current_opts.plain_cmds or {})
                            cmds["pdftex"] = input
                            config.set_project_option(target_path, "plain_cmds", cmds)
                          end
                          rebuild()
                        end)
                      end
                    },
                    { text = "  ⬅  Volver", action = rebuild }
                  }
                })
              end
            },
            {
              text = "  luatex",
              action = function()
                menu_builder.create_menu({
                  title = "luatex",
                  prompt = "¿Qué deseas hacer?",
                  options = {
                    {
                      text = "  Activar",
                      action = function() config.set_project_option(target_path, "plain_engine", "luatex"); rebuild() end
                    },
                    {
                      text = "  Personalizar opción",
                      action = function()
                        local def = current_opts.plain_cmds and current_opts.plain_cmds["luatex"] or ""
                        menu_builder.create_input({ prompt = "Ops luatex: ", default = def }, function(input)
                          if input then
                            local cmds = vim.tbl_deep_extend("force", {}, current_opts.plain_cmds or {})
                            cmds["luatex"] = input
                            config.set_project_option(target_path, "plain_cmds", cmds)
                          end
                          rebuild()
                        end)
                      end
                    },
                    { text = "  ⬅  Volver", action = rebuild }
                  }
                })
              end
            },
            {
              text = "  xetex",
              action = function()
                menu_builder.create_menu({
                  title = "xetex",
                  prompt = "¿Qué deseas hacer?",
                  options = {
                    {
                      text = "  Activar",
                      action = function() config.set_project_option(target_path, "plain_engine", "xetex"); rebuild() end
                    },
                    {
                      text = "  Personalizar opción",
                      action = function()
                        local def = current_opts.plain_cmds and current_opts.plain_cmds["xetex"] or ""
                        menu_builder.create_input({ prompt = "Ops xetex: ", default = def }, function(input)
                          if input then
                            local cmds = vim.tbl_deep_extend("force", {}, current_opts.plain_cmds or {})
                            cmds["xetex"] = input
                            config.set_project_option(target_path, "plain_cmds", cmds)
                          end
                          rebuild()
                        end)
                      end
                    },
                    { text = "  ⬅  Volver", action = rebuild }
                  }
                })
              end
            },
            { text = "  ⬅  Volver", action = rebuild }
          }
        })
      end
    })
    
    table.insert(menu_options, {
      text = "2. Modo Continuo: [" .. tostring(current_opts.continuous) .. "]",
      action = function()
        config.set_project_option(target_path, "continuous", not current_opts.continuous)
        rebuild()
      end
    })
  else
    table.insert(menu_options, {
      text = "1. Usar latexmk: [" .. tostring(current_opts.use_latexmk) .. "]",
      action = function()
        config.set_project_option(target_path, "use_latexmk", not current_opts.use_latexmk)
        rebuild()
      end
    })
    
    if current_opts.use_latexmk then
      table.insert(menu_options, {
        text = "2. Motor: [latexmk -" .. (current_opts.engine or "pdflatex") .. "]",
        action = function()
          menu_builder.create_menu({
            title = "Motor",
            prompt = "Selecciona motor:",
            options = {
              { text = "  pdflatex", action = function() config.set_project_option(target_path, "engine", "pdflatex"); rebuild() end },
              { text = "  xelatex",  action = function() config.set_project_option(target_path, "engine", "xelatex"); rebuild() end },
              { text = "  lualatex", action = function() config.set_project_option(target_path, "engine", "lualatex"); rebuild() end },
              { text = "  ⬅  Volver", action = rebuild }
            }
          })
        end
      })
      
      table.insert(menu_options, {
        text = "3. Personalizar opción (latexmk_options)",
        action = function()
          local def = current_opts.latexmk_options or ""
          menu_builder.create_input({ prompt = "Opciones latexmk: ", default = def }, function(input)
            if input then
              config.set_project_option(target_path, "latexmk_options", input)
            end
            rebuild()
          end)
        end
      })
      
      table.insert(menu_options, {
        text = "4. Modo Continuo (-pvc): [" .. tostring(current_opts.continuous) .. "]",
        action = function()
          config.set_project_option(target_path, "continuous", not current_opts.continuous)
          rebuild()
        end
      })
      
      table.insert(menu_options, {
        text = "5. Configurar .latexmkrc",
        action = function()
          local root_dir = vim.fn.fnamemodify(target_path, ":p:h")
          local local_rc = root_dir .. "/.latexmkrc"
          local global_rc = vim.fn.expand("~/.latexmkrc")
          
          if vim.fn.filereadable(local_rc) == 1 then
            vim.cmd("edit " .. vim.fn.fnameescape(local_rc))
          else
            menu_builder.create_menu({
              title = ".latexmkrc no encontrado",
              prompt = "No hay archivo local. ¿Qué deseas hacer?",
              options = {
                {
                  text = "  Crear .latexmkrc local",
                  action = function() vim.cmd("edit " .. vim.fn.fnameescape(local_rc)) end
                },
                {
                  text = "  Editar .latexmkrc global (~/.latexmkrc)",
                  action = function() vim.cmd("edit " .. vim.fn.fnameescape(global_rc)) end
                },
                { text = "  ⬅  Volver", action = rebuild }
              }
            })
          end
        end
      })
    else
      table.insert(menu_options, {
        text = "2. Motor: [" .. (current_opts.engine or "pdflatex") .. "]",
        action = function()
          menu_builder.create_menu({
            title = "Motor",
            prompt = "Selecciona motor:",
            options = {
              {
                text = "  pdflatex",
                action = function()
                  menu_builder.create_menu({
                    title = "pdflatex",
                    prompt = "¿Qué deseas hacer?",
                    options = {
                      {
                        text = "  Activar",
                        action = function() config.set_project_option(target_path, "engine", "pdflatex"); rebuild() end
                      },
                      {
                        text = "  Personalizar opción",
                        action = function()
                          local def = current_opts.raw_cmds and current_opts.raw_cmds["pdflatex"] or ""
                          menu_builder.create_input({ prompt = "Ops pdflatex: ", default = def }, function(input)
                            if input then
                              local cmds = vim.tbl_deep_extend("force", {}, current_opts.raw_cmds or {})
                              cmds["pdflatex"] = input
                              config.set_project_option(target_path, "raw_cmds", cmds)
                            end
                            rebuild()
                          end)
                        end
                      },
                      { text = "  ⬅  Volver", action = rebuild }
                    }
                  })
                end
              },
              {
                text = "  xelatex",
                action = function()
                  menu_builder.create_menu({
                    title = "xelatex",
                    prompt = "¿Qué deseas hacer?",
                    options = {
                      {
                        text = "  Activar",
                        action = function() config.set_project_option(target_path, "engine", "xelatex"); rebuild() end
                      },
                      {
                        text = "  Personalizar opción",
                        action = function()
                          local def = current_opts.raw_cmds and current_opts.raw_cmds["xelatex"] or ""
                          menu_builder.create_input({ prompt = "Ops xelatex: ", default = def }, function(input)
                            if input then
                              local cmds = vim.tbl_deep_extend("force", {}, current_opts.raw_cmds or {})
                              cmds["xelatex"] = input
                              config.set_project_option(target_path, "raw_cmds", cmds)
                            end
                            rebuild()
                          end)
                        end
                      },
                      { text = "  ⬅  Volver", action = rebuild }
                    }
                  })
                end
              },
              {
                text = "  lualatex",
                action = function()
                  menu_builder.create_menu({
                    title = "lualatex",
                    prompt = "¿Qué deseas hacer?",
                    options = {
                      {
                        text = "  Activar",
                        action = function() config.set_project_option(target_path, "engine", "lualatex"); rebuild() end
                      },
                      {
                        text = "  Personalizar opción",
                        action = function()
                          local def = current_opts.raw_cmds and current_opts.raw_cmds["lualatex"] or ""
                          menu_builder.create_input({ prompt = "Ops lualatex: ", default = def }, function(input)
                            if input then
                              local cmds = vim.tbl_deep_extend("force", {}, current_opts.raw_cmds or {})
                              cmds["lualatex"] = input
                              config.set_project_option(target_path, "raw_cmds", cmds)
                            end
                            rebuild()
                          end)
                        end
                      },
                      { text = "  ⬅  Volver", action = rebuild }
                    }
                  })
                end
              },
              {
                text = "  tectonic",
                action = function()
                  menu_builder.create_menu({
                    title = "tectonic",
                    prompt = "¿Qué deseas hacer?",
                    options = {
                      {
                        text = "  Activar",
                        action = function() config.set_project_option(target_path, "engine", "tectonic"); rebuild() end
                      },
                      {
                        text = "  Personalizar opción",
                        action = function()
                          local def = current_opts.raw_cmds and current_opts.raw_cmds["tectonic"] or ""
                          menu_builder.create_input({ prompt = "Ops tectonic: ", default = def }, function(input)
                            if input then
                              local cmds = vim.tbl_deep_extend("force", {}, current_opts.raw_cmds or {})
                              cmds["tectonic"] = input
                              config.set_project_option(target_path, "raw_cmds", cmds)
                            end
                            rebuild()
                          end)
                        end
                      },
                      { text = "  ⬅  Volver", action = rebuild }
                    }
                  })
                end
              },
              {
                text = "  arara",
                action = function()
                  menu_builder.create_menu({
                    title = "arara",
                    prompt = "¿Qué deseas hacer?",
                    options = {
                      {
                        text = "  Activar",
                        action = function() config.set_project_option(target_path, "engine", "arara"); rebuild() end
                      },
                      {
                        text = "  Personalizar opción",
                        action = function()
                          local def = current_opts.raw_cmds and current_opts.raw_cmds["arara"] or ""
                          menu_builder.create_input({ prompt = "Ops arara: ", default = def }, function(input)
                            if input then
                              local cmds = vim.tbl_deep_extend("force", {}, current_opts.raw_cmds or {})
                              cmds["arara"] = input
                              config.set_project_option(target_path, "raw_cmds", cmds)
                            end
                            rebuild()
                          end)
                        end
                      },
                      { text = "  ⬅  Volver", action = rebuild }
                    }
                  })
                end
              },
              {
                text = "  pythontex",
                action = function()
                  menu_builder.create_menu({
                    title = "pythontex",
                    prompt = "¿Qué deseas hacer?",
                    options = {
                      {
                        text = "  Activar",
                        action = function() config.set_project_option(target_path, "engine", "pythontex"); rebuild() end
                      },
                      {
                        text = "  Personalizar opción",
                        action = function()
                          local def = current_opts.raw_cmds and current_opts.raw_cmds["pythontex"] or ""
                          menu_builder.create_input({ prompt = "Ops pythontex: ", default = def }, function(input)
                            if input then
                              local cmds = vim.tbl_deep_extend("force", {}, current_opts.raw_cmds or {})
                              cmds["pythontex"] = input
                              config.set_project_option(target_path, "raw_cmds", cmds)
                            end
                            rebuild()
                          end)
                        end
                      },
                      { text = "  ⬅  Volver", action = rebuild }
                    }
                  })
                end
              },
              { text = "  ⬅  Volver", action = rebuild }
            }
          })
        end
      })
      
      table.insert(menu_options, {
        text = "3. Modo Continuo: [" .. tostring(current_opts.continuous) .. "]",
        action = function()
          config.set_project_option(target_path, "continuous", not current_opts.continuous)
          rebuild()
        end
      })
    end
  end
  
  -- Configuración de Carpeta de Salida
  local out_status = current_opts.use_out_dir and current_opts.out_dir_name or "Deshabilitado"
  table.insert(menu_options, {
    text = "▶ Carpeta de Salida: [" .. out_status .. "]",
    action = function()
      menu_builder.create_menu({
        title = "Carpeta de Salida",
        prompt = "¿Qué deseas configurar?",
        options = {
          {
            text = "  Activar/Desactivar Carpeta Externa: [" .. tostring(current_opts.use_out_dir) .. "]",
            action = function() 
              config.set_project_option(target_path, "use_out_dir", not current_opts.use_out_dir)
              rebuild() 
            end
          },
          {
            text = "  Cambiar Nombre de Carpeta: [" .. (current_opts.out_dir_name or "build") .. "]",
            action = function()
              menu_builder.create_input({ prompt = "Nombre de carpeta: ", default = current_opts.out_dir_name or "build" }, function(input)
                if input and input ~= "" then
                  config.set_project_option(target_path, "out_dir_name", input)
                end
                rebuild()
              end)
            end
          },
          { text = "  ⬅  Volver", action = rebuild }
        }
      })
    end
  })
  
  -- Opción de compilar siempre al final
  table.insert(menu_options, {
    text = "▶  ¡Compilar Ahora!",
    action = function()
      require("arttexcompiler").api.start(bufnr)
    end
  })
  
  menu_builder.create_menu({
    title = "Configuración del Compilador",
    prompt = "Destino: " .. filename,
    options = menu_options
  })
end

--- Punto de entrada público. Detecta la raíz del proyecto actual y lanza el constructor del menú.
--- Lanza una alerta si el usuario intenta configurarlo en un buffer que no pertenece a un proyecto LaTeX.
--- @param bufnr number|nil ID del buffer (0 por defecto).
function M.open_menu(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local root = workspace.api.get_root_file(bufnr)
  local current_filepath = vim.api.nvim_buf_get_name(bufnr)
  
  -- 1. Forzar que el archivo actual sea la raíz si es PlainTeX puro (\bye)
  local is_plain = (vim.bo[bufnr].filetype == "plaintex")
  if not is_plain and current_filepath and current_filepath ~= "" then
    local lines = vim.fn.readfile(current_filepath, "", -50)
    if lines then
      for _, line in ipairs(lines) do
        if line:match("\\bye%s*$") or line:match("\\bye%s*%%") or line == "\\bye" then
          is_plain = true
          break
        end
      end
    end
  end
  
  if is_plain then
    root = current_filepath
  end
  
  if not root then
    vim.notify("ArtTeX: No se detectó proyecto para configurar.", vim.log.levels.WARN)
    return
  end
  
  -- 2. Si es un módulo de un proyecto gigante (y no es plaintex)
  if root ~= current_filepath then
    vim.notify("ArtTeX: Módulo detectado. Configurando raíz: " .. vim.fn.fnamemodify(root, ":t"), vim.log.levels.INFO)
  end
  
  build_main_menu(bufnr, root)
end

return M
