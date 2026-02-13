

--project overview
This project implements a keypad-controlled display system using the 8051 microcontroller. The system reads input from a 4x4 matrix keypad and displays the corresponding value on a multiplexed 4-digit seven-segment display.

In Part B, the system is extended to function as a 2-digit decimal calculator capable of performing BCD addition (00–99 + 00–99).

The project is written entirely in Assembly language.

--hardware architecture
The system is built around the Intel 8051 microcontroller and uses an Intel 8255 programmable I/O expansion chip. the 8255 is configured in mode 0 with port A output to the Seven-segment segment lines bort B output for the multiplexing. port C upper nibbel is output for the keypad rows and port C lower nibble is input for the keypad columns.

--Keypad Scanning Method:

  -4x4 matrix keypad
  -Rows driven high sequentially
  -Columns read for key detection
  -Unique row/column combination mapped to key index (0–15)
  -Lookup table used to convert index to seven-segment code
  -Debouncing is implemented using delay and release verification.

  
-- Multiplexed Display Operation:
  -4-digit seven-segment display
  -Shared segment bus via Port A
  -Digit activation via Port B
  -Fast switching creates illusion of continuous illumination
  -Display refresh handled in main loop
  Registers:
  -R0–R3 → Digit storage (display buffer)

--Extended Functionality (Part B)
The system can be extended into a 2-digit decimal adder.
Features:
  -Enter two operands (00–99)
  -Store first operand (Key A)
  -Store second operand (Key B)
  -Select addition (Key C)
  -Compute result (Key D)
  -Clear system (Key F)
  -Result range: 000–198

Possible Improvements: 
  -Timer interrupt-based display refresh
  -Non-blocking debounce implementation
  -Interrupt-driven architecture
  -Support for subtraction and additional operations

