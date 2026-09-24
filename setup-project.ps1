<#
.SYNOPSIS
    Scaffolds the RTL-to-GDS project folder structure.

.DESCRIPTION
    Creates all directories and placeholder files described in
    folder-structure.txt / README.md. Safe to re-run — existing
    files/folders are left untouched.

.USAGE
    Open PowerShell in the parent directory where you want the
    project created, then run:

        .\setup-project.ps1

    If PowerShell blocks the script from running, first allow local
    scripts for this session:

        Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
#>

$ProjectName = "rtl2gds-project"
$Root = Join-Path (Get-Location) $ProjectName

Write-Host "Creating project at: $Root" -ForegroundColor Cyan

# ---- Folders ----
$folders = @(
    "src",
    "testbench",
    "sim",
    "constraints",
    "scripts",
    "build",
    "outputs\netlist",
    "outputs\reports",
    "outputs\layout",
    "outputs\images",
    "pdk\sky130",
    "docs"
)

foreach ($folder in $folders) {
    $path = Join-Path $Root $folder
    if (-not (Test-Path $path)) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
        Write-Host "  Created: $folder" -ForegroundColor Green
    } else {
        Write-Host "  Exists:  $folder" -ForegroundColor DarkGray
    }
}

# ---- Placeholder files ----
$files = @{
    "README.md"                        = "# RTL-to-GDS Project`n`nSee project docs for setup and learning roadmap.`n"
    "requirements.txt"                 = "siliconcompiler>=0.30.0`nyowasp-yosys`n"
    "src\my_design.v"                  = "// TODO: your RTL design goes here`nmodule my_design (`n    input  clk,`n    input  rst_n`n);`n`nendmodule`n"
    "testbench\my_design_tb.v"         = "// TODO: testbench for my_design`nmodule my_design_tb;`n`nendmodule`n"
    "constraints\my_design.sdc"        = "# TODO: timing constraints`ncreate_clock -name clk -period 10 [get_ports clk]`n"
    "scripts\run_sim.py"               = "# Compile + simulate with iverilog`nimport subprocess`n`n# subprocess.run(['iverilog', '-o', 'sim/my_design.vvp', 'src/my_design.v', 'testbench/my_design_tb.v'])`n# subprocess.run(['vvp', 'sim/my_design.vvp'])`n"
    "scripts\run_synth.py"             = "# RTL -> netlist using yowasp-yosys`n# TODO: fill in synthesis script`n"
    "scripts\run_flow.py"              = "from siliconcompiler import Chip`nfrom siliconcompiler.targets import skywater130_demo`n`nchip = Chip('my_design')`nchip.input('src/my_design.v')`nchip.clock('clk', period=10)`nchip.use(skywater130_demo)`nchip.set('option', 'remote', True)`nchip.run()`nchip.summary()`n"
    "docs\01_rtl_basics.md"            = "# RTL Basics`n`nNotes go here.`n"
    "docs\02_simulation.md"            = "# Simulation`n`nNotes go here.`n"
    "docs\03_synthesis.md"             = "# Synthesis`n`nNotes go here.`n"
    "docs\04_sta_timing.md"            = "# STA / Timing`n`nNotes go here.`n"
    "docs\05_floorplan_placement.md"   = "# Floorplan & Placement`n`nNotes go here.`n"
    "docs\06_cts_routing.md"           = "# CTS & Routing`n`nNotes go here.`n"
    "docs\07_physical_verification.md" = "# Physical Verification (DRC/LVS)`n`nNotes go here.`n"
    "docs\08_gdsii_signoff.md"         = "# GDSII & Sign-off`n`nNotes go here.`n"
}

foreach ($entry in $files.GetEnumerator()) {
    $path = Join-Path $Root $entry.Key
    if (-not (Test-Path $path)) {
        Set-Content -Path $path -Value $entry.Value -Encoding UTF8
        Write-Host "  Created: $($entry.Key)" -ForegroundColor Green
    } else {
        Write-Host "  Exists:  $($entry.Key)" -ForegroundColor DarkGray
    }
}

Write-Host "`nProject structure ready at $Root" -ForegroundColor Cyan
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  cd $ProjectName"
Write-Host "  python -m venv .venv"
Write-Host "  .venv\Scripts\activate"
Write-Host "  pip install -r requirements.txt"
