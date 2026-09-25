#!/usr/bin/env python3
import sys
import json
import os
import subprocess
import urllib.request

def wsl_to_linux(win_path):
    # Normalizar a forward slashes para facilitar la evaluación
    normalized = win_path.replace("\\", "/")
    
    # Si la ruta ya es absoluta en Unix (gracias al nuevo parche de SumatraPDF), 
    # no usar wslpath, solo limpiar el './' y devolver.
    if normalized.startswith("/"):
        return os.path.normpath(normalized)
    
    # Manejar rutas UNC nativas de WSL
    if normalized.startswith("//wsl.localhost/"):
        parts = normalized.split("/")
        # parts[0]="", parts[1]="", parts[2]="wsl.localhost", parts[3]="Ubuntu"
        if len(parts) >= 4:
            return "/" + "/".join(parts[4:])
    elif normalized.startswith("//wsl$/"):
        parts = normalized.split("/")
        if len(parts) >= 4:
            return "/" + "/".join(parts[4:])

    try:
        result = subprocess.run(['wslpath', '-u', win_path], capture_output=True, text=True, check=True)
        return result.stdout.strip()
    except:
        return normalized

def find_server_addr(tex_file, registry_path):
    if not os.path.exists(registry_path):
        return None
    
    with open(registry_path, 'r') as f:
        registry = json.load(f)
    
    # We don't know the exact root_file, but tex_file is inside the project
    # Find the longest matching root_dir
    best_match = None
    best_len = 0
    server_addr = None
    
    for root_file, addr in registry.items():
        root_dir = os.path.dirname(root_file)
        if tex_file.startswith(root_dir) and len(root_dir) > best_len:
            best_len = len(root_dir)
            best_match = root_file
            server_addr = addr
            
    return server_addr

def main():
    if len(sys.argv) < 4:
        print("Error: Not enough arguments. Expected: tex_file line registry_path")
        sys.exit(1)
        
    win_tex_file = sys.argv[1]
    line = sys.argv[2]
    registry_path = sys.argv[3]
    
    log_path = os.path.join(os.path.dirname(registry_path), 'inverse_search.log')
    with open(log_path, 'a') as log:
        log.write(f"\n--- New Inverse Search ---\n")
        log.write(f"Args: {sys.argv}\n")
        
        linux_tex_file = wsl_to_linux(win_tex_file)
        log.write(f"Linux path resolved: {linux_tex_file}\n")
        
        server_addr = find_server_addr(linux_tex_file, registry_path)
        log.write(f"Server address found: {server_addr}\n")
        
        if not server_addr:
            log.write(f"Error: No active Neovim session found for {linux_tex_file}\n")
            sys.exit(1)
            
        safe_file = linux_tex_file.replace("'", "\\'")
        keys = f"<C-\\><C-N>:lua require('arttexsynctex').api.handle_inverse_search('{safe_file}', {line})<CR>"
        log.write(f"Sending keys to nvim --server {server_addr}: {keys}\\n")
        
        try:
            # Timeout de 2 segundos: si nvim se queda congelado intentando enviar
            # los comandos, el timeout aborta la ejecución y MATA automáticamente
            # el proceso para evitar dejar un 'nvim' huérfano en la memoria.
            log.write(f"Ejecutando proceso nvim con timeout de 2s...\n")
            result = subprocess.run(
                ['nvim', '--server', server_addr, '--remote-send', keys], 
                capture_output=True, 
                text=True,
                timeout=2
            )
            log.write(f"Neovim remote send return code: {result.returncode}\n")
            if result.stderr:
                log.write(f"Neovim stderr: {result.stderr}\n")
                
        except subprocess.TimeoutExpired as e:
            log.write(f"[ERROR CRÍTICO] El comando remoto de Neovim se congeló tras 2 segundos.\n")
            log.write(f"[SISTEMA ANTI-ORPHAN] Matando forzosamente el subproceso nvim generado para prevenir fugas de RAM.\n")
        except Exception as e:
            log.write(f"[EXCEPCIÓN] Error inesperado lanzando nvim: {e}\n")

if __name__ == '__main__':
    main()
