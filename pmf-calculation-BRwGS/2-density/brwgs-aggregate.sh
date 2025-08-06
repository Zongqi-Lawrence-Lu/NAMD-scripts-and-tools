# Modifed Jul 16 to adapt to current system
# This version gives the unshifted free energy landscape, and plots it

#!/bin/bash

ni=30
nc=5
T=310

for j in $(seq 0 $((nc-1)))
do
    l=`wc ../1-pot/pot.$j | awk '{print $1}'`
    path/to/file/codes/brwgs -w $ni -l $l -g 0 -t $T -i 2000 < ../1-pot/pot.$j > density.$j.txt 2> density.$j.err
tail -$ni density.$j.err | awk '{print $1,$2}' | sort -n > fe_org.$j
done

module load python/anaconda-2023.09
python3 free_energy.py $ni $nc > fe.avg

module load gnuplot
gnuplot << EOF
set terminal pdfcairo size 18,12 color enhanced font "Times-Roman, 36" linewidth 3.0
unset key
set output "fe.pdf"
set xlabel "Image ID"
set ylabel "Free energy (kcal/mol)"

plot "fe.avg" using 1:2:3 with yerrorlines lt rgb "blue" lw 2 pt 7 ps 0.5
EOF