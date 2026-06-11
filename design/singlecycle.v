module SingleCycleCPU (
    input clk,
    input start
    
);

wire branch;
wire memRead;
wire memtoReg;
wire [1:0] ALUOp;
wire memWrite;
wire ALUSrc;
wire regWrite;
wire [4:0] readReg1;
wire [4:0] readReg2;
wire [4:0] writeReg;
wire [31:0] writeData;
wire [31:0] readData1;
wire [31:0] readData2;
wire [31:0] readData;
wire [31:0] pc_final;
wire [31:0] imm_reg_val;
wire zero;
wire [4:0] ALUCtl;
wire [31:0] imm;
wire [31:0] ALUOut;
wire [31:0] ALU_input1 = readData1;
wire [31:0] ALU_input2 = imm_reg_val;
wire [31:0] address;
wire [31:0] imm_sum;
wire [31:0] imm_s;
wire [31:0] inst;
wire [31:0] pc_i;
wire [31:0] pc_o;
wire [31:0] pc_new;

// When input start is zero, cpu should reset
// When input start is high, cpu start running

// TODO: connect wire to realize SingleCycleCPU
// The following provides simple template,

    InstructionMemory m_InstMem(
    .readAddr(pc_o),
    .inst(inst)
    );


    Mux2to1 #(.size(32)) m_Mux_PC(
        .sel(branch & zero),
        .s0(pc_new),
        .s1(imm_sum),
        .out(pc_final)
    
    );


    PC m_PC(
        .clk(clk),
        .rst(start),
        .pc_i(pc_final),
        .pc_o(pc_o)
    );

    Adder m_Adder_1(
        .a(pc_o),
        .b(4),
        .sum(pc_new)
    );










 //DECODE
    Control m_Control(
        .opcode(inst[6:0]),
        .branch(branch),
        .memRead(memRead),
        .memtoReg(memtoReg),
        .ALUOp(ALUOp),
        .memWrite(memWrite),
        .ALUSrc(ALUSrc),
        .regWrite(regWrite)
    );

    ImmGen #(.Width(32)) m_ImmGen(
        .inst(inst),
        .imm(imm)
    );




    Register m_Register(
        .clk(clk),
        .rst(start),
        .regWrite(regWrite),
        .readReg1(inst[19:15]),
        .readReg2(inst[24:20]),
        .writeReg(inst[11:7]),
        .writeData(writeData),
        .readData1(readData1),
        .readData2(readData2)
    );



//EXCECUTE
    ShiftLeftOne m_ShiftLeftOne(
    .i(imm),
    .o(imm_s)
    );

    Adder m_Adder_2(
    .a(pc_o),
    .b(imm_s),
    .sum(imm_sum)
    );

    Mux2to1 #(.size(32)) m_Mux_ALU(
    .sel(ALUSrc),
    .s0(readData2),
    .s1(imm),
    .out(imm_reg_val)
    );

    ALUCtrl m_ALUCtrl(
    .ALUOp(ALUOp),
    .funct7(inst[30]),
    .funct3(inst[14:12]),
    .ALUCtl(ALUCtl)
    );

    ALU m_ALU(
    .ALUCtl(ALUCtl),
    .A(ALU_input1),
    .B(ALU_input2),
    .ALUOut(ALUOut),
    .zero(zero)
    );





//MEMORY
    DataMemory m_DataMemory(
    .rst(start),
    .clk(clk),
    .memWrite(memWrite),
    .memRead(memRead),
    .address(ALUOut),
    .writeData(readData2),
    .readData(readData)
    );





//WRITEBACK
    Mux2to1 #(.size(32)) m_Mux_WriteData(
    .sel(memtoReg),
    .s0(ALUOut),
    .s1(readData),
    .out(writeData)
    );























endmodule