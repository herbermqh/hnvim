#!/usr/bin/env python3
import sys

# ==========================================
# HOOK DETERMINISTA: Validación de Consultas
# ==========================================
# Este script representa la capa "Hook". Es determinista y no depende del LLM.
# Su función es interceptar y bloquear acciones inseguras antes de que lleguen al MCP o sistema.

def validar_query(query):
    query_lower = query.lower()
    palabras_prohibidas = ["drop", "delete", "truncate", "alter"]
    
    for palabra in palabras_prohibidas:
        if palabra in query_lower:
            print(f"[ERROR HOOK] Operación destructiva detectada: '{palabra}'. Bloqueando ejecución.")
            sys.exit(1)
            
    print("[OK HOOK] Consulta segura. Procediendo a enviar al MCP.")
    sys.exit(0)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: python validador_hook.py '<sql_query>'")
        sys.exit(1)
        
    query_a_evaluar = sys.argv[1]
    validar_query(query_a_evaluar)
