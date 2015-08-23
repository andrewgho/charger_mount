// top_bracket.scad - top bracket for wall mount
// Andrew Ho (andrew@zeuscat.com)

include <dimensions.scad>
include <charger.scad>
include <screw_mount.scad>

mount_height = screw_head_diameter + (thickness * 2);

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

      // Cut out screw holes
      translate([shell_width / 4, shell_depth + thickness + e, mount_height / 2])
        rotate([90, 0, 0])
        cylinder(d = screw_head_diameter, h = thickness + e2, $fn = 360);
      translate([3 * shell_width / 4, shell_depth + thickness + e, mount_height / 2])
        rotate([90, 0, 0])
        cylinder(d = screw_head_diameter, h = thickness + e2, $fn = 360);
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

  // Screw holes
  translate([shell_width / 4, shell_depth + thickness, mount_height / 2])
    screw_mount();
  translate([3 * shell_width / 4, shell_depth + thickness, mount_height / 2])
    screw_mount();

  // Box frame
  translate([rear_bevel_height - thickness, shell_depth + thickness, 0]) {
    cube([shell_width - (2 * rear_bevel_height) + (2 * thickness),
          screw_head_height + thickness, thickness]);
    cube([thickness, screw_head_height + thickness, mount_height]);
  }
  translate([rear_bevel_height - thickness, shell_depth + thickness, mount_height - thickness])
    cube([shell_width - (2 * rear_bevel_height) + (2 * thickness),
          screw_head_height + thickness, thickness]);
  translate([shell_width - (rear_bevel_height),
             shell_depth + thickness, 0])
    cube([thickness, screw_head_height + thickness, mount_height]);
}
