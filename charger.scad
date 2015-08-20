// Outer dimensions of charger shell
w_shell = 96;
d_shell = 36;
h_shell = 8;

// Bottom center dimple width and cut-out height
w_dimple = 22.5;
h_dimple = h_shell - 4.5;

// e = epsilon fudge factor to add to cut-outs for smoother rendering
e = 0.1;
e2 = e * 2;

// Shortcuts for centered cube and translated, centered cube
module c(x, y, z) { cube(size = [x, y, z], center = true); }
module tc(dx, dy, dz, x, y, z) { translate([dx, dy, dz]) c(x, y, z); }

difference() {
  c(w_shell, d_shell, h_shell);
  {
    // Bottom center dimple
    tc(0, 0, (h_dimple - h_shell) / 2, w_dimple, d_shell + e2, h_dimple + e);

    // Outer front vertical bevels
    translate([w_shell / 2, -d_shell / 2, 0])
      rotate([0, 0, 45])
      c(5, 5, h_shell + e2);
    translate([-w_shell / 2, -d_shell / 2, 0])
      rotate([0, 0, 45])
      c(5, 5, h_shell + e2);

    // Bottom rear horizontal bezel
    translate([0, d_shell / 2, -h_shell / 2])
      rotate([atan(6 / 9), 0, 0])
      c(w_shell + e2, 4, 2);
  }
}
