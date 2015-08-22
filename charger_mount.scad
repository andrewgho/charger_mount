// e = epsilon fudge factor to add to cut-outs for smoother rendering
e = 0.1;
e2 = e * 2;

module charger_bottom(h_shell) {
  // Outer dimensions of charger shell (all dimensions in mm)
  w_shell = 96;
  d_shell = 36;

  // Bottom center dimple top/bottom width and cut-out height
  w_dimple_top = 23;
  w_dimple_bottom = 25;
  w_dimple_diff = (w_dimple_bottom - w_dimple_top) / 2;
  h_dimple = 2.5;

  // Front outer corner vertical bevels are 45° cut-outs with 6mm faces
  w_front_bevel = 6 / sqrt(2);

  // Rear bottom horizontal bevel extends 7.5mm deep, 4.5mm inwards
  rear_bevel_d = 7.5;
  rear_bevel_h = 4.5;
  rear_bevel_angle = atan(rear_bevel_h / rear_bevel_d);

  // Given angle theta, adjacent length, and height, render right triangle
  module right_triangle(theta, x, z) {
    y = tan(theta) * x;
    linear_extrude(height = z)
      polygon([[0, 0], [0, -e], [x + e, -e], [x + e, y], [x, y]]);
  }

  difference() {
    cube([w_shell, d_shell, h_shell]);
    union() {
      // Bottom center dimple
      translate([(w_shell - w_dimple_top) / 2, -e, h_dimple])
        rotate([270, 270, 0])
        linear_extrude(height = d_shell + e2)
        polygon([[0, 0], [0, w_dimple_top],
                 [-h_dimple, w_dimple_top + w_dimple_diff],
                 [-(h_dimple + e), w_dimple_top + w_dimple_diff],
                 [-(h_dimple + e), -w_dimple_diff],
                 [-h_dimple, -w_dimple_diff]]);

      // Front outer corner vertical bevels (from front: left, right)
      translate([0, w_front_bevel, -e])
        rotate([0, 0, 270])
        right_triangle(45, w_front_bevel, h_shell + e2);
      translate([w_shell - w_front_bevel, 0, -e])
        right_triangle(45, w_front_bevel, h_shell + e2);

      // Rear bottom horizontal bevel
      translate([-e, d_shell - (rear_bevel_d), 0])
        rotate([90, 0, 90])
        right_triangle(rear_bevel_angle, rear_bevel_d, w_shell + e2);

      // Rear outer corner vertical bevels (from front: left, right)
      translate([0, d_shell - rear_bevel_d, -e])
        mirror([1, 0, 0])
        rotate([0, 0, 90])
        right_triangle(rear_bevel_angle, rear_bevel_d, h_shell + e2);
      translate([w_shell, d_shell - rear_bevel_d, -e])
        rotate([0, 0, 90])
        right_triangle(rear_bevel_angle, rear_bevel_d, h_shell + e2);
    }
  }
}

mount_height = 8;
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
