---
name: neovim_mcp
description: Habilidad que conecta al agente directamente con la instancia activa de Neovim del usuario a través de un servidor MCP.
---

# Habilidad: Conexión y Control de Neovim via MCP

Esta skill instruye al agente sobre cómo usar el servidor MCP de Neovim (`mcp-neovim-server`) para leer buffers, ejecutar comandos de vim, obtener el estado, e incluso realizar ediciones y búsquedas dentro del entorno activo del usuario.

## Capacidades:
1. **Acceso al Buffer**: Leer y escribir en los buffers abiertos.
2. **Navegación y Búsqueda**: Buscar patrones en todo el proyecto usando el servidor.
3. **Manejo de Ventanas**: Dividir ventanas, cerrar y navegar por pestañas.
4. **Ejecución de Comandos**: Ejecutar comandos de Vim nativos directamente.

## Instrucciones para el Agente (LLM):
1. Antes de interactuar con el entorno de Neovim, verifica si se requiere usar el script de validación `scripts/validador_hook.py`.
2. Para hacer cambios, prefiere usar las herramientas de edición de MCP expuestas (ej. `vim_edit`, `vim_search_replace`, `vim_command`).
3. El servidor MCP ya expone las herramientas necesarias. ¡Úsalas!
