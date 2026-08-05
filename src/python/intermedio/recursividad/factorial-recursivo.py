numero = 5  # parámetro

def factorial_recursivo(n, profundidad=0):
    sangría = "  " * profundidad
    if n == 0:
        traza = f"{sangría}Caso base. factorial(0) = 1. Procedemos a resolver el resto del problema\n"
        return 1, traza
    else:
        traza = f"{sangría}Llamada: factorial({n}), ejecución a la espera.\n"
        resultado, traza_recursiva = factorial_recursivo(n - 1, profundidad + 1)
        resultado *= n
        traza += traza_recursiva
        traza += f"{sangría}Resolviendo llamada pendiente: factorial({n}) = {resultado}\n"
        return resultado, traza

if numero < 0:
    print("Por favor, ingresa un número no negativo.")
else:
    resultado, traza = factorial_recursivo(numero)
    print(f"Traza del cálculo recursivo del factorial de {numero}:\n")
    print(traza)
    print(f"El factorial de {numero} es: {resultado}")