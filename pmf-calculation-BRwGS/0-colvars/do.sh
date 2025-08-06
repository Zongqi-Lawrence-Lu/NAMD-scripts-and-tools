# Created Jul 10 to accomodate for the system colvars

#!/bin/bash

ni=30
nc=5
inputs="../../output"
nr=$((ni*nc))

rm colvars.*
rm hist.*
rm colvarsh.*

for i in `seq 0 $((nr-1))`; do
    image=$((i / nc))
    copy=$((i % nc))

    # Loop over each matching file separately
    for f in $inputs/$image/*.$i.colvars.traj; do
        grep -v "^#" "$f" | awk '$1 > 0' 
    done | awk -v image=$image -v copy=$copy '
        {
            printf "%s %s %s %s", $1, image, $2, $3;
            for(j=0; j<=4; j++) {
                printf " %s %s %s %s", $(9*j+5), $(9*j+7), $(9*j+9), $(9*j+11)
            }
            printf "\n"
        }
    ' | uniq -w 20 >> colvars.$copy
done

for i in `seq 0 $((nr-1))`
do
    image=$((i / nc))
    copy=$((i % nc))
    grep -v "#" $inputs/$image/*.$i.history | uniq | \
    awk -v image=$image ' {
        printf "%s %s %s\n", $1, image, $2
    }' >> hist.$copy
done

for j in `seq 0 $((nc-1))`
do
    paste -d ' ' hist.$j colvars.$j | \
    awk -v nc=$nc ' 
        ($1==$4)&&($2==$5) {
            image=int($3/nc)
            printf "%s %s",$1,image
            for(i=6;i<=NF;i++) {
                printf " %s",$i
            } 
            printf "\n"
    }' colvarsh.$j
done