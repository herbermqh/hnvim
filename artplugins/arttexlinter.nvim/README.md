# 🎨 ArtTeX Linter

**ArtTeX Linter** es un motor de análisis estático (Linting) ultrarrápido y no bloqueante para Neovim, diseñado específicamente para el ecosistema de LaTeX. Forma parte de la suite modular **ArtTeX** y está construido con una arquitectura 100% asíncrona, garantizando cero interrupciones y un rendimiento óptimo.

Mientras que servidores LSP como `texlab` se encargan de validar la sintaxis pura de LaTeX y verificar que los comandos existan, **ArtTeX Linter** se centra en el **estilo y la tipografía** (espaciado, uso correcto de guiones, puntos suspensivos, comillas, etc.), utilizando el potente motor `chktex` por debajo.

---

## 🚀 Características Principales

- **Latencia Cero (0ms):** El análisis se ejecuta en un hilo separado (C-core) utilizando `vim.uv.spawn`, lo que significa que Neovim jamás se congelará, sin importar el tamaño de tu documento.
- **Eficiencia Energética:** A diferencia de otros linters que analizan cada tecla que presionas, ArtTeX Linter se activa de forma inteligente en eventos estratégicos (por defecto `BufWritePost`, al guardar), ahorrando batería y CPU.
- **Persistencia Inteligente:** Tu configuración de encendido/apagado se guarda en un archivo `.json` local. Si lo apagas, se mantendrá apagado en tus siguientes sesiones.
- **Gestión de Falsos Positivos:** Sistema robusto para limpiar los diagnósticos automáticamente cuando el linter se desactiva en tiempo real.

---

## 🔌 Requisitos

El plugin depende del analizador estático **chktex**. Necesitas instalarlo en tu sistema operativo:

**Ubuntu / Debian / Mint:**
```bash
sudo apt update
sudo apt install chktex
```

**Arch Linux / Manjaro:**
```bash
sudo pacman -S chktex
```

**Fedora:**
```bash
sudo dnf install chktex
```

---

## ⌨️ Comandos y Atajos

El plugin se integra perfectamente con la interfaz gráfica de tu ecosistema `arttexworkspace`.

### Comandos de Usuario (User Commands)
* `:ArtLinterConfig` ➔ Abre el menú flotante interactivo para encender/apagar el linter o cambiar configuraciones.
* `:ArtTexLint` ➔ Fuerza una ejecución manual del linter en el archivo actual.

### Atajos de Teclado (Keymaps)
Si usas Which-Key en la configuración estándar:

| Atajo | Acción |
| --- | --- |
| `<leader>lL` | Abre el Menú Visual de Configuración |

---

## 💡 ¿Cómo funciona visualmente?

1. Guarda tu archivo LaTeX (`:w`).
2. Si cometes un error tipográfico (por ejemplo, escribir `1-10` en lugar de `1--10`, o escribir `...` en lugar de `\dots`), aparecerá un icono de advertencia (`` o ``) en la columna izquierda (Gutter).
3. El texto problemático se subrayará (Underline).
4. Puedes ver la sugerencia de corrección simplemente colocando el cursor sobre la línea subrayada, o abriendo una lista de problemas con herramientas como *Trouble*.

---

## ⚙️ Integración con Texlab

Para evitar advertencias duplicadas, asegúrate de que tu configuración de `texlab` (en `lsp.lua`) tenga apagado su propio `chktex`. ArtTeX Linter ya se encarga de esto de forma mucho más optimizada:

```lua
settings = {
  texlab = {
    chktex = {
      onOpenAndSave = false, 
      onEdit = false
    }
  }
}
```
