import numpy as np
import scipy.io

# Generate a complex vector x of size 1x1024 with random values
N = 1024
real_part = np.random.randn(N)  # Real part with normal distribution
imag_part = np.random.randn(N)  # Imaginary part with normal distribution
x = real_part + 1j * imag_part  # Combine to form complex vector

# Save the vector in MATLAB format
scipy.io.savemat('x.mat', {'x': x})

# Save the vector in a format readable by C/C++
with open('xcpp.dat', 'wb') as file:
    for value in x:
        file.write(np.array([value.real, value.imag], dtype=np.float64).tobytes())