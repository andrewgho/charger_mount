// biarc_cutout.scad - rectanglular solid with a biarc segment cut out
// Andrew Ho (andrew@zeuscat.com)
//
// biarc_cutout(size, radius) will generate a rectangular solid with an
// extruded biarc curve shaped cutout along the front (y/W near 0) bottom
// (z/H near 0) edge. This is most useful as a subtractive shape for
// creating a nicely rounded transition between two plateaus.

module biarc_cutout(size,                   // Overall size vector (H × W × D)
                    radius,                 // Biarc curve radius
                    vertical_offset = 0,    // Offset top biarc curve up
                    horizontal_offset = 0)  // Offset bottom biarc curve back
{
  // Break out size vector components
  width = size[0];
  depth = size[1];
  height = size[2];

  // Shorthand for common diameter measurement
  diameter = 2 * radius;

  // e = epsilon fudge factor to add to cut-outs for smoother rendering
  e = 0.1;
  e2 = 2 * e;

  // Draw cylinder oriented along x-axis
  module roll(location = [0, 0, 0], h = width) {
    translate(location)
      rotate([0, 90, 0])  // "Up" is now towards the front
        cylinder(r = radius, h = h, $fn = 360);
  }

  difference() {
    union() {
      difference() {

        // Base cube that fills the desired space
        cube([width, depth, height]);

        // Cut out space for the bottom-most cylinder curve
        translate([-e, -e, -e])
          cube([width + e2, horizontal_offset + diameter + e, radius + e]);
      }
      // Add bottom-most cylinder curve
      roll([0, horizontal_offset + diameter, radius]);
    }
    union() {

      // Cut out front/bottom facing cylinder curve
      roll([-e, horizontal_offset, vertical_offset + radius], width + e2);

      // Cut to front facing vertical face of indentation
      translate([-e, -e, -e])
        cube([width + e2,
              horizontal_offset + radius + e,
              vertical_offset + radius + e]);

      // Cut to bottom facing horizontal face of indentation
      translate([-e, -e, vertical_offset + radius - e])
        cube([width + e2, horizontal_offset + e, radius + e]);

      // Cut off any degenerate case overhang behind solid
      translate([-e, depth, -e])
        cube([width + e2, horizontal_offset + e, height + e]);
    }
  }
}

// Example usage: render a biarc curved transition from z = 5 to z = 10
module biarc_cutout_example() {
  box_size = [20, 10, 10];
  z_low = 5;
  z_high = 10;
  radius = (z_high - z_low) / 2;
  e = 0.1;
  e2 = 2 * e;

  difference() {
    cube(box_size);
    translate([-e, box_size[1] + e, z_low])
      mirror([0, 1, 0])
        biarc_cutout([box_size[0] + e2, box_size[1] + e2, box_size[2]], radius);
  }
}
