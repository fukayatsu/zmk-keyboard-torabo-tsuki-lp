// プレートと片側ウェッジの干渉チェック。結果が空なら干渉なし
//   openscad -D 'part="none"' -D 'side="R"' -D t=0 -D lift=0.4 -o /tmp/chk.stl chk_plate.scad
//   t: 手前へ引き出す量, lift: 持ち上げ量, rot: 手前面の中央まわりに傾ける角度 (+ で手前が上がる)
include <lap_kit.scad>
side = "R"; t = 0; lift = 0; rot = 0;
intersection() {
    wedge_world(side);
    local3(side) translate([0, -t, lift])
        translate([pr_cx, FE, 0]) rotate([-rot, 0, 0]) translate([-pr_cx, -FE, 0]) plate_local();
}
