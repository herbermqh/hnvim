# ArtTeX SyncTeX (`arttexsynctex.nvim`)

Un motor de sincronización bidireccional (Forward e Inverse Search) de alto rendimiento para el ecosistema **ArtTeX** en Neovim. Este plugin conecta tu código LaTeX con múltiples visores PDF de manera fluida, agnóstica y multiplataforma.

---

## 📖 Para Usuarios

### 🚀 Instalación y Configuración
El plugin se integra automáticamente con el ecosistema ArtTeX. Para configurarlo, puedes invocar su función `setup()` en tu `init.lua`:

```lua
require("arttexsynctex").setup({
  viewer = "sumatrapdf", -- Opciones: "sumatrapdf", "zathura", "sioyek", "okular", "skim", "termpdf"
  server_port = 0,       -- 0 asigna un puerto automático dinámico
})
```

### ⌨️ Comandos de Usuario
El plugin proporciona los siguientes comandos interactivos:

- `:ArtTexForwardSearch` (Atajo recomendado: `<leader>lv`): Sincroniza la vista del PDF con la línea exacta donde se encuentra tu cursor en Neovim.
- `:ArtTexSelectViewer` (Atajo recomendado: `<leader>lV`): Abre un hermoso menú gráfico interactivo para que puedas cambiar de visor PDF sobre la marcha, sin reiniciar el editor.

### 🔄 Búsqueda Inversa (Doble Clic)
La búsqueda inversa está activada por defecto. Al hacer "doble clic" o "Ctrl + clic" (dependiendo de tu visor) en cualquier parte del PDF, Neovim saltará instantáneamente al archivo y línea de código exacta que generó esa parte del documento.

---

## 🛠️ Para Desarrolladores (Arquitectura)

Este plugin fue diseñado con la escalabilidad y el rendimiento en mente. Utiliza el **Patrón de Diseño Strategy** para desacoplar el núcleo de sincronización de la lógica específica de cada visor PDF.

### 📂 Estructura del Código

```text
lua/arttexsynctex/
├── init.lua                 -- Punto de entrada, define la API pública y Comandos.
├── config.lua               -- Gestión de opciones y configuraciones por defecto.
│
├── core/
│   ├── server.lua           -- Servidor TCP Event-Driven para Búsqueda Inversa.
│   └── viewer.lua           -- Orquestador principal de Forward Search.
│
└── viewers/                 -- Patrón Strategy (Módulos por Visor)
    ├── init.lua             -- Factory de visores.
    ├── sumatrapdf.lua       -- Adaptador para SumatraPDF (Soporte Windows/WSL).
    ├── zathura.lua          -- Adaptador nativo para Zathura.
    ├── sioyek.lua           -- Adaptador nativo para Sioyek.
    ├── okular.lua           -- Adaptador nativo para Okular.
    ├── skim.lua             -- Adaptador nativo para Skim (macOS).
    └── termpdf.lua          -- Adaptador para emuladores de terminal.
```

### 🔍 ¿Cómo funciona el Forward Search?
1. El usuario invoca `:ArtTexForwardSearch`.
2. `core/viewer.lua` identifica el archivo `.tex` actual, la posición del cursor (línea y columna) y localiza el `.pdf` asociado a la raíz del proyecto.
3. Se invoca al `viewers_factory` (`viewers/init.lua`) para instanciar el adaptador del visor activo.
4. El adaptador específico genera los comandos y argumentos CLI necesarios.
5. El comando se ejecuta en segundo plano (`detach = true`) mediante `vim.system()`, evitando la asignación de PTY para prevenir parpadeos gráficos (WezTerm/WSL glitches).

### 🔄 ¿Cómo funciona la Búsqueda Inversa?
A diferencia de los enfoques anticuados que usan `neovim-remote` o `clientserver` exponiendo los sockets globalmente, ArtTeX implementa un servidor TCP silencioso dedicado:
1. `core/server.lua` arranca un socket TCP local al iniciar un proyecto.
2. Registra el puerto dinámico en `~/.cache/nvim/arttex_sockets.json` vinculándolo a la raíz del proyecto.
3. Cuando el visor hace doble clic, ejecuta el script router universal `scripts/inverse_search.py`.
4. El script en Python intercepta la ruta del PDF, localiza el puerto correcto en el registro JSON, y envía las coordenadas a Neovim a través de la red TCP en milisegundos.
*(Esta arquitectura permite tener múltiples proyectos de Neovim abiertos sin que las señales de búsqueda inversa colisionen o abran archivos en ventanas equivocadas).*

### 🖥️ Hack de Interoperabilidad WSL (El Caso SumatraPDF)
SumatraPDF es un ejecutable nativo de Windows (`.exe`). Cuando Neovim corre dentro de WSL (Linux) e intenta invocarlo, existen choques entre los sistemas de archivos (Windows NT vs Unix).

Dentro de `viewers/sumatrapdf.lua`, implementamos una lógica robusta multiplataforma:
- **Caché Singleton:** Se compila un `VBScript` en tiempo de ejecución de Neovim y se oculta. El VBScript se utiliza para que Sumatra invoque el `inverse_search.py` sin que salten "ventanas de CMD negras" en la pantalla del usuario.
- **`wslpath` dinámico:** Traduce las rutas de Unix (`/home/...`) a rutas UNC de red WSL (`\\wsl.localhost\...`) en milisegundos.
- **Native Check:** Si la función detecta que Neovim corre nativamente en Windows (`win32`), omite la capa de traducción WSL, convirtiéndose en un código puramente nativo.
- **Inyección Magistral (`.\`):** El motor `pdflatex` inyecta un `./` en los binarios del archivo SyncTeX que los parches de SumatraPDF ignoran. Nuestro script inyecta un `.\` preventivo en la ruta CLI enviada desde WSL para garantizar un `Exact Match` durante el Suffix Matching de la librería C de SyncTeX, recuperando el famoso "recuadro amarillo" de búsqueda.
