"""
TP5 - Sistema de Gestión FitChain
Parte D.2.a - SQL Injection: corrección con Prepared Statements
Comisión 3K03

El driver envía el texto SQL y los datos de forma separada:
cualquier carácter especial ('  ;  --) presente en el input se
trata como texto literal y no como código ejecutable, eliminando
la superficie de ataque demostrada en D2a_sql_injection.sql.
"""

import psycopg2


def login(input_email: str, input_pass: str):
    conn = psycopg2.connect(
        "dbname=fitchain user=postgres password=xxxx host=localhost"
    )
    cur = conn.cursor()

    # Placeholders posicionales (%s) nativos de psycopg2
    query = "SELECT * FROM CREDENCIAL_ACCESO WHERE email=%s AND passwordHash=%s"

    # Los parámetros se envían como tupla separada de la cadena SQL:
    # psycopg2 los escapa y tipa correctamente antes de mandarlos al motor
    cur.execute(query, (input_email, input_pass))
    result = cur.fetchall()

    cur.close()
    conn.close()
    return result


if __name__ == "__main__":
    # Ejemplo de uso; con esta implementación los 3 ataques de
    # D2a_sql_injection.sql dejan de funcionar porque el texto
    # inyectado (', ;, --) se trata como dato, no como código.
    login("socio@fitchain.com", "miClaveSegura123")
