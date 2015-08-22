// charger_mount.scad - bottom wall mount bracket for Nitecore Intellicharger i4
// Andrew Ho (andrew@zeuscat.com)

// e = epsilon fudge factor to add to cut-outs for smoother rendering
e = 0.1;
e2 = e * 2;

// Model bottom portion of charger
module charger_bottom(shell_height) {
  // Outer dimensions of charger shell (all dimensions in mm)
  shell_width = 96;
  shell_depth = 36;

  // Bottom center dimple top/bottom width and cut-out height
  dimple_top_width = 23;
  dimple_bottom_width = 25;
  dimple_width_diff = (dimple_bottom_width - dimple_top_width) / 2;
  dimple_height = 2.5;

  // Front outer corner vertical bevels are 45° cut-outs with 6mm faces
  front_bevel_width = 6 / sqrt(2);

  // Rear bottom horizontal bevel extends 7.5mm deep, 4.5mm inwards
  rear_bevel_depth = 7.5;
  rear_bevel_height = 4.5;
  rear_bevel_angle = atan(rear_bevel_height / rear_bevel_depth);

  // Given angle theta, adjacent length, and height, render right triangle
  module right_triangle(theta, x, z) {
    y = tan(theta) * x;
    linear_extrude(height = z)
      polygon([[0, 0], [0, -e], [x + e, -e], [x + e, y], [x, y]]);
  }

  difference() {
    cube([shell_width, shell_depth, shell_height]);
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

      // Front outer corner vertical bevels (from front: left, right)
      translate([0, front_bevel_width, -e])
        rotate([0, 0, 270])
        right_triangle(45, front_bevel_width, shell_height + e2);
      translate([shell_width - front_bevel_width, 0, -e])
        right_triangle(45, front_bevel_width, shell_height + e2);

      // Rear bottom horizontal bevel
      translate([-e, shell_depth - (rear_bevel_depth), 0])
        rotate([90, 0, 90])
        right_triangle(rear_bevel_angle, rear_bevel_depth, shell_width + e2);

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

// Bottom wall mount bracket
mount_height = 6;
mount_thickness = 1;
mount_thickness2 = mount_thickness * 2;

difference() {
  translate([-mount_thickness / 2, -mount_thickness / 2, -mount_thickness / 2])
    minkowski() {
      charger_bottom(mount_height);
      cube(size = [mount_thickness, mount_thickness, mount_thickness]);
    }
  charger_bottom(mount_height + (mount_thickness / 2) + e);
}
