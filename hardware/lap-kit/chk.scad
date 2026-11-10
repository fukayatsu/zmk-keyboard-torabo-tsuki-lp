include <lap_kit.scad>
side = "R"; t = 0; lift = 0;
function odir(side) = let(s = sgn(side), v = rot2(s * splay, [s * cos(tent), 0])) v / norm(v);
intersection() {
    bridge();
    translate(concat(odir(side) * t, [lift])) wedge_world(side);
}
