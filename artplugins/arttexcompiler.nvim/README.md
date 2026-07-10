# ArtTeX Compiler

Segundo módulo del ecosistema `ArtTeX`. Un compilador de LaTeX y PlainTeX asíncrono y altamente personalizable para Neovim.

## Características
- **Interfaz Interactiva:** Configuración de motores y banderas en tiempo real con una interfaz flotante premium sin tocar código.
- **Soporte Universal:** Soporta `latexmk` como orquestador primario, o motores puros directos (`pdflatex`, `xelatex`, `lualatex`, `tectonic`, `arara`, `pythontex`).
- **Modo Continuo Híbrido:** Usa `-pvc` de latexmk de manera nativa, y emula un modo continuo perfecto usando `BufWritePost` para motores puros y PlainTeX.
- **Soporte PlainTeX:** Detección de proyectos PlainTeX puros con soporte para `pdftex`, `luatex` y `xetex`.
- **Persistencia JSON:** Toda tu configuración se guarda a nivel de proyecto (`.nombre_proyecto.arttex.json`), respetando tu flujo global.
- **Comandos Seguros:** Prompts de compilación de raíz interactivos para evitar compilar submódulos por error.

## Comandos Disponibles
- `:ArtTexCompile`: Inicia la compilación usando las reglas del proyecto (aplica `latexmk` o el motor puro según tu configuración).
- `:ArtTexMenuCompilatorConfig`: Abre la **interfaz gráfica** para configurar tu compilador (Motor, latexmk, modo continuo, banderas).
- `:ArtTexStatus`: Muestra el estado del compilador en tu proyecto actual.
- `:ArtTexStop`: Detiene cualquier compilación continua o proceso activo del documento actual.
- `:ArtTexStopAll`: Destruye todos los procesos de compilación globales de todos tus proyectos a la vez.
- `:ArtTexClean`: Elimina archivos auxiliares del proyecto.

## Configuración (Opcional)
Puedes personalizar los valores **globales por defecto** del compilador (los que se usarán en proyectos nuevos) a través del método `setup()` en tu `init.lua`. Recuerda que si configuras algo usando el menú `:ArtTexMenuCompilatorConfig`, esos cambios tendrán prioridad a nivel local.

```lua
require("arttexcompiler").setup({
  -- ¿Usar latexmk como orquestador por defecto? (Recomendado: false para ligereza, true para proyectos grandes)
  use_latexmk = false,
  
  -- Motor por defecto para LaTeX
  engine = "pdflatex",           
  
  -- Opciones adicionales pasadas a latexmk (Ej. "-shell-escape")
  latexmk_options = "",
  
  -- Activar compilación continua por defecto (-pvc o emulación BufWritePost)
  continuous = false,
  
  -- Mostrar menú de confirmación UI al compilar desde un submódulo
  confirm_subfile_compilation = true,
  
  -- Destinar compilación a una carpeta específica para mantener limpia la raíz
  use_out_dir = false,     -- Por defecto está apagado al instalar el plugin
  out_dir_name = "build",  -- Nombre de la carpeta por defecto
  
  -- Banderas y comandos por defecto para Motores Puros (Cuando use_latexmk = false)
  raw_cmds = {
    pdflatex = "--shell-escape -interaction=nonstopmode -synctex=1",
    lualatex = "--shell-escape -interaction=nonstopmode -synctex=1",
    xelatex = "--shell-escape -interaction=nonstopmode -synctex=1",
    tectonic = "-X compile --synctex",
    arara = "",
    pythontex = ""
  },

  -- Opciones exclusivas para archivos PlainTeX (Sin \documentclass)
  plain_engine = "pdftex", 
  plain_cmds = {
    pdftex = 'pdftex --shell-escape -interaction=batchmode -synctex=1 %S',
    luatex = 'luatex --shell-escape -interaction=batchmode -synctex=1 %S',
    xetex  = 'xetex --shell-escape -interaction=batchmode -synctex=1 %S'
  }
})
```

## Arquitectura
Este plugin está fuertemente integrado con `arttexworkspace`. Toda la detección de raíces y lectura de clases (`\documentclass`) se realiza mediante sus analizadores AST, asegurando que un submódulo jamás se confunda con un proyecto, a menos que el usuario lo anule intencionalmente desde el menú.
