# modifed June 26 to adapt to current system 

#!/bin/bash

ni=30  # the number of images
nc=5   # the number of copies
centers_file="path/to/file"  # where the centers.tcl file is
cvs_file="../0-colvars/cvs.txt"   # where the cvs.txt file is
width_hinge=57.0 # the width for hinge
width_dihed=57.0 # the width for dihedral

rm forces.temp
rm centers.temp

# generate two temp files: forces.temp records the force constants for each image
# and centers.temp, which records the center for each image
cat $centers_file | awk -v ni=$ni '{
	if (NR % 2 == 1) {
		# match the forceconstant and output it to forces.txt
		match($0, /forceConstant[[:space:]]*\{[[:space:]]*([0-9.eE+-]+)[[:space:]]*\}/, fc)
		print fc[1] >> "forces.temp"

	} else {
		gsub(/[{},()]/, " ")  # remove punctuation
		n = split($0, fields, " ")
		line = ""
		count = 0
		for (i = 1; i <= n; i++) {
			if (fields[i] ~ /^[-+]?[0-9.]+([eE][-+]?[0-9]+)?$/) {
				line = line fields[i] " "
				count++
			}
		}
	print line >> "centers.temp"
	}
}'

module load python/anaconda-2023.09
python3 pot.py $ni $nc $cvs_file $width_hinge $width_dihed > pot.txt
