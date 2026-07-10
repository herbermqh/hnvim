# ArtTeX Workspace - Manual Oficial

ArtTeX Workspace es un motor avanzado de resolución de dependencias y estado para proyectos gigantes en LaTeX dentro de Neovim.

## Para el Usuario (Configuración)

### 1. Resolución Automática de Raíz
Cuando abres un archivo `.tex` profundo (ej. `teoria.tex`), el plugin intentará:
1. Buscar un marcador rápido como `\documentclass`
2. Buscar tu archivo de memoria `.arttexmain` en directorios superiores
3. Preguntarte interactivamente si no encuentra nada. Al seleccionar el maestro, se generará el marcador `.arttexmain` para que no vuelva a preguntar.

### 2. Detección de Estructura e IA Interactiva
El plugin no usa reglas estáticas. Contiene un **Macro Analyzer** que lee tu disco duro y aprende cómo estructuras tus libros, sincronizándose a la velocidad de la luz mediante cachés JSON.

**El Grafo de Conocimiento (Knowledge Graph) - `.arttex.json`**
Cada vez que guardas un archivo, el plugin actualiza silenciosamente un archivo de caché único por cada documento (Ej: `.fisicapre.arttex.json`). Este archivo tiene 5 bloques principales:

```json
{
  "manual_macros": {
    "micomando_raro": ["%s/manual.tex"]
  },
  "auto_macros": {
    "chapterfile": ["%s/teoria.tex", "%s/problemas_resueltos.tex"]
  },
  "project_tree": [
    "/Ruta/Al/Proyecto/main.tex",
    "/Ruta/Al/Proyecto/caps/cinematica/teoria.tex"
  ],
  "packages": [ "minted", "amsmath" ],
  "commands": [ "vectorFuerza" ]
}
```

**¿Cómo puedes personalizar la estructura tú mismo?**
Si el analizador automático no comprende tu código, puedes obligarlo editando manualmente el archivo `.arttex.json`.
Cualquier regla que escribas dentro del bloque `"manual_macros"` es la **Autoridad Máxima**. El plugin jamás borrará esta sección y usará tus reglas por encima de todo lo que él haya aprendido en `"auto_macros"`.

**IA Interactiva (Tecla `gf`)**
Si pones el cursor sobre una macro nueva y presionas `gf` (Go to File):
1. **Heurística Silenciosa:** El plugin buscará en el disco duro patrones válidos. Si encuentra el archivo, aprenderá la macro y te llevará al instante.
2. **Asistente:** Si no lo encuentra, abrirá una ventana flotante para preguntarte: *¿Dónde va este archivo?*. Al responder, el plugin guardará tu respuesta en `manual_macros` para no volver a preguntarte jamás.

Al hacer todo esto, ArtTeX actualizará en vivo el `project_tree` y generará un **`.fls` sintético** para engañar a tu LSP (TexLab) y obligarlo a entender tu proyecto complejo sin errores, incluso si borras el `.fls` original.

---

## Para el Desarrollador (Arquitectura del Plugin)

El plugin está estrictamente modularizado siguiendo el principio de Responsabilidad Única.

### Estructura de Directorios
- `init.lua`: Punto de entrada, define la API pública (`M.api`) y autocmds. Sin lógica de negocio.
- `core/`:
  - `config.lua`: Maneja el *merge* de configuraciones del usuario.
  - `log.lua`: Utilidad para notificaciones `vim.notify`.
  - `state.lua`: Caché en memoria. Guarda qué buffer pertenece a qué `main.tex`.
- `discovery/`:
  - `root_resolver.lua`: Responsable de subir por el sistema de archivos buscando `.arttexmain` o `.texlabroot` para anclar un subarchivo a su proyecto padre.
  - `project_tree.lua`: Motor híbrido FLS/Regex. Exporta `get_dependencies(main_path)` para obtener todos los archivos involucrados. Genera `.fls` sintéticos.
- `parsers/`:
  - `macro_analyzer.lua`: El motor de IA. Aprende comandos, paquetes y macros leyendo `.cls` y `.sty`, gestionando el Knowledge Graph `.arttex.json`.
  - `semantic.lua`: Evaluador del árbol en memoria (Aplica reglas JSON al documento).
- `ui/`:
  - `menu_builder.lua`: Creador de ventanas flotantes responsivas (auto-ajusta su tamaño dinámicamente) integrable con `pill-highlighter`.
  - `goto_file.lua`: Secuestra `gf` proveyendo fallbacks heurísticos e interacción de aprendizaje con el usuario.

### Flujo de Ejecución y Zero-Lag Policy
- El escaneo de macros solo ocurre al abrir Neovim si el JSON **no existe**.
- Al guardar un `.tex` (`BufWritePost`), el analizador actualiza el JSON de manera asíncrona usando `vim.loop.fs_scandir` (con filtro a carpetas pesadas como `IMAGES`).
- Esto garantiza tiempos de inicio de `0.0ms` y consumo mínimo de recursos.
