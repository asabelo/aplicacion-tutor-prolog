# no ejecutable

class Sandwich:
    def __init__(self, pan1, pan2, relleno):
        self.pan1 = pan1
        self.pan2 = pan2
        self.relleno = relleno

    def __str__(self):
        return f"{self.pan1} {self.relleno} {self.pan2}"

def hacer_sandwich(pan1, pan2, relleno):
    sandwich = Sandwich(pan1, pan2, relleno)
    return f"Sándwich pa ti, campeón: {sandwich}"