# Gestor de Plugins

Un **Plugin** en esta arquitectura es un envoltorio (bundle) que empaqueta un conjunto de *Skills*, *Tools* (servidores MCP preconfigurados) y *Hooks*.

## ¿Para qué sirve esta carpeta?
Si el día de mañana desarrollas un conjunto de habilidades para "Análisis de Datos con Pandas", en lugar de tenerlas sueltas, puedes agruparlas aquí como un Plugin. 
Así, cualquier otro proyecto solo tiene que importar la carpeta del plugin para adquirir todo ese conocimiento y herramientas de golpe.

### Estructura típica de un Plugin:
```
.agents/plugins/data_science_pack/
├── manifest.json
├── skills/
│   ├── analizar_csv/
│   └── limpiar_datos/
└── mcp_servers/
    └── jupyter_mcp/
```