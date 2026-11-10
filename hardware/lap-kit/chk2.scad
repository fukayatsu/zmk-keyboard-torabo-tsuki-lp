include <lap_kit.scad>
side = "R"; t = 0; lift = 0; rot = 0;
function odir(side) = let(s = sgn(side), v = rot2(s * splay, [s * cos(tent), 0])) v / norm(v);
// rot: 半身を内側辺 (帯の中央) まわりに回す。+ で外側が上がる
pv = concat(to_world2(side, [0, (br_y0 + br_y1) / 2]), [0]);
ax = concat(rot2(sgn(side) * splay, [0, 1]), [0]);
intersection() {
    bridge();
    translate(concat(odir(side) * t, [lift]))
        translate(pv) rotate(a = -sgn(side) * rot, v = ax) translate(-pv) wedge_world(side);
}
