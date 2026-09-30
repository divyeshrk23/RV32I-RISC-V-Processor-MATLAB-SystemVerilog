# RV32I RISC-V Processor - MATLAB + SystemVerilog

## Project Overview

This project implements and verifies a simplified RV32I RISC-V processor.

The project was developed in two major parts:

1. MATLAB-based processor simulation and architectural verification
2. SystemVerilog RTL implementation and verification

The final RTL processor was tested using Icarus Verilog.

---

## Project Goals

- Understand the RV32I instruction set
- Build a processor simulator in MATLAB
- Implement processor datapath and control logic
- Implement a pipelined SystemVerilog CPU
- Implement hazard detection
- Implement data forwarding
- Implement branch handling
- Implement jump and JALR handling
- Verify the processor using directed and randomized tests

---

## Processor Architecture

The processor is based on a five-stage pipeline:

1. IF - Instruction Fetch
2. ID - Instruction Decode
3. EX - Execute
4. MEM - Memory Access
5. WB - Write Back

---

## Supported Features

### Arithmetic

- ADD
- SUB
- ADDI

### Logical

- AND
- OR
- XOR

### Memory

- LW
- SW

### Branches

- BEQ
- BNE
- BLT
- BGE
- BLTU
- BGEU

### Jumps

- JAL
- JALR

### Register File

- 32 registers
- 32-bit registers
- x0 permanently reads as zero
- Register write protection for x0

---

## Pipeline Features

The RTL processor includes:

- Pipeline registers
- Hazard detection
- Data forwarding
- Branch handling
- Branch flushing
- Jump flushing
- JAL link address generation
- JALR target calculation
- Load/store support

---

## Verification

The RTL implementation was tested in multiple stages.

### Stage 24 Results

| Test | Result |
|---|---|
| RV32I instruction test suite | PASS |
| ALU verification | PASS |
| Branch verification | PASS |
| Load/store verification | PASS |
| Hazard verification | PASS |
| Forwarding verification | PASS |
| Jump verification | PASS |
| Randomized testing | PASS |
| Regression testing | PASS |
| Final RTL verification | PASS |

### Final RTL Verification

Final verification result:

**22 / 22 tests passed**

The final verification covered:

- Arithmetic operations
- Logical operations
- Load/store operations
- Data dependencies
- Branch flushing
- Branch targets
- JAL
- JALR
- Register x0 behavior
- CPU halt detection

---

## Tools Used

### MATLAB

Used for:

- Processor simulation
- Instruction execution
- CPU architecture development
- Performance analysis
- Functional verification

### SystemVerilog

Used for:

- RTL processor implementation
- Processor modules
- Pipeline implementation
- Verification

### Icarus Verilog

Used for:

- RTL compilation
- Simulation
- Automated verification

---

## Project Structure

```text
RISC_V_MATLAB/
│
├── main.m
├── alu.m
├── encoder.m
├── decoder.m
├── cpu.m
├── memory.m
├── instruction_memory.m
├── register_file.m
├── program_loader.m
├── assembly_reader.m
│
├── programs/
│
├── results/
│
└── rtl/
    ├── rv32i_cpu.sv
    ├── alu.sv
    ├── register_file.sv
    ├── immediate_generator.sv
    ├── decoder.sv
    ├── control_unit.sv
    ├── alu_control.sv
    ├── hazard_unit.sv
    ├── forwarding_unit.sv
    └── branch_unit.sv
---

## Final Status

The RV32I processor successfully completed MATLAB simulation and SystemVerilog RTL verification.

Final RTL verification:

**22 / 22 TESTS PASSED**

**STAGE 24.10 PASSED**

**FINAL RTL VERIFICATION PASSED**

---

## Future Work

Possible future improvements include:

- Additional RV32I instructions
- CSR support
- Interrupt support
- Cache implementation
- Branch prediction
- Performance optimization
- FPGA implementation
- RISC-V SoC integration
- Custom hardware accelerator integration

---

## Author

Divyesh R

---

## Project Completion

### Final Verification Summary

MATLAB source verification: **PASSED**

SystemVerilog RTL compilation: **PASSED**

Final RTL verification: **22 / 22 TESTS PASSED**

Stage 25 project organization: **PASSED**

### Project Status

**RISC-V RV32I PROCESSOR PROJECT COMPLETE**

The processor was developed and verified through MATLAB simulation and SystemVerilog RTL simulation.

Final verification confirms the functionality of the implemented processor architecture, including arithmetic, logical operations, memory operations, branches, jumps, hazard handling, forwarding, and register-file behavior.