"""Render every design and check its size and volume.

usage: python3 tests/check_renders.py [OPENSCAD]

Each .scad file under cad/, and each preset of the plant-pot test prints, is
rendered with --hardwarnings, so any warning fails the check. Sizes are
checked to within 0.01 mm and volumes to within 0.01 mm³; renders on the
pinned OpenSCAD repeat to 0.001 mm³. A different OpenSCAD can mesh curves
differently, so moving the pin may mean re-measuring these values.

Every .scad file under cad/ must be either checked here or listed in SKIP
with the reason, so a new design can't go unchecked.
"""

import glob
import json
import os
import struct
import subprocess
import sys
import tempfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SNAP = "cad/plant-pot/test-prints/pot_wall_snap.scad"
SNAP_PRESETS = "cad/plant-pot/test-prints/pot_wall_snap.json"

# path: (size x, y, z in mm, volume in mm³), from OpenSCAD 2026.10.15
EXPECTED = {
    "cad/ant-trap/ant-trap.scad": ((67.0, 66.633, 8.0), 16203.533),
    "cad/cassava-press/cassava-cylinder.scad": ((100.0, 100.0, 130.0), 180391.947),
    "cad/cassava-press/cassava-handle.scad": ((112.9, 27.847, 50.8), 31838.338),
    "cad/cassava-press/cassava-nut-plate.scad": ((100.0, 100.0, 13.75), 102746.521),
    "cad/cassava-press/cassava-plunger.scad": ((60.0, 60.0, 14.0), 22552.825),
    "cad/cassava-press/cassava-top.scad": ((100.0, 100.0, 15.5), 69106.434),
    "cad/chicken-feed-holder/chicken-feed-holder.scad": ((195.876, 195.876, 190.0), 379844.456),
    "cad/corn-sheller/corn-sheller.scad": ((72.751, 70.0, 55.0), 38187.141),
    "cad/custom-shovel-handle/custom-shovel-handle.scad": ((150.0, 47.737, 134.0), 212190.550),
    "cad/field-dressing-tool/field-dressing-tool.scad": ((85.0, 102.693, 4.0), 13458.871),
    "cad/garden-hose-splitter/garden-hose-splitter.scad": ((87.986, 101.598, 29.99), 73588.073),
    "cad/gasket/gasket.scad": ((8.0, 8.0, 1.0), 37.639),
    "cad/hand-shovel/hand-shovel.scad": ((152.634, 79.834, 152.772), 421294.677),
    "cad/hydroponic-halo-ring/hydroponic-halo-ring-pole.scad": ((5.0, 10.0, 190.0), 7270.985),
    "cad/hydroponic-halo-ring/hydroponic-halo-ring.scad": ((200.44, 176.826, 29.2), 141598.862),
    "cad/hydroponic-plant-pot/hydroponic-plant-pot.scad": ((50.0, 49.726, 60.0), 12358.099),
    "cad/irrigation-stake/irrigation-stake-1.scad": ((116.0, 11.891, 5.0), 1735.694),
    "cad/irrigation-stake/irrigation-stake-2.scad": ((145.0, 18.0, 4.5), 4287.668),
    "cad/plant-pot/examples/pot_dia_diff.scad": ((108.0, 108.0, 116.0), 171902.466),
    "cad/plant-pot/examples/pot_lower_from_angle.scad": ((108.0, 108.0, 116.0), 155427.417),
    "cad/plant-pot/examples/pot_upper_from_angle.scad": ((130.511, 130.511, 116.0), 196711.483),
    SNAP: ((100.0, 100.0, 103.0), 25696.411),
    "cad/pulleys/pulley.scad": ((65.0, 85.0, 77.5), 113689.906),
    "cad/wall-pot-holder/wall-pot-holder.scad": ((350.0, 550.0, 150.558), 2302711.684),
}

# preset of pot_wall_snap.json: (size, volume)
EXPECTED_SNAP_PRESETS = {
    "pot_wall_snap": ((54.0, 54.0, 50.0), 9114.594),
    "pot_wall_snap_ivw": ((54.0, 54.0, 50.0), 10648.284),
    "pot_wall_snap_collar": ((100.0, 100.0, 103.0), 24162.721),
    "pot_wall_snap_collar_ivw": ((100.0, 100.0, 103.0), 25696.411),
}

SKIP = {
    "cad/plant-pot/plant-pot.scad": "a library of modules; its examples and test prints render it",
}


def measure(path):
    data = open(path, "rb").read()
    (n,) = struct.unpack_from("<I", data, 80)
    lo, hi, volume = [float("inf")] * 3, [float("-inf")] * 3, 0.0
    for i in range(n):
        v = struct.unpack_from("<9f", data, 84 + i * 50 + 12)
        a, b, c = v[0:3], v[3:6], v[6:9]
        volume += (
            a[0] * (b[1] * c[2] - b[2] * c[1])
            - a[1] * (b[0] * c[2] - b[2] * c[0])
            + a[2] * (b[0] * c[1] - b[1] * c[0])
        ) / 6
        for p in (a, b, c):
            for k in range(3):
                lo[k], hi[k] = min(lo[k], p[k]), max(hi[k], p[k])
    return [h - l for h, l in zip(hi, lo)], volume


def main():
    openscad = sys.argv[1] if len(sys.argv) > 1 else "openscad"
    os.chdir(ROOT)
    failures = []

    found = set(glob.glob("cad/**/*.scad", recursive=True))
    listed = set(EXPECTED) | set(SKIP)
    for path in sorted(found - listed):
        failures.append(f"{path}: not checked and not in SKIP")
    for path in sorted(listed - found):
        failures.append(f"{path}: listed but not in cad/")
    presets = set(json.load(open(SNAP_PRESETS))["parameterSets"])
    if presets != set(EXPECTED_SNAP_PRESETS):
        failures.append(f"presets in {SNAP_PRESETS} {sorted(presets)} != checked {sorted(EXPECTED_SNAP_PRESETS)}")

    checks = [(path, [path], expected) for path, expected in EXPECTED.items()]
    checks += [(f"{SNAP} -P {name}", ["-p", SNAP_PRESETS, "-P", name, SNAP], expected)
               for name, expected in EXPECTED_SNAP_PRESETS.items()]

    with tempfile.TemporaryDirectory() as tmp:
        for i, (name, args, (size, volume)) in enumerate(checks):
            out = os.path.join(tmp, f"{i}.stl")
            cmd = [openscad, "--hardwarnings", "--export-format", "binstl", "-o", out] + args
            result = subprocess.run(cmd, capture_output=True, text=True)
            if result.returncode != 0:
                errors = [l for l in result.stderr.splitlines() if "WARNING" in l or "ERROR" in l]
                failures.append(f"{name}: openscad exited {result.returncode}: {'; '.join(errors)}")
                continue
            got_size, got_volume = measure(out)
            ok = all(abs(g - e) <= 0.01 for g, e in zip(got_size, size)) and \
                abs(got_volume - volume) <= 0.01
            sizes = " x ".join(f"{g:.3f}" for g in got_size)
            print(f"{'ok  ' if ok else 'FAIL'} {name}: {sizes} mm, {got_volume:.3f} mm³")
            if not ok:
                expected = " x ".join(f"{e:.3f}" for e in size)
                failures.append(f"{name}: expected {expected} mm, {volume:.3f} mm³")

    for path, reason in SKIP.items():
        print(f"skip {path}: {reason}")
    for f in failures:
        print("FAIL", f)
    sys.exit(1 if failures else 0)


if __name__ == "__main__":
    main()
