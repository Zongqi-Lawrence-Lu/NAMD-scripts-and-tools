# Modified Jul 19 to adapt to the current system
# It adds additional images between consecutive images to increase sampling overlap.
# For instance, with ni=30 and np=10, there will be 30 + 9 * 29 = 291 images

#!/bin/bash
ni=30 # number of images in smwst
nc_smwst=20 # number of copies in SMwST
np=2 # the number of images per segment. For instance, to put 3 images between two consecutive images, np=4.
nc_beus=3 # number of copies in BEUS
job_id=2 # last smwst job_id
force=3 # force constant
# pick the last SMwST output directiry
output=path/to/file/output

for i in `seq 0 $((ni-1))`
do
    output_root=$output/$i/XXX
    if [ "$((np*nc_beus))" -gt "$nc_smwst" ]; then
        for j in `seq 0 $((np*nc_beus-1))`
        do
            replica=$(shuf -i $((i*nc_smwst))-$((i*nc_smwst+nc_smwst-1)) -n 1)
            cp $output_root.job$job_id.$replica.restart.coor ../input/init.$((i*np*nc_beus+j)).coor
            cp $output_root.job$job_id.$replica.restart.vel ../input/init.$((i*np*nc_beus+j)).vel
            cp $output_root.job$job_id.$replica.restart.xsc ../input/init.$((i*np*nc_beus+j)).xsc
        done
    else
        for j in `seq 0 $((np*nc_beus-1))`
        do
            cp $output_root.job$job_id.$((i*nc_smwst+j)).restart.coor ../input/init.$((i*np*nc_beus+j)).coor
            cp $output_root.job$job_id.$((i*nc_smwst+j)).restart.vel ../input/init.$((i*np*nc_beus+j)).vel
            cp $output_root.job$job_id.$((i*nc_smwst+j)).restart.xsc ../input/init.$((i*np*nc_beus+j)).xsc
        done
    fi
done

cat $output/logs/job$job_id.log.0 | \
grep "TCL: Reparametrized " | tail -$ni | awk -v ni=$ni -v np=$np -v force=$force '{
    image = NR-1
    hinge[image] = $5
    dihed[image] = $6
    if (image > 0) {
        for (t = 1; t <= np; t++) {
            replica = (image - 1) * np + t
            printf "set centers(%d) [list harm \"forceConstant \{ %s \}\n", replica, force
            h = hinge[image - 1] + (hinge[image] - hinge[image - 1]) * t / np
            d = dihed[image - 1] + (dihed[image] - dihed[image - 1]) * t / np
            printf " centers \{ %s %s \} \" ]\n", h, d
        }
    } else {
        printf "set centers(0) [list harm \"forceConstant \{ %s \}\n", force
        printf " centers \{ %s %s \} \" ]\n", hinge[image], dihed[image]
    }
}' > ../centers.tcl

