# Capítulo 7: Referencia de la API Pública

## 7.1 Módulo `arttexworkspace.api`

### `get_root_file(bufnr)`
Retorna la ruta absoluta del archivo maestro (`main.tex`) asociado al buffer dado.
- **Parámetros**: `bufnr` (number) - Opcional. ID del buffer. Si es `nil` o `0`, usa el buffer actual.
- **Retorno**: `string|nil`
- **Uso Crítico**: Evita llamar a esta función en bucles (loops) de resaltado sintáctico. Es rápida, pero depende de lectura de memoria.

### `get_dependencies(main_path)`
Retorna el grafo de dependencias estáticas (librerías y archivos incluidos) para un proyecto.
- **Parámetros**: `main_path` (string) - Ruta absoluta al archivo maestro.
- **Retorno**: `table` (Array de strings con rutas absolutas).

## 7.2 Estructura del Caché `.arttex.json`
Para sobrevivir a cierres inesperados de Vim (crash survival), todo el árbol y las macros inyectadas dinámicamente se guardan en `.arttex.json` junto al archivo maestro.

```json
{
  "estructura_manual_usuario": {},
  "estructura_aprendida_ia": {
    "\\myPersonalMacro": {
      "definition": "Macro custom del usuario",
      "line": 42
    }
  },
  "project_tree": [
    "/home/user/documento/capitulo1.tex"
  ],
  "packages": [
    "amsmath",
    "fisica"
  ]
}
```
Este archivo actúa como un volcado de memoria (memory dump). Al reabrir Neovim, el sistema lee este JSON en `1ms`, saltándose la heurística de Ripgrep y el parser léxico, garantizando que Neovim abra *instantáneamente*, sin importar si el proyecto LaTeX tiene 20,000 líneas de código.

---
*Este documento ha sido generado mediante los agentes de ArtTeX. Representa la estructura base de la documentación definitiva del ecosistema.*
