---
name: base_de_datos_mcp
description: Habilidad auto-detectable que actúa como cliente para conectarse a un Servidor MCP de base de datos.
---

# Habilidad: Conexión a Base de Datos via MCP

Esta skill instruye al agente sobre cómo usar un servidor MCP externo para bases de datos.
Al estar dentro de `.agents/skills/`, el sistema lee el bloque YAML superior automáticamente y me hace "consciente" de esta habilidad sin gastar tokens extra leyendo todo el archivo.

## Instrucciones para el Agente (LLM):
1. Cuando necesites datos, no los inventes.
2. Ejecuta el hook de validación localizado en `scripts/validador_hook.py` antes de cualquier operación.
3. Conéctate al servidor MCP (que expone sus herramientas dinámicamente mediante el protocolo Model Context Protocol).
4. Pasa la consulta validada al MCP.
