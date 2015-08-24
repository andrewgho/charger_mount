// bottom_bracket.scad - bottom bracket for wall mount
// Andrew Ho (andrew@zeuscat.com)

include <dimensions.scad>
include <charger.scad>
include <screw_mount.scad>
include <scutout.scad>

// Overall height of bottom bracket
mount_height = rear_bevel_height + screw_head_diameter;

// Rectangular cutouts for cooling vents
vent_width = 22;
vent_depth = 16;
vent_corner_radius = 1.8;
vent_side_offset = ((shell_width - dimple_bottom_width) / 4) - (vent_width / 2);
vent_front_offset = (shell_depth - vent_width) / 2;

// Rectangle with rounded corners
module rounded_cube(x, y, z, r) {
  translate([r, r, 0])
    minkowski() {
      cube([x - (r * 2), y - (r * 2), z]);
      cylinder(r = r, h = z, $fn = 360);
    }
}

difference() {

difference() {
  union() {
    translate([-thickness, -thickness, -thickness])
      minkowski() {
        charger_bottom(mount_height);
        cube([thickness * 2, thickness * 2, thickness * 2]);
      }

    // Screw mounts
    translate([shell_width / 4, shell_depth + thickness,
               rear_bevel_height + (screw_head_diameter / 2)])
      screw_mount();
    translate([3 * shell_width / 4, shell_depth + thickness,
               rear_bevel_height + (screw_head_diameter / 2)])
      screw_mount();

    // Box frame
    translate([rear_bevel_height - thickness, shell_depth + thickness, rear_bevel_height - thickness]) {
      cube([shell_width - (2 * rear_bevel_height) + (2 * thickness),
            screw_head_height + thickness, thickness]);
      cube([thickness, screw_head_height + thickness, mount_height - rear_bevel_height + (2 * thickness)]);
    }
    translate([rear_bevel_height - thickness, shell_depth + thickness, mount_height])
      cube([shell_width - (2 * rear_bevel_height) + (2 * thickness),
            screw_head_height + thickness, thickness]);
    translate([shell_width - rear_bevel_height, shell_depth + thickness, rear_bevel_height - thickness])
      cube([thickness, screw_head_height + thickness, mount_height - rear_bevel_height + (2 * thickness)]);
  }
  union() {
    charger_bottom(mount_height + thickness + e);

    // Rectangular cutouts for cooling vents (from front: left, right)
    translate([vent_side_offset, vent_front_offset, -(thickness + e)])
      rounded_cube(vent_width, vent_depth, thickness + e2,
                   vent_corner_radius);
    translate([shell_width - vent_side_offset - vent_width,
               vent_front_offset, -(thickness + e)])
      rounded_cube(vent_width, vent_depth, thickness + e2,
                   vent_corner_radius);

    // Cut out screw holes
    translate([shell_width / 4, shell_depth + thickness + e,
               rear_bevel_height + (screw_head_diameter / 2)])
      rotate([90, 0, 0])
      cylinder(d = screw_head_diameter, h = thickness + e2, $fn = 360);
    translate([3 * shell_width / 4, shell_depth + thickness + e,
               rear_bevel_height + (screw_head_diameter / 2)])
      rotate([90, 0, 0])
      cylinder(d = screw_head_diameter, h = thickness + e2, $fn = 360);
  }
}

// S-curve cutout to better expose lower front
translate([-(thickness + e),
            shell_depth - e, 7 - (thickness + e)])
  mirror([0, 1, 0])
  cutout(shell_width + (2 * thickness) + e2,
         shell_depth + thickness + e,
         mount_height + thickness + e,
         4.5, 0, 6);

}
