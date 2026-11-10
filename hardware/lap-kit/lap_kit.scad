// torabo-tsuki LP (L) simple-case lap kit
//   - wedge (L/R): 公式シンプルケースの下に既存M2ネジ穴で共締めする一様な厚さの板 (ハの字に配置)
//   - bridge: 2つのピル形 (先端半円) を中心でつないだブーメラン形。
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

br_t     = 4;     // ブリッジ・舌片の厚さ (= ポケットの深さ - clr)
br_len   = 46;    // ブリッジ本体の先端 (内側辺からの距離)。先端は半径 br_r の半円
br_y0    = -50;   // ブリッジ範囲 (ピボット基準 local y)
br_y1    = -8;
br_ext   = 12;    // 内側辺より先へ伸ばす量 (中心線 x=0 で左右がつながる)
br_round = 3;     // 中央の継ぎ目の角の丸め半径
br_ch    = 0.5;   // 上面の縁の面取り

tab_w    = 2.0;   // フランジの張り出し
tab_z0   = 1.4;   // フランジ下面 (付け根側) の高さ。下面は 45° で外へ向かって上がる
slide_len = 32;   // ブリッジの付け外しのスライド量 (約 30 mm で外れる)
clr      = 0.15;  // ポケットのすきま (0.2 だと若干ゆるかった)

mag_d    = 8.3;   // 磁石穴 (Ø8 + 公差)
mag_t    = 2;     // 磁石の厚み
mag_h    = mag_t + 0.1;  // 磁石穴の深さ (ブリッジ・舌片側)
mag_pts  = [[-24, -29]];   // ブリッジ磁石: 左側 local [x,y] (右はx反転)。片側1個

// ウェッジの厚さ: ポケット (br_t + clr) + 磁石。ウェッジ側の磁石穴は貫通させ、磁石の上面がケース底面に当たる
wedge_t  = br_t + clr + mag_t;

// パームレスト (サンワ TOK-MU2NBK2: W94 x D80 x H21, 角丸長方形)
pr_w     = 94;
pr_d     = 80;
pr_r     = 8;     // 置き場の角の丸め (パームレストの角 R 以下にする)
pr_clr   = 1.0;   // 置き場とパームレストのすきま (片側)
pr_cx    = 92;    // 置き場の中心 (内側辺からの距離, local x)
rim_w    = 2.4;   // 縁の幅
rim_h    = 3;     // 縁の高さ (プレート上面から)
plate_t  = 3;     // プレートの厚さ
pl_gap   = 0.5;   // ウェッジ手前面とプレートのすきま
tg_r     = 25;    // 舌片の先端半径 (幅 = 2 * tg_r)
tg_len   = 32;    // 舌片がウェッジに入る長さ (手前面から)
tg_mag   = 14;    // 舌片の磁石の位置 (手前面から)
pl_slide = 36;    // プレートの付け外しのスライド量 (約 34 mm で外れる)

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

// 左右の並進 (gap.sh で奥側の最接近 ≈ 2.2 mm になるよう求めた値)
x_off = 1.1;

z_lift = wedge_t + W_CASE * sin(tent) - Y_FRONT * sin(pitch);
$fn = 48;

// ブリッジのピル形 (local, R 向き)
br_r  = (br_y1 - br_y0) / 2;
br_yc = (br_y0 + br_y1) / 2;
br_xc = br_len - br_r;

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

// 全周フランジ付きの板: children = フランジ込みの外形 (2D)。下面は 45°、上の縁は br_ch 面取り
module flanged() {
    linear_extrude(tab_z0) offset(r = -tab_w) children();
    minkowski() {
        translate([0, 0, tab_z0]) linear_extrude(0.01) offset(r = -tab_w) children();
        cylinder(h = tab_w, r1 = 0, r2 = tab_w, $fn = 32);
    }
    translate([0, 0, tab_z0 + tab_w]) linear_extrude(br_t - br_ch - tab_z0 - tab_w) children();
    translate([0, 0, br_t - br_ch]) linear_extrude(br_ch) offset(r = -br_ch) children();
}

// ウェッジ側のポケット + 溝: children = フランジを除いた本体の外形 (2D, 凸形)。
// sweep 方向へ掃引して口を開ける (フランジの 45° 面を法線方向に clr オフセット)
module dovetail_pocket(sweep) {
    dz = clr * sqrt(2);
    zr = tab_z0 - dz - 1;               // 付け根 (本体側へ 1 mm 入った所) の高さ
    zo = tab_z0 - dz + tab_w + clr;     // 張り出し端の高さ
    translate([0, 0, -1]) linear_extrude(br_t + clr + 1)
        hull() { offset(r = clr) children(); translate(sweep) offset(r = clr) children(); }
    hull() for (v = [[0, 0], sweep]) translate(v) {
        translate([0, 0, zr]) linear_extrude(0.01) offset(r = -1) children();
        translate([0, 0, zo]) linear_extrude(br_t + 2 * clr - zo) offset(r = tab_w + clr) children();
    }
}

/* ---------- ブリッジ ---------- */

// ピル形 (local, R 向き): x_from から先端の半円まで。ofs で外側へ一様にオフセット
module pill2d(ofs, x_from = -br_ext)
    hull() {
        translate([br_xc, br_yc]) circle(r = br_r + ofs, $fn = 120);
        translate([x_from, br_y0 - ofs]) square([br_xc - x_from, br_y1 - br_y0 + 2 * ofs]);
    }

// 上から見た外形 (フランジ込み): 左右のピルを中心線 x=0 で切ってつなぎ、継ぎ目の角を丸める
module bridge_outline()
    offset(r = -br_round) offset(r = 2 * br_round) offset(r = -br_round)
        for (side = ["L", "R"]) intersection() {
            local3(side) pill2d(tab_w);
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

// 舌片の本体 (フランジを除く)。手前面 FE から tg_len 入る。手前側はプレートの中まで伸ばす
module tongue2d() hull() {
    translate([pr_cx, FE + tg_len - tg_r]) circle(r = tg_r, $fn = 120);
    translate([pr_cx - tg_r, FE - pl_gap - 6]) square([2 * tg_r, tg_len - tg_r + pl_gap + 6]);
}
pr_in_y1 = FE - pl_gap - rim_w;                 // 置き場の内側の奥端
pr_in_y0 = pr_in_y1 - (pr_d + 2 * pr_clr);      // 置き場の内側の手前端
module rest_in2d()
    translate([pr_cx, (pr_in_y0 + pr_in_y1) / 2])
        offset(r = pr_r) square([pr_w + 2 * pr_clr - 2 * pr_r, pr_d + 2 * pr_clr - 2 * pr_r], center = true);
module rest_out2d() offset(r = rim_w) rest_in2d();
tg_mag_p = [pr_cx, FE + tg_mag];

module plate_local() {
    difference() {
        union() {
            linear_extrude(plate_t) rest_out2d();
            linear_extrude(plate_t + rim_h) difference() { rest_out2d(); rest_in2d(); }
            // 舌片は置き場の奥の縁から先だけ (置き場の中に盛り上がらないように)
            intersection() {
                flanged() offset(r = tab_w) tongue2d();
                translate([pr_cx - 100, pr_in_y1, -1]) cube([200, 200, br_t + 2]);
            }
        }
        translate([tg_mag_p[0], tg_mag_p[1], br_t - mag_h]) cylinder(d = mag_d, h = mag_h + 1);
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
        local3(side) {
            // ブリッジ用: 内側 (-x) へ掃引
            dovetail_pocket([-200, 0]) pill2d(0, 0);
            // プレート用: 手前 (-y) へ掃引
            dovetail_pocket([0, -200]) tongue2d();
            // 磁石穴 (貫通。磁石の上面がケース底面に当たる)
            translate([tg_mag_p[0], tg_mag_p[1], br_t + clr - 0.01]) cylinder(d = mag_d, h = 20);
        }
        for (m = mag_pts) let(w = to_world2(side, [-s * m[0], m[1]]))
            translate([w[0], w[1], br_t + clr - 0.01]) cylinder(d = mag_d, h = 20);
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
module rest_dummy() translate([0, 0, plate_t])
    linear_extrude(21) translate([pr_cx, (pr_in_y0 + pr_in_y1) / 2])
        offset(r = pr_r) square([pr_w - 2 * pr_r, pr_d - 2 * pr_r], center = true);
module mags_wedge(sides = ["L", "R"]) for (side = sides) {
    for (m = mag_pts) let(s = sgn(side), w = to_world2(side, [-s * m[0], m[1]]))
        translate([w[0], w[1], br_t + clr]) cylinder(d = 8, h = mag_t);
    local3(side) translate([tg_mag_p[0], tg_mag_p[1], br_t + clr]) cylinder(d = 8, h = mag_t);
}
module mags_bridge() for (side = ["L", "R"]) for (m = mag_pts) let(s = sgn(side), w = to_world2(side, [-s * m[0], m[1]]))
    translate([w[0], w[1], br_t - mag_t]) cylinder(d = 8, h = mag_t);
module mags_plate(side) local3(side) translate([tg_mag_p[0], tg_mag_p[1], br_t - mag_t]) cylinder(d = 8, h = mag_t);

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
