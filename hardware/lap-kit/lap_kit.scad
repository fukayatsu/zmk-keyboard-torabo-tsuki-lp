// torabo-tsuki LP (L) simple-case lap kit
//   - wedge (L/R): 公式シンプルケースの下に既存M2ネジ穴で共締めする一様な厚さの板 (ハの字に配置)。
//                  手前にパームレスト置き場のプレートを一体で持つ (上面を下にして 1 部品で印刷)
//   - hinge: スガツネ HG-TS03 (トルクヒンジ) 1 個で左右のウェッジの底を直接つなぐ。背中合わせにたたむ
//
// part = "assembly" | "wedge_L" | "wedge_R" | "coupon_L" | "coupon_R" | "coupon_sw" | "sw_lid" (2 個)
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
// 羽根は M4 皿小ねじ (六角穴付き) を上から通し、底の羽根側を薄型ナットで留める (2026-11-13 に下からのボルト + 上面の
// 袋ナットから変更。袋ナットが電池カバーに近すぎ、いちばん奥のナットを外さないとカバーを外せなかったため)。
// 皿の座ぐりで頭は上面と面一になり、上には何も出ない。ネジはケースの外 (左右の間) に来るので、
// 左右の間隔を広げ (x_off)、ウェッジの内側にヒンジ用の張り出し (hn_tab) を足す。
// 寸法はメーカー図 (2026-11-12 確認): 全長 32・開いた幅 36・穴ピッチ 18 × 21・M4 穴 Ø4.3・板厚 1.2・軸筒 Ø7.5・取付面から軸 4.25
hn_len   = 32;    // 全長 (軸方向)
hn_w     = 18;    // 軸の中心から羽根の端まで (開いた幅 36 の半分)
hn_t     = 1.2;   // 羽根の板厚
hn_d     = 7.5;   // 軸筒の直径
hn_off   = 4.25;  // 羽根の取付面から軸の中心まで
hn_holes = [[10.5, -9], [10.5, 9]];   // 片側の羽根の穴 [軸からの距離 (ピッチ 21 の半分), 丁番の中心からの y (ピッチ 18)]
hn_hole  = 4.3;
hn_ycs   = [-26, -76];  // 丁番の中心 (world y)。2 個を同じ軸 (中心線) に前後に離して並べ、使用時の剛性を上げる
                        // (2026-11-12: 1 個 (-25 -> -50) から 2 個 (-35, -85) に。2026-11-15: 上面のネジが面一になったので
                        //  奥へ寄せて張り出し (奥の縁は中心で y 約 1.6、手前の端は hn_ty0) の中で前後対称に。
                        //  丁番どうしの間は 18 mm、奥・手前の余白は約 12 mm。いちばん奥の皿の座ぐり Ø9 と
                        //  ケースのすきまは約 0.4 mm で、これ以上奥へは寄せられない)
hn_bolt  = 4.5;   // M4 ボルトの通し穴
hn_csk_d = 9.0;   // 皿の座ぐりの上面での直径 (六角穴付き皿ボルト M4 の頭 Ø8.96 以下。90° の円錐、深さ 2.25)。
                  // 上面を下にして印刷するので 45° の円錐はブリッジなしで出る
hn_nut   = 7;     // M4 薄型ナット (3 種) の二面幅
hn_nut_h = 2.4;   // 薄型ナットの厚さ
hn_tip   = 0.2;   // ナットから出るネジ先の目安 (M4x8: 板 5.4 + ナット 2.4 = 7.8)
hn_er    = 5;     // 張り出しの内側の縁 (当たり面) の前後の角の R (たたんだとき上に来る角)
hn_fr2   = 15;    // 張り出しの手前の付け根の R (置き場へ向かう斜めの縁との鈍角)
hn_tab_m = 3;     // 張り出しの羽根の掘り込みからの余白 (y 方向)
use_th   = 8;     // 使用時の片側テンティング角 [deg] (ヒンジの角度)。左右の内側の面がこの角度でぴったり当たり、平らな側へは戻らない
hn_clr   = 0.3;   // 羽根・軸筒のまわりのすきま
// 張り出し (2 個をまたぐ 1 枚) の前後の端
hn_ty0   = -104.3;  // 手前の端は固定 (丁番を -85 に置いていたときの位置 = ケース手前の内側の角のあたり。丁番を動かしても形を変えない)
hn_ty1   = max(hn_ycs) + hn_len / 2 + hn_clr + hn_tab_m;
hn_za    = hn_t - hn_off;  // 軸の高さ (底面 z=0 より下)
// 開閉検出スイッチ: オムロン D2F-01 (ピン押しボタン形、微小負荷用・金合金接点、はんだづけ端子) を左右に 1 個ずつ、
// どちらも 2 個の丁番の間の中央に左右対称に置く (2026-11-19。はじめはレバー形 D2F-01L を左右で前後にずらしたが、
// 持ち運び時に出っ張らないピン押しボタン形で左右とも中央に、というユーザーの要望で変更)。
// それぞれのキーボードの電池 + 線に直列に入れ (COM と NO)、使用時の角度まで開くと電源が入る。たたむと切れる。
// 左右の回路は独立でヒンジをまたぐ配線は無い。
// 押しボタンは本体の中心から sw_pin_y 寄っているので、左右でスイッチの向きを反対にし (R は奥寄り、L は手前寄り)、
// それぞれの押しボタンが相手のスイッチ本体の平らな面 (押しボタンの無い側) を押すようにする (ユーザーの案。
// はじめは同じ向きで押しボタンどうしを突き合わせていた)。押しボタンの押し込み量は左右の本体どうしのすきまで
// 決まり、左右のばねの釣り合いによらない。
// 本体の面どうしを平行に向かい合わせるため、スイッチは使用時の姿勢で水平 (ウェッジに対して use_th 傾く。
// 押しボタンの向きが当たり面に垂直) に置く。以下の sw_* の x・z は「使用時の座標」(半身を use_th たたんだ
// world。当たり面が x = 0 の鉛直面) で書き、fold(side, -use_th) で半身の座標へ戻す。
// 横倒し (厚さ 5.8 が上下) で底から掘ったポケットに入れる。上面側は閉じた床 (sw_floor 以上) で、上には何も出ない。
// 固定は底のふた (sw_lid): ふたのピンをスイッチの取付穴 Ø2 に差し、ふたを M2×8 皿小ねじ (上から。頭は上面と面一) と
// ふたに埋めた M2 ナットで留める (2026-11-19 ユーザーの案: ヒンジと同じ皿ボルト + ナット。スイッチの取付穴に直接
// 通すと 皿頭 + スイッチ 5.8 + ナット が板厚と たたみのすきまに収まらないので、ふたのネジをこの方式にした)。
// ナットはふたの底側の六角の長いくぼみに入って回らず、上からドライバーだけで締められる (開いた姿勢のまま調整できる)。
// ふたの長穴でスイッチを当たり面に対して前後 (x) に ±sw_adj 動かし、入り切りの角度を合わせる (動作位置の公差 ±0.3、
// 動作後の動き 0.25 以上と余裕が小さいため)。ふたはウェッジの底に平行 (半身の座標)、スイッチは 8° 傾くので、ふたの
// スイッチの下は斜めの台、ピンも 8° 傾く。配線はふたの上の底の溝を通り、電池カバーの壁の真下で上面へ抜ける。
// 寸法はメーカーのカタログ (B036-E1-12): 本体 12.8 × 5.8 × 6.5、取付穴 Ø2 ピッチ 6.5 (押しボタン側の面から 5.0)、
// 押しボタン 1.2 × 2.9 (片方の取付穴から 1.2 = 本体の中心から 2.05)、取付穴から押しボタン先まで 動作位置 5.5±0.3、
// 動作までの動き 0.5 以下、動作後の動き 0.25 以上、端子の長さ 3.5
sw_len   = 12.8;  // 本体の長さ (y)
sw_h     = 6.5;   // 本体の高さ (押しボタン側の面から端子側の面まで。横倒しなので x)
sw_th    = 5.8;   // 本体の厚さ (横倒しなので z)
sw_pitch = 6.5;   // 取付穴のピッチ
sw_hole_x = 5.0;  // 押しボタン側の面から取付穴まで
sw_pin_y = 2.05;  // 押しボタンの位置 (本体の中心から。R は奥寄り、L は手前寄りに向ける。左右で 4.1 離れる)
sw_floor = 0.6;   // ポケットの床 (上面側に残す厚さの最小)
sw_clr   = 0.2;   // 本体のまわりのすきま
sw_x0    = 0.3;   // 押しボタン側の面の位置 (当たり面から。長穴の中央のとき)。左右の本体のすきまは 2 倍の 0.6 で、
                  // 押しボタンの動作位置 (本体の面から 0.5±0.3) の少し手前。左右どちらかの長穴で詰める
sw_adj   = 0.55;  // 長穴による調整しろ (±)
sw_term  = 4.5;   // 端子と配線の場所 (端子側の面より外側へ)
sw_yc    = (hn_ycs[0] + hn_ycs[1]) / 2;   // スイッチの中心 (world y)。2 個の丁番の間の中央
// 使用時の座標での上面・底面の高さ (x の位置で)
function sw_ztop(x) = hn_za + (pl_t - hn_za) / cos(use_th) - x * tan(use_th);
function sw_zbot(x) = hn_za - hn_za / cos(use_th) - x * tan(use_th);
sw_xb    = sw_x0 + sw_adj + sw_h + sw_clr;          // 本体の場所の外側の端
sw_xt    = sw_xb + sw_term;                          // 端子の場所の外側の端
sw_zc    = sw_ztop(sw_xb) - sw_floor / cos(use_th);  // 本体の場所の天井
sw_zb    = sw_zc - 0.1 - sw_th - 0.05;               // 本体の底 = ふたの当たる面
// ふた (半身の座標、R 向き)
sw_lid_z0 = -2.45; // ふたの底
sw_lid_z1 = -1.65; // ふたの板の上の面 (スイッチの下。これより内側ではスイッチのほうが下に出る)
sw_lid_x0 = 3.8;   // ふたの内側の端 (これより内側は本体が見える)
sw_lid_x1 = 19;    // ふたの外側の端
sw_lid_xe = 12.9;  // ふたの外側の厚い部分 (底面に当たる) の内側の端。ポケットの外側の端より外
sw_lid_hw = 6.8;   // ふたの幅の半分 (y)
sw_lid_sx = 15;    // ふたのネジの位置 (x)。皿頭が電池カバーの壁に掛からない位置
sw_lid_sy = 4.0;   // ふたのネジの位置 (y、中心から ±)
sw_bolt  = 2.3;    // M2 の通し穴・ふたの長穴の幅
sw_csk_d = 4.2;    // M2 皿小ねじの座ぐりの上面での直径 (頭 Ø4 以下。90° の円錐)
sw_nut   = 4.1;    // M2 ナットの二面幅 + すきま
sw_nut_h = 1.6;    // M2 ナットの厚さ (1 種)
sw_pin_d = 1.8;    // ふたのピン (スイッチの取付穴 Ø2 に入る)
sw_pin_h = 2.2;
// 配線: ポケットの外側の端から底の溝 (sw_wire_w) を通り、ケースの内側の辺の手前 (電池カバーの壁の真下あたり) で
// 上面へ抜ける長穴へ。長穴はケースの内側の辺から内側へ sw_wire_in、ケースの下へ sw_wire_out
sw_wire_w = 2.5;
sw_wire_in = 2.5;
sw_wire_out = 1;
function sw_xe() = x_off - sw_yc * tan(splay);   // スイッチの位置でのケースの内側の辺 (world x、平らなとき)
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
BK      = [[7.0, 4.08], [36.4, 5.26]];  // 奥の直線辺 (内側の段より外側) の 2 点 (local)

// 置き場の中心 (local)。x: 回転前のパームレストの外側の辺がウェッジの外側の辺 (x = W_CASE) から pr_out はみ出す位置
pr_out   = 5;
pr_cx    = W_CASE + pr_out - pr_w / 2;
pr_back  = 25;    // 2026-11-11 に一体印刷 (ベッド 220) のため置き場を 25 mm 奥へ
pr_cy    = FE - 0.5 - 2.4 - 41 - 50 + pr_back;  // 2.4: 旧縁幅 (中心位置を保つ)

// 左右の並進。ヒンジのネジ (穴 x=10.5 のまわり、皿の座ぐり Ø9) がケースの外に出るよう求めた値
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
module hn_cut_R() for (yc = hn_ycs) {
    y0 = yc - hn_len / 2 - hn_clr; y1 = yc + hn_len / 2 + hn_clr;
    translate([-1, y0, -1]) cube([hn_w + hn_clr + 1, y1 - y0, 1 + hn_t]);
    ycyl(0, hn_za, y0, y1, hn_d + 2 * hn_clr);
    for (h = hn_holes) translate([h[0], yc + h[1], 0]) {
        translate([0, 0, -1]) cylinder(d = hn_bolt, h = wedge_t + 2, $fn = 24);
        // 皿の座ぐり (上面に開く 90° の円錐)
        translate([0, 0, wedge_t - (hn_csk_d - hn_bolt) / 2])
            cylinder(d1 = hn_bolt, d2 = hn_csk_d + 0.02, h = (hn_csk_d - hn_bolt) / 2 + 0.01, $fn = 48);
    }
}
function nut_cd(s) = s * 2 / sqrt(3);   // 二面幅 -> 外接円の直径
// ウェッジ内側のヒンジ用の張り出し (world 2D, R)。中心線近くからケースの中まで
module hn_tab_R() let(y0 = hn_ty0, y1 = hn_ty1, r = 2)
    translate([-3, y0]) offset(r = r) offset(delta = -r) square([60, y1 - y0]);  // 内側は stop_cut で切る
module hn_tab(side) if (side == "R") hn_tab_R(); else mirror([1, 0]) hn_tab_R();
// 張り出しの奥: 張り出しからケースの奥の辺まで、左右のケースの間のへこみと奥の内側の角の段を埋める。
// 奥の縁はケースの奥の直線辺 (BK) をそのまま中心線まで延ばした直線 (ケースの辺とは同じ直線でつながる)
module hn_back_fill_R() let(a = to_world2("R", BK[0]), b = to_world2("R", BK[1]),
                            yl = a[1] + (b[1] - a[1]) / (b[0] - a[0]) * (-3 - a[0]))
    polygon([[-3, hn_ty1 - 3], [-3, yl], a, [a[0], hn_ty1 - 3]]);
// 張り出しの手前: 置き場へ向かう斜めの縁とのへこんだ角 (鈍角) を半径 hn_fr2 で埋める。丸め処理 (offset 往復) は
// 張り出しのまわりの箱の中だけに掛け、元の外形と union する (全体に掛けると丸め誤差で段差が出るため)
module hn_tab_fill(side) {
    if (side == "R") hn_back_fill_R(); else mirror([1, 0]) hn_back_fill_R();
    hn_round(side, hn_fr2, hn_ty0 - 3 * hn_fr2, hn_ty0 + hn_fr2);
}
module hn_round(side, r, y0, y1) intersection() {
    offset(r = -r) offset(r = r) union() { base2d(side); hn_tab(side); }
    mirror([side == "L" ? 1 : 0, 0]) translate([-3, y0]) square([60, y1 - y0]);
}
// 張り出しの内側の縁 (当たり面) の前後の角を半径 hn_er で丸める切り取り (R)。当たり面は傾いているので、
// 当たり面の位置 (2D の x = 0) で丸めた形を当たり面に沿って斜めに押し出す (y 方向は変わらない)
module hn_corner_cut_R() let(yb = to_world2("R", BK[0])[1], r = hn_er,
                             t = tan(use_th))
    multmatrix([[1, 0, -t, hn_za * t], [0, 1, 0, 0], [0, 0, 1, 0]]) translate([0, 0, -1])
        linear_extrude(wedge_t + 2) for (b = [[hn_ty0 - 5, hn_ty0 + r + 1], [yb - 3 * r, yb + 5]])
            difference() {
                translate([-5, b[0]]) square([r + 6, b[1] - b[0]]);
                offset(r = r) offset(delta = -r) intersection() {
                    top2d("R");
                    translate([0, -500]) square(1000);
                }
            }
module hn_corner_cut(side) if (side == "R") hn_corner_cut_R(); else mirror([1, 0, 0]) hn_corner_cut_R();
module hn_cut(side) if (side == "R") hn_cut_R(); else mirror([1, 0, 0]) hn_cut_R();

// 丁番の形 (確認用)。羽根は side ごと (R 側に軸筒を含める)。hn_ycs の全部
module hinge_leaf(side, barrel = true) for (yc = hn_ycs) hinge_leaf1(side, yc, barrel);
module hinge_leaf1(side, hn_yc, barrel) let(sx = sgn(side), y0 = hn_yc - hn_len / 2) {
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
    // 底の薄型ナットとネジ先、上面と面一の皿頭 (座ぐりより少し小さく描く)
    for (h = hn_holes) translate([sx * h[0], hn_yc + h[1], 0]) {
        translate([0, 0, -hn_nut_h]) rotate(30) cylinder(d = nut_cd(hn_nut), h = hn_nut_h, $fn = 6);
        translate([0, 0, -hn_nut_h - hn_tip]) cylinder(d = 4, h = hn_tip + 0.01, $fn = 24);
        translate([0, 0, wedge_t - 2.2]) cylinder(d1 = 4, d2 = 8.4, h = 2.2, $fn = 32);
    }
}
// たたむ: 半身を軸 (中心線、z = hn_za) まわりに th 度回す (+ で外側が下がる = 背中合わせ。th = use_th が使用時)
module fold(side, th) translate([0, 0, hn_za]) rotate([0, sgn(side) * th, 0]) translate([0, 0, -hn_za]) children();
// 左右の内側の面 (当たり面): 軸を通り、use_th だけたたんだときに鉛直 (中心面) になる面。
// 半身の座標 (th = 0) では上ほど中心線を越えて反対側へ出る (use_th 8 で上面で約 1.2 mm)
module stop_cut(side) mirror([side == "L" ? 1 : 0, 0, 0])
    translate([0, 0, hn_za]) rotate([0, -use_th, 0]) translate([-1000, -500, -500]) cube(1000);

/* ---------- 開閉検出スイッチ (オムロン D2F-01) ---------- */

// 半身の座標 (R 向き、y はスイッチの中心から) で書いたものを置く
module sw_frame(side) mirror([side == "L" ? 1 : 0, 0, 0]) translate([0, sw_yc, 0]) children();
// 使用時の座標で書いたものを半身の座標へ戻す
module sw_use() fold("R", -use_th) children();
// ウェッジから除く部分 (R 向き、y はスイッチの中心から)
module sw_cut0() let(hl = sw_len / 2 + sw_clr, zt = sw_ztop(sw_xt) - sw_floor / cos(use_th)) {
    sw_use() {
        // 本体の場所 (当たり面を抜ける)
        translate([-5, -hl, -20]) cube([5 + sw_xb, 2 * hl, 20 + sw_zc]);
        // 端子・配線の場所 (上面が下がるぶん天井を下げる)
        translate([sw_xb - 0.01, -hl, -20]) cube([sw_term + 0.01, 2 * hl, 20 + zt]);
        // 配線の溝 (底) と、上面へ抜ける長穴
        translate([sw_xt - 0.5, -sw_wire_w / 2, -20]) cube([sw_xe() - sw_xt, sw_wire_w, 20 + sw_zb + 1.6]);
        translate([sw_xe() - sw_wire_in, -sw_wire_w / 2, -20]) cube([sw_wire_in + sw_wire_out, sw_wire_w, 40]);
    }
    // ふたの M2 皿小ねじ (上面に垂直。通し穴と、上面に開く 90° の円錐の座ぐり)
    for (dy = [-1, 1] * sw_lid_sy) translate([sw_lid_sx, dy, 0]) {
        translate([0, 0, -1]) cylinder(d = sw_bolt, h = wedge_t + 2, $fn = 24);
        translate([0, 0, wedge_t - (sw_csk_d - sw_bolt) / 2])
            cylinder(d1 = sw_bolt, d2 = sw_csk_d + 0.02, h = (sw_csk_d - sw_bolt) / 2 + 0.01, $fn = 32);
    }
}
module sw_cuts(side) sw_frame(side) sw_cut0();
// ふた (R 向き)。左右で同じ形 (前後対称なので、左右反転 = 180° 回転)
module sw_lid0() {
    difference() {
        union() {
            // 板
            translate([sw_lid_x0, -sw_lid_hw, sw_lid_z0]) cube([sw_lid_x1 - sw_lid_x0, 2 * sw_lid_hw, sw_lid_z1 - sw_lid_z0]);
            // 外側の厚い部分 (ウェッジの底に当たる)
            translate([sw_lid_xe, -sw_lid_hw, sw_lid_z0]) cube([sw_lid_x1 - sw_lid_xe, 2 * sw_lid_hw, -sw_lid_z0]);
            // スイッチの下の斜めの台 (スイッチの底の面まで)
            intersection() {
                translate([sw_lid_x0, -sw_len / 2, sw_lid_z0]) cube([sw_xb - sw_lid_x0, sw_len, 3]);
                sw_use() translate([-50, -50, -50]) cube([100, 100, 50 + sw_zb]);
            }
        }
        for (dy = [-1, 1] * sw_lid_sy) {
            // 長穴
            hull() for (dx = [-1, 1] * sw_adj) translate([sw_lid_sx + dx, dy, sw_lid_z0 - 1]) cylinder(d = sw_bolt, h = 5, $fn = 24);
            // ナットの入る六角の長いくぼみ (底側に開く。二面が x に平行で、ナットは回らずに前後に動ける)
            hull() for (dx = [-1, 1] * sw_adj) translate([sw_lid_sx + dx, dy, sw_lid_z0 - 1])
                cylinder(d = nut_cd(sw_nut), h = 1 + sw_nut_h, $fn = 6);
        }
    }
    // ピン (スイッチの取付穴の向き = 8° 傾く)
    sw_use() for (dy = [-1, 1] * sw_pitch / 2) translate([sw_x0 + sw_hole_x, dy, sw_zb - 0.6])
        cylinder(d = sw_pin_d, h = sw_pin_h + 0.6, $fn = 24);
}
// スイッチの形 (確認用)。押しボタンは押された位置。pin_y は押しボタンの寄っている向き
module sw_dummy0(pin_y = sw_pin_y) {
    sw_use() {
        translate([sw_x0, -sw_len / 2, sw_zb + 0.05]) cube([sw_h, sw_len, sw_th]);
        translate([-sw_x0 + 0.02, pin_y - 0.6, sw_zb + 0.05 + sw_th / 2 - 1.45]) cube([2 * sw_x0 + 0.01, 1.2, 2.9]);
        for (dy = [-5.08, 0, 5.08]) translate([sw_x0 + sw_h, dy - 0.6, sw_zb + sw_th / 2 - 0.15]) cube([3.5, 1.2, 0.4]);
    }
    sw_lid0();
    // M2×8 皿小ねじ (頭は上面と面一、座ぐりより少し小さく描く) とナット
    for (dy = [-1, 1] * sw_lid_sy) translate([sw_lid_sx, dy, 0]) {
        translate([0, 0, wedge_t - 0.9]) cylinder(d1 = 2, d2 = 3.8, h = 0.9, $fn = 24);
        translate([0, 0, wedge_t - 8]) cylinder(d = 2, h = 7.2, $fn = 16);
        translate([0, 0, sw_lid_z0]) cylinder(d = nut_cd(4), h = sw_nut_h, $fn = 6);
    }
}
module sw_dummy(side) sw_frame(side) sw_dummy0(side == "R" ? sw_pin_y : -sw_pin_y);

/* ---------- パームレスト置き場 ---------- */

module rest_place() translate([pr_cx, pr_cy]) rotate(pr_rot) children();
// パームレストの外形 (local, R 向き)。置き場の外形もこれと同じ
module rest2d() rest_place() offset(r = pr_r) square([pr_w - 2 * pr_r, pr_d - 2 * pr_r], center = true);

// ケース外形 (world 2D)
module case2d(side) translate([sgn(side) * x_off, 0]) rotate(sgn(side) * splay) outline(side);
// 上から見たウェッジ全体の外形 (world 2D): ケース外形 + (ケース手前の帯とパームレストの凸包)。
// 内側はケース手前の内側の角からパームレスト手前の内側の角へ、外側はケース手前の外側の角から
// パームレスト奥の外側の角へ、まっすぐつながる
module base2d(side) union() {
    case2d(side);
    hull() {
        intersection() { case2d(side); lrect(side, -1000, 1000, -1000, FE + fill_band); }
        local3(side) rest2d();
    }
}
module top2d(side) union() {
    base2d(side);
    hn_tab(side);
    hn_tab_fill(side);
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
        hn_corner_cut(side);
        sw_cuts(side);
        local3(side) for (f = ft_pos()) translate([f[0], f[1], -1]) cylinder(d = ft_d, h = 1 + ft_dep);
    }
}

// テスト片: ヒンジの取付部だけ切り出し (掘り込み・下穴の確認)
module coupon_world(side) {
    s = sgn(side);
    intersection() {
        wedge_world(side);
        translate([s > 0 ? -2 : -(hn_w + 8), hn_ycs[0] - hn_len / 2 - 6, -1]) cube([hn_w + 10, hn_len + 12, 100]);  // 奥のヒンジ 1 個分
    }
}

// テスト片: 開閉検出スイッチのポケットだけ切り出し (スイッチのはまり具合・ふた・配線の穴を確認)。R 側の形
module coupon_sw_world() intersection() {
    wedge_world("R");
    translate([-3, sw_yc - sw_len / 2 - 2.3, -1]) cube([sw_xe() + sw_wire_out + 5, sw_len + 4.6, 100]);
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

if (part == "w_hinge_L") { hinge_leaf("L"); sw_dummy("L"); }
else if (part == "w_hinge_R") { hinge_leaf("R"); sw_dummy("R"); }
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
        color("crimson") sw_dummy(side);
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
} else if (part == "coupon_sw") {
    print_pose("R") coupon_sw_world();
} else if (part == "sw_lid") {
    // ふた: 平らな面を下、ピンを上にして印刷
    translate([-sw_lid_x0, 0, -sw_lid_z0]) sw_lid0();
}
