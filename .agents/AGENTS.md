# Reglas Globales del Espacio de Trabajo (Rules)

Este archivo (`AGENTS.md`) define el comportamiento probabilístico del agente y del LLM para este proyecto. El sistema lo auto-detecta por estar en la carpeta `.agents/`.

## 1. LLMs y Comportamiento Base
- **Tono:** Profesional, técnico y directo.
- **Idioma:** Español.
- **Respuestas:** Siempre prioriza la eficiencia. No des explicaciones redundantes.

## 2. Comandos Recomendados (Slash Commands)
El agente debe sugerir proactivamente al usuario el uso de los siguientes comandos cuando sea apropiado:
- `/goal`: Para refactorizaciones masivas o tareas largas que el agente debe ejecutar de forma ininterrumpida.
- `/schedule`: Para programar revisiones de código periódicas o monitoreo de subagentes.

## 3. Manejo de Sesiones (Transcripts)
- **Regla de Auditoría:** Si el proyecto se vuelve complejo, el orquestador debe usar la herramienta `run_command` para buscar en el archivo de sesión (`~/.gemini/antigravity-cli/brain/<conversation-id>/.system_generated/logs/transcript.jsonl`) en lugar de preguntar cosas que ya se discutieron.

## 4. Orquestación de Subagentes
- Nunca satures tu contexto. Si una tarea requiere leer más de 5 archivos o investigar una API nueva, DEBES usar `invoke_subagent` para lanzar un trabajador (ej. rol 'Investigador').

## 5. Manejo de Plugins, Skills Externas y Hooks
- Cuando interactúes con la carpeta `.agents/plugins/`, tu obligación es empaquetar o desempaquetar configuraciones asegurándote de actualizar el archivo `README.md` de esa carpeta.
- Si añades o modificas una Skill (habilidad) que requiera ser expuesta o no esté en la ruta estándar, DEBES registrarla proactivamente editando `.agents/skills.json`. Esto garantiza que la plataforma lea correctamente su Frontmatter YAML y sea autodetectable.
- **Validación Estricta (Hooks):** Antes de usar cualquier servidor MCP o ejecutar una acción crítica, es TU OBLIGACIÓN revisar si dentro de la carpeta de la Skill existe una subcarpeta `scripts/` con un Hook (ej. `validador_hook.py`). Si existe, debes pasar tu input obligatoriamente por ese script validador mediante un comando en terminal y respetar si este aprueba o bloquea la acción.

## 6. Registro de Auto-Descubrimiento (Los 9 Pilares)
Para garantizar la autodetectabilidad completa del sistema, el orquestador debe reconocer y mapear las siguientes ubicaciones:
- **Agentes:** El orquestador principal se rige por las instrucciones de esta carpeta raíz y delega inteligentemente.
- **Subagentes:** Detectables en `.agents/subagents/`. Cada uno tiene su propio `AGENTS.md` y memoria aislada.
- **Skills:** Detectables automáticamente vía `SKILL.md` en `.agents/skills/`.
- **Comandos:** Atajos nativos de la plataforma (`/goal`, `/schedule`, etc.) listos para ser sugeridos.
- **Hooks:** Detectables como scripts en las subcarpetas `scripts/` dentro de cada Skill.
- **Sessiones:** El historial persistente autodetectable en `~/.gemini/antigravity-cli/brain/<conversation-id>/.system_generated/logs/transcript.jsonl`.
- **Rules:** Todo el comportamiento global reside explícitamente en este archivo (`.agents/AGENTS.md`).
- **LLMs:** El motor de razonamiento se ajusta a las directrices de la sección 1 (Tono y comportamiento base).
- **Memorias:** Detectables y gestionables proactivamente en `.agents/memory/` (SEMANTIC, EPISODIC, PROCEDURAL).

## 7. Arquitectura LaTeX y VimTeX
- **VimTeX y Treesitter:** NUNCA desactivar `vim.g.vimtex_syntax_enabled = 0`. Esto destruye las definiciones de `conceal` de los símbolos matemáticos (`\alpha` -> `α`) y rompe los snippets (Dev David) que dependen de `in_mathzone()`. SIEMPRE mantener `additional_vim_regex_highlighting = { "latex", "tex" }`.
- **Fábrica de Plugins:** Todos los plugins creados por IA deben vivir de forma nativa en `/home/userh/.config/nvim/artplugins/<nombre>.nvim` y ser inyectados en `lazy.nvim` mediante la directiva `dir`.
- **Desarrollo y Testing de Plugins:** Al crear o modificar plugins, DEBES conectarte a Neovim usando MCP para probarlos en tiempo real. Si la prueba falla, DEBES entrar en un bucle iterativo (reprogramar -> recargar/probar) hasta que el plugin funcione correctamente.

## 8. Arquitectura ArtTeX (Plugins Modulares)
- **Estructura Base:** El reemplazo de VimTeX se compone de 12 plugins modulares nativos en `artplugins/` bajo el prefijo `arttex*` (ej. `arttexworkspace`, `arttexcompiler`, `arttexsynctex`).
- **Nomenclatura:** Los plugins NO deben llevar guiones en su nombre ni en la carpeta ni en el nombre del módulo Lua.
- **Comunicación e Independencia:** Cada plugin exporta una API pública estructurada en la tabla `M.api`. TODOS los plugins deben funcionar de manera totalmente independiente y desacoplada entre sí, con UNA única excepción: **`arttexworkspace`**.
- **Dependencia Central:** El plugin `arttexworkspace` es el núcleo absoluto de la arquitectura. Todos los demás plugins dependen de él para obtener el estado y la raíz del proyecto LaTeX (vía `require("arttexworkspace").api.get_root_file()`).
- **Persistencia y Memoria:** El agente asume esta arquitectura como verdad absoluta para cualquier sesión futura. No requiere que el usuario le vuelva a explicar la división de los 12 plugins ni sus reglas de dependencia.

## 9. Aprendizaje Proactivo y Documentación (Regla Inquebrantable)
- **Meta-Aprendizaje Autónomo (Auto-Refinamiento):** El agente tiene **PROHIBIDO** esperar a que el usuario le ordene guardar un nuevo estándar, convención de diseño, o patrón arquitectónico. En el momento en que se acuerda una mejora o se toma una decisión técnica (ej. uso de un plugin específico, un color, un comando), el agente DEBE editar proactivamente este archivo `AGENTS.md` en segundo plano para asimilar el conocimiento de manera permanente.
- **Arquitectura de Responsabilidad Única (Modularización):** Todos los plugins deben estar organizados en subcarpetas lógicas dentro de `lua/<plugin_name>/` (ej. `core/`, `ui/`, `parsers/`, `discovery/`). Se prohíbe crear archivos monolíticos de más de 300 líneas. Si un archivo crece o asume dos responsabilidades (ej. buscar rutas y dibujar menús), DEBE ser dividido en módulos independientes para garantizar escalabilidad extrema y fácil lectura para el usuario.
- **Auto-documentación Continua:** A medida que se desarrollan o modifican plugins, el agente DEBE documentar autónomamente (sin que el usuario se lo pida) las funciones, APIs públicas expuestas (`M.api`), atajos de teclado creados y su uso general.
- **Mapeo Centralizado:** Toda esta información técnica debe volcarse progresivamente en un archivo de memoria persistente dedicado a la documentación técnica (ej. `.agents/memory/API_MAP.md`).
- **Objetivo:** Garantizar que en el futuro exista un mapa exacto de la arquitectura construida que sirva para generar documentación automática o para que otros subagentes sepan exactamente qué APIs están disponibles para consumir.

## 10. Trazabilidad Global (Regla Inquebrantable)
- **Sistema de Logs:** TODO plugin desarrollado debe implementar o consumir un sistema de trazabilidad (Logs). Las funciones internas y de estado clave deben registrar sus decisiones (`TRACE`, `DEBUG`, `INFO`, `ERROR`) de manera silenciosa en un archivo de log (ej. `~/.cache/nvim/arttex.log`).
- **Propósito:** El usuario nunca debe estar ciego ante los procesos del ecosistema ArtTeX. Si algo falla o no se comporta como el usuario espera, debe poder leer el log y saber el "por qué".
- **Dependencia:** El sistema de log base será administrado por el plugin central `arttexworkspace`.

## 11. Estándares de Ingeniería y Arquitectura (Regla Inquebrantable)
- **Calidad de Código y Diseño:** TODO desarrollo de plugin en este ecosistema DEBE regirse estrictamente por los más altos estándares de ingeniería de software. Esto incluye:
  - **Arquitectura de Sistemas Operativos:** Uso de Microkernels, separación de procesos (módulos), manejadores de estado tipo memoria, y buses de comunicación mediante eventos (Pub/Sub).
  - **Arquitectura de Software y Base de Datos:** Principios SOLID, alta cohesión, bajo acoplamiento, Singletons justificados para caché/estado y estructuras de datos eficientes para consultas O(1).
  - **Clean Code:** Funciones con responsabilidad única, nombramiento claro y semántico de variables (sin abreviaturas crípticas), y código altamente legible.
  - **Manejo de Errores y Trazabilidad:** Todo posible punto de fallo debe ser interceptado (ej. mediante `pcall` en Lua) y volcado inmediatamente al sistema de trazabilidad (Logs) con su stack trace, en lugar de bloquear el editor del usuario.

## 12. Generación Inteligente de Plugins e Interfaces
- **Estado del Arte en IA:** Se deben utilizar las últimas tecnologías, paradigmas y mejores prácticas de inteligencia artificial para estructurar y desarrollar el código de los plugins.
- **Creación Automática de Comandos:** Por cada funcionalidad principal desarrollada en un plugin, el agente DEBE generar comandos nativos de Neovim (`vim.api.nvim_create_user_command`) de forma automática.
- **Exposición Exclusiva de Comandos (No Hardcodear Atajos):** Los plugins desarrollados DEBEN limitar su alcance a la creación de comandos (`vim.api.nvim_create_user_command`) o APIs públicas. Tienen **ESTRICTAMENTE PROHIBIDO** inyectar o hardcodear atajos de teclado usando `which-key.nvim` o `vim.keymap.set` dentro del propio código fuente del plugin.
- **Delegación a `whichkey-config.lua`:** Todos los atajos de teclado del ecosistema LaTeX son de gusto personal del usuario. La configuración de atajos debe realizarse directa y únicamente en `/home/userh/.config/nvim/lua/whichkey-config.lua`. El agente debe crear el comando en el plugin y luego ir al archivo de configuración del usuario para registrar el atajo.
- **Enfoque Open Source (GitHub):** Todos los plugins deben ser diseñados para ser publicados en repositorios de GitHub. El código debe ser genérico, altamente configurable y aplicable a cualquier usuario. NUNCA quemar (hardcode) rutas o variables específicas del entorno local.
- **Documentación Exhaustiva y Continua:** Es obligatorio redactar y mantener actualizada la documentación (ej. `README.md`, ayuda nativa de Neovim o archivos markdown locales) detallando qué se está haciendo, la arquitectura, cómo se manejan los plugins, sus comandos y atajos de teclado.

## 13. Diseño de Interfaces (UI/UX) y Estética Visual
- **Integración con el Ecosistema del Usuario:** Toda interfaz flotante (menús, pop-ups, prompts) DEBE integrarse de manera fluida y nativa con el diseño general del Neovim del usuario. No se deben crear interfaces genéricas o rudimentarias.
- **Librería UI Estandarizada:** Para la selección de opciones en CUALQUIER plugin de ArtTeX futuro, es **OBLIGATORIO** utilizar la librería genérica que hemos construido: `require("arttexworkspace.ui").create_menu(opts)`. Nunca se debe reescribir lógica de ventanas flotantes (`vim.api.nvim_open_win`) directamente en los plugins individuales.
- **Uso Estricto de la Paleta de Colores:** Se debe utilizar única y exclusivamente la familia de colores del tema configurado por el usuario (actualmente **`tokyonight.nvim`**). Esto significa usar variables como `#7aa2f7` (Azul TokyoNight), `#2e3c64` (Fondo de selección), etc. Nunca inventar colores arbitrarios (ej. nada de neones genéricos si no coinciden con el esquema).
- **Reutilización de Componentes Core (Pill-Highlighter):** El motor gráfico central (`arttexworkspace.ui`) consumirá por debajo el plugin `require('pill-highlighter')` y aplicará `winhl = "Normal:Normal"` con bordes redondeados curvos para igualar matemáticamente la opacidad y ocultar el cursor de hardware.
- **Navegación Premium:** Las interfaces deben soportar atajos inmediatos (hotkeys) y navegación direccional estándar (`j`, `k`, `<Up>`, `<Down>`, `<CR>`) comportándose como menús modernos de videojuegos o Dashboards, en lugar de depender exclusivamente del input clásico de consola.
### Performance and Optimization (Zero-Lag Policy)
1. **Never Block the Main Thread**: All heavy operations (file scanning, parsing, compiling) must be offloaded using `vim.schedule`, `vim.loop` (libuv asynchronous threads), or executed in background jobs.
2. **Aggressive Caching**: Startup time is sacred. Do not parse massive file trees on `BufEnter` if a cache exists (e.g., using `.json` memory files).
3. **Filter Noise**: When scanning directories natively, always ignore heavy static folders like `IMAGES`, `JUPY`, `.git`, or `build` instantly to save CPU cycles.

## 14. Regla General Estricta: Ecosistema ArtTeX
- **Personalización Extrema:** Todo plugin `arttex*` DEBE ser lo más personalizable posible. Siempre debe existir un módulo de configuración (`config.lua`) que exponga opciones claras y modificables por el usuario al llamar a la función `setup(opts)`. Las opciones no pueden estar "hardcodeadas".
- **Máxima Eficiencia (Mínimo Consumo):** El código debe consumir la menor cantidad de recursos (memoria y CPU) posible, apoyándose fuertemente en ejecución bajo demanda, hilos asíncronos (`vim.system`, `vim.schedule`) y delegación estricta (Zero-lag).
- **Documentación Exhaustiva:** Es un requisito obligatorio e innegociable generar documentación detallada sin omitir NINGÚN detalle (ya sea a través de un archivo `README.md` exhaustivo dentro de la carpeta del plugin, ayuda en `vimdoc` o mapas de API) para que el usuario o futuros desarrolladores comprendan perfectamente la arquitectura y configuración.
