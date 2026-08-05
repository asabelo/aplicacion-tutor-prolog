numero = 5  # parámetro

def factorial_iterativo(n):
    factorial = 1
    traza = ""
    for i in range(1, n + 1):
        factorial *= i
        traza += f"Iteración {i}: factorial = {factorial}\n"
    return traza, factorial

if numero < 0:
    print("Por favor, ingresa un número no negativo.")
else:
    traza, resultado = factorial_iterativo(numero)
    print(f"Traza del cálculo iterativo del factorial de {numero}:\n")
    print(traza)
    print(f"El factorial de {numero} es: {resultado}")