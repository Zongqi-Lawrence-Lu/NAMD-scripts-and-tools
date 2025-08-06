# Modifed Jul 16 to adapt to current system
# This version gives one free energy per copy

#!/bin/bash

ni=30
nc=5
T=310

for j in $(seq 0 $((nc-1)))
do
    l=`wc ../1-pot/pot.$j | awk '{print $1}'`
    path/to/file/brwgs -w $ni -l $l -g 0 -t $T -i 2000 < ../1-pot/pot.$j > density.$j.txt 2> density.$j.err
tail -$ni density.$j.err | awk '{print $1,$2}' | awk 'BEGIN{f0=1e8}{if($2<f0){f0=$2}f[$1]=$2}END{for(i in f)print i,f[i]-f0}' | sort -n > fe.$j
done
