// torabo-tsuki LP (L) simple-case lap kit
//   - wedge (L/R): 公式シンプルケースの下に既存M2ネジ穴で共締めする一様な厚さの板 (ハの字に配置)。
//                  手前にパームレスト置き場のプレートを一体で持つ (上面を下にして 1 部品で印刷)
//   - hinge: スガツネ HG-TS03 (トルクヒンジ) 1 個で左右のウェッジの底を直接つなぐ。背中合わせにたたむ
//
// part = "assembly" | "wedge_L" | "wedge_R" | "coupon_L" | "coupon_R"
part = "assembly";

// 公式リポジトリ (sekigon-gonnoc/torabo-tsuki-lp) を ./official に clone して使う
STL_DIR = "official/3d-models/STL/option/L-size/";
STL_L = str(STL_DIR, "torabo-tsuki-lp-L-simple-case-left-key.stl");
STL_R = str(STL_DIR, "torabo-tsuki-lp-L-simple-case-right-tb.stl");

/* ---------- 調整パラメータ ---------- */
tent   = 0;    // ウェッジの厚みで付けるテンティング角 [deg] (使わない。テンティングはヒンジの角度 use_th で付ける)
pitch  = 0;    // 前後の傾斜 [deg] (奥が上がる)
splay  = 8;    // ハの字 片側あたり [deg] (奥が近く手前が開く)

pl_t     = 5.4;   // 板の厚さ (ウェッジ・置き場で共通)
// ヒンジ: スガツネ HG-TS03 (トルク 0.35 N·m、フリーストップ) 1 個を、左右のウェッジの底に羽根を埋めてねじ止め。
// 平らなとき羽根の取付面が上 (ウェッジ側)、軸筒は下に出る。軸は中心線上、取付面から hn_off 下 (底面より下)
// なので、背中合わせにたたむ間ずっと左右の半身は中心線の自分の側にいる (ぶつからない)。
// 羽根は M4 ボルト + 袋ナットで留める。ナットはケースの外 (左右の間) のウェッジ上面に出るので、
// 左右の間隔を広げ (x_off)、ウェッジの内側にヒンジ用の張り出し (hn_tab) を足す。
// 寸法はメーカー図 (2026-11-12 確認): 全長 32・開いた幅 36・穴ピッチ 18 × 21・M4 穴 Ø4.3・板厚 1.2・軸筒 Ø7.5・取付面から軸 4.25
hn_len   = 32;    // 全長 (軸方向)
hn_w     = 18;    // 軸の中心から羽根の端まで (開いた幅 36 の半分)
hn_t     = 1.2;   // 羽根の板厚
hn_d     = 7.5;   // 軸筒の直径
hn_off   = 4.25;  // 羽根の取付面から軸の中心まで
hn_holes = [[10.5, -9], [10.5, 9]];   // 片側の羽根の穴 [軸からの距離 (ピッチ 21 の半分), 丁番の中心からの y (ピッチ 18)]
hn_hole  = 4.3;
hn_yc    = -50;   // 丁番の中心 (world y)。キーボードの前後の中ほど (2026-11-12 に -25 から。ハの字で手前ほど左右のケースが離れ、袋ナットとケースのすきまが広がる)
hn_bolt  = 4.5;   // M4 ボルトの通し穴
hn_nut   = 7;     // M4 袋ナットの二面幅
hn_nut_h = 4;     // 袋ナットの六角部の高さ (目安)
hn_cap_h = 7;     // 袋ナットの全高 (目安。ネジ穴の深さ 4〜5 なら M4x10 の先 (座金の上 3.8) は奥に当たらない)
hn_wsh_d = 8;     // M4 平座金 (小形) の外径。ナットは上面に座金を挟んで置き、スパナで押さえて締める
hn_wsh_t = 0.8;   // 座金の厚さ
hn_fr    = 6;     // 張り出しの付け根の R
hn_tab_m = 3;     // 張り出しの羽根の掘り込みからの余白 (y 方向)
use_th   = 8;     // 使用時の片側テンティング角 [deg] (ヒンジの角度)。左右の内側の面がこの角度でぴったり当たり、平らな側へは戻らない
hn_clr   = 0.3;   // 羽根・軸筒のまわりのすきま
hn_za    = hn_t - hn_off;  // 軸の高さ (底面 z=0 より下)
// ウェッジの厚さ: 置き場部分と同じ (2026-11-11 に 8.65 から変更。ポケット・磁石が無くなったため)
wedge_t  = pl_t;

// パームレスト (W80 x D60 x H18, 角 R3 の角丸長方形)
pr_w     = 80;
pr_d     = 60;
pr_h     = 18;
pr_r     = 3;     // パームレストの角 R
pr_rot   = 5;     // ウェッジに対する追加のハの字 [deg] (手前が外へ開く)
// 置き場は上から見てパームレストと同じ外形の平らな板 (くぼみ・縁なし。両面テープで貼る)
fill_band = 5;    // 置き場とつなぐときに使うウェッジ手前の帯の幅 (手前面 FE から奥へ)

// クッションゴム (3M CS-01、丸形 Ø7.9 × 2.2) を貼る底のくぼみ。使用時 (テンティング) に机に届く外側の縁に沿って片側 3 個
ft_d     = 8.5;   // くぼみの直径 (Ø7.9 + すきま)
ft_dep   = 0.5;   // くぼみの深さ (ゴムは底から 1.7 出る)
// 位置 (local, R 向き): 奥の外側の角 / 外側の縁のケース手前寄り / 置き場の手前外側の角 (角から 9 mm 内側)。
// 外側の縁の M2 ネジ (x 149.2, y -20.2 / -77.2) の座ぐりは避ける
function ft_pos() = [[144, -10], [144, -90],
    [pr_cx, pr_cy] + rot2(pr_rot, [pr_w / 2 - 9, -pr_d / 2 + 9])];

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
pr_back  = 25;    // 2026-11-11 に一体印刷 (ベッド 220) のため置き場を 25 mm 奥へ
pr_cy    = FE - 0.5 - 2.4 - 41 - 50 + pr_back;  // 2.4: 旧縁幅 (中心位置を保つ)

// 左右の並進。ヒンジのナット・座金 (穴 x=10 のまわり) がケースの外に出るよう求めた値 (Ø9 の座金でも当たらない)
// (2026-11-11 に 1.1 から変更、2026-11-12 にヒンジ穴が軸から 10.5 と分かり 12.5 -> 13。奥側の最接近 2.25 -> 約 26 mm)
x_off = 13;

z_lift = wedge_t + W_CASE * sin(tent) - Y_FRONT * sin(pitch);
$fn = 48;

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

/* ---------- ヒンジ (スガツネ HG-TS03) ---------- */

module ycyl(x, z, y0, y1, d) translate([x, y1, z]) rotate([90, 0, 0]) cylinder(d = d, h = y1 - y0, $fn = 48);
// R 側のウェッジから除く部分 (world): 羽根の掘り込み (底面と面一)・軸筒の逃げ・下穴
module hn_cut_R() {
    y0 = hn_yc - hn_len / 2 - hn_clr; y1 = hn_yc + hn_len / 2 + hn_clr;
    translate([-1, y0, -1]) cube([hn_w + hn_clr + 1, y1 - y0, 1 + hn_t]);
    ycyl(0, hn_za, y0, y1, hn_d + 2 * hn_clr);
    for (h = hn_holes) translate([h[0], hn_yc + h[1], -1]) cylinder(d = hn_bolt, h = wedge_t + 2, $fn = 24);
}
function nut_cd(s) = s * 2 / sqrt(3);   // 二面幅 -> 外接円の直径
// ウェッジ内側のヒンジ用の張り出し (world 2D, R)。中心線近くからケースの中まで
module hn_tab_R() let(y0 = hn_yc - hn_len / 2 - hn_clr - hn_tab_m, y1 = hn_yc + hn_len / 2 + hn_clr + hn_tab_m, r = 2)
    translate([-3, y0]) offset(r = r) offset(delta = -r) square([60, y1 - y0]);  // 内側は stop_cut で切る
module hn_tab(side) if (side == "R") hn_tab_R(); else mirror([1, 0]) hn_tab_R();
// 張り出しとウェッジの内側の縁がつくるへこんだ角を半径 hn_fr で埋める。丸め処理 (offset 往復) は張り出しの
// まわりの箱の中だけに掛け、元の外形と union する (全体に掛けると丸め誤差で段差が出るため)
module hn_tab_fill(side) let(y0 = hn_yc - hn_len / 2 - hn_clr - hn_tab_m, y1 = hn_yc + hn_len / 2 + hn_clr + hn_tab_m)
    intersection() {
        offset(r = -hn_fr) offset(r = hn_fr) union() { case2d(side); hn_tab(side); }
        mirror([side == "L" ? 1 : 0, 0]) translate([-3, y0 - 3 * hn_fr]) square([60, y1 - y0 + 6 * hn_fr]);
    }
module hn_cut(side) if (side == "R") hn_cut_R(); else mirror([1, 0, 0]) hn_cut_R();

// 丁番の形 (確認用)。羽根は side ごと (R 側に軸筒を含める)
module hinge_leaf(side, barrel = true) let(sx = sgn(side), y0 = hn_yc - hn_len / 2) {
    difference() {
        translate([sx > 0 ? 0 : -hn_w, y0, 0]) cube([hn_w, hn_len, hn_t]);
        for (h = hn_holes) translate([sx * h[0], hn_yc + h[1], -1]) cylinder(d = hn_hole, h = 5, $fn = 16);
    }
    // 羽根から軸筒へ下りる部分
    translate([sx > 0 ? 0 : -hn_d / 2, y0, hn_za]) cube([hn_d / 2, hn_len, -hn_za]);
    if (side == "R" && barrel) difference() {
        ycyl(0, hn_za, y0 + 1.5, y0 + hn_len - 1.5, hn_d);
        ycyl(0, hn_za, y0, y0 + hn_len, 2);
    }
    // M4 トラス頭の目安 (Ø9.5 × 2.6)、上面の座金と袋ナット
    for (h = hn_holes) translate([sx * h[0], hn_yc + h[1], 0]) {
        translate([0, 0, -2.6]) cylinder(d = 9.5, h = 2.6, $fn = 32);
        translate([0, 0, wedge_t]) cylinder(d = hn_wsh_d, h = hn_wsh_t, $fn = 32);
        translate([0, 0, wedge_t + hn_wsh_t]) {
            rotate(30) cylinder(d = nut_cd(hn_nut), h = hn_nut_h, $fn = 6);
            translate([0, 0, hn_nut_h]) cylinder(d = hn_nut, h = hn_cap_h - hn_nut_h - hn_nut / 2 + 0.01, $fn = 32);
            translate([0, 0, hn_cap_h - hn_nut / 2]) intersection() { sphere(d = hn_nut, $fn = 32); cylinder(d = hn_nut, h = hn_nut / 2); }
        }
    }
}
// たたむ: 半身を軸 (中心線、z = hn_za) まわりに th 度回す (+ で外側が下がる = 背中合わせ。th = use_th が使用時)
module fold(side, th) translate([0, 0, hn_za]) rotate([0, sgn(side) * th, 0]) translate([0, 0, -hn_za]) children();
// 左右の内側の面 (当たり面): 軸を通り、use_th だけたたんだときに鉛直 (中心面) になる面。
// 半身の座標 (th = 0) では上ほど中心線を越えて反対側へ出る (use_th 8 で上面で約 1.2 mm)
module stop_cut(side) mirror([side == "L" ? 1 : 0, 0, 0])
    translate([0, 0, hn_za]) rotate([0, -use_th, 0]) translate([-1000, -500, -500]) cube(1000);

/* ---------- パームレスト置き場 ---------- */

module rest_place() translate([pr_cx, pr_cy]) rotate(pr_rot) children();
// パームレストの外形 (local, R 向き)。置き場の外形もこれと同じ
module rest2d() rest_place() offset(r = pr_r) square([pr_w - 2 * pr_r, pr_d - 2 * pr_r], center = true);

// ケース外形 (world 2D)
module case2d(side) translate([sgn(side) * x_off, 0]) rotate(sgn(side) * splay) outline(side);
// 上から見たウェッジ全体の外形 (world 2D): ケース外形 + (ケース手前の帯とパームレストの凸包)。
// 内側はケース手前の内側の角からパームレスト手前の内側の角へ、外側はケース手前の外側の角から
// パームレスト奥の外側の角へ、まっすぐつながる
module top2d(side) union() {
    case2d(side);
    hn_tab(side);
    hn_tab_fill(side);
    hull() {
        intersection() { case2d(side); lrect(side, -1000, 1000, -1000, FE + fill_band); }
        local3(side) rest2d();
    }
}

/* ---------- ウェッジ ---------- */

module wedge_world(side) {
    P = side == "L" ? P_L : P_R;
    H = side == "L" ? HOLES_L : HOLES_R;
    s = sgn(side);
    difference() {
        linear_extrude(wedge_t) top2d(side);
        // ネジ: ケース底面に垂直
        place(side) for (h = H) translate([h[0] - P[0], h[1] - P[1], 0]) {
            translate([0, 0, -skin - 1]) cylinder(d = screw_d, h = skin + 5);
            translate([0, 0, -80 - skin]) cylinder(d = head_d, h = 80);
        }
        hn_cut(side);
        stop_cut(side);
        local3(side) for (f = ft_pos()) translate([f[0], f[1], -1]) cylinder(d = ft_d, h = 1 + ft_dep);
    }
}

// テスト片: ヒンジの取付部だけ切り出し (掘り込み・下穴の確認)
module coupon_world(side) {
    s = sgn(side);
    intersection() {
        wedge_world(side);
        translate([s > 0 ? -2 : -(hn_w + 8), hn_yc - hn_len / 2 - 6, -1]) cube([hn_w + 10, hn_len + 12, 100]);
    }
}

// 印刷用: 上面 (ケースが載る面) を下にして置く (x 軸まわりに 180° 返す。198.4 x 211.7 に収まる)。
// ヒンジの掘り込み・軸筒の逃げ・ネジの座ぐりは上向きに開き、ブリッジは無い
module print_pose(side) translate([-sgn(side) * x_off, 0, wedge_t]) rotate([180, 0, 0]) children();

module world_side(side) { place(side) case_stl(side); wedge_world(side); }
module case_simple(side) {
    difference() {
        linear_extrude(8.5) outline(side);
        translate([0, 0, 1.5]) linear_extrude(10) offset(delta = -1.2) outline(side);
    }
}
module rest_dummy() translate([0, 0, pl_t]) linear_extrude(pr_h) rest2d();

if (part == "w_hinge_L") hinge_leaf("L");
else if (part == "w_hinge_R") hinge_leaf("R");
else if (part == "w_case_L") place("L") case_simple("L");
else if (part == "w_case_R") place("R") case_simple("R");
else if (part == "w_wedge_L") wedge_world("L");
else if (part == "w_wedge_R") wedge_world("R");
else if (part == "w_rest_L") local3("L") rest_dummy();
else if (part == "w_rest_R") local3("R") rest_dummy();
else if (part == "projL") projection() world_side("L");
else if (part == "projR") projection() world_side("R");
else if (part == "assembly") {
    // 使用時の姿勢 (片側 use_th のテンティング)
    for (side = ["L", "R"]) fold(side, use_th) {
        color("dimgray") place(side) case_stl(side);
        color("orange") wedge_world(side);
        color("silver") hinge_leaf(side);
        color("#333", 0.5) local3(side) rest_dummy();
    }
} else if (part == "wedge_L") {
    print_pose("L") wedge_world("L");
} else if (part == "wedge_R") {
    print_pose("R") wedge_world("R");
} else if (part == "coupon_L") {
    print_pose("L") coupon_world("L");
} else if (part == "coupon_R") {
    print_pose("R") coupon_world("R");
}
