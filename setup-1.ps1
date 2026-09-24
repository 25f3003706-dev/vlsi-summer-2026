# ===== RTL-Learning Project Setup Script =====
$root = "RTL-Learning"

# --- Top-level folders ---
$folders = @(
    "$root\docs\notes",
    "$root\docs\cheatsheets",
    "$root\docs\interview",
    "$root\scripts",
    "$root\build",
    "$root\waves",
    "$root\logs",
    "$root\modules\01_basics",
    "$root\modules\02_combinational",
    "$root\modules\03_sequential",
    "$root\modules\04_fsm",
    "$root\modules\05_memory",
    "$root\modules\06_protocols",
    "$root\modules\07_projects",
    "$root\template"
)

foreach ($folder in $folders) {
    New-Item -ItemType Directory -Path $folder -Force | Out-Null
}

# --- Top-level files ---
$topFiles = @(
    "$root\README.md",
    "$root\roadmap.md",
    "$root\requirements.txt"
)
foreach ($file in $topFiles) {
    if (-not (Test-Path $file)) {
        New-Item -ItemType File -Path $file -Force | Out-Null
    }
}

# --- Script files ---
$scriptFiles = @(
    "$root\scripts\run.py",
    "$root\scripts\clean.py",
    "$root\scripts\create.py",
    "$root\scripts\open_wave.py",
    "$root\scripts\config.py"
)
foreach ($file in $scriptFiles) {
    if (-not (Test-Path $file)) {
        New-Item -ItemType File -Path $file -Force | Out-Null
    }
}

# --- Template files ---
$templateFiles = @(
    "$root\template\module.v",
    "$root\template\testbench.v"
)
foreach ($file in $templateFiles) {
    if (-not (Test-Path $file)) {
        New-Item -ItemType File -Path $file -Force | Out-Null
    }
}

Write-Host "RTL-Learning directory structure created successfully at: $(Resolve-Path $root)" -ForegroundColor Green