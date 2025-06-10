import numpy as np

def entropy(x):
    # Znajdź unikalne symbole i ich ilość wystąpień
    symbols, counts = np.unique(x, return_counts=True)
    # Oblicz prawdopodobieństwa
    p = counts / counts.sum()
    # Oblicz entropię H = -sum(p * log2(p))
    H = -np.sum(p * np.log2(p))
    return H, symbols, p

x1 = [0, 1, 2, 3, 3, 2, 1, 0]
x2 = [0, 7, 0, 2, 0, 2, 0, 7, 4, 2]
x3 = [0, 0, 0, 0, 0, 0, 0, 15]

for i, x in enumerate([x1, x2, x3], start=1):
    H, symbols, p = entropy(x)
    print(f"x{i}:")
    print(f"  Unikalne symbole: {symbols}")
    print(f"  Prawdopodobieństwa: {p}")
    print(f"  Entropia H(x) = {H:.4f} bitów na symbol\n")
