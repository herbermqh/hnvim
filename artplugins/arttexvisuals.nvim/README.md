# 🎨 ArtTeX Visuals (`arttexvisuals.nvim`)

**ArtTeX Visuals** es el "Puente de Mando" interactivo del ecosistema ArtTeX. Su propósito es dotar a Neovim de capacidades "WYSIWYG" (Lo que ves es lo que obtienes) mediante interfaces gráficas nativas e integración de Llamadas a Procedimientos Remotos (RPC) con aplicaciones externas.

Este plugin elimina la fricción de programar estructuras LaTeX complejas a mano.

## 🌟 Arquitectura y Módulos

Actualmente el plugin se estructura en tres pilares interactivos:

### 1. Generador Visual de Tablas (`ArtTexVisualTable`)
Permite abrir una **Hoja de Cálculo Flotante** directamente en Neovim. En lugar de lidiar con los símbolos `&` y `\\` a mano, este módulo te permite moverte por una cuadrícula tipo Excel, rellenar datos y exportar instantáneamente el código `\begin{tabular}` perfectamente alineado a tu documento.

### 2. Editor Matemático Externo (`ArtTexVisualMath`)
¿Extrañas *MathType* o *Word* para ecuaciones gigantes? Este módulo utiliza la tecnología `msgpack-rpc` de Neovim para comunicarse bidireccionalmente con un programa nativo (escrito en C/C++). 
Al invocarlo, se abre una interfaz gráfica externa real donde puedes hacer clic en símbolos y construir fracciones visuales. Al presionar "Enviar", el programa en C++ inyecta silenciosamente el código LaTeX en tu sesión de Neovim.

### 3. Generador de Gráficas TikZ (`ArtTexVisualGraph`)
*(En planificación)*. Un asistente visual interactivo para construir diagramas, ejes `pgfplots` y nodos TikZ sin necesidad de escribir la geometría a mano.

## 🚀 Comandos de Usuario

Puedes mapear los siguientes comandos a tus atajos favoritos (recomendamos bajo la letra `<leader>v` de Visuals):

* `:ArtTexVisualTable` ➔ Inicia la cuadrícula para Tablas.
* `:ArtTexVisualMath` ➔ Inicia el puente RPC con la aplicación C++ de ecuaciones.
* `:ArtTexVisualGraph` ➔ Inicia el asistente de gráficas.

## 🛠️ Filosofía de Desarrollo

El ecosistema **ArtTeX** cree firmemente que *Neovim debe ser rápido y enfocado en texto*, pero que las tareas puramente visuales (como armar una gran matriz o diseñar una tabla larga) deben asistirse con herramientas visuales de primera categoría. Al separar estas interfaces en un plugin independiente, logramos mantener nuestro motor de edición y compilación a 0% de uso de CPU, llamando a los asistentes pesados solo cuando realmente los necesitamos.
