import numpy as np

# Parameters
N = 20
s = np.sqrt(2 / N)
s0 = np.sqrt(1 / N)

# Function to generate DCT-II matrix
def generate_dct_matrix(N):
    A = np.zeros((N, N))
    for k in range(N):
        sk = s0 if k == 0 else s
        for n in range(N):
            A[k, n] = sk * np.cos((np.pi * k / N) * (n + 0.5))
    print(A)
    return A

# Generate the analysis matrix A
A = generate_dct_matrix(N)

# Generate the synthesis matrix S (IDCT) by transposing A
S = A.T
print(S)
# Check if SA equals the identity matrix I
I = np.eye(N)
SA = np.dot(S, A)
print("I:" , I)
print("SA:" , SA)
is_identity = np.allclose(SA, I)
print(f"SA equals the identity matrix: {is_identity}")

# Generate a random signal
x = np.random.randn(N)

# Perform analysis: X = A * x
X = np.dot(A, x)

# Perform synthesis: xs = S * X
xs = np.dot(S, X)

# Check if the transformation has the perfect reconstruction property
is_perfect_reconstruction = np.allclose(xs, x)
print(f"Transformation has perfect reconstruction property: {is_perfect_reconstruction}")