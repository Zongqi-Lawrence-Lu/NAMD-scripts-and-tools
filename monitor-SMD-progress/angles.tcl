
proc vecsub {v1 v2} {
    return [list \
        [expr {[lindex $v1 0] - [lindex $v2 0]}] \
        [expr {[lindex $v1 1] - [lindex $v2 1]}] \
        [expr {[lindex $v1 2] - [lindex $v2 2]}]]
}

proc vecdot {v1 v2} {
    return [expr {
        [lindex $v1 0]*[lindex $v2 0] +
        [lindex $v1 1]*[lindex $v2 1] +
        [lindex $v1 2]*[lindex $v2 2]
    }]
}

proc veccross {v1 v2} {
    set x [expr {[lindex $v1 1]*[lindex $v2 2] - [lindex $v1 2]*[lindex $v2 1]}]
    set y [expr {[lindex $v1 2]*[lindex $v2 0] - [lindex $v1 0]*[lindex $v2 2]}]
    set z [expr {[lindex $v1 0]*[lindex $v2 1] - [lindex $v1 1]*[lindex $v2 0]}]
    return [list $x $y $z]
}

proc vecnorm {v} {
    set mag [expr {sqrt(
        [lindex $v 0]*[lindex $v 0] +
        [lindex $v 1]*[lindex $v 1] +
        [lindex $v 2]*[lindex $v 2])}]
    if {$mag == 0.0} {
        return {0.0 0.0 0.0}
    }
    return [list \
        [expr {[lindex $v 0] / $mag}] \
        [expr {[lindex $v 1] / $mag}] \
        [expr {[lindex $v 2] / $mag}]]
}

proc vecangle {v1 v2} {
    set dot [vecdot $v1 $v2]
    set norm1 [expr {sqrt([vecdot $v1 $v1])}]
    set norm2 [expr {sqrt([vecdot $v2 $v2])}]
    if {$norm1 == 0.0 || $norm2 == 0.0} {
        return 0.0
    }
    set cos_theta [expr {$dot / ($norm1 * $norm2)}]
    if {$cos_theta > 1.0} { set cos_theta 1.0 }
    if {$cos_theta < -1.0} { set cos_theta -1.0 }
    return [expr {acos($cos_theta)}]
}

proc distance {v1 v2} {
    set dx [expr {[lindex $v1 0] - [lindex $v2 0]}]
    set dy [expr {[lindex $v1 1] - [lindex $v2 1]}]
    set dz [expr {[lindex $v1 2] - [lindex $v2 2]}]
    return [expr {sqrt($dx*$dx + $dy*$dy + $dz*$dz)}]
}

proc dihedral {p1 p2 p3 p4} {
      set b1 [vecsub $p2 $p1]
      set b2 [vecsub $p3 $p2]
      set b3 [vecsub $p4 $p3]

      set n1 [vecnorm [veccross $b1 $b2]]
      set n2 [vecnorm [veccross $b2 $b3]]
      set m1 [vecnorm [veccross $n1 $b2]]

      set x [vecdot $n1 $n2]
      set y [vecdot $m1 $n2]

      return [expr atan2($y,$x)]
}
