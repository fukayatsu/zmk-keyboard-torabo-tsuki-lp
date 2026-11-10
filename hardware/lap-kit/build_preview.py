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
PRINT_PARTS = ["wedge_L", "wedge_R", "bridge", "coupon_L", "coupon_R"]
WORLD_PARTS = ["w_bridge", "w_case_L", "w_case_R", "w_wedge_L", "w_wedge_R",
               "w_mag_wedge_L", "w_mag_wedge_R", "w_mag_bridge"]


def export(part: str, out: pathlib.Path) -> None:
    subprocess.run(
        ["openscad", "-D", f'part="{part}"', "--export-format", "binstl",
         "-o", str(out), "lap_kit.scad"],
        cwd=HERE, check=True, capture_output=True)
    print("  ", out.relative_to(HERE))


def main() -> None:
    BUILD.mkdir(exist_ok=True)
    if "--stl" in sys.argv:
        for p in PRINT_PARTS:
            export(p, HERE / "stl" / f"{p}.stl")
    for p in WORLD_PARTS:
        export(p, BUILD / f"{p}.stl")
    data = {}
    for p in WORLD_PARTS:
        data[p] = base64.b64encode((BUILD / f"{p}.stl").read_bytes()).decode()
    for p in PRINT_PARTS:
        src = HERE / "stl" / f"{p}.stl"
        data[p] = base64.b64encode(src.read_bytes()).decode()
    html = (HERE / "preview_template.html").read_text()
    out = BUILD / "lap-kit-preview.html"
    out.write_text(html.replace("__DATA__", json.dumps(data)))
    print("  ", out.relative_to(HERE))


if __name__ == "__main__":
    main()
