import numpy as np
from sys import argv

T = float(argv[1])
d_hinge = float(argv[2])
d_dihed = float(argv[3])
d_quat = float(argv[4])
kB = 0.0019872041
kBT = 0.0019872041 * T

cvs = np.loadtxt("../0-colvars/cvs.txt")
density = np.loadtxt("../2-fe/density.txt")

if density.shape[0] != cvs.shape[0]:
    raise ValueError("density.txt and cvs.txt not of the same size")

# Extract probs and colvars
probs = density[:, 2]
hinge = cvs[:, 3]
dihed = cvs[:, 4] 
q1 = np.arccos(cvs[:, 5]) * (360 / np.pi)
q5 = np.arccos(cvs[:, 21]) * (360 / np.pi)

'''
# Manually get the centers and bins
hinge_bins = np.round(hinge / d_hinge).astype(int)
hinge_min_bin = hinge_bins.min()
hinge_max_bin = hinge_bins.max()
hinge_centers = (np.arange(hinge_min_bin, hinge_max_bin + 1)) * d_hinge
hinge_n_bins = hinge_max_bin - hinge_min_bin + 1
'''

# Make the edges
hinge_edges = np.arange(np.floor(hinge.min() / d_hinge) * d_hinge, np.ceil(hinge.max() / d_hinge) * d_hinge + d_hinge, d_hinge)
dihed_edges = np.arange(np.floor(dihed.min() / d_dihed) * d_dihed, np.ceil(dihed.max() / d_dihed) * d_dihed + d_dihed, d_dihed)
q1_edges = np.arange(np.floor(q1.min() / d_quat) * d_quat, np.ceil(q1.max() / d_quat) * d_quat + d_quat, d_quat)
q5_edges = np.arange(np.floor(q5.min() / d_quat) * d_quat, np.ceil(q5.max() / d_quat) * d_quat + d_quat, d_quat)

# Make the weighted hisograms:
hist_hinge_dihed, _, _ = np.histogram2d(hinge, dihed, bins=[hinge_edges, dihed_edges], weights=probs)
hist_q1_q5, _, _ = np.histogram2d(q1, q5, bins=[q1_edges, q5_edges], weights=probs)
p_hinge, _ = np.histogram(hinge, bins=hinge_edges, weights=probs)
p_dihed, _ = np.histogram(dihed, bins=dihed_edges, weights=probs)
p_q1, _ = np.histogram(q1, bins=q1_edges, weights=probs)
p_q5, _ = np.histogram(q5, bins=q5_edges, weights=probs)

# Reconstruct the centers
hinge_centers = 0.5 * (hinge_edges[:-1] + hinge_edges[1:])
dihed_centers = 0.5 * (dihed_edges[:-1] + dihed_edges[1:])
q1_centers = 0.5 * (q1_edges[:-1] + q1_edges[1:])
q5_centers = 0.5 * (q5_edges[:-1] + q5_edges[1:])

'''
# This is another way to do it, manually computing the histograms
p_hinge = np.zeros(hinge_n_bins)
hinge_bin_indices = hinge_bins - hinge_min_bin
np.add.at(p_hinge, hinge_bin_indices, probs)
'''

# Compute PMFs
with np.errstate(divide='ignore'):
    hinge_pmf = -kBT * np.log(p_hinge)
    dihed_pmf = -kBT * np.log(p_dihed)
    q1_pmf = -kBT * np.log(p_q1)
    q5_pmf = -kBT * np.log(p_q5)
    hinge_dihed_pmf = -kBT * np.log(hist_hinge_dihed)
    q1_q5_pmf = -kBT * np.log(hist_q1_q5)

# Normalize to make lowest zero
hinge_pmf = hinge_pmf - np.nanmin(hinge_pmf)
dihed_pmf = dihed_pmf - np.nanmin(dihed_pmf)
q1_pmf = q1_pmf - np.nanmin(q1_pmf)
q5_pmf = q5_pmf - np.nanmin(q5_pmf)
hinge_dihed_pmf = hinge_dihed_pmf - np.nanmin(hinge_dihed_pmf)
q1_q5_pmf = q1_q5_pmf - np.nanmin(q1_q5_pmf)

# Write the 1D PMFs
with open("hinge_pmf.txt", "w") as f:
    f.write("hinge_center pmf\n")
    for i, hinge in enumerate(hinge_centers):
        if p_hinge[i] >= 0:
            f.write("{} {}\n".format(hinge, hinge_pmf[i]))
        else:
            f.write("{} inf\n".format(hinge))

with open("dihed_pmf.txt", "w") as f:
    f.write("dihed_center pmf\n")
    for i, dihed in enumerate(dihed_centers):
        if p_dihed[i] >= 0:
            f.write("{} {}\n".format(dihed, dihed_pmf[i]))
        else:
            f.write("{} inf\n".format(dihed))

with open("q1_pmf.txt", "w") as f:
    f.write("q1_center pmf\n")
    for i, q1 in enumerate(q1_centers):
        if p_q1[i] >= 0:
            f.write("{} {}\n".format(q1, q1_pmf[i]))
        else:
            f.write("{} inf\n".format(q1))

with open("q5_pmf.txt", "w") as f:
    f.write("q5_center pmf\n")
    for i, q5 in enumerate(q5_centers):
        if p_q5[i] >= 0:
            f.write("{} {}\n".format(q5, q5_pmf[i]))
        else:
            f.write("{} inf\n".format(q5))

# Write 2D PMFs
with open("hinge_dihed_pmf.txt", "w") as f:
    for i, hinge in enumerate(hinge_centers):
        for j, dihed in enumerate(dihed_centers):
            if hist_hinge_dihed[i,j] > 0:
                f.write("{:.2f} {:.2f} {:.5f}\n".format(hinge, dihed, hinge_dihed_pmf[i,j]))

with open("q1_q5_pmf.txt", "w") as f:
    for i, q1 in enumerate(q1_centers):
        for j, q5 in enumerate(q5_centers):
            if hist_q1_q5[i,j] > 0:
                f.write("{:.2f} {:.2f} {:.5f}\n".format(q1, q5, q1_q5_pmf[i,j]))