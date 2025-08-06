# Created Jun 21
# Given an input file, the time step, and an array of times, write the .coor and .xsc file

#!/bin/bash

# INPUTS
structure="../XXX.psf"
input_dcd="../XXX.dcd"
ps_per_frame=50
arr=(
  0.0, ... 150.0)
array_string=$(IFS=, ; echo "${arr[*]}")

module load vmd/1.9.4
vmd -dispdev text -e extract.tcl -args "$structure" "$input_dcd" "$ps_per_frame" "$array_string" > /dev/null


