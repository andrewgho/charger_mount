// top_bracket.scad - top bracket for wall mount
// Andrew Ho (andrew@zeuscat.com)

include <dimensions.scad>
include <charger.scad>
include <screw_box.scad>

mount_height = screw_head_diameter + (thickness * 2);

module top_bracket_arms() {
  union() {
    difference() {
      difference() {
        translate([-thickness, -thickness, -thickness])
          minkowski() {
            charger_top(mount_height);
            cube([thickness * 2, thickness * 2, thickness * 2]);
          }
        union() {
          // Chop off unnecessary vertical shell expansion (top, bottom)
          translate([-(thickness + e), -(thickness + e), mount_height])
            cube([shell_width + (thickness * 2) + e2,
                  shell_depth + (thickness * 2) + e2,
                  thickness + e]);
          translate([-(thickness + e), -(thickness + e), -(thickness + e)])
            cube([shell_width + (thickness * 2) + e2,
                  shell_depth + (thickness * 2) + e2,
                  thickness + e]);
        }
      }
      union() {
        translate([0, 0, -e])
        charger_top(mount_height + e2);

        // Cut out front portion
        translate([top_front_bevel_width, -(thickness + e), -e])
          cube([shell_width - (top_front_bevel_width * 2),
                thickness + e2, mount_height + e2]);
      }
    }

    // Rounded edges for outer wings
    hull() {
      translate([top_front_bevel_width - (thickness), 0, (mount_height / 2)])
        rotate([0, 0, 45])
        cube(size = [thickness * sqrt(2), thickness * sqrt(2), mount_height],
             center = true);
      translate([top_front_bevel_width - thickness + (thickness * sqrt(2) / 2),
                 -thickness * sqrt(2) / 2, 0])
        cylinder(d = thickness * sqrt(2), h = mount_height, $fn = 360);
    }
    translate([shell_width, 0, 0])
      mirror([1, 0, 0])
      hull() {
        translate([top_front_bevel_width - (thickness), 0, (mount_height / 2)])
          rotate([0, 0, 45])
          cube(size = [thickness * sqrt(2), thickness * sqrt(2), mount_height],
               center = true);
        translate([top_front_bevel_width - thickness + (thickness * sqrt(2) / 2),
                   -thickness * sqrt(2) / 2, 0])
          cylinder(d = thickness * sqrt(2), h = mount_height, $fn = 360);
      }
  }
}

module top_bracket() {
  screw_box([rear_bevel_height - thickness,
             shell_depth,
             0],
            [shell_width - (2 * rear_bevel_height) + (2 * thickness),
             screw_head_height + thickness,
             mount_height],
            hole_diameter = screw_hole_diameter,
            head_diameter = screw_head_diameter,
            hole_pattern = [1/6, 5/6])
    top_bracket_arms();
}

top_bracket();
