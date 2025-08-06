# Created Jul 10 to make it compatible with current colvars
# Modified Jul 11 to add window dependent force constants

#!/bin/bash

ni=30
nc=5
width=57.0

for s in `seq 0 $((nc-1))`
do
cat ../../centers.tcl ../0-colvars/colvarsh.$s | \
awk -v ni=$ni -v w=$width ' # w is the wi
    function acos(o) {
        if (o>=1) {
            return 0
        } else if (o<=-1) {
            return 4*atan2(0.5,0.5)
        } else {
            return atan2(-o,sqrt(1-o*o))+2*atan2(0.5,0.5)
        }
    }{ 
    if (NR<=2*ni) {
        if (NR%2==1) {
            k[NR/2]= $7
        } else {  
            z1[NR/2] = $3
            z2[NR/2] = $4
            for (i=1; i<=5; i++) {
                q[NR/2, i, 1] = $((9*i-3))
                q[NR/2, i, 2] = $((9*i-1))
                q[NR/2, i, 3] = $((9*i+1))
                q[NR/2, i, 4] = $((9*i+3))
            }
        }
    } else { 
            printf "%d %d",$2,$1
            for (i=1;i<=ni;i++) {
                u = 0.5 * k[i] / w * ($3 - z1[i]) * ($3 - z1[i])  # hinge
                u += 0.5 * k[i] / w * ($4 - z2[i]) * ($4 - z2[i]) # dihed
                for (j=1;j<=5;j++) {
                    co=0
                    for (l=1;l<=4;l++) {
                        co+=q[i,j,l]* $(4*(j-1) + l + 4)
                    }
                    o=acos(co)
                    u+=0.5*k[i]*o*o
                }
                printf " %f",u
            }
            printf "\n"
        }
}' > pot.$s
done
