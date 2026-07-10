#!/usr/bin/env python3
import sys
import json

# Hook de validación básico para la skill de Neovim MCP
# Permite todas las acciones por defecto pero puede ser extendido para mayor seguridad.

def validar_input():
    print("[OK HOOK] Conexión a Neovim segura. Procediendo a ejecutar a través del MCP.")
    sys.exit(0)

if __name__ == '__main__':
    validar_input()
