#!/bin/bash

ni=30 #number of images in smwst
nc=20 # number of copies in smwst
job_id=2 # last smwst job_id
force=3.5 # force constant
# pick the right directory
output=../output

for i in `seq 0 $((ni-1))`
do
    output_root=$output/$i/OCnoINS
    for j in `seq 0 $((nc-1))`
    do
	cp $output_root.job$job_id.$((i*nc+j)).restart.coor ../input/init.$((i*nc+j)).coor
	cp $output_root.job$job_id.$((i*nc+j)).restart.vel ../input/init.$((i*nc+j)).vel
	cp $output_root.job$job_id.$((i*nc+j)).restart.xsc ../input/init.$((i*nc+j)).xsc
    done
done

cat $output/logs/job$job_id.log.0 | \
grep "TCL: Reparametrized " | tail -$ni | awk -v force=$force '{
    printf "set centers(%d) [list harm \"forceConstant \{ %s \} \n centers \{ ",$4,force
    printf "%s %s ", $5, $6 
    for(i=1;i<6;i++) printf "( %s , %s , %s , %s ) ",$(4*i+3),$(4*i+4),$(4*i+5),$(4*i+6)
    printf "\} \" ]",$i;printf"\n"
}' > ../centers.tcl
