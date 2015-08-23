// bottom_bracket.scad - bottom bracket for wall mount
// Andrew Ho (andrew@zeuscat.com)

include <dimensions.scad>
include <charger.scad>

// Overall height of bottom bracket, minus screw tabs
mount_height = 6;

// Rectangular cutouts for cooling vents
vent_width = 22;
vent_depth = 16;
vent_corner_radius = 1.8;
vent_side_offset = ((shell_width - dimple_bottom_width) / 4) - (vent_width / 2);
vent_front_offset = (shell_depth - vent_width) / 2;

// Screw tab
screw_hole_diameter = 4.78;
screw_tab_margin = 4;
screw_tab_width = screw_hole_diameter + screw_tab_margin;
screw_tab_hang = rear_bevel_height + 1;

// Rectangle with rounded corners
module rounded_cube(x, y, z, r) {
  translate([r, r, 0])
    minkowski() {
      cube([x - (r * 2), y - (r * 2), z]);
      cylinder(r = r, h = z, $fn = 360);
    }
}

// Rounded tab with hole for screw
module screw_tab() {
  translate([-screw_tab_width, 0, -screw_tab_width / 2])
  rotate([90, 0, 0])
  difference() {
    union() {
      // Central screw tab face
      translate([screw_tab_width, -screw_tab_hang, 0])
        cylinder(d = screw_tab_width, h = thickness, $fn = 360);
      // Screw tab side wing (T-shape top)
      cube([screw_tab_width * 2, screw_tab_width / 2, thickness]);
      // Screw tab hang (T-shape shaft)
      translate([screw_tab_width / 2, -screw_tab_hang, 0])
        cube([screw_tab_width, screw_tab_hang + screw_tab_width / 2,
              thickness]);
      // Support buttress (from front: left, right)
      translate([2 * screw_tab_width / 3,
                 -(screw_tab_hang - rear_bevel_height), 0])
        cube([thickness, screw_tab_hang, screw_tab_width / 2]);
      translate([(4 * screw_tab_width / 3) - thickness,
                 -(screw_tab_hang - rear_bevel_height), 0])
        cube([thickness, screw_tab_hang, screw_tab_width / 2]);
    }
    union() {
      // Screw tab left side wing cutout
      translate([0, 0, -e])
        cylinder(d = screw_tab_width, h = thickness + e2, $fn = 360);
      // Screw hole cutout
      translate([screw_tab_width, -screw_tab_hang, -e])
        cylinder(d = screw_hole_diameter, h = thickness + e2, $fn = 360);
      // Screw tab right side wing cutout
      translate([screw_tab_width * 2, 0, -e])
        cylinder(d = screw_tab_width, h = thickness + e2, $fn = 360);
      // Buttress cutouts (from front: left, right)
      translate([(2 * screw_tab_width / 3) - e,
                 -(screw_tab_hang - rear_bevel_height),
                 screw_tab_width / 2 + thickness])
        rotate([0, 90, 0])
        cylinder(d = screw_tab_width, h = thickness + e2, $fn = 360);
      translate([(4 * screw_tab_width / 3) - thickness - e,
                 -(screw_tab_hang - rear_bevel_height),
                 screw_tab_width / 2 + thickness])
        rotate([0, 90, 0])
        cylinder(d = screw_tab_width, h = thickness + e2, $fn = 360);
    }
  }
}

difference() {
  union() {
    translate([-thickness, -thickness, -thickness])
      minkowski() {
        charger_bottom(mount_height);
        cube([thickness * 2, thickness * 2, thickness * 2]);
      }

    // Screw tabs (from front: left, right)
    translate([screw_tab_width + rear_bevel_height,
               shell_depth + thickness,
               rear_bevel_height - thickness])
      screw_tab();
    translate([shell_width - (screw_tab_width + rear_bevel_height),
               shell_depth + thickness,
               rear_bevel_height - thickness])
      screw_tab();
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
