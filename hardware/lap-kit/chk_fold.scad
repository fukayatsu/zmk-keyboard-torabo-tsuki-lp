// ヒンジでたたむときの干渉チェック。結果の体積が 0 なら干渉なし
//   openscad -D 'part="none"' -D 'side="R"' -D th=45 -D mode="mid" -o /tmp/chk.stl chk_fold.scad
//   th: たたむ角度 [deg] (0 = 平ら、90 = 底面どうしが向き合う、- は真ん中が沈む向き)
//   mode = "mid":  半身 (ケース・ウェッジ・丁番・プレート) と中心面の反対側 (左右対称なので、ここに入らなければ反対の半身とぶつからない)
//   mode = "pair": 左右の半身どうし (どちらも th 度たたむ)
include <lap_kit.scad>
side = "R"; th = 0; mode = "mid"; hinge = false;  // hinge = true で丁番の羽根・ネジ頭も含める (pair 用)
module half(sd) fold(sd, th) {
    place(sd) case_stl(sd);
    wedge_world(sd);
    if (hinge) hinge_leaf(sd, barrel = false);  // 軸筒は中心線をまたぐ共有部分なので除く
    local3(sd) plate_local();
}
intersection() {
    half(side);
    if (mode == "pair") half(side == "R" ? "L" : "R");
    else translate([side == "R" ? -1000 + 0.05 : -0.05, -500, -500]) cube([1000, 1000, 1000]);
}
