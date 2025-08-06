# Created Jul 10 to make it compatible with current colvars
# Note that in this implementation, the force constants must be uniform.

#!/bin/bash

ni=30
nc=5
k=0.1538935 # Force constants. K is for quaternions and k is for hinge and dihedral
K=500

for s in `seq 0 $((nc-1))`
do
cat ../../centers.tcl ../0-colvars/colvarsh.$s | \
awk -v ni=$ni -v k=$k -v K=$K ' 
    function acos(o) {
        if (o>=1) {
            return 0
        } else if (o<=-1) {
            return 4*atan2(0.5,0.5)
        } else {
            return atan2(-o,sqrt(1-o*o))+2*atan2(0.5,0.5)
        }
    }{ 
    if (NR<=ni) {
        z1[NR] = $(11)
        z2[NR] = $(12)
        for (i=1; i<=5; i++) {
            q[NR, i, 1] = $((9*i+5))
            q[NR, i, 2] = $((9*i+7))
            q[NR, i, 3] = $((9*i+9))
            q[NR, i, 4] = $((9*i+11))
        }
    } else { 
            printf "%d %d",$2,$1
            for (i=1;i<=ni;i++) {
                u = 0.5 * k * ($3 - z1[i]) * ($3 - z1[i])  # hinge
                u += 0.5 * k * ($4 - z2[i]) * ($4 - z2[i]) # dihed             
                for (j=1;j<=5;j++) {
                    co=0
                    for (l=1;l<=4;l++) {
                        co+=q[i,j,l]* $(4*(j-1) + l + 4)
                    }
                    o=acos(co)
                    u+=0.5*K*o*o
                }
                printf " %f",u
            }
            printf "\n"
        }
}' > pot.$s
done

