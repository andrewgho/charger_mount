// scutout.scad - S-curve cutout solid object
// Andrew Ho (andrew@zeuscat.com)

// Overall dimensions, curve radius, offset from bottom, offset from front
module cutout(width, depth, height, radius, v_offset = 0, h_offset = 0) {
  diameter = 2 * radius;  // Shorthand for common dimension
  e = 0.1;                // e = epsilon fudge factor to help rendering
  e2 = 2 * e;             // Shorthand for 2e for cutout parts

  // Draw cylinder oriented along x-axis
  module roll(location = [0, 0, 0], h = width) {
    translate(location)
      rotate([0, 90, 0])
        cylinder(r = radius, h = h, $fn = 360);
  }

  difference() {
    union() {
      difference() {
        // Base cube that fills the desired space
        cube([width, depth, height]);
        // Cut out space for the bottom-most cylinder curve
        translate([-e, -e, -e])
          cube([width + e2, h_offset + diameter + e, radius + e]);
      }
      // Add bottom-most cylinder curve
      roll([0, h_offset + diameter, radius]);
    }
    union() {
      // Cut out front/bottom facing cylinder curve
      roll([-e, h_offset, v_offset + radius], width + e2);
      // Cut to front facing vertical face of indentation
      translate([-e, -e, -e])
        cube([width + e2, h_offset + radius + e, v_offset + radius + e]);
      // Cut to bottom facing horizontal face of indentation
      translate([-e, -e, v_offset + radius - e])
        cube([width + e2, h_offset + e, radius + e]);
      // Cut off any degenerate case overhang behind solid
      translate([-e, depth, -e])
        cube([width + e2, h_offset + e, height + e]);
    }
  }
}
