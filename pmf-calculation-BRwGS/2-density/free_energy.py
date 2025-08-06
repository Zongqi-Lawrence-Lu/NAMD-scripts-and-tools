import numpy as np
from sys import argv

ni = int(argv[1])
nc = int(argv[2])

fes = []
for i in range(nc):
    data = np.loadtxt("fe_org.{}".format(i))
    if data.shape[0] != ni or data.shape[1] != 2:
        raise ValueError("Wrong format in fe.{} file".format(i))
    fes.append(data[:, 1])

fes = np.stack(fes)
avg_fe = np.mean(fes, axis=0)
std_fe = np.std(fes, axis=0, ddof=1)

# Shift down the free energy so that lowest is zero
avg_fe = avg_fe - np.min(avg_fe)

for i in range(ni):
    print("{} {:.5f} {:.5f}".format(i, avg_fe[i], std_fe[i]))