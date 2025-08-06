import numpy as np
import matplotlib.pyplot as plt
from sys import argv
from scipy import interpolate

d_hinge = float(argv[1])
d_dihed = float(argv[2])
d_quat = float(argv[3])

# Read the data
hinge_dihed_data = np.loadtxt("hinge_dihed_pmf.txt")
q1_q5_data = np.loadtxt("q1_q5_pmf.txt")
centers = np.loadtxt("../1-pot/centers.temp")
hinges = hinge_dihed_data[:, 0]
diheds = hinge_dihed_data[:, 1]
hinge_dihed_pmf = hinge_dihed_data[:, 2]
q1 = q1_q5_data[:, 0]
q5 = q1_q5_data[:, 1]
q1_q5_pmf = q1_q5_data[:, 2]

# Create grids
hinge_grid_temp = np.arange(np.min(hinges), np.max(hinges) + d_hinge, d_hinge)
dihed_grid_temp = np.arange(np.min(diheds), np.max(diheds) + d_dihed, d_dihed)
hinge_grid, dihed_grid = np.meshgrid(hinge_grid_temp, dihed_grid_temp)
hinge_dihed_pmf_grid = interpolate.griddata((hinges, diheds), hinge_dihed_pmf, (hinge_grid, dihed_grid), method="cubic")

q1_grid_temp = np.arange(np.min(q1), np.max(q1) + d_quat, d_quat)
q5_grid_temp = np.arange(np.min(q5), np.max(q5) + d_quat, d_quat)
q1_grid, q5_grid = np.meshgrid(q1_grid_temp, q5_grid_temp)
q1_q5_pmf_grid = interpolate.griddata((q1, q5), q1_q5_pmf, (q1_grid, q5_grid), method="cubic")

# Create plots for hinge vs dihedral
plt.figure()
plt.contourf(hinge_grid, dihed_grid, hinge_dihed_pmf_grid, cmap="coolwarm")
plt.plot(centers[:, 0], centers[:, 1], color="black", linewidth=2, linestyle="-", label="Reaction Trajectory")
plt.colorbar()
plt.title("PMF in hinge and dihedral space")
plt.xlabel("Hinge (degrees)")
plt.ylabel("Dihedral (degrees)")
plt.savefig("hinge_dihed.pdf", format="pdf", bbox_inches="tight")
plt.close()

# Create plots for q1 vs q5
plt.figure()
plt.contourf(q1_grid, q5_grid, q1_q5_pmf_grid, cmap="coolwarm")
q1_traj = (360 / np.pi) * np.arccos(centers[:, 2])
q5_traj = (360 / np.pi) * np.arccos(centers[:, 18])
plt.plot(q1_traj, q5_traj, color="black", linewidth=2, linestyle="-", label="Reaction Trajectory")
plt.colorbar()
plt.title("PMF in q1 and q5 space")
plt.xlabel("q1 (degrees)")
plt.ylabel("q5 (degrees)")
plt.savefig("q1_q5.pdf", format="pdf", bbox_inches="tight")
plt.close()