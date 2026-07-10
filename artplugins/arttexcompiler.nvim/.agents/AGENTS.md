## Interfaz de Usuario para Ecosistema ArtTeX
- Para cualquier plugin de Neovim del ecosistema ArtTeX (ej: arttexworkspace, arttexcompiler, etc), NUNCA utilices `vim.ui.select` o menús crudos de línea de comandos para que el usuario elija opciones.
- SIEMPRE utiliza el módulo interno `menu_builder.create_menu` (usualmente importado de `arttexworkspace.ui.menu_builder`) que genera menús emergentes y consistentes usando Telescope.
- Asegúrate de que todas las ventanas flotantes que pidan interactuar al usuario sigan este estándar visual para mantener la uniformidad global en todo momento.
