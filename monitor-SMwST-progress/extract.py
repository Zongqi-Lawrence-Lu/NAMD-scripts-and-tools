# Created Jun8. Computes the string RMSD (wrt first and last)

import numpy as np
from sys import argv

ni = int(argv[1])

with open("cv-R.txt", 'r') as f:
    lines = [line.strip() for line in f]

data = np.array([[float(x) for x in line.split()[1:]] for line in lines if line.split()])

iterations = len(data) // ni
data = data.reshape((iterations, ni, -1))

# given two arrays of colvars, return the RMSD values
def colvar_rmsd(a, b):
    sq_sum = 0.0
    for i in range(ni):
        hinge_diff = a[i, 0] - b[i, 0]
        dihed_diff = a[i, 1] - b[i, 1]
        sq_sum += hinge_diff ** 2 + dihed_diff ** 2

        q1 = a[i, 2:22].reshape((5, 4))
        q2 = b[i, 2:22].reshape((5, 4))

        # loop over the 5 quarternions and compute the angle differences
        for j in range(5):
            rads = np.arccos(np.clip(np.dot(q1[j],q2[j]), -1.0 ,1.0))
            sq_sum += (rads * 360.0 / 3.1415926) ** 2

    return np.sqrt(sq_sum / (7 * ni))

# compute the values over the entire iteration
rmsd_wrt_first_list = np.zeros(iterations)
rmsd_wrt_last_list = np.zeros(iterations)
rmsd_wrt_prev_list = np.zeros(iterations)
for i in range(1, iterations):
    rmsd_wrt_first_list[i] = colvar_rmsd(data[0], data[i])
    rmsd_wrt_last_list[i] = colvar_rmsd(data[i - 1], data[iterations - 1])
    rmsd_wrt_prev_list[i] = colvar_rmsd(data[i - 1], data[i])

with open("smwst_rmsd.dat", "w") as f:
    f.write("iterations rmsd_wrt_first rmsd_wrt_last rmsd_wrt_prev\n")
    for i in range(1, iterations):
        f.write(f"{i} {rmsd_wrt_first_list[i]} {rmsd_wrt_last_list[i]} {rmsd_wrt_prev_list[i]}\n")
    
