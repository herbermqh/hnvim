# Reglas Inmutables (Memoria Semántica)

## 1. Mantenimiento de Snippets
- **REGLA ESTRICTA:** Siempre que se añada un nuevo snippet a cualquier archivo (`general.lua`, `algebra.lua`, `quimica.lua`, etc.), el agente TIENE la obligación de actualizar manualmente el archivo `~/.config/nvim/lua/luasnippets/manual_completo.md` para incluir el nuevo activador y su descripción.
- **REGLA ESTRICTA:** De la misma manera, si un snippet es modificado o eliminado, el agente DEBE ir al `manual_completo.md` y reflejar la eliminación.
- El manual debe ser considerado la fuente de verdad y nunca debe quedar desactualizado.
