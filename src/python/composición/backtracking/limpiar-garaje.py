def limpiar_garaje(escoba_rota, garaje_hecho_un_asco, i):
    print("El garaje está hecho un asco.")
    if not escoba_rota:
        print("La escoba está en buen estado. Limpiando el garaje...")
    elif escoba_rota and not garaje_hecho_un_asco:
        print("La escoba tiene el mango roto.")
        print("Cogiendo las herramientas del garaje...")
        arreglar_mango_escoba()
        print("Limpiando el garaje con la escoba reparada...")
        limpiar_garaje(escoba_rota, garaje_hecho_un_asco, i)
    elif i < 15:
        print("Vas a limpiarlo, pero la escoba tiene el mango roto.")
        print("Vas a por las herramientas que están en el garaje, pero está hecho un asco y no encuentras las herramientas.")
        limpiar_garaje(escoba_rota, garaje_hecho_un_asco, i + 1)
    if i == 15:
        print("A LA ****** EL GARAJE.")

def arreglar_mango_escoba():
    print("Arreglando el mango de la escoba...")
    escoba_rota = False

limpiar_garaje(True, True, 1)