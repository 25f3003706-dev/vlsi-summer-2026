"""
run_flow.py

Runs the full RTL-to-GDS flow using SiliconCompiler:
    Netlist -> STA -> Floorplan/Place/CTS/Route (OpenROAD) -> GDSII

Saves the key output of each stage into outputs/, and (optionally)
opens the final layout in KLayout.

Usage:
    python scripts/run_flow.py
    python scripts/run_flow.py --design my_design --clock-period 10 --remote
    python scripts/run_flow.py --design my_design --show
"""

import argparse
import shutil
import sys
from pathlib import Path
import openlane,operoad
from siliconcompiler import Chip
from siliconcompiler.targets import skywater130_demo

ROOT = Path(__file__).resolve().parent.parent
SRC_DIR = ROOT / "src"
OUTPUTS_DIR = ROOT / "outputs"


def build_chip(design_name: str, clock_period: float, remote: bool) -> Chip:
    rtl_file = SRC_DIR / f"{design_name}.v"
    if not rtl_file.exists():
        print(f"RTL file not found: {rtl_file}", file=sys.stderr)
        sys.exit(1)

    chip = Chip(design_name)
    chip.input(str(rtl_file))
    chip.clock("clk", period=clock_period)
    chip.use(skywater130_demo)

    if remote:
        chip.set("option", "remote", True)

    return chip


def save_outputs(chip: Chip, design_name: str):
    """Copies the key artifact from each stage into outputs/<design>/, organized by type."""
    targets = {
        "netlist": (OUTPUTS_DIR / design_name / "netlist", "vg", "syn"),
        "sta_report": (OUTPUTS_DIR / design_name / "reports", "log", "sta"),
        "def": (OUTPUTS_DIR / design_name / "layout", "def", "route"),
        "gds": (OUTPUTS_DIR / design_name / "layout", "gds", "export"),
    }

    saved = {}
    for label, (dest_dir, filetype, step) in targets.items():
        dest_dir.mkdir(parents=True, exist_ok=True)
        try:
            result_path = chip.find_result(filetype, step=step)
        except Exception as exc:  # noqa: BLE001 - report but keep going
            print(f"Could not locate '{label}' output (step={step}): {exc}")
            continue

        if result_path and Path(result_path).exists():
            output_name = f"{design_name}_{Path(result_path).name}"
            dest_path = dest_dir / output_name
            shutil.copy(result_path, dest_path)
            saved[label] = dest_path
            print(f"Saved {label:12s} -> {dest_path}")
        else:
            print(f"No output found for '{label}' (step={step}) — that stage may not have run.")

    return saved


def main():
    parser = argparse.ArgumentParser(description="Run full RTL-to-GDS flow with SiliconCompiler")
    parser.add_argument("--design", default="my_design", help="Design name (without .v)")
    parser.add_argument("--clock-period", type=float, default=10.0, help="Clock period in ns")
    parser.add_argument("--remote", action="store_true", help="Run remotely (no local OpenROAD/OpenSTA needed)")
    parser.add_argument("--show", action="store_true", help="Open the final layout in KLayout when done")
    args = parser.parse_args()

    chip = build_chip(args.design, args.clock_period, args.remote)

    chip.run()
    chip.summary()

    saved = save_outputs(chip, args.design)

    if "gds" not in saved:
        print("\nWarning: no GDS file was produced — check the log above for the failing step.")
        sys.exit(1)

    print(f"\nFlow complete. Final GDS: {saved['gds']}")

    if args.show:
        chip.show()


if __name__ == "__main__":
    main()