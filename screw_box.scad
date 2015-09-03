// screw_box.scad - rear-facing screw mount box
// Andrew Ho (andrew@zeuscat.com)
//
// screw_box(location, size, thickness) { ... } will add a rear-facing
// screw mount box of the given size, translated to the given location.
// "Rear-facing" assumes that the child object(s) have their rear in
// the positive y (positive depth) direction. The screw mount hole will 
// punch through one thickness unit on the rear of the child object(s).
//
// Optional hole_diameter and head_diameter arguments accommodate
// different screw sizes; the default measurements are in mm, calibrated
// for #8 × 1½″ pan head machine screws taken from the following
// TOGGLER SnapSkru self-drilling anchor set:
// http://www.amazon.com/TOGGLER-SnapSkru-Self-Drilling-Drywall-Anchor/dp/B0051IB63Q

module screw_box(location,              // Translation vector (x, y, z)
                 size,                  // Size vector (H × W × D)
                 thickness = 1,         // Hull thickness
                 hole_diameter = 4.78,  // Through hole diameter
                 head_diameter = 9,     // Hole with clearance for screw head
                 hole_pattern = [1/2],  // Vector of left/right hole locations
                 brace_pattern = [])    // Vector of vertical brace locations
{
  // Break out size vector components
  width = size[0];
  depth = size[1];
  height = size[2];

  // Shorthand for common 2 × thickness measurement
  thickness2 = 2 * thickness;

  // e = epsilon fudge factor to add to cut-outs for smoother rendering
  e = 0.1;
  e2 = 2 * e;

  difference() {
    union() {

      // Render children, so we can punch screw head hole through them
      children();
      translate(location) {

        // Surrounding box walls
        difference() {
          cube(size);
          translate([thickness, thickness, thickness])
            cube([width - thickness2, depth + e, height - thickness2]);
        }

        // Horizontal cross-brace
        translate([0, 0, (height - thickness) / 2])
          cube([width, depth, thickness]);

        // Vertical cross-braces
        for(fraction = concat(hole_pattern, brace_pattern)) {
          translate([(width - thickness) * fraction, 0, 0])
            cube([thickness, depth, height]);
        }

        // Solid cylinders through which screw holes will be punched
        for(fraction = hole_pattern) {
          translate([width * fraction, 0, height / 2])
            rotate([270, 0, 0])  // "Up" is now towards the rear
              cylinder(d = head_diameter + thickness2, h = depth, $fn = 360);
        }
      }
    }
    translate(location) {
      for(fraction = hole_pattern) {
        translate([width * fraction, -e, height / 2]) {
          rotate([270, 0, 0]) {  // "Up" is now towards the rear

            // Screw head hole, leaves one thickness on rear for mounting
            cylinder(d = head_diameter, h = depth - thickness + e, $fn = 360);

            // Screw shaft hole, goes all the way through rear
            cylinder(d = hole_diameter, h = depth + e2, $fn = 360);
          }
        }
      }
    }
  }
}

// Example usage: draw an open box, then add a screw mount to its rear
module screw_box_example() {
  open_box_size = [40, 10, 30];
  screw_box_size = [25, 5, 20];
  thickness = 1;
  thickness2 = 2 * thickness;
  e = 0.1;

  screw_box([(open_box_size[0] - screw_box_size[0]) / 2,
             open_box_size[1] - thickness,
             (open_box_size[2] - screw_box_size[2]) / 2],
            screw_box_size,
            thickness) {
    difference() {
      cube(open_box_size);
      translate([thickness, -e, thickness])
        cube([open_box_size[0] - thickness2,
              open_box_size[1] - thickness + e,
              open_box_size[2] - thickness2]);
    }
  }
}
