# ArtTeX Workspace 🚀

**ArtTeX Workspace** es el motor inteligente definitivo para proyectos LaTeX monolíticos y modulares en Neovim. Transforma el desarrollo clásico en LaTeX a una experiencia de "Entorno de Trabajo" (Workspace) moderno de alta velocidad, enfocado en el uso intensivo de macros estructurales personalizadas.

## 🌟 Características Principales

1. **Escaneo Mágico `gf` Inteligente (Goto File)**
   ¿Tienes macros anidadas ultra complejas como `\chapterfile{dinamica}` que internamente incluyen `teoria.tex`, `pr.tex` y formularios?
   Coloca tu cursor sobre el argumento `dinamica` y presiona `gf`. La IA de ArtTeX resolverá tu macro, ubicará las dependencias y si son múltiples archivos, ¡te abrirá un hermoso menú interactivo (`pill-highlighter`) para elegir a cuál saltar!
   
2. **Caché en Memoria (0 Latencia)**
   ArtTeX carga los archivos principales de tu ecosistema LaTeX en memoria RAM interna y los parsea en O(1) ignorando el bloqueante árbol del sistema o dependencias basura de CTAN.

3. **Árbol Semántico en Tiempo Real**
   Visualiza una topología gráfica de tu proyecto. El visor no te mostrará solo el sistema de archivos del SO, sino cómo tu documento LaTeX engarza los módulos. ¡Con soporte absoluto para rutas relativas limpias y Nerd Fonts!

## 📦 Instalación (Lazy.nvim)

```lua
{
  dir = "~/.config/nvim/artplugins/arttexworkspace.nvim",
  name = "arttexworkspace",
  config = function()
    require("arttexworkspace").setup({
      -- Aquí ubicas las carpetas donde guardas tus clases (.cls) o paquetes (.sty) privados.
      -- Soporta rutas para setups híbridos WSL/Windows
      library_paths = {
        "~/Documents/LaTeX/paquetes",
        "~/Documents/LaTeX/devclass"
      }
    })
  end
}
```

## 🎮 Comandos de Uso

* **`gf`**: En modo Normal. Pon el cursor sobre cualquier nombre de comando que invoque sub-archivos y salta a ellos al instante.
* **`:ArtTexWorkspaceTree`**: Abre un árbol flotante jerárquico que desglosa en tiempo real tu estructura LaTeX. Puedes moverte con `j/k` y abrir el archivo deseado con `Enter`.

## 🧠 ¿Cómo funciona la IA Estructural? (El archivo `.arttex.json`)

En la raíz de tu proyecto, ArtTeX generará un archivo `.[nombre].arttex.json`.
Este archivo representa el **aprendizaje neuronal** del sistema.
La IA escanea tus definiciones de comandos (incluso las más sucias llenas de arrobas `@` o dependencias cíclicas anidadas inversas) y compila las reglas.

Si en algún momento el escáner falla por usar sintaxis de LaTeX ultra esotérica, tú puedes sobreescribir las reglas manualmente en el mismo archivo JSON:

```json
{
  "estructura_manual_usuario": {
    "mi_macro_loca": [
      "ruta/oculta/%s.tex"
    ]
  }
}
```

## 🔌 API Pública para otros Plugins

Puedes extender tus plugins integrándolos con la API de ArtTeX:

```lua
local api = require("arttexworkspace").api

-- Retorna la ruta absoluta del archivo "main.tex" del proyecto actual
local root = api.get_root_file(bufnr)

-- Retorna la tabla de estado (Clase usada, dependencias, engine, packages cargados)
local state = api.get_project_state(bufnr)

-- Extrae en un array las dependencias reales (módulos incluidos)
local tree_array = api.get_project_tree(bufnr)

-- Ejecuta la acción de abrir la UI Flotante del Explorador de Árbol
api.open_tree(bufnr)
```
