# RTL -> netlist using yowasp-yosys

"""
run_synth.py

Runs standalone logic synthesis (RTL -> gate-level netlist) using
yowasp-yosys. Useful for quickly checking that your RTL synthesizes
cleanly before running the full SiliconCompiler flow.

Usage:
    python scripts/run_synth.py --design half_adder
    python scripts/run_synth.py --all
"""

import argparse
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
MODULES_DIR = ROOT / "modules"
SRC_DIR = ROOT / "src"
OUT_DIR = ROOT / "outputs" / "netlist"


def find_rtl_file(design_name: str) -> Path:
    """Finds RTL file matching design_name under modules/ or src/."""
    candidates = []
    search_dirs = [d for d in [MODULES_DIR, SRC_DIR] if d.exists()]
    for sdir in search_dirs:
        for f in sdir.glob("**/*"):
            if f.is_file() and f.suffix.lower() in (".v", ".sv") and "tb" not in f.stem.lower():
                if f.stem.lower() == design_name.lower():
                    return f
                candidates.append(f)
    return None


def build_yosys_script(rtl_file: Path, top_module: str, netlist_out: Path) -> str:
    """Builds a Yosys TCL/script string for generic synthesis."""
    return f"""
read_verilog {rtl_file.as_posix()}
hierarchy -top {top_module}
proc; opt; fsm; opt; memory; opt
techmap; opt
write_verilog {netlist_out.as_posix()}
stat
"""


def get_yosys_executable():
    venv_exe = Path(sys.executable).parent / "yowasp-yosys.exe"
    if venv_exe.exists():
        return str(venv_exe)
    venv_exe_noext = Path(sys.executable).parent / "yowasp-yosys"
    if venv_exe_noext.exists():
        return str(venv_exe_noext)
    return shutil.which("yowasp-yosys") or "yowasp-yosys"


def run_synthesis(design_name: str, top_module: str = None) -> bool:
    OUT_DIR.mkdir(parents=True, exist_ok=True)

    rtl_file = find_rtl_file(design_name)
    if not rtl_file:
        print(f"RTL file not found for design: {design_name}", file=sys.stderr)
        return False

    top = top_module or rtl_file.stem
    netlist_out = OUT_DIR / f"{top}_netlist.v"
    script_file = OUT_DIR / f"{top}_synth.ys"

    script_contents = build_yosys_script(rtl_file, top, netlist_out)
    script_file.write_text(script_contents)

    yosys_cmd = get_yosys_executable()
    print(f"\nSynthesizing {rtl_file.name} (top={top})...")
    print(f"$ {yosys_cmd} -s {script_file}")
    result = subprocess.run([yosys_cmd, "-s", str(script_file)])

    if result.returncode != 0:
        print(f"Synthesis failed for {design_name}.", file=sys.stderr)
        return False

    print(f"Netlist written to: {netlist_out}")
    return True


def discover_all_rtl_designs():
    designs = []
    if MODULES_DIR.exists():
        for f in MODULES_DIR.glob("**/*"):
            if f.is_file() and f.suffix.lower() in (".v", ".sv") and "tb" not in f.stem.lower():
                if f.stem not in designs:
                    designs.append(f.stem)
    return designs


def main():
    parser = argparse.ArgumentParser(description="Run generic synthesis with yowasp-yosys")
    parser.add_argument("--design", default=None, help="Design name (e.g. half_adder, full_adder, DFF)")
    parser.add_argument("--top", default=None, help="Top-level module name (defaults to design name)")
    parser.add_argument("--all", action="store_true", help="Synthesize all discovered RTL designs")
    args = parser.parse_args()

    if args.all or not args.design:
        designs = discover_all_rtl_designs()
        print(f"Discovered {len(designs)} RTL design(s) for synthesis: {', '.join(designs)}")
        successes = 0
        for d in designs:
            if run_synthesis(d):
                successes += 1
        print(f"\nSynthesis finished: {successes}/{len(designs)} designs synthesized successfully.")
    else:
        run_synthesis(args.design, args.top)


if __name__ == "__main__":
    main()