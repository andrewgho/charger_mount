// dimensions.scad - shared dimensions for Nitecore Intellicharger i4 wall mount
// Andrew Ho (andrew@zeuscat.com)

// Hull thickness of completed components
thickness = 1;

// Outer dimensions of charger shell (all dimensions in mm)
shell_width = 96;
shell_depth = 36;

// Top front outer corner vertical bevels are 45° cut-outs with 2.5mm faces
top_front_bevel_width = 2.5 / sqrt(2);

// Bottom front outer corner vertical bevels are 45° cut-outs with 6mm faces
bottom_front_bevel_width = 6 / sqrt(2);

// Bottom center dimple top/bottom width and cut-out height
dimple_top_width = 23;
dimple_bottom_width = 25;
dimple_width_diff = (dimple_bottom_width - dimple_top_width) / 2;
dimple_height = 2.5;

// Rear bottom horizontal bevel extends 7.5mm deep, 4.5mm inwards
rear_bevel_depth = 7.5;
rear_bevel_height = 4.5;
rear_bevel_angle = atan(rear_bevel_height / rear_bevel_depth);

// e = epsilon fudge factor to add to cut-outs for smoother rendering
e = 0.1;
e2 = e * 2;
