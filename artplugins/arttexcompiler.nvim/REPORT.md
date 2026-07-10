# Informe Técnico de Desarrollo: `arttexcompiler`

## 1. Visión General
Se ha diseñado y construido un plugin modular para Neovim escrito 100% en Lua llamado **`arttexcompiler`**. Su objetivo es reemplazar y superar la funcionalidad monolítica de VimTeX, adhiriéndose a las mejores prácticas de Arquitectura de Software, Código Limpio y Trazabilidad exigidas en las "Reglas de Oro" del usuario.

El compilador funciona como una aplicación de microservicios: delega la búsqueda de archivos al kernel `arttexworkspace` y se encarga exclusivamente de la ejecución en segundo plano y análisis de errores.

---

## 2. Arquitectura y Control de Procesos (Regla 11 OS)

### Asincronía Pura
- En lugar de usar comandos bloqueantes (`!latexmk` o `os.execute`), el motor utiliza la API de Neovim `vim.fn.jobstart`.
- Todo el proceso de compilación corre en hilos paralelos (background jobs), permitiendo al usuario seguir editando código sin que la interfaz se congele un solo milisegundo.

### Singleton y Prevención de Zombies
- **Estado en RAM:** Existe un gestor de estados (`state.lua`) que funciona como una tabla hash en memoria. Registra el PID y estado de cada compilador activo usando la ruta de `main.tex` como llave.
- **Prevención de Colisiones:** Si el usuario intenta lanzar una compilación cuando ya existe un proceso corriendo para ese documento, el plugin lo intercepta y lo impide, ahorrando ciclos de CPU.
- **Limpieza Absoluta (VimLeavePre):** Se programó un *Autocommand* que rastrea si Neovim o la terminal se cierran bruscamente. En ese escenario, el plugin mata todos los procesos y PIDs hijos antes de cerrarse, garantizando que **nunca quedarán procesos huérfanos** consumiendo RAM en segundo plano en Windows/WSL.

---

## 3. Inteligencia de Compilación (Sub-Archivos)
Al estar conectado al plugin `arttexworkspace`, el compilador es inmune a los errores por "módulos":
- Si el usuario edita un archivo incrustado (ej. `capitulo1.tex` insertado vía `\input`), el compilador no intentará compilar el módulo suelto.
- El compilador interrogará a la memoria y descubrirá quién es el archivo raíz (`main.tex`). La compilación siempre se lanzará sobre el archivo maestro de forma segura, incluso estando a varios subdirectorios de distancia.

---

## 4. Analizador de Errores Gráfico (Quickfix / Trouble)
El plugin incluye un motor analizador (`quickfix.lua`) diseñado como una "Caja de Cristal":
- **Parseo Inteligente:** Lee el archivo `.log` generado por LaTeX buscando el formato estándar de `-file-line-error`. 
- **Interfaz Híbrida:** Convierte los errores y rutas relativas en rutas absolutas, alimentando directamente la lista nativa de errores de Neovim (`qflist`).
- **Integración Premium:** Si detecta que el usuario tiene instalado el plugin gráfico de élite `trouble.nvim`, abrirá esa interfaz automáticamente para mostrar los errores categorizados; de lo contrario, usará la ventana inferior tradicional como respaldo de seguridad.
- **Fácil de Expandir:** El código Lua usa RegEx simples, facilitando enormemente agregar reglas futuras (como detectar *Overfull hbox*).

---

## 5. Flexibilidad de Ejecución (Nativo vs Bypass)
Se le otorgó al usuario el control absoluto sobre cómo se ejecutan los motores mediante 3 niveles de personalización en la configuración:

1. **Modo Nativo (Default):** `use_native_latexmkrc = true`. El plugin se hace a un lado y ejecuta `latexmk`, dejando que éste obedezca las reglas del archivo `.latexmkrc` instalado global o localmente en el SO.
2. **Modo Inyección:** `inject_cmds_to_latexmk = true`. Sigue usando `latexmk` pero le inyecta comandos crudos de shell-escape y configuraciones del usuario a través de scripts Perl por debajo (`-e $pdflatex=...`).
3. **Modo Bypass Total:** Si se desactivan las dos opciones anteriores, el plugin **elimina a latexmk de la ecuación**. Construye el comando crudo (ej. `pdflatex -synctex=1 main.tex`) y lo ejecuta directamente en la terminal.

### Soporte Especializado para PlainTeX
- El sistema detecta automáticamente si el archivo actual no posee `\documentclass` (es decir, Neovim lo cataloga como `plaintex`).
- Si detecta `plaintex`, ignora `latexmk` y utiliza la opción Bypass Total automáticamente para compilarlo con el comando definido por el usuario (ej. `pdftex %S`).
- Incluye el comando de auxilio `:ArtTexCompilePlain` para forzar esto manualmente.

---

## 6. API Pública de Comandos
El ecosistema completo expone los siguientes comandos:
- `:ArtTexCompile` -> Inicia la compilación inteligente.
- `:ArtTexCompilePlain` -> Fuerza la compilación cruda usando `pdftex`.
- `:ArtTexStop` -> Detiene (kill) el compilador asociado al documento actual.
- `:ArtTexStopAll` -> Botón de emergencia global que aniquila todos los compiladores LaTeX corriendo en WSL/Linux.
- `:ArtTexClean` -> Localiza y elimina la "basura" (archivos auxiliares) del directorio del proyecto actual.
- `:ArtTexStatus` -> Muestra en un print los procesos de compilación activos.
- `:ArtTexErrors` -> Re-abre la ventana de diagnóstico (`Trouble` o `Quickfix`) forzando la lectura del último archivo `.log`.

---
**ESTADO DEL MÓDULO:** COMPLETADO, ESCALABLE Y BLINDADO.
