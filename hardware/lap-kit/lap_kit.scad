// torabo-tsuki LP (L) simple-case lap kit
//   - wedge (L/R): 公式シンプルケースの下に既存M2ネジ穴で共締めする一様な厚さの板 (ハの字に配置)
//   - bridge: 2つの角丸四角形 (先端の角 R6) を中心でつないだブーメラン形。
//             全周の 45° フランジが、ウェッジ底面ポケットの溝に入るスライドロック (内側から差し込む)
//   - plate (L/R): パームレスト置き場。全周フランジ付きの舌片をウェッジ手前のポケットに前から差し込む
//   + Ø8x2 磁石 (ロック位置の保持・ガタ取り)
//
// part = "assembly" | "wedge_L" | "wedge_R" | "bridge" | "plate_L" | "plate_R" | "coupon_L" | "coupon_R"
part = "assembly";

// 公式リポジトリ (sekigon-gonnoc/torabo-tsuki-lp) を ./official に clone して使う
STL_DIR = "official/3d-models/STL/option/L-size/";
STL_L = str(STL_DIR, "torabo-tsuki-lp-L-simple-case-left-key.stl");
STL_R = str(STL_DIR, "torabo-tsuki-lp-L-simple-case-right-tb.stl");

/* ---------- 調整パラメータ ---------- */
tent   = 0;    // テンティング角 [deg] (内側が上がる)
pitch  = 0;    // 前後の傾斜 [deg] (奥が上がる)
splay  = 8;    // ハの字 片側あたり [deg] (奥が近く手前が開く)

br_len   = 46;    // ブリッジ本体の先端 (内側辺からの距離)。先端は角丸の四角形 (角 R = br_rc)
br_rc    = 6;     // ブリッジ先端の角 R (フランジを除く本体)
br_y0    = -50;   // ブリッジ範囲 (ピボット基準 local y)
br_y1    = -8;
br_ext   = 12;    // 内側辺より先へ伸ばす量 (中心線 x=0 で左右がつながる)
br_round_f = 80;  // 中央の継ぎ目 手前側 (出っ張った角) の丸め半径
br_round_b = 80;  // 中央の継ぎ目 奥側 (へこんだ角) の丸め半径

tab_w    = 2.0;   // フランジの張り出し
tab_z0   = 1.4;   // フランジ下面 (付け根側) の高さ。下面は 45° で外へ向かって上がる
tab_top  = tab_w; // フランジ上の垂直部の高さ (45° 部の高さ tab_w と同じ)
// ブリッジ・舌片の厚さ (= ポケットの深さ - clr): 下の垂直部 + 45° 部 + 上の垂直部
br_t     = tab_z0 + tab_w + tab_top;
slide_len = 48;   // ブリッジの付け外しのスライド量 (約 46 mm で外れる)
clr      = 0.15;  // ポケットのすきま (0.2 だと若干ゆるかった)

mag_d    = 8.3;   // 磁石穴 (Ø8 + 公差)
mag_t    = 2;     // 磁石の厚み
mag_h    = mag_t + 0.1;  // 磁石穴の深さ (ブリッジ・舌片・ウェッジ共通)
mag_skin = 1.0;   // ウェッジの磁石穴の天井 (ケース底面側の肉厚)
mag_pts  = [[-24, -40], [-24, -18]];   // ブリッジ磁石: 左側 local [x,y] (右はx反転)。片側2個 (回転方向のがたつき防止)

// ウェッジの厚さ: ポケット (br_t + clr) + 磁石穴 (くぼみ) + 天井
wedge_t  = br_t + clr + mag_h + mag_skin;

// パームレスト (W80 x D60 x H18, 角 R3 の角丸長方形)
pr_w     = 80;
pr_d     = 60;
pr_h     = 18;
pr_r     = 3;     // パームレストの角 R (置き場の角は pr_r + pr_clr)
pr_rot   = 5;     // ウェッジに対する追加のハの字 [deg] (手前が外へ開く)
pr_clr   = 1.0;   // 置き場とパームレストのすきま (片側)
rim_w    = 2.4;   // 縁の幅
pr_depth = 1;     // パームレスト置き場の深さ (プレート上面から)
plate_t  = br_t - pr_depth;  // 置き場の床の厚さ
pl_gap   = 0.5;   // ウェッジ手前面とプレートのすきま
pl_fillet = 10;   // 舌片と置き場の付け根の丸め半径
tg_r     = 25;    // 舌片の先端半径 (幅 = 2 * tg_r)
tg_len   = 60;    // 舌片がウェッジに入る長さ (手前面から)
tg_rc    = 6;     // 舌片先端の角 R (フランジを除く本体)
tg_mag   = tg_len - 12;    // 舌片の磁石の位置 (手前面から)
tg_mag_dx = 12;   // 舌片の磁石 2 個の中心からの横のずれ (回転方向のがたつき防止)
pl_slide = tg_len + 4;     // プレートの付け外しのスライド量 (約 tg_len + 2 で外れる)

screw_d   = 2.4;  // M2 通し穴
head_d    = 4.6;  // なべ頭用ザグリ
skin      = 1.5;  // ザグリ天井 (=ケース底面からの肉厚) -> M2x6 想定 (ケース側に Ø5x0.7 座ぐりあり)

/* ---------- ケース実測値 (公式STL座標) ---------- */
// ピボット = 内側直線辺の奥端, ケース底面
P_L = [-59.2, 134.0, -6.6];
P_R = [-27.5, 134.0, -6.6];
HOLES_L = [[-208.4,113.6],[-208.4,56.6],[-115.2,121.6],[-70.5,38.9]];
HOLES_R = [[121.7,113.8],[121.7,56.8],[28.5,121.8],[-16.2,39.1]];
W_CASE = 154;
Y_FRONT = -107.6;  // ケース手前端 (親指部分, ピボット基準 local y)
FE      = -98.2;   // 手前の直線辺 (local x 42〜151) の y

// 置き場の中心 (local)。x: 回転前のパームレストの外側の辺がウェッジの外側の辺 (x = W_CASE) から pr_out はみ出す位置
pr_out   = 5;
pr_cx    = W_CASE + pr_out - pr_w / 2;
pr_cy    = FE - pl_gap - rim_w - 41 - 50;
// 置き場の外周の半幅・半奥行・角 R
pr_oa    = pr_w / 2 + pr_clr + rim_w;
pr_ob    = pr_d / 2 + pr_clr + rim_w;
pr_orc   = pr_r + pr_clr + rim_w;
// 回転後の置き場の外周の最も内側 (-x) の x (内側奥の角 R の頂点) と、内側奥の角の y
pr_in_x  = pr_cx - (pr_oa - pr_orc) * cos(pr_rot) - (pr_ob - pr_orc) * sin(pr_rot) - pr_orc;
pr_tl_y  = pr_cy - pr_oa * sin(pr_rot) + pr_ob * cos(pr_rot);
// 舌片の中心 (local x): 舌片の内側の辺 (フランジ込み) を置き場の内側の辺に揃える
tg_cx    = pr_in_x + tg_r + tab_w;

// 左右の並進 (gap.sh で奥側の最接近 ≈ 2.2 mm になるよう求めた値)
x_off = 1.1;

z_lift = wedge_t + W_CASE * sin(tent) - Y_FRONT * sin(pitch);
$fn = 48;

// ブリッジのピル形 (local, R 向き)

function sgn(side) = side == "L" ? -1 : 1;
// local(ピボット原点, ケース底面 z=0) -> world の 2D 写像 (z=0 平面上の点)
function rot2(a, p) = [p[0]*cos(a) - p[1]*sin(a), p[0]*sin(a) + p[1]*cos(a)];
function to_world2(side, p) =
    [sgn(side) * x_off, 0] + rot2(sgn(side) * splay, [p[0] * cos(tent), p[1] * cos(pitch)]);

module place(side) {
    s = sgn(side);
    translate([s * x_off, 0, z_lift])
        rotate([0, 0, s * splay])
            rotate([pitch, 0, 0])
                rotate([0, s * tent, 0])
                    children();
}

// local 座標 (R 向き = +x で書く) を world の床面 (z=0 基準) へ。to_world2 と同じ写像。L は x 反転
module local3(side) {
    s = sgn(side);
    translate([s * x_off, 0, 0]) rotate([0, 0, s * splay])
        scale([cos(tent), cos(pitch), 1]) mirror([side == "L" ? 1 : 0, 0, 0]) children();
}

module case_stl(side) {
    P = side == "L" ? P_L : P_R;
    translate(-P) import(side == "L" ? STL_L : STL_R);
}

// ケース底面の外形 (ネジ穴・小さな切欠きを埋める)
module outline(side) {
    offset(r = -3) offset(r = 3)
        projection(cut = true) translate([0, 0, -0.2]) case_stl(side);
}

// local 矩形 [x0,x1]x[y0,y1] を world 2D 多角形に
module lrect(side, x0, x1, y0, y1)
    polygon([for (p = [[x0, y0], [x1, y0], [x1, y1], [x0, y1]]) to_world2(side, p)]);

/* ---------- 全周フランジのスライドロック (ブリッジ・プレート共通) ---------- */

// 全周フランジ付きの板: children = フランジ込みの外形 (2D)。断面は 垂直 tab_z0 → 45° (tab_w) → 垂直 tab_top
module flanged() {
    linear_extrude(tab_z0) offset(r = -tab_w) children();
    minkowski() {
        translate([0, 0, tab_z0]) linear_extrude(0.01) offset(r = -tab_w) children();
        cylinder(h = tab_w, r1 = 0, r2 = tab_w, $fn = 32);
    }
    translate([0, 0, tab_z0 + tab_w]) linear_extrude(tab_top) children();
}

// 2D 図形を v 方向へ掃引 (凹形でも可)
module swept2d(v) minkowski() {
    children();
    hull() { square(0.01, center = true); translate(v) square(0.01, center = true); }
}

// ウェッジ側のポケット + 溝: children = フランジを除いた本体の外形 (2D, 凹形でも可)。
// sweep 方向へ掃引して口を開ける (フランジの 45° 面を法線方向に clr オフセット)
module dovetail_pocket(sweep) {
    dz = clr * sqrt(2);
    zr = tab_z0 - dz - 1;               // 付け根 (本体側へ 1 mm 入った所) の高さ
    zo = tab_z0 - dz + tab_w + clr;     // 張り出し端の高さ
    translate([0, 0, -1]) linear_extrude(br_t + clr + 1) swept2d(sweep) offset(r = clr) children();
    minkowski() {
        translate([0, 0, zr]) linear_extrude(0.01) swept2d(sweep) offset(r = -1) children();
        cylinder(h = zo - zr, r1 = 0, r2 = zo - zr, $fn = 32);
    }
    translate([0, 0, zo]) linear_extrude(br_t + 2 * clr - zo) swept2d(sweep) offset(r = tab_w + clr) children();
}

/* ---------- ブリッジ ---------- */

// ブリッジ片側の形 (local, R 向き): x_from から角丸四角形の先端まで。ofs で外側へ一様にオフセット
module pill2d(ofs, x_from = -br_ext)
    hull() {
        for (y = [br_y0 + br_rc, br_y1 - br_rc]) translate([br_len - br_rc, y]) circle(r = br_rc + ofs, $fn = 64);
        translate([x_from, br_y0 - ofs]) square([br_len - br_rc - x_from, br_y1 - br_y0 + 2 * ofs]);
    }

// 継ぎ目の角 (world, 中心線 x=0 上): R 側の local y = ly の直線が x=0 と交わる点
function seam_pt(ly) = to_world2("R", [(ly * sin(splay) - x_off) / cos(splay), ly]);
// 継ぎ目の角の丸め用: 角 c と、角の上側 (+y) に中心を置く半径 rr の円の間の三角形の残り
module seam_corner(c, rr) {
    t = rr * tan(splay);
    difference() {
        polygon([c, c + t * [cos(splay), sin(splay)], c + t * [-cos(splay), sin(splay)]]);
        translate(c + [0, rr / cos(splay)]) circle(r = rr, $fn = 720);
    }
}

// 上から見た外形 (フランジ込み): 左右のピルを中心線 x=0 で切ってつなぎ、
// 手前の出っ張った角は削り、奥のへこんだ角は埋めて丸める
module bridge_outline() {
    difference() {
        for (side = ["L", "R"]) intersection() {
            local3(side) pill2d(tab_w);
            translate([side == "R" ? 0 : -500, -500]) square([500, 1000]);
        }
        seam_corner(seam_pt(br_y0 - tab_w), br_round_f);
    }
    seam_corner(seam_pt(br_y1 + tab_w), br_round_b);
}
// 片側のウェッジに入る部分の本体 (フランジを除く, world)
module bridge_body_half(side)
    intersection() {
        offset(r = -tab_w) bridge_outline();
        translate([side == "R" ? 0 : -500, -500]) square([500, 1000]);
    }

module bridge() {
    difference() {
        flanged() bridge_outline();
        for (side = ["L", "R"]) for (m = mag_pts) let(s = sgn(side), w = to_world2(side, [-s * m[0], m[1]]))
            translate([w[0], w[1], br_t - mag_h]) cylinder(d = mag_d, h = mag_h + 1);
    }
}

// 印刷用ブリッジ: 磁石穴を上にしてそのまま (フランジ下面は 45°)
module bridge_print() bridge();

/* ---------- パームレスト用プレート (local, R 向き) ---------- */

// 舌片の本体 (フランジを除く)。手前面 FE から tg_len 入る。手前側は置き場の内側奥の角 (pr_tl_y) まで伸ばす
module tongue2d() hull() {
    for (sx = [-1, 1]) translate([tg_cx + sx * (tg_r - tg_rc), FE + tg_len - tg_rc]) circle(r = tg_rc, $fn = 64);
    translate([tg_cx - tg_r, pr_tl_y]) square([2 * tg_r, FE + tg_len - tg_rc - pr_tl_y]);
}
module rest_place() translate([pr_cx, pr_cy]) rotate(pr_rot) children();
module rest2d() rest_place() offset(r = pr_r) square([pr_w - 2 * pr_r, pr_d - 2 * pr_r], center = true);
module rest_in2d() offset(r = pr_clr) rest2d();
module rest_out2d() offset(r = rim_w) rest_in2d();

tg_mag_ps = [for (sx = [-1, 1]) [tg_cx + sx * tg_mag_dx, FE + tg_mag]];
// プレートを上から見た外形 (フランジ込み)。舌片と置き場の付け根のへこんだ角を pl_fillet で丸める
// 内側 (-x) は舌片の辺から置き場の内側の辺へまっすぐつなぐ (hull)。
// 外側のへこんだ角だけ pl_fillet で丸める (丸め処理は角のまわりだけに使い、他の辺は元の多角形のまま)
module plate_base2d() union() {
    offset(r = tab_w) tongue2d();
    rest_out2d();
    // 舌片の内側の辺の線 (x = tg_cx - tg_r - tab_w) より外へは出さない
    intersection() {
        hull() {
            intersection() { offset(r = tab_w) tongue2d(); translate([-500, pr_tl_y]) square([500 + tg_cx, 500]); }
            intersection() { rest_out2d(); translate([-500, -500]) square([500 + tg_cx, 1000]); }
        }
        translate([tg_cx - tg_r - tab_w, -500]) square([500, 1000]);
    }
}
// 外側の付け根の角: 舌片の外側の辺 x = pr_fx と、置き場の奥の辺の交点付近
pr_fx = tg_cx + tg_r + tab_w;
pr_fy = pr_cy + ((pr_fx - pr_cx + pr_ob * sin(pr_rot)) / cos(pr_rot)) * sin(pr_rot) + pr_ob * cos(pr_rot);
module plate_top2d() union() {
    plate_base2d();
    intersection() {
        offset(r = -pl_fillet) offset(r = pl_fillet) plate_base2d();
        translate([pr_fx - 1, pr_fy - 3]) square([2 * pl_fillet, 2 * pl_fillet]);
    }
}

// 舌片のフランジ下の切り欠き (ウェッジに入る部分, y >= FE - pl_gap)
module tongue_undercut() {
    y0 = FE - pl_gap;
    z1 = tab_z0 + tab_w;   // 45° 部の上端
    intersection() {
        // 外形の柱 (z < z1) から、フランジ断面を引く。舌片は凸形なので 45° 部は 2 枚の断面の hull で正確に作る
        difference() {
            translate([0, 0, -0.01]) linear_extrude(z1 + 0.01) offset(r = tab_w) tongue2d();
            linear_extrude(tab_z0) tongue2d();
            hull() {
                translate([0, 0, tab_z0]) linear_extrude(0.001) tongue2d();
                translate([0, 0, z1 - 0.001]) linear_extrude(0.1) offset(r = tab_w) tongue2d();
            }
        }
        translate([-500, y0, -1]) cube([1000, 500, br_t + 2]);
    }
}

module plate_local() {
    difference() {
        // 上から見た外形の板 (高さ br_t)。付け根は丸める
        linear_extrude(br_t) plate_top2d();
        // ウェッジに入る部分だけフランジ断面にする。外は垂直な側面
        tongue_undercut();
        // 置き場: 床 plate_t を残して掘る
        translate([0, 0, plate_t]) linear_extrude(br_t) rest_in2d();
        for (m = tg_mag_ps) translate([m[0], m[1], br_t - mag_h]) cylinder(d = mag_d, h = mag_h + 1);
    }
}

/* ---------- ウェッジ ---------- */

module wedge_world(side) {
    P = side == "L" ? P_L : P_R;
    H = side == "L" ? HOLES_L : HOLES_R;
    s = sgn(side);
    difference() {
        intersection() {
            place(side) translate([0, 0, -60]) linear_extrude(60) outline(side);
            translate([-500, -500, 0]) cube([1000, 1000, 200]);
        }
        // ネジ: ケース底面に垂直
        place(side) for (h = H) translate([h[0] - P[0], h[1] - P[1], 0]) {
            translate([0, 0, -skin - 1]) cylinder(d = screw_d, h = skin + 5);
            translate([0, 0, -80 - skin]) cylinder(d = head_d, h = 80);
        }
        // ブリッジ用: 内側 (local -x) へ掃引
        dovetail_pocket(rot2(s * splay, [-s * 200, 0])) bridge_body_half(side);
        local3(side) {
            // プレート用: 手前 (-y) へ掃引
            dovetail_pocket([0, -200]) tongue2d();
            // 磁石穴 (ポケットの天井から上へくぼみ。ケース側は mag_skin 残す)
            for (m = tg_mag_ps) translate([m[0], m[1], br_t + clr - 0.01]) cylinder(d = mag_d, h = mag_h + 0.01);
        }
        for (m = mag_pts) let(w = to_world2(side, [-s * m[0], m[1]]))
            translate([w[0], w[1], br_t + clr - 0.01]) cylinder(d = mag_d, h = mag_h + 0.01);
    }
}

// テスト片: ブリッジ用ポケットまわりだけ切り出し
module coupon_world(side) {
    s = sgn(side);
    intersection() {
        wedge_world(side);
        translate([0, 0, -1]) linear_extrude(100)
            lrect(side, s * (br_len + 8), -s * 20, br_y0 - 10, br_y1 + 10);
    }
}

// 印刷用: ケース当たり面(平面)を下にして置く -> ポケット/ザグリ/磁石穴がすべて上向きでサポート不要
module print_pose(side) {
    s = sgn(side);
    rotate([180, 0, 0])
        rotate([0, -s * tent, 0]) rotate([-pitch, 0, 0]) rotate([0, 0, -s * splay])
            translate([-s * x_off, 0, -z_lift]) children();
}

module world_side(side) { place(side) case_stl(side); wedge_world(side); local3(side) plate_local(); }
module case_simple(side) {
    difference() {
        linear_extrude(8.5) outline(side);
        translate([0, 0, 1.5]) linear_extrude(10) offset(delta = -1.2) outline(side);
    }
}
module rest_dummy() translate([0, 0, plate_t]) linear_extrude(pr_h) rest2d();
module mags_wedge(sides = ["L", "R"]) for (side = sides) {
    for (m = mag_pts) let(s = sgn(side), w = to_world2(side, [-s * m[0], m[1]]))
        translate([w[0], w[1], br_t + clr + mag_h - mag_t]) cylinder(d = 8, h = mag_t);
    local3(side) for (m = tg_mag_ps) translate([m[0], m[1], br_t + clr + mag_h - mag_t]) cylinder(d = 8, h = mag_t);
}
module mags_bridge() for (side = ["L", "R"]) for (m = mag_pts) let(s = sgn(side), w = to_world2(side, [-s * m[0], m[1]]))
    translate([w[0], w[1], br_t - mag_t]) cylinder(d = 8, h = mag_t);
module mags_plate(side) local3(side) for (m = tg_mag_ps) translate([m[0], m[1], br_t - mag_t]) cylinder(d = 8, h = mag_t);

if (part == "w_bridge") bridge();
else if (part == "w_case_L") place("L") case_simple("L");
else if (part == "w_case_R") place("R") case_simple("R");
else if (part == "w_wedge_L") wedge_world("L");
else if (part == "w_wedge_R") wedge_world("R");
else if (part == "w_plate_L") local3("L") plate_local();
else if (part == "w_plate_R") local3("R") plate_local();
else if (part == "w_rest_L") local3("L") rest_dummy();
else if (part == "w_rest_R") local3("R") rest_dummy();
else if (part == "w_mag_wedge_L") mags_wedge(["L"]);
else if (part == "w_mag_wedge_R") mags_wedge(["R"]);
else if (part == "w_mag_bridge") mags_bridge();
else if (part == "w_mag_plate_L") mags_plate("L");
else if (part == "w_mag_plate_R") mags_plate("R");
else if (part == "projL") projection() world_side("L");
else if (part == "projR") projection() world_side("R");
else if (part == "assembly") {
    color("dimgray") for (side = ["L", "R"]) place(side) case_stl(side);
    color("orange") for (side = ["L", "R"]) wedge_world(side);
    color("deepskyblue") bridge();
    color("mediumseagreen") for (side = ["L", "R"]) local3(side) plate_local();
    color("#333", 0.5) for (side = ["L", "R"]) local3(side) rest_dummy();
} else if (part == "wedge_L") {
    print_pose("L") wedge_world("L");
} else if (part == "wedge_R") {
    print_pose("R") wedge_world("R");
} else if (part == "bridge") {
    bridge_print();
} else if (part == "plate_L") {
    mirror([1, 0, 0]) plate_local();
} else if (part == "plate_R") {
    plate_local();
} else if (part == "coupon_L") {
    print_pose("L") coupon_world("L");
} else if (part == "coupon_R") {
    print_pose("R") coupon_world("R");
}
