# 8051 Assembly – Keypad Controlled 7-Segment Display & 2-Digit Decimal Adder

##  Overview

This project implements a keypad-controlled display system using the Intel 8051 microcontroller and an Intel 8255 Programmable Peripheral Interface (PPI).

The system:
- Reads user input from a 4×4 matrix keypad  
- Identifies the pressed key  
- Displays the corresponding value on a multiplexed 4-digit seven-segment display  

In **Part B**, the system is extended into a simple 2-digit decimal calculator capable of performing BCD addition:

00–99 + 00–99 → Result range: 000–198

The entire project is written in pure 8051 Assembly language.

---

# Hardware Architecture

## Core Components

- Intel 8051 Microcontroller  
- Intel 8255 Programmable Peripheral Interface  
- 4×4 Matrix Keypad  
- 4-Digit Multiplexed Seven-Segment Display  

---

## 8255 Configuration

The 8255 is configured in **Mode 0 (Basic I/O)**.

Control word used: `81h`

| Port | Configuration | Function |
|------|--------------|----------|
| Port A | Output | Segment lines (a–g, dp) |
| Port B | Output | Digit selection (multiplex control) |
| Port C (Upper nibble) | Output | Keypad rows |
| Port C (Lower nibble) | Input | Keypad columns |

---

# Keypad Scanning Method

- All rows driven high initially  
- Columns read to detect key press  
- If a column is high → key detected  
- Rows activated one at a time to identify exact key  
- Row/column combination converted to index (0–15)  
- Lookup table converts index → seven-segment code  
- Software debounce implemented using:
  - Delay routine  
  - Release verification loop  

---

# Display Multiplexing

- All segment lines shared via Port A  
- Individual digits enabled via lower 4 bits of Port B  
- Four display registers used:

R3-> leftmost digit, 
R2, 
R1, 
R0 -> rightmost digit





- Rapid cycling through digits creates flicker-free illumination  
- Refresh handled inside the main loop (interrupts were not permitted in coursework)

---

#  Digit Shift Mechanism

On every valid key press:

R3 new <- R2 old, 
R2 new <- R1 old , 
R1 new <- R0 old , 
R0 new <- new key segment code


If key **F** is pressed:
- All display registers are cleared

---

#  Part B – 2-Digit Decimal Adder

The system was extended into a simple calculator.

## Key Reassignment

| Key | Function |
|------|----------|
| 0–9 | Digit input |
| A | Store first operand |
| B | Store second operand |
| C | Select addition |
| D | Perform calculation (=) |
| F | Clear all |

---

## Internal Operation

- Operands stored in Register Bank 2  
- Displayed digits converted from segment code → BCD  
- BCD addition performed digit-by-digit  
- Carry handled manually  
- Result converted back to seven-segment codes  
- Up to 3-digit result displayed (0–198)  

---

#  Software Structure

The program is logically structured into:

1. 8255 initialization  
2. Key detection and decoding  
3. Index conversion routine  
4. Register shifting routine  
5. Calculator logic (Part B)  
6. Multiplexed display routine  
7. Debounce handling  

The display routine from Part A is reused in Part B.

---

#  Performance

- Reliable key detection  
- Stable, flicker-free display  
- Correct BCD arithmetic  
- Robust debounce behavior  
- Correct handling of rapid key presses  

Tested successfully in simulation and hardware.

---

#  Learning Outcomes

- External memory-mapped I/O  
- 8255 peripheral configuration  
- Matrix keypad scanning  
- Multiplexed display control  
- Register bank usage  
- BCD arithmetic in Assembly  
- Structured embedded programming without interrupts  

---

#  Coursework Context

Developed for:

**Microprocessor Systems Design – Lab 2 (Peripheral Interfacing)**  

Interrupts were not permitted as part of the coursework constraints, therefore display refresh is implemented in the main execution loop.

