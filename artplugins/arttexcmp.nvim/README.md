# ArtTeX Cmp (`arttexcmp.nvim`)

Un plugin de autocompletado avanzado, diseñado específicamente para integrarse como fuente de datos en `nvim-cmp`. Construido sobre el conocimiento estructural extraído por `arttexworkspace`, ofrece autocompletado en tiempo real con **cero latencia** (consumo ultra-bajo de RAM y CPU).

## Características Principales
- ⚡ **Zero-Latency**: Todo el proceso de parseo está hiperoptimizado. Usa sets de búsqueda `O(1)` y un sistema inteligente de caché granular (por archivo basado en `mtime`) para evitar leer discos o bloquear la interfaz.
- 🧠 **Citas y Referencias Vivas**: Autocompleta llaves de bibliografía desde archivos `.bib` (`\cite{...}`) y etiquetas locales o cruzadas del proyecto (`\ref{...}`).
- 📦 **Reconocimiento Estructural**: Se integra con `arttexworkspace` para entender en todo momento qué paquetes has importado, qué macros IA ha deducido que actúan como comandos, y la topología de tus archivos.
- 🎨 **Interfaz Interactiva**: Trae una UI flotante para personalizar qué comandos desencadenan el autocompletado en tiempo real. No requiere que edites manualmente tus Dotfiles para personalizar macros.

## Instalación
Si usas `lazy.nvim` y posees el ecosistema ArtTeX instalado, el plugin se registra así:

```lua
{ 
  dir = vim.fn.stdpath("config") .. "/artplugins/arttexcmp.nvim", 
  ft = "tex", 
  dependencies = { "arttexworkspace" }, 
  config = function() require("arttexcmp").setup() end 
}
```

Asegúrate de agregar `arttex` a tus `sources` en la configuración de tu `nvim-cmp`:

```lua
cmp.setup.filetype({ "tex", "plaintex" }, {
  sources = cmp.config.sources({
    { name = 'arttex' },  -- <--- Registrado
    { name = 'buffer' },
  })
})
```

## Uso
El plugin es automático. Solo entra a modo inserción y comienza a escribir:
- `\begin{` o `\end{` para entornos.
- `\usepackage{` para paquetes importados en el proyecto.
- `\cite{` para desplegar todas tus referencias bibliográficas en los archivos `.bib`.
- `\ref{` para listar todos los `\label{}` extraídos nativamente de los documentos.
- `\input{`, `\include{`, `\includegraphics{` para sugerir archivos del workspace.

## Personalización Visual (Comando: `:ArtCmpConfig`)

Puedes acceder en cualquier momento al dashboard interactivo tipeando:
**`:ArtCmpConfig`** (O presionando `<leader>loa` si tienes el atajo configurado).

Este menú flotante te permite añadir o quitar macros personalizados (ej: si has creado `\artcite{}` o `\miref{}`) para que el autocompletador los reconozca al vuelo. Todo se guarda persistentemente en un archivo JSON local.
