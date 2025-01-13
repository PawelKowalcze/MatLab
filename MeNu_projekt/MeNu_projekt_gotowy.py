# Propagacja fali elektromagnetycznej z losowymi zaburzeniami ośrodka wprowadzonymi metodą Monte Carlo

import numpy as np
import matplotlib

matplotlib.use('TkAgg')
import matplotlib.pyplot as plt

c = 3e8
f = 1400e6
w = 2 * np.pi * f
num_spatial_points = 500  # number of spatial points
num_time_steps = 5000  # number of time points
dtdx = 0.2  # time-space resolution ratio
wavelength = c / f  # wavelength of RF wave
wave_number = 2 * np.pi / wavelength  # wave number
total_spatial_domain = 3 * wavelength  # total spatial domain
dx = total_spatial_domain / num_spatial_points  # spatial step size
dt = dtdx * dx / c  # time step size
spatial_grid = np.linspace(0, total_spatial_domain, num_spatial_points + 1)  # spatial grid points
num_realizations = 100  # number of Monte Carlo realizations

# results storage
wave_realizations = np.zeros((num_realizations, num_spatial_points + 1))

for realization in range(num_realizations):

    epsilon = 1 + 0.1 * np.random.randn(num_spatial_points + 1)
    q = (c * dt / (dx * np.sqrt(epsilon))) ** 2  # CFL condition c* delta t/ delta x <=1

    # initial conditions
    u0 = np.sin(-wave_number * spatial_grid)  # electric field
    v0 = w * np.cos(-wave_number * spatial_grid)  # magnetic field -> derivative of electric one
    u1 = u0 + dt * v0  # electric at the next time step
    U = [u0, u1]  # solutions for visualization

    # time integration loop -> PDE is solved using iterative algorithm
    for time_step_index in range(1, num_time_steps):
        u2 = np.zeros(num_spatial_points + 1)  # placeholder for the next time step
        for j in range(2, num_spatial_points):  # update interior points
            u2[j] = (q[j] * (u1[j + 1] - 2 * u1[j] + u1[j - 1]) + 2 * u1[j] - u0[j])

        # periodic boundary conditions
        u2[0] = q[0] * (u1[1] - 2 * u1[0] + u1[-1]) + 2 * u1[0] - u0[0]
        u2[-1] = u2[0]

        # update fields for next time step
        u0, u1 = u1, u2
        U.append(u2)

    # results for this realization
    wave_realizations[realization, :] = U[-1]

# mean and standard deviation -> make some use from those Monte Carlo realizations
mean_wave = np.mean(wave_realizations, axis=0)
std_wave = np.std(wave_realizations, axis=0)

# Calculate deviations from the mean
deviations = np.sum((wave_realizations - mean_wave) ** 2, axis=1)

# Find the indices of the two most deviated realizations
most_deviated_indices = np.argsort(deviations)[-2:]

# Plot all results simultaneously
fig, axs = plt.subplots(3, 1, figsize=(10, 18))

# Plot mean and standard deviation
axs[0].plot(spatial_grid, mean_wave, 'g', label='Mean Wave Amplitude')
axs[0].fill_between(spatial_grid, mean_wave - std_wave, mean_wave + std_wave, color='orange', alpha=0.4,
                    label='Standard Deviation')
axs[0].grid()
axs[0].set_xlabel('x [m]')
axs[0].set_ylabel('Wave Amplitude')
axs[0].set_title('Wave Propagation')
axs[0].legend()

# Plot the two most deviated realizations
for i, index in enumerate(most_deviated_indices):
    axs[i + 1].plot(spatial_grid, wave_realizations[index, :], label=f'Realization {index + 1}')
    axs[i + 1].grid()
    axs[i + 1].set_xlabel('x [m]')
    axs[i + 1].set_ylabel('Wave Amplitude')
    axs[i + 1].set_title(f'Most Deviated Realization {i + 1}')
    axs[i + 1].legend()

plt.tight_layout()
plt.show()
