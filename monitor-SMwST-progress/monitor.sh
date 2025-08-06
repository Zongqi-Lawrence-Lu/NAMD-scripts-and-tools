# Created Jun 8. Extract the colvars and RMSD in SWmST, and plot the hinge vs dihedryl and q1 v q2.
# Modified Jun 21. Added wrt previous in string RMSD, and plot q3 v q4 and q1 v q4.

#!/bin/bash

# INPUTS
ni=30       ;# number of images 
# list all the log files from the zeroth replica
log="../output/logs/job0.log.0"  

cat $log | grep "TCL: Reparametrized " | awk -v ni=$ni '{for(i=4;i<=NF;i++) printf "%s ",$i; printf "\n"; if($4==ni-1) print ""}' > cv-R.txt

# Calculate the string RMSDs
module load python/anaconda-2023.09
python3 extract.py $ni 

# Plot hinge vs dihedryl, q1 vs q2, 
module load gnuplot
gnuplot << EOF

set size 1, 1
set terminal pdfcairo size 17,15 color enhanced font "Times-Roman, 36" linewidth 3.0
set encoding iso_8859_1

set lmargin at screen 0.1
set rmargin at screen 0.9
set bmargin at screen 0.1
set tmargin at screen 0.9

# Plot hinge vs dihedryl
set output "hinge_dihed.pdf"
set size square
set xlabel "Hinge (degrees)"
set ylabel "Dihedral (degrees)"

set palette defined (0 "blue", 1 "cyan" , 2 "green", 3 "yellow", 4 "orange", 5 "red")
set cblabel "Iteration"
set colorbox

plot "cv-R.txt" u (\$2):(\$3):(int(\$0/${ni})) w l palette notitle

# Plot q1 vs q2
set output "q1_q2.pdf"
set xlabel "{/Symbol q_{1}}"
set ylabel "{/Symbol q_{2}}"
plot \
"cv-R.txt" u (2*180*acos(\$4)/3.1415926):(2*180*acos(\$8)/3.1415926):(int(\$0/(${ni}+1))) w l palette notitle

# Plot q3 vs q4
set output "q3_q4.pdf"
set xlabel "{/Symbol q_{3}}"
set ylabel "{/Symbol q_{4}}"
plot \
"cv-R.txt" u (2*180*acos(\$12)/3.1415926):(2*180*acos(\$16)/3.1415926):(int(\$0/(${ni}+1))) w l palette notitle

# Plot q1 vs q5
set output "q1_q5.pdf"
set xlabel "{/Symbol q_{1}}"
set ylabel "{/Symbol q_{5}}"
plot \
"cv-R.txt" u (2*180*acos(\$4)/3.1415926):(2*180*acos(\$20)/3.1415926):(int(\$0/(${ni}+1))) w l palette notitle

# Plot RMSD
set key top right
set terminal pdfcairo size 18,12
set output "string_rmsd.pdf"
set xlabel "Iteration"
set ylabel "RMSD"
set size ratio 0.66
set yrange [0:2.5]
set datafile separator whitespace
plot 'smwst_rmsd.dat' using 1:2 with lines title 'RMSD wrt First', \
     '' using 1:3 with lines title 'RMSD wrt Last', \
     '' using 1:4 with lines title 'RMSD wrt Previous'


EOF
