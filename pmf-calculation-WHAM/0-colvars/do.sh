# Modified June 25 to adapt to the system. Note that this sytem does not support more than 1 BEUS job
# The colvar output frequency must be the same as the BEUS run time
# The output format should be "step copy_id(not replica id) image_id hinge dihed q_1_1 q_1_2 ...", delimited by a space

#!/bin/bash

ni=30 # number of images
nc=5 # number of copies
nr=$((ni*nc)) # number of replicas
system="prefix"   # the prefix of the system
output="path/to/file" # the beus output files

mkdir -p colvars
mkdir -p hist
rm colvars/*
rm hist/*

# The output trajectory file has format
# step hinge dihed ( q_1_1 , q_1_2 , q_1_3 , q_1_4 ) (q2) (q3) (q4) (q5)
# The output history file has format
# step replica(the actual replica id at this moment)
for r in `seq 0 $((nr-1))`
do
    c=$((r % nc))
    i=$((r / nc))

    # For each replica i, output to the colvars/i file, which has format
    # time copy_id hinge dihed ( q_1_1 , q_1_2 , q_1_3 , q_1_4 ) (q2) (q3) (q4) (q5)
    grep -v "#" $output/$i/$system.job0.$r.colvars.traj | uniq | \
    awk -v c=$c '
        $1 > 0 {
        printf "%s %s %s %s",$1, c, $2, $3;
        for ( cv=0 ; cv < 5; cv++) {
            printf " %s %s %s %s",$(9*cv+5),$(9*cv+7),$(9*cv+9),$(9*cv+11);
        }
        printf"\n"
        }' | uniq -w 20 >> colvars/$i 
    
    # For each replica i, output to the hist/i file, which has format
    # time copy_id(from 0 to nc, not replica id) replica_id(the actual replica id at this moment)
    grep -v "#" $output/$i/$system.job0.$r.history | uniq | \
    awk -v c=$c -v nc=$nc '
        {
            print $1,c,int($2/nc)
        }
    ' >> hist/$i
done

rm cvs.txt
for i in `seq 0 $((ni-1))`
do
    # paste them side by side and check if they the time and copy id are the same
    # if so, print as the output format
    paste hist/$i colvars/$i | \
    awk '
        ($1==$4) && ($2==$5) {
        printf "%s %s %s",$1,$2,$3;
        for(i=6; i<=NF; i++) {
            printf " %s",$i;
        }
        printf "\n";
    }' >> cvs.txt
done