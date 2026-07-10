---
name: plugin_developer
description: Skill para desarrollar plugins iterativamente basándose en VimTeX, con testing MCP y validación de subagente.
---

# Procedimiento de Desarrollo de Plugins (Skill: plugin_developer)

Este skill define el flujo de trabajo obligatorio e inquebrantable para crear o refactorizar cualquier plugin del ecosistema ArtTeX. Se basa en ingeniería inversa, pruebas en caliente (MCP) y validación por un agente supervisor.

## Bucle de Desarrollo (El Kernel del Proceso)

1. **Fase de Investigación (Subagente):**
   - El orquestador (tú) debe invocar un subagente (ej. `investigador`) para que analice el código fuente original de VimTeX (`/home/userh/.gemini/antigravity-cli/scratch/vimtex`).
   - El objetivo es extraer los fundamentos, lógica base (el "kernel") y estructuras de datos del componente específico que se va a desarrollar (ej. state, compiler, synctex).

2. **Fase de Desarrollo (Orquestador):**
   - Con las ideas extraídas por el investigador, debes programar la lógica en el plugin Lua correspondiente en `artplugins/`.
   - Asegúrate de exponer la funcionalidad mediante `M.api`.

3. **Fase de Testing (MCP):**
   - Debes inyectar y ejecutar un script de prueba en Neovim vía **MCP**.
   - Se debe capturar la salida estándar (stdout) o cualquier error que arroje Neovim.

4. **Fase de Validación (Subagente Validador):**
   - Debes invocar un subagente con el rol `validador`.
   - Pásale el código que escribiste y la salida/resultado de la prueba de MCP.
   - Pide al validador que evalúe si el código es "Manejable", "Funcional" y cumple con la filosofía modular.
   
5. **Condición de Parada (El Bucle):**
   - Si el validador aprueba el código, se avanza a la fase de Documentación.
   - Si el validador rechaza el código o encuentra fallos, **DEBES REINICIAR EL BUCLE**. Vuelve a analizar el código, reescribe el plugin, vuelve a probar en MCP y vuelve a enviar al validador, iterando hasta conseguir la aprobación.

6. **Fase de Documentación (Regla Estricta):**
   Una vez aprobado el código, el orquestador DEBE generar y/o actualizar obligatoriamente dos archivos dentro de la carpeta del plugin (ej. `artplugins/arttex*/`):
   - **`README.md` (Documentación Pública):** Dirigido al usuario final y a GitHub. Debe explicar qué hace el plugin, cómo instalarlo y cómo usarlo (atajos, comandos, configuración).
   - **`DEVELOPER.md` (Documentación Privada Exhaustiva):** Dirigido exclusivamente al creador y a la IA. Debe contener una explicación detallada del comportamiento de CADA variable local/global y CADA función interna (privada) del plugin. Además, debe explicar minuciosamente el uso y el manejo de las APIs públicas (`M.api`) para que otros plugins sepan cómo interactuar. Estos archivos deben actualizarse, eliminarse o modificarse conforme el plugin evolucione.
