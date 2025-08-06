from sys import argv
import numpy as np

ni = int(argv[1])
nc = int(argv[2])
cvs_file = argv[3]
width_hinge = float(argv[4])
width_dihed = float(argv[5])

centers = []

# read the forces for quaternions from forces.txt as an array, and make the forces for hinge and dihedral
with open("forces.temp", 'r') as f:
    lines = f.readlines()
forces_quat = np.array([float(line.strip()) for line in lines if line.strip() != ''])
forces_hinge = np.divide(forces_quat, width_hinge ** 2)
forces_dihed = np.divide(forces_quat, width_dihed ** 2)

if len(forces_quat) != ni:
    raise ValueError("Forces should be an array of {} values".format(ni))

# read the image centers from centers.txt as three arrays 
with open("centers.temp", 'r') as f:
    lines = f.readlines()
    for line in lines:
        values = [float(x) for x in line.strip().split()]
        if len(values) != 22:
            raise ValueError("The centers of each image should be an array of 22 values")
        centers.append(values)
    if len(centers) != ni:
        raise ValueError("There should be {} groups of centers for centers.tcl".format(ni))
centers = np.array(centers)
hinge_centers = centers[:, 0]
dihed_centers = centers[:, 1]
quats_centers = centers[:, 2:].reshape(ni, 5, 4)

# load the data in its original form
data = np.loadtxt("../0-colvars/cvs.txt")
n_data = data.shape[0]

# Extract columns
time = data[:, 0].astype(int)      
copy_id = data[:, 1].astype(int) 
window_id = data[:, 2].astype(int)

hinge_data = data[:, 3]
dihed_data = data[:, 4]

# reshape quaternions to (n_samples, 5, 4)
quats_data = data[:, 5:].reshape(data.shape[0], 5, 4)

# Broadcasted difference: shape (n_samples, ni)
delta_hinge = hinge_data[:, None] - hinge_centers[None, :]
delta_dihed = dihed_data[:, None] - dihed_centers[None, :]

# Multiply by forces: shape (ni,)
bias_hinge = 0.5 * (delta_hinge ** 2) * forces_hinge[None, :]  # (n_samples, ni)
bias_dihed = 0.5 * (delta_dihed ** 2) * forces_dihed[None, :]  # (n_samples, ni)

# the dot product for quaternion distance
dot_products = np.einsum('sqk,wqk->swq', quats_data, quats_centers)
dot_products = np.clip(dot_products, -1.0, 1.0)

# calculate the force
angles = np.arccos(dot_products)
bias_quat = 0.5 * (angles ** 2) * forces_quat[None, :, None]

# Sum over the 5 quaternions
bias_quat_total = np.sum(bias_quat, axis=2)  
bias_total = bias_hinge + bias_dihed + bias_quat_total 

for i in range(n_data):
    print("{} {} {} ".format(window_id[i], copy_id[i], time[i]) + ' '.join(map(str, bias_total[i]))) 