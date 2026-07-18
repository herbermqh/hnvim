# 🛠️ ArtTexConceal - Developer Guide

Este documento detalla la arquitectura interna, decisiones de diseño y flujo de datos del plugin `arttexconceal`. Está dirigido a desarrolladores que desean realizar mantenimiento, extender funcionalidades o comprender la profunda optimización de rendimiento implementada.

## 🏗️ Arquitectura del Sistema

ArtTexConceal está fuertemente acoplado con **Neovim Extmarks** y **Tree-Sitter**. Evita intencionalmente los mecanismos de *syntax match* nativos de Vimscript (que son lentos y basados puramente en regex) a favor de un análisis sintáctico semántico real.

### Grafo de Componentes y Flujo de Datos

A continuación se muestra cómo interactúan los módulos internos del plugin.

```mermaid
graph TD
    UI[ui.lua\nConfig Menus & Toggles] --> Config[config.lua\nState Management]
    Core[core.lua\nEvent Orchestrator] --> Scanner[scanner.lua\nMain Entry & Query Engine]
    Core --> UI
    
    Scanner --> Math[mathzone.lua\nCalculate Math Ranges]
    Scanner --> Lits[scanner/literals.lua\nRegex Fallback]
    Scanner --> Depth[scanner/depth.lua\nO(N) Caching Engine]
    Scanner --> Dispatch[scanner/handlers.lua\nNode Handlers Dispatch]
    
    Dispatch --> Symbols[symbols.lua\nHardcoded Maps]
    Dispatch --> ExtMarks[extmarks.lua\nNeovim API Wrapper]
    Lits --> ExtMarks
    
    ExtMarks --> Buffer[(Neovim Buffer)]
```

## 🧩 Descripción Detallada de los Módulos

### 1. `core.lua` (El Motor de Ciclo de Vida)
Es responsable de engancharse a los búferes de Neovim y manejar el "debounce" y procesamiento por chunks (lotes) de las líneas para evitar congelamientos de UI al escanear documentos largos. Utiliza `vim.api.nvim_buf_attach` para reaccionar a `on_lines`. Cuando una opción global es cambiada, la función expuesta `M.reprocess_all_buffers()` limpia los estados colgados en todos los buffers activos y los obliga a re-renderizarse desde cero.

### 2. `scanner.lua` (El Orquestador)
En lugar de compilar la consulta de Treesitter repetidamente, este módulo lo hace **una sola vez** (`vim.treesitter.query.parse`) y la almacena en caché. 
Cuando se solicita analizar un rango de líneas:
1. Pide a `mathzone.lua` que marque dónde están todas las secciones matemáticas.
2. Ejecuta el módulo de fallback literal para capturar cosas que Treesitter no parsea individualmente como nodos.
3. Itera sobre las capturas y delega inmediatamente al `handler` correspondiente.

### 3. `scanner/handlers.lua` (Tabla de Despacho)
Toda la lógica masiva de "Si esto es un comando, haz esto, si es una fracción haz lo otro" ha sido abstraída en una tabla limpia. 
Cada captura de la consulta (ej. `@cmd`, `@bracket`, `@section`) tiene asignada una función en `M.dispatch`.
Para extender el plugin y procesar una nueva estructura:
1. Agrega una captura en el String de Query en `scanner.lua`.
2. Agrega la lógica de procesamiento definiendo `M.dispatch.nombre_de_captura` en este archivo.

### 4. `scanner/depth.lua` (Optimización O(N) Crítica)
**Problema histórico:** Anteriormente, calcular el nivel de profundidad de un corchete `\left(` implicaba recorrer el árbol sintáctico hacia los padres, ubicar el contenedor delimitador de entorno y bajar a todos los hijos buscando llaves `{ }`. Hacer esto para cada corchete resultaba en una complejidad de $O(N^2)$, lo cual causaba altos picos de uso de CPU.
**Solución actual:** `depth.lua` utiliza una función `get_container_flat_depths` que:
* Recibe el ID de nodo del contenedor padre.
* Si no está en su `container_cache`, atraviesa el contenedor padre **una sola vez**.
* Guarda el cálculo de profundidad (`flat_depth`) de todos los nodos que lo componen en un mapa.
* Cuando `handlers.lua` pide la profundidad para otro nodo en el mismo párrafo, se saca del caché de manera instantánea ($O(1)$).

### 5. `themes.lua` y `highlights.lua` (Dinámicos)
Garantizan que comandos de estilos de texto como `\textbf{}` o `\textit{}` mantengan coherencia de colores. Capturan el color dinámico del texto "Normal" de la terminal e inyectan el *Foreground* en tiempo real, evitando así "fugas de color" provenientes de títulos y encabezados.

## 📌 Guía Rápida para Desarrolladores

* **Si necesitas agregar una nueva palabra clave matemática:** Ve a `symbols.lua` y agrégala al mapa `math_words`.
* **Si necesitas ocultar de manera especial una estructura (Ej: un entorno específico):** Define un nuevo Query Capture en `scanner.lua`, y procesa sus *Extmarks* dentro de `handlers.lua`.
* **Si observas problemas de memoria (Memory Leaks):** Revisa que los variables como `container_cache` en `scanner.lua` se estén re-inicializando (`{}`) correctamente por cada ejecución de `process_lines` de modo que la basura de viejos escaneos pueda ser recolectada (GC). El plugin está diseñado para ser *"Stateless"* entre re-dibujados de buffer.
