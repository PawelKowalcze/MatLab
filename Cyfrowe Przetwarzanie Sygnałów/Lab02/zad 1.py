import numpy as np

# Parametry
N = 20
s = np.sqrt(2 / N)
s0 = np.sqrt(1 / N)

# Funkcja do generowania wzorców kosinusowych
def generate_dct_matrix(N):
    A = np.zeros((N, N))
    for k in range(N):
        sk = s0 if k == 0 else s
        for n in range(N):
            A[k, n] = sk * np.cos((np.pi * k / N) * (n + 0.5))
    print(A)
    return A

# Generowanie macierzy analizy A
A = generate_dct_matrix(N)

# Sprawdzanie ortonormalności wektorów
def check_orthonormality(A):
    N = A.shape[0]
    for i in range(N):
        for j in range(i, N):
            dot_product = np.dot(A[i], A[j])
            print(f"Skalarne iloczyny wektorów {i} i {j}: {dot_product}")
            #Sprawdż czy iloczyn skalarny jest równy 1 dla i=j i 0 dla i!=j
            if i == j:

                if not np.isclose(dot_product, 1):
                    return False
            else:
                if not np.isclose(dot_product, 0):
                    return False
    return True

# Sprawdzenie ortonormalności
is_orthonormal = check_orthonormality(A)
print(f"Macierz analizy A jest ortonormalna: {is_orthonormal}")

