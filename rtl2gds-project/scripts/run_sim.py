"""
run_sim.py

Compiles RTL + testbench with Icarus Verilog, runs the simulation,
and optionally opens the resulting waveform in GTKWave.

Auto-locates Verilog RTL and testbench files within the project (e.g., modules/, src/, testbench/).
Expands wildcards/globs and handles top-level module selection safely without syntax errors.

Usage examples:
    python scripts/run_sim.py --design gates
    python scripts/run_sim.py --design gates --wave
    python scripts/run_sim.py --design half_adder
    python scripts/run_sim.py modules/01_basics/gates/rtl/* modules/01_basics/gates/tb/gates_tb.sv -o sim/all_gates.vvp
"""

import argparse
import glob
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
MODULES_DIR = ROOT / "modules"
SRC_DIR = ROOT / "src"
TB_DIR = ROOT / "testbench"
SIM_DIR = ROOT / "sim"
WAVEFORM_DIR = ROOT / "waveform"


def run(cmd, **kwargs):
    print(f"$ {' '.join(cmd)}")
    result = subprocess.run(cmd, **kwargs)
    if result.returncode != 0:
        print(f"Command failed with exit code {result.returncode}", file=sys.stderr)
        sys.exit(result.returncode)
    return result


def expand_globs(path_patterns):
    """Expands list of file paths or glob patterns into concrete Path objects."""
    files = []
    for pattern in path_patterns:
        pattern_str = str(pattern)
        matched = glob.glob(pattern_str, recursive=True)
        if matched:
            for m in matched:
                p = Path(m).resolve()
                if p.is_file() and p not in files:
                    files.append(p)
        else:
            p = Path(pattern_str).resolve()
            if p.is_file() and p not in files:
                files.append(p)
            elif p.is_dir():
                for f in p.glob("**/*"):
                    if f.is_file() and f.suffix.lower() in ('.v', '.sv') and f not in files:
                        files.append(f)
    return files


def find_design_files(design_name):
    """
    Automatically locates RTL and testbench files for a given design name.
    Supports design names like 'gates', '01_basics/gates', 'half_adder', 'full_adder', 'DFF', etc.
    """
    rtl_files = []
    tb_files = []

    target = design_name.replace("\\", "/").strip()

    # 1. Search under modules directory
    if MODULES_DIR.exists():
        # Check direct folder match (e.g. modules/01_basics/gates or modules/gates)
        for folder in MODULES_DIR.glob("**/*"):
            if folder.is_dir():
                rel_path = folder.relative_to(MODULES_DIR).as_posix().lower()
                if folder.name.lower() == target.lower() or rel_path.endswith(target.lower()):
                    for f in folder.glob("**/*"):
                        if f.is_file() and f.suffix.lower() in (".v", ".sv"):
                            if "tb" in f.stem.lower() or "test" in f.stem.lower():
                                tb_files.append(f)
                            else:
                                rtl_files.append(f)

        # If not found by folder match, search by file name tokens (e.g., 'half_adder' or 'half')
        if not rtl_files and not tb_files:
            clean_name = target.replace("_tb", "").replace("tb_", "")
            tokens = [clean_name.lower()]
            if "_" in clean_name:
                tokens.extend([t.lower() for t in clean_name.split("_") if len(t) > 2])

            for f in MODULES_DIR.glob("**/*"):
                if f.is_file() and f.suffix.lower() in (".v", ".sv"):
                    name_lower = f.stem.lower()
                    matched = any(tok in name_lower for tok in tokens)
                    if matched:
                        if "tb" in name_lower or "test" in name_lower:
                            tb_files.append(f)
                        else:
                            rtl_files.append(f)

    # 2. Fallback search under src/ and testbench/
    if not rtl_files and SRC_DIR.exists():
        for f in SRC_DIR.glob("**/*"):
            if f.is_file() and f.suffix.lower() in (".v", ".sv"):
                if design_name.lower() in f.stem.lower():
                    rtl_files.append(f)

    if not tb_files and TB_DIR.exists():
        for f in TB_DIR.glob("**/*"):
            if f.is_file() and f.suffix.lower() in (".v", ".sv"):
                if design_name.lower() in f.stem.lower():
                    tb_files.append(f)

    def unique_paths(path_list):
        seen = set()
        res = []
        for p in path_list:
            resolved = p.resolve()
            if resolved not in seen:
                seen.add(resolved)
                res.append(resolved)
        return res

    return unique_paths(rtl_files), unique_paths(tb_files)


def compile_design(rtl_files, tb_files, out_file, top_module=None, include_dirs=None):
    SIM_DIR.mkdir(parents=True, exist_ok=True)
    out_file.parent.mkdir(parents=True, exist_ok=True)

    all_files = list(rtl_files) + list(tb_files)

    if not all_files:
        print("Error: No RTL or Testbench files found for compilation.", file=sys.stderr)
        sys.exit(1)

    cmd = ["iverilog", "-g2012", "-o", str(out_file)]

    inc_dirs = set()
    if include_dirs:
        inc_dirs.update(include_dirs)
    inc_dirs.add(ROOT)
    if MODULES_DIR.exists():
        inc_dirs.add(MODULES_DIR)
        for d in MODULES_DIR.glob("**"):
            if d.is_dir():
                inc_dirs.add(d)

    for inc in inc_dirs:
        cmd.extend(["-I", str(inc)])

    # Top module flag: ONLY pass -s if top_module is provided and non-empty!
    if top_module and top_module.strip() and top_module.strip() != '""':
        cmd.extend(["-s", top_module.strip()])

    cmd.extend([str(f) for f in all_files])

    print(f"\nCompiling {len(all_files)} file(s)...")
    for f in all_files:
        try:
            print(f"  - {f.relative_to(ROOT)}")
        except ValueError:
            print(f"  - {f}")

    run(cmd)
    return out_file


def collect_and_organize_vcd(design_name):
    WAVEFORM_DIR.mkdir(parents=True, exist_ok=True)
    SIM_DIR.mkdir(parents=True, exist_ok=True)
    for search_dir in [ROOT, SIM_DIR]:
        for vcd in search_dir.glob("*.vcd"):
            dest = WAVEFORM_DIR / vcd.name
            if vcd.resolve() != dest.resolve():
                shutil.copy(vcd, dest)
                print(f"Saved waveform -> {dest.relative_to(ROOT)}")


def simulate(vvp_file):
    print(f"\nRunning simulation on {vvp_file.name}...")
    run(["vvp", str(vvp_file)])


def open_waveform(design_name, custom_vcd=None):
    candidate_vcds = []
    if custom_vcd:
        candidate_vcds.append(Path(custom_vcd))
    
    candidate_vcds.extend([
        WAVEFORM_DIR / f"{design_name}.vcd",
        ROOT / f"{design_name}.vcd",
        SIM_DIR / f"{design_name}.vcd",
        WAVEFORM_DIR / "all_gates.vcd",
        ROOT / "all_gates.vcd",
    ])
    
    candidate_vcds.extend(list(WAVEFORM_DIR.glob("*.vcd")))
    candidate_vcds.extend(list(ROOT.glob("*.vcd")))
    candidate_vcds.extend(list(SIM_DIR.glob("*.vcd")))

    vcd_file = None
    for cand in candidate_vcds:
        if cand.exists():
            vcd_file = cand
            break

    if not vcd_file:
        print(f"No waveform (.vcd) file found for design '{design_name}'.")
        print("Make sure your testbench includes $dumpfile/$dumpvars.")
        return

    print(f"Opening waveform file: {vcd_file}")
    subprocess.Popen(["gtkwave", str(vcd_file)])


def discover_all_sim_designs():
    designs = []
    if MODULES_DIR.exists():
        for f in MODULES_DIR.glob("**/*"):
            if f.is_file() and f.suffix.lower() in (".v", ".sv"):
                stem = f.stem.lower()
                if "tb" in stem or "test" in stem:
                    if stem == "gates_tb":
                        dname = "gates"
                    elif stem == "half_tb":
                        dname = "half_adder"
                    elif stem == "full_tb":
                        dname = "full_adder"
                    elif stem == "dff_tb":
                        dname = "DFF"
                    else:
                        dname = f.stem.replace("_tb", "").replace("tb_", "")
                    if dname not in designs:
                        designs.append(dname)
    return designs


def list_available_designs():
    print("Discovered designs in project:")
    if MODULES_DIR.exists():
        for category in MODULES_DIR.iterdir():
            if category.is_dir():
                print(f"\n  [{category.name}]")
                subdirs = [s for s in category.iterdir() if s.is_dir() and s.name not in ("rtl", "tb")]
                if subdirs:
                    for sub in subdirs:
                        rtl = list(sub.glob("rtl/*")) + list(sub.glob("*.v")) + list(sub.glob("*.V"))
                        tb = list(sub.glob("tb/*")) + list(sub.glob("*.sv")) + list(sub.glob("*.SV"))
                        print(f"    - {sub.name:<20} (RTL: {len(rtl)} file(s), TB: {len(tb)} file(s))")
                else:
                    rtl = list(category.glob("rtl/*"))
                    tb = list(category.glob("tb/*"))
                    print(f"    - category files     (RTL: {len(rtl)} file(s), TB: {len(tb)} file(s))")


def run_single_design(design_name, top_module=None, output_path=None, wave=False, custom_vcd=None):
    rtl_files, tb_files = find_design_files(design_name)
    if not rtl_files and not tb_files:
        print(f"Error: Could not locate RTL or Testbench files for design '{design_name}'.", file=sys.stderr)
        return False

    out_name = output_path or f"sim/{design_name}.vvp"
    if not out_name.endswith(".vvp"):
        out_name += ".vvp"
    out_file = (ROOT / out_name).resolve()

    vvp_file = compile_design(
        rtl_files=rtl_files,
        tb_files=tb_files,
        out_file=out_file,
        top_module=top_module,
    )

    simulate(vvp_file)
    collect_and_organize_vcd(design_name)

    if wave:
        open_waveform(design_name, custom_vcd)
    return True


def main():
    parser = argparse.ArgumentParser(
        description="Compile and simulate Verilog/SystemVerilog RTL with Icarus Verilog",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument("files", nargs="*", help="Optional explicit RTL/TB files or glob patterns")
    parser.add_argument("--design", "-d", default=None, help="Design name (e.g. gates, half_adder, full_adder, DFF)")
    parser.add_argument("--top", "-t", default=None, help="Top-level testbench module name")
    parser.add_argument("--output", "-o", default=None, help="Output .vvp file path (default: sim/<design>.vvp)")
    parser.add_argument("--wave", "-w", action="store_true", help="Open GTKWave after simulation")
    parser.add_argument("--vcd", help="Explicit path to VCD waveform file")
    parser.add_argument("--list", action="store_true", help="List all available modules/designs in the workspace")
    parser.add_argument("--all", "-a", action="store_true", help="Automatically detect and simulate all designs in the project")

    args = parser.parse_args()

    if args.list:
        list_available_designs()
        return

    explicit_files = expand_globs(args.files) if args.files else []

    if explicit_files:
        rtl_files = [f for f in explicit_files if "tb" not in f.stem.lower()]
        tb_files = [f for f in explicit_files if "tb" in f.stem.lower()]
        if not rtl_files:
            rtl_files = explicit_files
            tb_files = []
        design_name = args.design or "custom_design"
        out_name = args.output or f"sim/{design_name}.vvp"
        if not out_name.endswith(".vvp"):
            out_name += ".vvp"
        out_file = (ROOT / out_name).resolve()
        vvp_file = compile_design(rtl_files=rtl_files, tb_files=tb_files, out_file=out_file, top_module=args.top)
        simulate(vvp_file)
        collect_and_organize_vcd(design_name)
        if args.wave:
            open_waveform(design_name, args.vcd)
        return

    if args.all or not args.design:
        designs = discover_all_sim_designs()
        print(f"Auto-discovered {len(designs)} design(s) with testbenches: {', '.join(designs)}")
        for d in designs:
            print(f"\n================ Running Simulation: {d} ================")
            run_single_design(d, top_module=args.top, wave=args.wave, custom_vcd=args.vcd)
        print("\nAll simulations completed.")
    else:
        run_single_design(args.design, top_module=args.top, output_path=args.output, wave=args.wave, custom_vcd=args.vcd)


if __name__ == "__main__":
    main()