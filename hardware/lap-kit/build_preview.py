#!/usr/bin/env python3
"""lap_kit.scad から STL を書き出し、3D プレビュー HTML (build/lap-kit-preview.html) を作る。

使い方 (このディレクトリで):
    python3 build_preview.py            # プレビューだけ
    python3 build_preview.py --stl      # stl/ の印刷用 STL も書き出し直す
"""
import base64
import json
import pathlib
import subprocess
import sys

HERE = pathlib.Path(__file__).resolve().parent
BUILD = HERE / "build"
PRINT_PARTS = ["wedge_L", "wedge_R", "coupon_L", "coupon_R", "coupon_sw", "sw_lid"]
# ポゴピン版 (sw_type="pogo"): 出力名 -> 元の part
POGO_WORLD = ["w_hinge_L", "w_hinge_R", "w_wedge_L", "w_wedge_R"]  # 組立表示のポゴピン版 (build/*_pogo.stl)
POGO_PARTS = {"wedge_L_pogo": "wedge_L", "wedge_R_pogo": "wedge_R", "coupon_pogo": "coupon_sw", "coupon_pogo_L": "coupon_sw_L"}
WORLD_PARTS = ["w_hinge_L", "w_hinge_R", "w_case_L", "w_case_R", "w_wedge_L", "w_wedge_R", "w_rest_L", "w_rest_R"]


def export(part: str, out: pathlib.Path, sw_type: str = "switch") -> None:
    subprocess.run(
        ["openscad", "-D", f'part="{part}"', "-D", f'sw_type="{sw_type}"', "--export-format", "binstl",
         "-o", str(out), "lap_kit.scad"],
        cwd=HERE, check=True, capture_output=True)
    print("  ", out.relative_to(HERE))


def main() -> None:
    BUILD.mkdir(exist_ok=True)
    if "--stl" in sys.argv:
        for p in PRINT_PARTS:
            export(p, HERE / "stl" / f"{p}.stl")
        for name, p in POGO_PARTS.items():
            export(p, HERE / "stl" / f"{name}.stl", "pogo")
    for p in WORLD_PARTS:
        export(p, BUILD / f"{p}.stl")
    for p in POGO_WORLD:
        export(p, BUILD / f"{p}_pogo.stl", "pogo")
    data = {}
    for p in WORLD_PARTS + [f"{p}_pogo" for p in POGO_WORLD]:
        data[p] = base64.b64encode((BUILD / f"{p}.stl").read_bytes()).decode()
    for p in PRINT_PARTS + list(POGO_PARTS):
        src = HERE / "stl" / f"{p}.stl"
        data[p] = base64.b64encode(src.read_bytes()).decode()
    html = (HERE / "preview_template.html").read_text()
    out = BUILD / "lap-kit-preview.html"
    out.write_text(html.replace("__DATA__", json.dumps(data)))
    print("  ", out.relative_to(HERE))


if __name__ == "__main__":
    main()
