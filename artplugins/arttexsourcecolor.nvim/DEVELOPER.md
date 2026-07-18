# 🛠️ ArtTex SourceColor - Developer Guide

Este documento proporciona información crítica sobre el diseño arquitectónico del coloreado semántico, los puentes de comunicación y cómo exprimir el máximo rendimiento de Neovim a través del sistema Decoration Provider (`virtual_engine.lua`).

## 🏗️ Arquitectura del Sistema

A diferencia de `arttexconceal`, que establece marcadores persistentes (`extmarks`) tras eventos físicos (`on_lines`), `arttexsourcecolor` utiliza la API **`nvim_set_decoration_provider`** de Neovim. Esto significa que **dibuja sus decoraciones directamente en el bucle de renderizado de la interfaz gráfica** (bucle en C) justo milisegundos antes de que el texto sea enviado a la pantalla. No hay "persistencias" y no hay "basura residual"; todo sucede al vuelo, efímeramente.

### Grafo de Componentes y Flujo de Interacción

```mermaid
graph TD
    Init[init.lua\nEntry Point & Autocmds] --> Bridge[workspace_bridge.lua\nListen to ArtTexWorkspace]
    Bridge --> Config[config.lua\nEnvironment Keywords & JSON]
    
    Init --> Virt[virtual_engine.lua\nHigh-Performance Decorator]
    UI[ui.lua\nLive Config Menus] --> Virt
    UI --> Bridge
    
    Virt --> Tq[Treesitter Query\nBuilt dynamically per options]
    Virt --> Win[on_win Event\nCaching & Clear State]
    Win --> Line[on_line Event\nRender colors dynamically]
    
    Line --> Cache[M.labels_cache\nValidating References]
    Line --> DepthCache[frame_cache\nO(N) Fast Depth Engine]
    
    Line --> Screen((Pantalla de Neovim))
```

## 🧩 Motores Principales y Componentes Clave

### 1. `virtual_engine.lua` (El Corazón de Alto Rendimiento)
El proveedor de decoraciones (`decoration_provider`) es invocado por la pantalla de Neovim **cada vez** que se dibuja una ventana o se desplaza (scroll).
- **`on_win`:** Se ejecuta al iniciar el renderizado de una ventana. Aquí limpiamos el `frame_cache` (un caché generacional por frame para prevenir la duplicación de escaneos y mantener un tiempo $O(N)$), y determinamos si el documento tiene etiquetas para reciclar.
- **`on_line`:** Se dispara para **cada línea** individual que está estrictamente visible en el viewport. Por lo tanto, si tu documento tiene un millón de líneas, pero solo ves 50 en pantalla, el costo de CPU equivale únicamente a buscar tokens sobre esas 50 líneas.
- **`clear_all()`:** Asegura que en caso de desactivación del plugin, la basura efímera y del renderizado no quede trabada en múltiples buffers. Se debe invocar iterando sobre `nvim_list_bufs()`.

### 2. `workspace_bridge.lua`
Escucha a otros ecosistemas (usualmente `arttexworkspace`). Por ejemplo, si el usuario define a nivel global de su espacio de trabajo que "theorem" o "proof" es un entorno válido, el Bridge sincroniza este contexto hacia la configuración y fuerza que `virtual_engine.lua` regenere sus sentencias (`string.format`) en el objeto de Treesitter Query en caliente.

### 3. Resolutor de Profundidad (Depth Caching Engine)
*Ubicado internamente en `virtual_engine.lua`*.
Para resolver los colores recursivos arcoíris (`RainbowBrackets`), no se puede recorrer desde la hoja hasta la raíz y luego iterar por los descendientes en cada línea de la pantalla; esto generaría retrasos (stutters). 
El módulo implementa un motor `traverse()` y un registro de contenedor `frame_cache`. La primera vez que una línea renderiza un delimitador anidado complejo, rastrea a todos los elementos adyacentes del contenedor y los cachea simultáneamente para las siguientes ejecuciones de esa misma porción de pantalla ($O(N^2)$ a $O(N)$ algorítmico real).

### 4. Resaltado Selectivo de Errores y Entornos Semánticos
El `virtual_engine.lua` tiene filtros contra el spam. Si la consulta extrae el tag `ERROR`, un `_G.arttex_error_ignore_cache` intercepta el archivo original de la captura. Si el usuario está trabajando dentro de un paquete nativo de `LaTeX` compilado `.sty` importado externamente, silenciaremos el parpadeo y los subrayados visuales del *linter*, manteniendo tu concentración exclusiva sobre tu espacio de trabajo real.

## 📌 Guía Rápida para Modificaciones de Interfaz y Gráficos

* **Si el Plugin comienza a causar 'lag' al escribir:** Verifica que nadie haya agregado lógica compleja, *I/O bloqueante* o búsquedas regulares pesadas dentro del evento **`on_line`** de `virtual_engine.lua`. Todo en `on_line` debe ser $O(1)$ resolviéndose idealmente de una tabla generada o cacheada previamente.
* **Si deseas crear un nuevo color o regla virtual:**
  1. Define tu Query de captura semántica en `get_virt_query`.
  2. Evalúa en el loop de `on_line` con `if name == "TuCaptura"`.
  3. Ejecuta un extmark usando el flag crítico `ephemeral = true`, de lo contrario corres riesgo de ahogar la memoria del búfer actual.
