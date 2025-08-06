package require pbctools

set structure [lindex $argv 0]
set input_dcd [lindex $argv 1]
set pc_per_frame [lindex $argv 2]
set array_string [lindex $argv 3]
set arr [split $array_string ","]

mol new $structure type psf
mol addfile "$input_dcd" type dcd waitfor all
set num_frames [molinfo top get numframes]
set all [atomselect top all]

set count 0
for {set i 0} {$i < $num_frames} {incr i} {
  set time [expr {$i * $pc_per_frame / 1000.0}]
  if {[lsearch -exact $arr $time] != -1} {
    $all frame $i
    $all writenamdbin ../input/init.$count.coor
    pbc writexst ../input/init.$count.xsc -first $i -last $i
    incr count
  }
}

quit