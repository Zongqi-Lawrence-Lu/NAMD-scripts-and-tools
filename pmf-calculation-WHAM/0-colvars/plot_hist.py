# Created Jul 30
# This use the cvs.txt result and plot the histogram for hinge (first scalar colvar)

import numpy as np
import matplotlib.pyplot as plt

file_name = "cvs.txt"
num_image = 59
bin_width = 0.1
stride = 1

data = np.loadtxt(file_name)
time = data[:, 0]
image_id = data[:, 2]
hinge = data[:, 3]

min_hinge = np.min(hinge)
max_hinge = np.max(hinge)
num_bins = int((max_hinge - min_hinge) / bin_width)

plt.figure(figsize=(18, 4))
color_map = plt.cm.get_cmap('tab20', num_image // stride) # change this

for image in range(0, num_image, stride):
    hinge_values = hinge[image_id == image]
    plt.hist(hinge_values, bins=np.arange(min_hinge, max_hinge + bin_width, bin_width),
             alpha=0.5, label=f'Image {image}', edgecolor='black')

plt.xlabel('Hinge Value')
plt.ylabel('Frequency')
plt.title('Hinge Value Histograms for Each Image ID')
plt.grid(True)
plt.tight_layout()
plt.savefig("hist.pdf", format = "pdf", bbox_inches = "tight")

