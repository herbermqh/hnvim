# Capítulo 5: Ciclo de Eventos Asíncronos (The Router)

## 5.1 El Bus de Neovim (`User Autocmds`)
El núcleo de Neovim provee un mecanismo para eventos personalizados. ArtTeX usa esto como un **Bus de Publicación/Suscripción (Pub/Sub)**. En lugar de exponer funciones callback complicadas en la configuración, los plugins se comunican mediante "gritos" en el sistema.

### `ArtTexWorkspaceReady`
Cuando el parser semántico termina exitosamente su trabajo (y guarda el JSON en disco), el código de `semantic.lua` ejecuta:

```lua
vim.schedule(function()
  pcall(vim.api.nvim_exec_autocmds, "User", {
    pattern = "ArtTexWorkspaceReady",
    data = { main_path = main_path }
  })
end)
```
Observa el uso de `pcall` (Protective Call). Si por alguna razón un plugin suscriptor tiene un error fatal en su lógica, el `pcall` atrapa ese error, y la cadena de inicialización de los demás módulos de ArtTeX **no se detiene**.

## 5.2 Manejo de Compiladores (Jobs)
En `arttexcompiler.nvim`, el archivo `core/job.lua` implementa un *wrapper* asíncrono sobre la API de Neovim (`vim.fn.jobstart`).

```lua
job_id = vim.fn.jobstart(cmd_args, {
  on_stdout = function(j, data, name)
    -- Recibe streaming del output de latexmk
  end,
  on_exit = function(j, return_val, name)
    -- Evalua el código de salida
    if return_val == 0 then
      log.notify("Compilación Exitosa")
    end
  end
})
```
Este jobstart permite que, mientras la compilación pesada toma unos segundos en generar un PDF complejo de 400 páginas, el usuario puede seguir escribiendo sin experimentar la temida "ventana congelada".

## 5.3 Asesino de Procesos (Zombie Reaper)
Ocurre frecuentemente que, si Neovim se cierra forzosamente (`kill -9`), el proceso hijo de `latexmk` sigue corriendo en el sistema operativo consumiendo el 100% de la CPU. 

ArtTeX incluye un recolector de basura (Reaper). Al inicializar, busca PIDs huérfanos emparejados a la ruta del archivo actual usando un escaneo a nivel shell:
`pgrep -f "latexmk.*<ruta_proyecto>"`
Y les envía señales `SIGKILL` para mantener la RAM y el procesador limpios.
