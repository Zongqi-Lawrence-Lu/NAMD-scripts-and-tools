#!/bin/bash

ni=30 # number of images
nc=5 # number of copies
l=`wc ../1-pot/pot.txt | awk '{print $1}'` 

# using generalized wham algorithm with bootstrapping
path/to/file/npwham -w $ni -l $l -t 310 -b $nc -B 100 < ../1-pot/pot.txt > bootstrap.txt 2> bootstrap.err

module load gnuplot
gnuplot << EOF
set terminal pdfcairo size 18,12 color enhanced font "Times-Roman, 36" linewidth 3.0
unset key
set output "fe.pdf"
set xlabel "Image ID"
set ylabel "Free energy (kcal/mol)"

plot "< tail -$ni bootstrap.err | awk '{print \$3, \$4, \$5}'" using 1:2:3 with yerrorlines lt rgb "blue" lw 2 pt 7 ps 0.5
EOF