# RTL Design Bootcamp 🚀

Welcome to my RTL Design Bootcamp repository.

This repository is a structured 6-month learning plan for RTL design and digital VLSI fundamentals. It documents my journey from a VLSI undergraduate student to an RTL Design Engineer through hands-on practice, Verilog coding, simulation, and project-based learning.

---

## 🎯 Goal

The aim of this bootcamp is to become comfortable with:

- Verilog HDL
- RTL Design
- Digital Design Concepts
- Finite State Machines (FSM)
- Verification using Verilog testbenches
- SystemVerilog basics
- FIFO, register files, and memories
- UART, SPI, and I²C
- APB and AXI-Lite interfaces
- Mini SoC design

---

## 🛠 Development Environment

### Operating System

- Ubuntu (GitHub Codespaces)

### Tools

- Icarus Verilog - compile and simulate Verilog code
- Verilator - simulator and lint tool
- Git - version control
- GitHub Codespaces - cloud development environment
- VS Code - code editor

### Verify installation

```bash
iverilog -V
verilator --version
git --version
gcc --version
make --version
```

---

## 📅 Bootcamp Roadmap

### Month 1 – Verilog Fundamentals

- RTL design flow
- Verilog syntax
- Modules and ports
- Data types and operators
- Continuous assignment
- Procedural blocks
- Combinational logic
- Coding style

Mini projects:

- Logic gates
- Multiplexers
- Encoders
- Decoders
- Comparators
- Adders

### Month 2 – Sequential RTL

- Flip-flops
- Registers
- Shift registers
- Counters
- Clocking
- Reset strategies
- FSM design

### Month 3 – RTL Building Blocks

- Register files
- Memories
- FIFO
- ALU
- Multipliers
- Dividers
- Barrel shifters

### Month 4 – Verification

- Testbench writing
- Self-checking testbenches
- Random testing
- Assertions basics
- SystemVerilog basics

### Month 5 – Industry RTL

- UART
- SPI
- I²C
- APB
- AXI-Lite
- CDC basics
- Reset synchronization

### Month 6 – Capstone

- Mini SoC
- APB bus
- UART
- GPIO
- Timer
- Memory
- Custom RTL modules

---

## 📂 Repository Structure

```text
vlsi-summer-2026/
├── README.md
├── day01/
│   ├── logic_gates/
│   └── COMB_CKT/
└── ...
```

> This repository currently contains Day 01 learning materials and will expand as the bootcamp progresses.

---

## 📚 Learning Workflow

```text
Specification
      ↓
RTL coding
      ↓
Testbench
      ↓
Compile
      ↓
Simulation
      ↓
Debug
      ↓
Verification
      ↓
Git commit
```

---

## ▶️ How to Run the Simulations

### Run each folder

#### 1. Logic gates

```bash
cd day01/logic_gates
make
```

#### 2. Combinational circuits

```bash
cd day01/COMB_CKT
make
```

#### 3. Clean generated files

```bash
cd day01/logic_gates
make clean

cd day01/COMB_CKT
make clean
```

---

## 📁 Project Structure Inside Each Day

- rtl/ - RTL design source files
- tb/ - testbench files
- sim/ - compiled simulation binaries
- waveforms/ - generated VCD waveform files

---

## 📈 Progress Tracker

### Month 1

- [x] Day 01
- [ ] Day 02
- [ ] Day 03
- [ ] Day 04
- [ ] Day 05
- [ ] Week 1 complete

### Month 2

- [ ] Sequential logic

### Month 3

- [ ] RTL components

### Month 4

- [ ] Verification

### Month 5

- [ ] Interfaces

### Month 6

- [ ] Mini SoC

---

## 🏁 Final Goal

By the end of this bootcamp, I aim to have:

- 30+ RTL modules
- 20+ verified testbenches
- Multiple communication protocol implementations
- A complete RTL portfolio on GitHub
- Strong interview preparation for RTL Design Engineer roles

---

**Design hardware. Verify everything. Commit often. Learn continuously.**
