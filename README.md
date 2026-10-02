# 32-bit Pipelined Processor
### Five stages. Custom instructions. Predicated execution.

A computer architecture project implementing a **32-bit, five-stage pipelined processor in Verilog**, with a separate Logisim circuit design, component testbenches, a full-processor simulation trace, and saved waveform files.

The project explores how instructions move through a pipeline—and how forwarding, load-use stalls, and control-flow flushing keep dependent instructions coordinated.

[Architecture Report](arcPrj_report.pdf) · [Verilog Design](rtl/) · [Testbenches](testbenches/) · [Logisim Circuit](logisim/PipelinedProcesserArch.circ)

## Highlights

- **Five-stage pipeline:** instruction fetch, decode, execute, memory access, and write-back.
- **Custom 32-bit instruction set:** arithmetic, logic, immediate operations, memory access, and jumps/calls.
- **Data forwarding:** EX, MEM, and WB results can feed decode-stage operands, with priority given to the newest result.
- **Load-use hazard detection:** stalls account for dependencies on source operands and the predicate register.
- **Control-flow flushing:** a kill unit works with the fetch stage and IF/ID pipeline register.
- **Predicated execution:** instructions can execute conditionally based on a selected register.
- **Modular implementation:** 21 RTL files and 13 testbenches, including an integrated processor testbench.

## Pipeline Architecture

| Stage | Role | Main implementation |
| --- | --- | --- |
| IF — Fetch | Read the instruction and select the next program counter | `FetchStage.v`, `InstructionMemory.v`, `PC_Control.v` |
| ID — Decode | Decode fields, read registers, resolve dependencies, and evaluate the predicate | `DecodeStage.v`, `ControlUnit.v`, `RegFile.v`, forwarding/stall/predicate units |
| EX — Execute | Perform the selected ALU operation and calculate memory addresses | `ExecutionStage.v`, `ALU.v` |
| MEM — Memory | Read or write data memory | `MemoryStage.v`, `DataMemory.v` |
| WB — Write-back | Select the ALU result, memory data, or return address for register write-back | Selection logic in `PiplinedProcessor.v` |

The stages are separated by **IF/ID**, **ID/EX**, **EX/MEM**, and **MEM/WB** pipeline registers. The top-level Verilog module is named `PipelinedProcessor`; its source filename is `rtl/PiplinedProcessor.v`.

### Registers and Memory

| Resource | Implementation |
| --- | --- |
| Register file | 32 registers, each 32 bits wide |
| R0 | Reads as zero; regular writes are blocked |
| R30 | Holds the program counter |
| R31 | Receives the return address for `CALL` |
| Instruction memory | 1,024 × 32-bit words, loaded from hexadecimal text |
| Data memory | 1,024 × 32-bit words (4 KiB), asynchronous reads and synchronous writes |
| Addressing | Word-indexed memory; sequential PC advances by 1 |

## Instruction Set

This is a **custom ISA**. Instruction encodings should be taken from this implementation and the project report.

| Class | Instructions | Opcode values (decimal) |
| --- | --- | --- |
| Register arithmetic and logic | `ADD`, `SUB`, `OR`, `NOR`, `AND` | 0–4 |
| Immediate arithmetic and logic | `ADDI`, `ORI`, `NORI`, `ANDI` | 5–8 |
| Memory access | `LW`, `SW` | 9–10 |
| Control flow | `J`, `CALL`, `JR` | 11–13 |

The instruction splitter defines the following fields, listed from most significant to least significant:

| Format | Fields |
| --- | --- |
| R-type | Opcode (5), Rp (5), Rd (5), Rs (5), Rt (5), unused (7) |
| I-type | Opcode (5), Rp (5), Rd (5), Rs (5), immediate (12) |
| J-type | Opcode (5), Rp (5), offset (22) |

`ADDI`, `LW`, and `SW` use a sign-extended 12-bit immediate. Logical immediate instructions use zero extension. Jump/call offsets use sign extension from 22 bits. `JR` uses a register target.

### Predicated Execution

Each instruction includes an **Rp** field:

- **Rp = R0:** execution is enabled unconditionally.
- **Rp ≠ R0:** execution is enabled when the selected predicate register contains a nonzero value.

Predicate operands participate in forwarding and load-use stall detection alongside the other source operands.

## Repository Guide

| Path | Contents |
| --- | --- |
| [`rtl/`](rtl/) | Processor stages, pipeline registers, ALU, memories, and control/hazard units |
| [`testbenches/`](testbenches/) | Component tests and the full-processor testbench |
| [`programs/inst.txt`](programs/inst.txt) | Sample program encoded as hexadecimal instruction words |
| [`logisim/`](logisim/) | Separate Logisim circuit design |
| [`waveforms/`](waveforms/) | Saved `.asdb` waveform databases and `.awc` configuration |
| [`arcPrj_report.pdf`](arcPrj_report.pdf) | Project architecture report |

## Running the Verilog Simulation

Use a Verilog/SystemVerilog-capable simulator. Some source files declare variables inside procedural blocks, so enable SystemVerilog support when required by your tool.

1. Add all files from `rtl/` to your simulation project.
2. Add `testbenches/PipelinedProcessor_tb.v`.
3. Select **`PipelinedProcessor_tb`** as the simulation top.
4. Set the simulator working directory to **`programs/`**, or copy `programs/inst.txt` into the simulator working directory.
5. Compile and run the simulation.

**Program loading matters:** `InstructionMemory.v` uses `$readmemh("inst.txt", ROM)`. This path is relative to the simulator working directory.

### Command-line example with Icarus Verilog

From the repository root, with `iverilog` and `vvp` installed:

```bash
mkdir -p build
iverilog -g2012 -s PipelinedProcessor_tb -o build/processor_sim rtl/*.v testbenches/PipelinedProcessor_tb.v
cd programs
vvp ../build/processor_sim
```

This is a command-line recipe derived from the source layout; it has not been executed as part of this documentation update.

### Reading the Simulation Output

The integrated testbench generates a 10 ns clock and prints a state snapshot on falling clock edges, including:

- Cycle count, PC, and decoded instruction.
- All 32 register values.
- Data-memory entries 15 through 20.

It waits until `32'h0000DEAD` reaches the decode stage, then allows four more falling clock edges before finishing. **This value is a testbench completion marker**, rather than a dedicated hardware halt instruction.

The integrated testbench is intended for inspecting execution traces. Its completion message indicates that the stop condition was reached; it does not by itself establish correctness for every instruction or hazard scenario.

### Component Testbenches

The repository includes separate testbenches for the ALU, control unit, data memory, instruction memory, extender, forwarding unit, kill unit, PC control, predicate unit, register file, splitter, and stall unit.

To run one component testbench, compile it with the required RTL files and select its declared module as the simulation top.

## Exploring the Circuit and Waveforms

- Open [`PipelinedProcesserArch.circ`](logisim/PipelinedProcesserArch.circ) in a compatible Logisim installation to explore the circuit design.
- Use a simulator compatible with the saved `.asdb` and `.awc` formats to inspect the files in [`waveforms/`](waveforms/).
- Read the [architecture report](arcPrj_report.pdf) alongside the RTL to connect the design documentation with the implementation.

---

**Built to study the details of pipelining:** instruction decoding, register dependencies, predicate evaluation, memory access, and control flow.
