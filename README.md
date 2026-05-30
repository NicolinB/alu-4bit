# alu_4bit

4-bit Arithmetic Logic Unit (ALU) implemented in VHDL for the Intel DE10-Lite FPGA board.

## Operations (SW[9:7])

| SEL | Operation |
|-----|-----------|
| 000 | ADD  A + B |
| 001 | SUB  A − B |
| 010 | AND  A & B |
| 011 | OR   A \| B |
| 100 | XOR  A ⊕ B |
| 101 | NOT  ¬A |
| 110 | SHL  A << 1 |
| 111 | SHR  A >> 1 |

## Board mapping (DE10-Lite)

| Signal | Pins |
|--------|------|
| A (operand) | SW[3:0] |
| B (operand) | SW[7:4] |
| SEL (operation) | SW[9:7] |
| Y (result) | LEDR[3:0] |
| Z (zero), S (sign), OV (overflow), C (carry) | LEDR[4:7] |

## Synthesis

Open `alu_4bit.qpf` in **Quartus Prime**, compile, and program the DE10-Lite.
