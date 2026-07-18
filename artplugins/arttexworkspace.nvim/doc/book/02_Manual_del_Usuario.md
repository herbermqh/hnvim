# Capítulo 2: Manual del Usuario y Configuración

## 2.1 Instalación Modular
La filosofía *Zero-Lag* obliga a que el usuario cargue los módulos perezosamente (lazy loading). Se asume el uso de `lazy.nvim` como gestor de paquetes.

```lua
return {
  {
    "arttexworkspace",
    dir = "~/.config/nvim/artplugins/arttexworkspace.nvim",
    event = "BufEnter *.tex", -- Carga condicional
    config = function()
      require("arttexworkspace").setup({
        -- Aquí se definen las librerías globales del usuario
        library_paths = {
          "~/Documents/LaTeX/paquetes",
          "~/Documents/LaTeX/devclass",
        },
      })
    end
  },
  -- Configuración de otros plugins se obvia por brevedad
}
```

## 2.2 Uso Práctico: Navegación de Proyectos (Go To Definition)
ArtTeX sobrescribe mágicamente los comandos nativos de LSP. Al colocar el cursor sobre un paquete personal (`\usepackage{fisica}`) o sobre un macro (`\maketitleexam`), presionar `gd` (Go to Definition) abrirá de forma instantánea el archivo fuente correspondiente saltando a la línea exacta, incluso si el archivo está en una carpeta global del sistema y no en el proyecto actual.

## 2.3 Magia Blanca: Magic Comments
A veces, el motor heurístico puede fallar si editas un documento LaTeX que no tiene un `\documentclass` o si el archivo `.texlabroot` está corrupto.
ArtTeX otorga el poder absoluto al usuario a través de "Magic Comments".

Escribir en la primera línea de tu archivo:
```tex
% !TEX root = ../master.tex
% !TEX engine = xelatex
```
Forzará al motor de memoria a asignar `../master.tex` como el archivo raíz y cambiará el motor de compilación asíncrono ignorando la caché.
