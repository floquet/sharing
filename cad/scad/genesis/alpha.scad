// Satellite Model

$fn=100; // Controls smoothness by number of segments
$fa=5;   // Alternative control by maximum angle per segment
$fs=0.5; // Alternative control by maximum segment size

// Body (Sphere)
module body() {
    translate([0, 0, 0])
    sphere(1);
}

// Solar Panel A (6x2x1) - aligned along the bisector between z and x axes
module solar_panel_A() {
    // Rotate the panel by 45 degrees around the y-axis
    // to align it along a bisector between the longest and shortest axes
    translate([-1/2, -1, -1])    // Position relative to body
    rotate([0, 90, 0])      // Rotate around y-axis to bisect x and z planes
    cube([6, 2, 1]);
}

// Solar Panel B (3x2x1)
module solar_panel_B() {
    translate([-4, -1, -1/2
    ])  // Adjust position relative to body if needed
    cube([3, 2, 1]);
}

// Assemble the model
body();
solar_panel_A();
solar_panel_B();
