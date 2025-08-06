package require pbctools
source angles.tcl

set structure [lindex $argv 0]
set input_root [lindex $argv 1]
set first_job [lindex $argv 2]
set last_job [lindex $argv 3]
set pc_per_frame [lindex $argv 4]

mol new $structure type psf

for {set i $first_job} {$i <= $last_job} {incr i} {
  mol addfile "$input_root$i.dcd" type dcd waitfor all
}

set domain1 [atomselect top "name CA and resid 46 to 277"]
set domain2 [atomselect top "name CA and resid 293 to 516"]
set domain3 [atomselect top "name CA and resid 549 to 763"]
set domain4 [atomselect top "name CA and resid 776 to 960"]
set domain2_3 [atomselect top "name CA and ((resid 293 to 516) or (resid 549 to 763))"]

set outfile [open "distance_hinge_dihed.dat" w]
puts $outfile "time(ns) distance hinge dihedral"

set num_frames [molinfo top get numframes]

for {set i 0} {$i < $num_frames} {incr i} {
  $domain1 frame $i
  $domain2 frame $i
  $domain3 frame $i
  $domain4 frame $i
  $domain2_3 frame $i

  set com_domain1 [measure center $domain1 weight mass]
  set com_domain2 [measure center $domain2 weight mass]
  set com_domain3 [measure center $domain3 weight mass]
  set com_domain4 [measure center $domain4 weight mass]
  set com_domain2_3 [measure center $domain2_3 weight mass]

  set time [expr {$i * $pc_per_frame / 1000.0}]
  set dist [distance $com_domain1 $com_domain4]

  set v1 [vecsub $com_domain1 $com_domain2_3]
  set v2 [vecsub $com_domain4 $com_domain2_3]
  set hinge_rad [vecangle $v1 $v2]

  set dihed_rad [dihedral $com_domain1 $com_domain2 $com_domain3 $com_domain4]
  set hinge [expr {$hinge_rad * 180.0 / acos(-1)}]
  set dihed [expr {$dihed_rad * 180.0 / acos(-1)}]  

  puts $outfile "$time $dist $hinge $dihed"
}

close $outfile
quit