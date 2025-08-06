# Created May 17 
# Given a strcture input root and final job number, times per frame
# output a file that extract the distance between domain 1 and 4 with respect to time

# Modifed June 20
# Added hinge and dihedral, as defined in the SMwST colvar file

#!/bin/bash

# SET INPUTS
structure="/path/to/file"
input_root=""
first_job=0
last_job=1
ps_per_frame=50

# EXECUTION
rm distance_hinge_dihed.dat
module load vmd/1.9.4
vmd -dispdev text -e monitor.tcl -args "$structure" "$input_root" "$first_job" "$last_job" "$ps_per_frame" > /dev/null