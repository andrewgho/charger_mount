// bottom_bracket.scad - bottom bracket for wall mount
// Andrew Ho (andrew@zeuscat.com)

include <dimensions.scad>
include <charger.scad>
include <screw_box.scad>
include <biarc_cutout.scad>

// Overall height of bottom bracket
mount_height = rear_bevel_height + screw_head_diameter;
mount_height_front = bottom_front_bevel_width + (thickness * 2);

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

module bottom_bracket_shelf() {
  difference() {
    union() {
      translate([-thickness, -thickness, -thickness])
        minkowski() {
          charger_bottom(mount_height);
          cube([thickness * 2, thickness * 2, thickness * 2]);
        }
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
    }
  }
}

module bottom_bracket() {
  difference() {
    screw_box([rear_bevel_height - thickness,
               shell_depth,
               rear_bevel_height - thickness],
              [shell_width - (2 * rear_bevel_height) + (2 * thickness),
               screw_head_height + thickness,
               mount_height - rear_bevel_height + (2 * thickness)],
              hole_diameter = screw_hole_diameter,
              head_diameter = screw_head_diameter,
              hole_pattern = [1/6, 5/6])
      bottom_bracket_shelf();

    // Biarc curve cutout to better expose lower front
    translate([-(thickness + e),
               shell_depth - e,
               mount_height_front + thickness])
      mirror([0, 1, 0])
      biarc_cutout([shell_width + (2 * thickness) + e2,
                    shell_depth + thickness + e,
                    mount_height - mount_height_front + e],
                   (mount_height - mount_height_front) / 2,
                   vertical_offset = 0,
                   horizontal_offset = rear_bevel_height + (2 * thickness));
  }
}

bottom_bracket();
