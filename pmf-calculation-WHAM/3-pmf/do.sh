# Created Jul 12 to apply to the current system

#!/bin/bash

# Set Inputs
T=310
d_hinge=0.5  # bin sizes
d_dihed=0.2
d_quat=0.3

module load python/anaconda-2023.09
python3 pmf.py $T $d_hinge $d_dihed $d_quat
python3 plot_contour.py $d_hinge $d_dihed $d_quat

module load gnuplot
gnuplot << EOF
set terminal pdfcairo size 18,12 color enhanced font "Times-Roman, 36" linewidth 3.0
unset key
set yrange [*:*]

# Plot hinge
set output "hinge_pmf.pdf"
set xlabel "Hinge (degrees)"
set ylabel "PMF (kcal/mol)"
plot 'hinge_pmf.txt' using 1:2 with linespoints lt rgb "blue" lw 2 pt 7 ps 0.5

# dihed
set output "dihed_pmf.pdf"
set xlabel "Dihedral (degrees)"
set ylabel "PMF (kcal/mol)"
plot 'dihed_pmf.txt' using 1:2 with linespoints lt rgb "blue" lw 2 pt 7 ps 0.5

# q1
set output "q1_pmf.pdf"
set xlabel "q1 (degrees)"
set ylabel "PMF (kcal/mol)"
plot 'q1_pmf.txt' using 1:2 with linespoints lt rgb "blue" lw 2 pt 7 ps 0.5

# q5
set output "q5_pmf.pdf"
set xlabel "q5 (degrees)"
set ylabel "PMF (kcal/mol)"
plot 'q5_pmf.txt' using 1:2 with linespoints lt rgb "blue" lw 2 pt 7 ps 0.5
EOF