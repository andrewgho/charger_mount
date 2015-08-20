w_shell = 96;
d_shell = 36;
h_shell = 8;

w_dimple = 22.5;
h_dimple = h_shell - 4.5;

e = 0.1;
e2 = e * 2;

difference() {
  cube([w_shell, d_shell, h_shell]);
  translate([(w_shell - w_dimple) / 2, -e, -e])
    cube([w_dimple, d_shell + e2, h_dimple + e]);
}
