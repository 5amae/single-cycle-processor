# single-cycle-processor
this is a basic single cycle risc v processor with rv32i instructions

A synthesizable, foundational **Single-Cycle RISC-V Processor Core** implemented in Verilog. This project implements the RV32I instruction subset, executing every instruction (Fetch, Decode, Execute, Memory Access, and Writeback) in a single clock cycle. This design serves as the architectural baseline for evaluating the performance benefits of pipelined and out-of-order execution engines.

In a single-cycle implementation, there are no intermediate pipeline registers. Data propagates from the Program Counter through the entire combinational circuit, culminating in register or memory writes at the next rising clock edge.

```mermaid
graph TD
    PC[Program Counter] --> IM[Instruction Memory]
    IM --> CTRL[Control Unit]
    IM --> RF[Register File]
    IM --> ImmGen[Immediate Generator]
    
    RF --> MUX_ALU[ALU Source Mux]
    ImmGen --> MUX_ALU
    
    RF --> ALU[ALU]
    MUX_ALU --> ALU
    
    ALU --> DM[Data Memory]
    
    DM --> MUX_WB[Writeback Mux]
    ALU --> MUX_WB
    
    MUX_WB -.->|Writeback Data| RF
