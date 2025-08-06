#!/bin/bash

ni=30 # number of images
l=`wc ../1-pot/pot.txt | awk '{print $1}'`

awk '{for(i=1;i<=NF;i++) if(i!=2) printf "%s ",$i; printf"\n"}' ../1-pot/pot.txt | \
path/to/file/codes/npwham -w $ni -l $l -t 310 > density.txt 2> density.err

module load gnuplot
gnuplot << EOF
set terminal pdfcairo size 18,12 color enhanced font "Times-Roman, 36" linewidth 3.0
unset key
set output "fe.pdf"
set xlabel "Image ID"
set ylabel "Free energy (kcal/mol)"

plot "< tail -$ni density.err | awk '{print \$3, \$4}'" using 1:2 with linespoints lt rgb "blue" lw 2 pt 7 ps 0.5
EOF