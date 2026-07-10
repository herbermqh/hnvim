# Manual del Desarrollador (Developer Docs) - arttexcompiler

Diseñado bajo la **Regla Inquebrantable 11**, este plugin implementa una arquitectura modular de micro-servicios, altamente dependiente del Event Bus (Pub/Sub) del plugin base `arttexworkspace`.

## Arquitectura Interna

### 1. `state.lua` (Gestor de Procesos)
- Actúa como el administrador de procesos del "Sistema Operativo" ArtTeX.
- Mantiene un Singleton mapeando `main_path` -> `job_id`.
- Garantiza que nunca haya dos compiladores corriendo simultáneamente para el mismo proyecto (evita colisiones y bloqueos de CPU).

### 2. `job.lua` (Controlador de I/O Asíncrono)
- Extrae la información interrogando al `arttexworkspace`.
- **Modo LaTeX:** Ensambla el comando para `latexmk`. Inyecta un script Perl diminuto (`-e`) a `latexmk`. Esto hace que grite a través de `stdout` las palabras mágicas `arttex_success` o `arttex_failure`.
- **Modo PlainTeX:** Si detecta que es `plaintex`, **bypassea a `latexmk` completamente**. Llama a la shell cruda (`sh -c`) para ejecutar binarios como `pdftex` de manera directa. Lee el `Exit Code` del proceso (0 para éxito, otro para error) para mantener la asincronía.
- Maneja el hilo (job) con `vim.fn.jobstart` de manera 100% no bloqueante.

### 3. `init.lua` (Facade y API)
- Expone los comandos del usuario (`ArtTexCompile`, `ArtTexStop`, `ArtTexClean`).
- Contiene la API de integración (`get_compilation_state`, `get_status_string`) diseñada para que plugins externos (como Lualine o Noice) puedan leer el estado del compilador sin romper la asincronía.

### 4. `config.lua` (Gestor de Opciones)
- Administra opciones `globales` (definidas por `.setup()`) y `locales` (guardadas en un archivo oculto `.nombre.arttex.json` por proyecto).
- Almacena variables booleanas cruciales (como `use_out_dir`, `use_latexmk`) e inyecta propiedades.

### 5. Interfaz Gráfica (`ui/`)
- **`menu.lua`**: Usando Telescope vía el `menu_builder` del workspace, permite alterar opciones como motores y carpetas de salida sin necesidad de comandos complejos. Re-renderiza en caliente (recursividad) para reflejar cambios.
- **`output.lua`**: Administra Buffers y Ventanas (Windows) flotantes en Neovim para emular una terminal interactiva que vuelca `stdout/stderr` y captura interrupciones (C-c, C-z).
- **`quickfix.lua`**: Posee un algoritmo heurístico temporal que analiza `fs_stat.mtime` para buscar el archivo `.log` más reciente (en `root`, `build/` o un directorio de salida personalizado). Procesa el log y abre `Trouble.nvim` (o `copen`) mostrando la línea exacta del error LaTeX.

## Dependencias
- Requiere de `arttexworkspace.nvim` obligatoriamente (usa su API de estado y su logger).
