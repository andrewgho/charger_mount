// charger.scad - base Nitecore Intellicharger i4 model
// Andrew Ho (andrew@zeuscat.com)

include <dimensions.scad>

// Model midpoint of charger (small front bevels, no top/bottom features)
module charger_top(shell_height) {
  charger_body(shell_height, top_front_bevel_width);
}

// Model bottom of charger (large front bevels, bottom topology)
module charger_bottom(shell_height) {
  difference() {
    charger_body(shell_height, bottom_front_bevel_width);
    union() {

      // Bottom center dimple
      translate([(shell_width - dimple_top_width) / 2, -e, dimple_height])
        rotate([270, 270, 0])
        linear_extrude(height = shell_depth + e2)
        polygon([[0, 0], [0, dimple_top_width],
                 [-dimple_height, dimple_top_width + dimple_width_diff],
                 [-(dimple_height + e), dimple_top_width + dimple_width_diff],
                 [-(dimple_height + e), -dimple_width_diff],
                 [-dimple_height, -dimple_width_diff]]);

      // Rear bottom horizontal bevel
      translate([-e, shell_depth - (rear_bevel_depth), 0])
        rotate([90, 0, 90])
        right_triangle(rear_bevel_angle, rear_bevel_depth, shell_width + e2);
    }
  }
}

// Base charger body model (cut out front and back bevels)
module charger_body(shell_height, front_bevel_width) {
  difference() {
    cube([shell_width, shell_depth, shell_height]);
    union() {
      // Front outer corner vertical bevels (from front: left, right)
      translate([0, front_bevel_width, -e])
        rotate([0, 0, 270])
        right_triangle(45, front_bevel_width, shell_height + e2);
      translate([shell_width - front_bevel_width, 0, -e])
        right_triangle(45, front_bevel_width, shell_height + e2);

      // Rear outer corner vertical bevels (from front: left, right)
      translate([0, shell_depth - rear_bevel_depth, -e])
        mirror([1, 0, 0])
        rotate([0, 0, 90])
        right_triangle(rear_bevel_angle, rear_bevel_depth, shell_height + e2);
      translate([shell_width, shell_depth - rear_bevel_depth, -e])
        rotate([0, 0, 90])
        right_triangle(rear_bevel_angle, rear_bevel_depth, shell_height + e2);
    }
  }
}

// Given angle theta, adjacent length, and height, render right triangle
module right_triangle(theta, x, z) {
  y = tan(theta) * x;
  linear_extrude(height = z)
    polygon([[0, 0], [0, -e], [x + e, -e], [x + e, y], [x, y]]);
}
