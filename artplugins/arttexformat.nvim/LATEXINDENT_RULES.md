# 📖 Guía de Configuración: `setting_latexindent.yaml`

El archivo `setting_latexindent.yaml` es el "cerebro" detrás de las decisiones tipográficas del motor de formateo. Dictamina cómo estructurar, tabular y alinear automáticamente tu código de LaTeX.

Al estar fuertemente personalizado para tu ecosistema de apuntes y exámenes (ArtTeX / Fisica), contiene una serie de reglas especializadas. Aquí tienes la documentación detallada de cada bloque principal para que puedas escalarlo según tus necesidades.

---

## 1. 📏 `lookForAlignDelims` (Alineación en Matrices y Tablas)
Este bloque es el responsable de la magia matemática de `latexindent`. Se encarga de buscar los delimitadores (generalmente el `&`) y alinear el código verticalmente para que tu matriz sea legible antes de compilarse.

*   **Entornos Clásicos:** `tabular`, `matrix`, `array`, `align*`.
*   **Alineación:** La clave `spacesBeforeAmpersand: 1` y `spacesAfterAmpersand: 1` aseguran que haya exactamente un espacio rodeando a los `&`.
*   **Multi-Columna:** `multiColumnGrouping: 1` previene que se rompa la alineación de tablas cuando hay celdas unidas por `\multicolumn`.
*   **Tabbing / tabularx:** Tiene reglas especiales usando `delimiterRegEx` para soportar alineaciones con el tabulador estándar de LaTeX.

---

## 2. 📝 `indentAfterItems` (Entornos de Listas)
Aquí se registran **todos** los entornos que hacen uso del comando `\item`. `latexindent` necesita saber cuáles son para indentar el texto del ítem correctamente.

**Tus agregados personalizados:**
Además de los clásicos (`itemize`, `enumerate`), se han incorporado tus listas especializadas:
*   `exercises`, `questions`, `ejercicios`
*   `ejerciciosCaja`, `enumdesc`, `problist`
*   `problemasResueltasPropuestas`

*Si creas un nuevo entorno de lista en un examen futuro, ¡debes agregarlo a esta lista con valor `1`!*

---

## 3. 📦 `noAdditionalIndent` (Contenedores Especiales)
Existen entornos en LaTeX que actúan como "envoltorios de página" (wrappers). Si `latexindent` intentara ponerles sangría al cuerpo de estos entornos, **todo tu código se desplazaría** un nivel hacia la derecha innecesariamente.

Para evitarlo, la propiedad `body: 0` le dice al formateador: *"no añadas tabulación extra adentro de esto"*.
*   **Entornos Globales:** `document`, `fisica`.
*   **Columnas:** `PResueltasOneColumn`, `PResueltasOtherColumn`.
*   **Cortes/Fragmentos:** `fragment`.

---

## 4. 📐 `indentRules` e `indentRulesGlobal` (Reglas de Bloques y Comandos)
Aquí configuras el tamaño exacto de la sangría para tus comandos y bloques. La variable global está seteada para que, por defecto, todo entorno nuevo se tabule con `"  "` (2 espacios).

**Tus Comandos Importadores:**
Se han declarado comandos multilínea propios de tu ecosistema. Al declarar sus argumentos, el motor sabrá cómo ordenar las llaves `{...}` de forma escalonada.
*   `\imagebody`, `\usarproblema`, `\usarexamen`, `\usarpractica`.

---

## 5. 🔒 `verbatimEnvironments` y `noIndentBlock` (Zonas Intocables)
Hay código en LaTeX donde **un solo espacio extra puede destruir la compilación** (por ejemplo, código fuente Python incrustado, o librerías de circuitos).

*   `lstlisting`, `minted`, `verbatim`, `pythoncode`, `latexcode`, `artcircuit`.
*   Al estar en esta lista, `latexindent` ignorará por completo lo que ocurra adentro y dejará tu código de programación intacto y respetando su indentación sintáctica original.

---

## 6. 🔗 `specialBeginEnd` (Modo Matemático y Pseudocódigo)
LaTeX tiene comandos que actúan como apertura y cierre pero no tienen la sintaxis de entorno clásica (`\begin{}`).

*   **Corchetes de Ecuación:** `\[` y `\]`.
*   **Dólares (Math Mode):** `$$` y `$`.
*   **Algoritmos / Pseudocódigo:** `\If`, `\Else`, `\EndIf`.

Gracias a estas reglas, cuando envuelvas una ecuación entre `\[ ... \]`, el contenido interior recibirá automáticamente un nivel más de sangría.

---

## 💡 ¿Cómo realizar modificaciones?
Si en el futuro creas un paquete nuevo o un nuevo diseño de documento:
1. Abre el archivo pulsando el atajo rápido `<leader>lr` (o el comando `:ArtFormatEditRules`).
2. Agrega el nombre de tu nuevo entorno o comando en la sección correspondiente (ej. si es una lista, añádelo en `indentAfterItems`).
3. Guarda el archivo (`:w`).
4. **Listo.** No tienes que reiniciar Neovim, los próximos documentos que formatees usarán tus nuevas reglas automáticamente al presionar `<leader>lf`.
