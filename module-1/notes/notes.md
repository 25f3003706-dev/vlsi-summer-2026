# What is a MOSFET?

A MOSFET is a **voltage-controlled transistor** used as an electronic switch or amplifier, and in digital logic it is often treated as a switch whose gate voltage controls whether current can flow between drain and source .

## MOSFET types

There are two main types: **NMOS** and **PMOS**. NMOS turns on with a high gate voltage and is commonly used to pull a node toward ground, while PMOS turns on with a low gate voltage and is commonly used to pull a node toward VDD.

## CMOS inverter

A CMOS inverter pairs one PMOS and one NMOS to make a NOT gate. When the input is low, the PMOS turns on and the NMOS turns off, so the output goes high; when the input is high, the PMOS turns off and the NMOS turns on, so the output goes low.

## Why CMOS is efficient

In a stable CMOS logic state, one transistor is off, so there is no direct path from VDD to GND and static power is very low. Most power is used during switching, when the output capacitance is charged or discharged.

## Your text in Markdown
