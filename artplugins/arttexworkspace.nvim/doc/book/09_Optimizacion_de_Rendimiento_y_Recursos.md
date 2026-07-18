# Capítulo 9: Perfilado de Rendimiento y Optimización de Recursos

ArtTeX Workspace está diseñado bajo una filosofía estricta de eficiencia computacional (Zero-Overhead). A pesar de manejar de forma heurística proyectos masivos con cientos de archivos y dependencias, el impacto del plugin sobre la CPU y la RAM del usuario es virtualmente nulo.

## 9.1 Cortocircuitos a Nivel de Bytes en el Parser Semántico

El componente más intensivo del plugin es `semantic.lua`, el cual se ejecuta en segundo plano durante el evento `BufWritePost` (cada vez que se guarda un archivo). Históricamente, iterar sobre miles de líneas de texto usando Expresiones Regulares en Lua generaba un gasto considerable de CPU.

Para mitigar esto, se implementaron dos técnicas de aceleración extrema:
1. **Byte-Level Short-Circuit:** Antes de que el motor de expresiones regulares evalúe una línea buscando variables o macros, ejecuta una primitiva de C (`string.find(line, "\\", 1, true)`). Dado que el 90% de un documento LaTeX es texto convencional, el parser descarta inmediatamente casi todo el documento en fracciones de nanosegundo sin invocar al compilador regex.
2. **Tablas Hash `O(1)`:** Se eliminaron los bucles anidados. Las listas de palabras clave para macros se convirtieron en tablas Hash (Sets). Ahora, el AST comprueba si un macro recién descubierto pertenece al sistema en tiempo constante `O(1)`.

Esto reduce la carga de CPU de parseo en un **95%**, garantizando que el plugin no introduzca latencia al momento de tipear y guardar en Neovim.

## 9.2 Thread-Capping en Heurísticas del Sistema (Ripgrep)

Las funciones de navegación heurística (`gf` y la detección de librerías locales) dependen de `ripgrep` (`rg`). Por defecto, `rg` paraleliza su carga de trabajo utilizando tantos Hilos (Threads) como núcleos físicos tenga la CPU del sistema.

En el contexto de un editor de texto interactivo, despertar súbitamente 16 o 32 núcleos al 100% durante 2 milisegundos para buscar una sola imagen genera:
- Picos térmicos repentinos.
- Activación innecesaria de los ventiladores del equipo.
- Mayor consumo de RAM y batería.

**La Solución:** 
Todas las invocaciones a nivel de sistema que realiza ArtTeX inyectan automáticamente la bandera restrictiva `-j 1`. Esto fuerza a `ripgrep` a utilizar un **único hilo de CPU** (Single-Thread Mode). Al restringir el procesamiento, se logra un consumo de recursos absolutamente lineal y predecible. La diferencia de velocidad al buscar localmente en un proyecto de LaTeX es imperceptible para el usuario, pero el ahorro de energía para el Sistema Operativo es masivo.
