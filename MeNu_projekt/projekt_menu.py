import numpy as np
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt

c = 3e8  
f = 900e6  
w = 2 * np.pi * f  
nx = 500  # number of spatial points
nt = 5000  # number of time points
dtdx = 0.2  # time-space resolution ratio
len_wave = c / f  # wavelength of RF wave
k = 2 * np.pi / len_wave  # wave number
xx = 3 * len_wave  # total spatial domain
dx = xx / nx  # spatial step size
dt = dtdx * dx / c  # time step size
x = np.linspace(0, xx, nx + 1)  # spatial grid points
num_realizations = 100  # number of Monte Carlo realizations

# results storage
wave_data = np.zeros((num_realizations, nx + 1))

for r in range(num_realizations):

    epsilon = 1 + 0.1 * np.random.randn(nx + 1) 
    q = (c * dt / (dx * np.sqrt(epsilon))) ** 2  # CFL condition c* delta t/ delta x <=1
    
    # initial conditions
    u0 = np.sin(-k * x)  # electric field
    v0 = w * np.cos(-k * x)  # magnetic field -> derivative of electic one
    u1 = u0 + dt * v0  # electric at the next time step
    U = [u0, u1]  # solutions for visualization -> would be nice to show sth

    # let's the battle begin -> time integration loop here PDE is solved using iterative algorithm !!!
    for n in range(1, nt):
        u2 = np.zeros(nx + 1)  # placeholder for the next time step
        for j in range(2, nx):  # here you updated interior points
            u2[j] = (q[j] * (u1[j + 1] - 2 * u1[j] + u1[j - 1])+ 2 * u1[j] - u0[j])
        
        # boundary conditions  -> for periodicaly
        u2[0] = q[0] * (u1[1] - 2 * u1[0] + u1[-1]) + 2 * u1[0] - u0[0]
        u2[-1] = u2[0]

        # update fields for next time step
        u0, u1 = u1, u2
        U.append(u2)

    # results for this realization
    wave_data[r, :] = U[-1]

# mean and standard deviation -> make some use from those Monte Carlo realisations
mean_wave = np.mean(wave_data, axis=0)
std_wave = np.std(wave_data, axis=0)

plt.figure(figsize=(10, 6))
plt.plot(x, mean_wave, 'b', label='Mean Wave Amplitude')
plt.fill_between(x, mean_wave - std_wave, mean_wave + std_wave, color='r', alpha=0.3, label='Standard Deviation')
plt.grid()
plt.xlabel('x [m]')
plt.ylabel('Wave Amplitude')
plt.title('Wave Propagation')
plt.legend()
plt.show()
