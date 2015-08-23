screw_head_diameter = 9;
screw_head_height = 4;
screw_hole_diameter = 4.78;

module screw_mount() {

  translate([0, screw_head_height + thickness, 0])
    rotate([90, 0, 0])
    difference() {
      union() {
        cylinder(d = screw_head_diameter + (thickness * 2),
                 h = thickness,
                 $fn = 360);
        cylinder(d = screw_head_diameter + (thickness * 2),
                 h = screw_head_height + thickness,
                 $fn = 360);
      }
      union() {
        translate([0, 0, -e])
          cylinder(d = screw_hole_diameter,
                   h = thickness + e2,
                   $fn = 360);
        translate([0, 0, thickness])
          cylinder(d = screw_head_diameter,
                   h = screw_head_height + e,
                   $fn = 360);
      }
    }
}
