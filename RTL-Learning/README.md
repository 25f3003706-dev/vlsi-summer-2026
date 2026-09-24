# RTL-Learning

A structured, day-by-day Verilog/RTL learning repository built around Icarus Verilog and GTKWave.

## Structure

- `modules/` — practice modules grouped by topic (basics → protocols → projects)
- `template/` — starter files for new modules (`module.v`, `testbench.v`)
- `scripts/` — Python helpers to compile, simulate, clean, and view waveforms
- `docs/` — notes, cheatsheets, and interview prep
- `build/`, `waves/`, `logs/` — auto-generated output (safe to delete/clean)

## Quick Start

```bash
# Create a new module from template
python scripts/create.py 01_basics counter

# Compile and simulate a module
python scripts/run.py modules/01_basics/counter

# Open the waveform in GTKWave
python scripts/open_wave.py modules/01_basics/counter

# Clean build artifacts
python scripts/clean.py
```

## Requirements

See `requirements.txt`. Requires Icarus Verilog (`iverilog`, `vvp`) and GTKWave on PATH.

## Progress

See `roadmap.md` for the 6-month plan and current status.
