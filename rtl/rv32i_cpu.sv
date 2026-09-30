module rv32i_cpu (

    input  logic clk,

    input  logic reset,



    output logic halted

);



    // ============================================================

    // Instruction memory

    // ============================================================



    logic [31:0] instruction_memory [0:255];



    // ============================================================

    // Data memory

    // ============================================================



    logic [31:0] data_memory [0:255];



    integer i;



    // ============================================================

    // Program Counter

    // ============================================================



    logic [31:0] PC;

    logic [31:0] nextPC;



    // ============================================================

    // IF stage

    // ============================================================



    logic [31:0] IF_instruction;



    assign IF_instruction = instruction_memory[PC[9:2]];



    // ============================================================

    // IF/ID pipeline register

    // ============================================================



    logic [31:0] IF_ID_PC;

    logic [31:0] IF_ID_instruction;

    logic        IF_ID_valid;



    // ============================================================

    // ID stage

    // ============================================================



    logic [6:0] ID_opcode;

    logic [4:0] ID_rd;

    logic [4:0] ID_rs1;

    logic [4:0] ID_rs2;

    logic [2:0] ID_funct3;

    logic [6:0] ID_funct7;



    logic [31:0] ID_decoder_immediate;



    logic ID_isRType;

    logic ID_isIType;

    logic ID_isSType;

    logic ID_isBType;

    logic ID_isJType;



    logic ID_isALU;

    logic ID_isLoad;

    logic ID_isStore;

    logic ID_isBranch;

    logic ID_isJAL;

    logic ID_isJALR;



    logic [31:0] ID_immediate;



    // ============================================================

    // Control signals

    // ============================================================



    logic       ID_RegWrite;

    logic       ID_MemRead;

    logic       ID_MemWrite;

    logic       ID_MemToReg;

    logic       ID_ALUSrc;

    logic       ID_Branch;

    logic       ID_Jump;

    logic       ID_Jalr;



    logic [3:0] ID_ALUControl;

    logic [2:0] ID_BranchType;

    logic [1:0] ID_PCSrc;



    // ============================================================

    // Register file

    // ============================================================



    logic [31:0] ID_rs1_data;

    logic [31:0] ID_rs2_data;



    logic [4:0] WB_rd;

    logic [31:0] WB_writeData;

    logic        WB_RegWrite;



    // ============================================================

    // ID/EX pipeline register

    // ============================================================



    logic [31:0] ID_EX_PC;

    logic [31:0] ID_EX_rs1_data;

    logic [31:0] ID_EX_rs2_data;

    logic [31:0] ID_EX_immediate;



    logic [4:0] ID_EX_rs1;

    logic [4:0] ID_EX_rs2;

    logic [4:0] ID_EX_rd;



    logic [2:0] ID_EX_funct3;



    logic       ID_EX_RegWrite;

    logic       ID_EX_MemRead;

    logic       ID_EX_MemWrite;

    logic       ID_EX_MemToReg;

    logic       ID_EX_ALUSrc;

    logic       ID_EX_Branch;

    logic       ID_EX_Jump;

    logic       ID_EX_Jalr;



    logic [3:0] ID_EX_ALUControl;

    logic [2:0] ID_EX_BranchType;

    logic [1:0] ID_EX_PCSrc;



    logic       ID_EX_valid;



    // ============================================================

    // Forwarding

    // ============================================================



    logic [1:0] ForwardA;

    logic [1:0] ForwardB;



    logic [31:0] EX_operandA;

    logic [31:0] EX_operandB_register;

    logic [31:0] EX_operandB;



    // ============================================================

    // EX stage

    // ============================================================



    logic [31:0] EX_alu_result;

    logic        EX_zero;

    logic        EX_less_signed;

    logic        EX_less_unsigned;



    logic        EX_branch_taken;

    logic [31:0] EX_branch_target;



    logic [31:0] EX_jump_target;

    logic [31:0] EX_link_value;



    // ============================================================

    // EX/MEM pipeline register

    // ============================================================



    logic [31:0] EX_MEM_alu_result;

    logic [31:0] EX_MEM_store_data;

    logic [31:0] EX_MEM_link_value;



    logic [4:0] EX_MEM_rd;



    logic       EX_MEM_RegWrite;

    logic       EX_MEM_MemRead;

    logic       EX_MEM_MemWrite;

    logic       EX_MEM_MemToReg;

    logic       EX_MEM_Jump;



    logic [2:0] EX_MEM_funct3;



    logic       EX_MEM_valid;



    // ============================================================

    // MEM stage

    // ============================================================



    logic [31:0] MEM_read_data;



    // ============================================================

    // MEM/WB pipeline register

    // ============================================================



    logic [31:0] MEM_WB_alu_result;

    logic [31:0] MEM_WB_read_data;

    logic [31:0] MEM_WB_link_value;



    logic [4:0] MEM_WB_rd;



    logic       MEM_WB_RegWrite;

    logic       MEM_WB_MemToReg;

    logic       MEM_WB_Jump;



    logic       MEM_WB_valid;



    // ============================================================

    // Hazard unit

    // ============================================================



    logic PCWrite;

    logic IF_ID_Write;

    logic ID_EX_Flush;

    logic HazardDetected;



    // ============================================================

    // Decoder

    // ============================================================



    decoder decoder_unit (

        .instruction(IF_ID_instruction),



        .opcode(ID_opcode),

        .rd(ID_rd),

        .rs1(ID_rs1),

        .rs2(ID_rs2),

        .funct3(ID_funct3),

        .funct7(ID_funct7),



        .immediate(ID_decoder_immediate),



        .isRType(ID_isRType),

        .isIType(ID_isIType),

        .isSType(ID_isSType),

        .isBType(ID_isBType),

        .isJType(ID_isJType),



        .isALU(ID_isALU),

        .isLoad(ID_isLoad),

        .isStore(ID_isStore),

        .isBranch(ID_isBranch),

        .isJAL(ID_isJAL),

        .isJALR(ID_isJALR)

    );



    // ============================================================

    // Immediate Generator

    // ============================================================



    logic [2:0] ID_ImmType;



    always_comb begin



        case (ID_opcode)



            7'b0010011,

            7'b0000011,

            7'b1100111:

                ID_ImmType = 3'b000;



            7'b0100011:

                ID_ImmType = 3'b001;



            7'b1100011:

                ID_ImmType = 3'b010;



            7'b0110111,

            7'b0010111:

                ID_ImmType = 3'b011;



            7'b1101111:

                ID_ImmType = 3'b100;



            default:

                ID_ImmType = 3'b000;



        endcase



    end



    immediate_generator immediate_unit (

        .instruction(IF_ID_instruction),

        .ImmType(ID_ImmType),

        .immediate(ID_immediate)

    );



    // ============================================================

    // Control Unit

    // ============================================================



    control_unit control_unit_inst (

        .opcode(ID_opcode),

        .funct3(ID_funct3),

        .funct7(ID_funct7),



        .RegWrite(ID_RegWrite),

        .MemRead(ID_MemRead),

        .MemWrite(ID_MemWrite),

        .MemToReg(ID_MemToReg),

        .ALUSrc(ID_ALUSrc),

        .Branch(ID_Branch),

        .Jump(ID_Jump),

        .Jalr(ID_Jalr),



        .ALUControl(ID_ALUControl),

        .BranchType(ID_BranchType),

        .PCSrc(ID_PCSrc)

    );



    // ============================================================

    // Register File

    // ============================================================



    register_file register_file_inst (

        .clk(clk),

        .reset(reset),



        .rs1(ID_rs1),

        .rs2(ID_rs2),

        .rd(WB_rd),



        .writeData(WB_writeData),

        .RegWrite(WB_RegWrite),



        .readData1(ID_rs1_data),

        .readData2(ID_rs2_data)

    );



    // ============================================================

    // Write-back mux

    // ============================================================



    always_comb begin



        if (MEM_WB_Jump)

            WB_writeData = MEM_WB_link_value;



        else if (MEM_WB_MemToReg)

            WB_writeData = MEM_WB_read_data;



        else

            WB_writeData = MEM_WB_alu_result;



    end



    assign WB_rd = MEM_WB_rd;

    assign WB_RegWrite = MEM_WB_RegWrite;



    // ============================================================

    // Hazard Unit

    // ============================================================



    hazard_unit hazard_unit_inst (

        .ID_rs1(ID_rs1),

        .ID_rs2(ID_rs2),



        .EX_rd(ID_EX_rd),

        .EX_MemRead(ID_EX_MemRead),



        .PCWrite(PCWrite),

        .IF_ID_Write(IF_ID_Write),

        .ID_EX_Flush(ID_EX_Flush),



        .HazardDetected(HazardDetected)

    );



    // ============================================================

    // Forwarding Unit

    // ============================================================



    forwarding_unit forwarding_unit_inst (

        .ID_EX_rs1(ID_EX_rs1),

        .ID_EX_rs2(ID_EX_rs2),



        .EX_MEM_rd(EX_MEM_rd),

        .EX_MEM_RegWrite(EX_MEM_RegWrite),



        .MEM_WB_rd(MEM_WB_rd),

        .MEM_WB_RegWrite(MEM_WB_RegWrite),



        .ForwardA(ForwardA),

        .ForwardB(ForwardB)

    );



    // ============================================================

    // Forwarding multiplexers

    // ============================================================



    always_comb begin



        case (ForwardA)



            2'b00:

                EX_operandA = ID_EX_rs1_data;



            2'b01:

                EX_operandA = WB_writeData;



            2'b10:

                EX_operandA = EX_MEM_alu_result;



            default:

                EX_operandA = ID_EX_rs1_data;



        endcase





        case (ForwardB)



            2'b00:

                EX_operandB_register = ID_EX_rs2_data;



            2'b01:

                EX_operandB_register = WB_writeData;



            2'b10:

                EX_operandB_register = EX_MEM_alu_result;



            default:

                EX_operandB_register = ID_EX_rs2_data;



        endcase



    end



    // ============================================================

    // ALU source mux

    // ============================================================



    always_comb begin



        if (ID_EX_ALUSrc)

            EX_operandB = ID_EX_immediate;

        else

            EX_operandB = EX_operandB_register;



    end



    // ============================================================

    // ALU

    // ============================================================



    alu alu_unit (

        .A(EX_operandA),

        .B(EX_operandB),

        .ALUControl(ID_EX_ALUControl),



        .Result(EX_alu_result),

        .Zero(EX_zero),

        .LessThanSigned(EX_less_signed),

        .LessThanUnsigned(EX_less_unsigned)

    );



    // ============================================================

    // Branch Unit

    // ============================================================



    branch_unit branch_unit_inst (

        .rs1_data(EX_operandA),

        .rs2_data(EX_operandB_register),



        .BranchType(ID_EX_BranchType),

        .Branch(ID_EX_Branch),



        .PC(ID_EX_PC),

        .immediate(ID_EX_immediate),



        .BranchTaken(EX_branch_taken),

        .BranchTarget(EX_branch_target)

    );



    // ============================================================

    // Jump target

    // ============================================================



    always_comb begin



        if (ID_EX_Jalr)

            EX_jump_target =

                (EX_operandA + ID_EX_immediate) & 32'hFFFFFFFE;

        else

            EX_jump_target =

                ID_EX_PC + ID_EX_immediate;



    end



    assign EX_link_value = ID_EX_PC + 32'd4;



    // ============================================================

    // Control flow decision

    // ============================================================



    logic        EX_control_taken;

    logic [31:0] EX_control_target;



    always_comb begin



        EX_control_taken  = 1'b0;

        EX_control_target = PC + 32'd4;



        if (ID_EX_Branch && EX_branch_taken) begin



            EX_control_taken = 1'b1;

            EX_control_target = EX_branch_target;



        end



        else if (ID_EX_Jump) begin



            EX_control_taken = 1'b1;

            EX_control_target = EX_jump_target;



        end



    end



    // ============================================================

    // Data memory read

    // ============================================================



    always_comb begin



        MEM_read_data = 32'd0;



        if (EX_MEM_MemRead)

            MEM_read_data =

                data_memory[EX_MEM_alu_result[9:2]];



    end



    // ============================================================
// Halt detection
//
// 0x00000000 is treated as END/NOP for this integration test.
// A valid zero instruction in the IF/ID stage marks the end
// of the program.
// ============================================================

always_comb begin

    halted = 1'b0;

   if ((IF_ID_instruction == 32'h00000000) &&
    IF_ID_valid)
        halted = 1'b1;

end


    // Next PC

    // ============================================================



    always_comb begin



        nextPC = PC + 32'd4;



        if (EX_control_taken)

            nextPC = EX_control_target;



    end



    // ============================================================

    // Sequential pipeline

    // ============================================================



    always_ff @(posedge clk) begin



        if (reset) begin



            PC = 32'd0;



            IF_ID_PC = 32'd0;

            IF_ID_instruction = 32'd0;

            IF_ID_valid = 1'b0;



            ID_EX_PC = 32'd0;

            ID_EX_rs1_data = 32'd0;

            ID_EX_rs2_data = 32'd0;

            ID_EX_immediate = 32'd0;



            ID_EX_rs1 = 5'd0;

            ID_EX_rs2 = 5'd0;

            ID_EX_rd = 5'd0;



            ID_EX_funct3 = 3'd0;



            ID_EX_RegWrite = 1'b0;

            ID_EX_MemRead = 1'b0;

            ID_EX_MemWrite = 1'b0;

            ID_EX_MemToReg = 1'b0;

            ID_EX_ALUSrc = 1'b0;

            ID_EX_Branch = 1'b0;

            ID_EX_Jump = 1'b0;

            ID_EX_Jalr = 1'b0;



            ID_EX_ALUControl = 4'd0;

            ID_EX_BranchType = 3'd0;

            ID_EX_PCSrc = 2'd0;



            ID_EX_valid = 1'b0;



            EX_MEM_alu_result = 32'd0;

            EX_MEM_store_data = 32'd0;

            EX_MEM_link_value = 32'd0;



            EX_MEM_rd = 5'd0;



            EX_MEM_RegWrite = 1'b0;

            EX_MEM_MemRead = 1'b0;

            EX_MEM_MemWrite = 1'b0;

            EX_MEM_MemToReg = 1'b0;

            EX_MEM_Jump = 1'b0;



            EX_MEM_funct3 = 3'd0;

            EX_MEM_valid = 1'b0;



            MEM_WB_alu_result = 32'd0;

            MEM_WB_read_data = 32'd0;

            MEM_WB_link_value = 32'd0;



            MEM_WB_rd = 5'd0;



            MEM_WB_RegWrite = 1'b0;

            MEM_WB_MemToReg = 1'b0;

            MEM_WB_Jump = 1'b0;



            MEM_WB_valid = 1'b0;



        end



        else begin



            // ----------------------------------------------------

            // Program counter

            // ----------------------------------------------------



            if (PCWrite)

                PC <= nextPC;



            // ----------------------------------------------------

            // MEM/WB

            // ----------------------------------------------------



            MEM_WB_alu_result <= EX_MEM_alu_result;

            MEM_WB_read_data <= MEM_read_data;

            MEM_WB_link_value <= EX_MEM_link_value;



            MEM_WB_rd <= EX_MEM_rd;



            MEM_WB_RegWrite <= EX_MEM_RegWrite;

            MEM_WB_MemToReg <= EX_MEM_MemToReg;

            MEM_WB_Jump <= EX_MEM_Jump;



            MEM_WB_valid <= EX_MEM_valid;



            // ----------------------------------------------------

            // Store

            // ----------------------------------------------------



            if (EX_MEM_MemWrite)

                data_memory[EX_MEM_alu_result[9:2]]

                    <= EX_MEM_store_data;



            // ----------------------------------------------------

            // EX/MEM

            // ----------------------------------------------------



            EX_MEM_alu_result <= EX_alu_result;

            EX_MEM_store_data <= EX_operandB_register;

            EX_MEM_link_value <= EX_link_value;



            EX_MEM_rd <= ID_EX_rd;



            EX_MEM_RegWrite <= ID_EX_RegWrite;

            EX_MEM_MemRead <= ID_EX_MemRead;

            EX_MEM_MemWrite <= ID_EX_MemWrite;

            EX_MEM_MemToReg <= ID_EX_MemToReg;

            EX_MEM_Jump <= ID_EX_Jump;



            EX_MEM_funct3 <= ID_EX_funct3;



            EX_MEM_valid <= ID_EX_valid;



            // ----------------------------------------------------

            // ID/EX

            // ----------------------------------------------------



            if (EX_control_taken) begin



                // Flush instruction behind branch/jump



                ID_EX_PC <= 32'd0;

                ID_EX_rs1_data <= 32'd0;

                ID_EX_rs2_data <= 32'd0;

                ID_EX_immediate <= 32'd0;



                ID_EX_rs1 <= 5'd0;

                ID_EX_rs2 <= 5'd0;

                ID_EX_rd <= 5'd0;



                ID_EX_funct3 <= 3'd0;



                ID_EX_RegWrite <= 1'b0;

                ID_EX_MemRead <= 1'b0;

                ID_EX_MemWrite <= 1'b0;

                ID_EX_MemToReg <= 1'b0;

                ID_EX_ALUSrc <= 1'b0;

                ID_EX_Branch <= 1'b0;

                ID_EX_Jump <= 1'b0;

                ID_EX_Jalr <= 1'b0;



                ID_EX_ALUControl <= 4'd0;

                ID_EX_BranchType <= 3'd0;

                ID_EX_PCSrc <= 2'd0;



                ID_EX_valid <= 1'b0;



            end



            else if (ID_EX_Flush) begin



                ID_EX_PC <= 32'd0;

                ID_EX_rs1_data <= 32'd0;

                ID_EX_rs2_data <= 32'd0;

                ID_EX_immediate <= 32'd0;



                ID_EX_rs1 <= 5'd0;

                ID_EX_rs2 <= 5'd0;

                ID_EX_rd <= 5'd0;



                ID_EX_funct3 <= 3'd0;



                ID_EX_RegWrite <= 1'b0;

                ID_EX_MemRead <= 1'b0;

                ID_EX_MemWrite <= 1'b0;

                ID_EX_MemToReg <= 1'b0;

                ID_EX_ALUSrc <= 1'b0;

                ID_EX_Branch <= 1'b0;

                ID_EX_Jump <= 1'b0;

                ID_EX_Jalr <= 1'b0;



                ID_EX_ALUControl <= 4'd0;

                ID_EX_BranchType <= 3'd0;

                ID_EX_PCSrc <= 2'd0;



                ID_EX_valid <= 1'b0;



            end



            else begin



                ID_EX_PC <= IF_ID_PC;



                ID_EX_rs1_data <= ID_rs1_data;

                ID_EX_rs2_data <= ID_rs2_data;

                ID_EX_immediate <= ID_immediate;



                ID_EX_rs1 <= ID_rs1;

                ID_EX_rs2 <= ID_rs2;

                ID_EX_rd <= ID_rd;



                ID_EX_funct3 <= ID_funct3;



                ID_EX_RegWrite <= ID_RegWrite;

                ID_EX_MemRead <= ID_MemRead;

                ID_EX_MemWrite <= ID_MemWrite;

                ID_EX_MemToReg <= ID_MemToReg;

                ID_EX_ALUSrc <= ID_ALUSrc;

                ID_EX_Branch <= ID_Branch;

                ID_EX_Jump <= ID_Jump;

                ID_EX_Jalr <= ID_Jalr;



                ID_EX_ALUControl <= ID_ALUControl;

                ID_EX_BranchType <= ID_BranchType;

                ID_EX_PCSrc <= ID_PCSrc;



                ID_EX_valid <= IF_ID_valid;



            end



            // ----------------------------------------------------

            // IF/ID

            // ----------------------------------------------------



            if (EX_control_taken) begin



                IF_ID_PC <= 32'd0;

                IF_ID_instruction <= 32'd0;

                IF_ID_valid <= 1'b0;



            end



            else if (IF_ID_Write) begin



                IF_ID_PC <= PC;

                IF_ID_instruction <= IF_instruction;

                IF_ID_valid <= 1'b1;



            end



        end



    end



    // ============================================================

    // Initialize memories

    // ============================================================



    initial begin



        for (i = 0; i < 256; i = i + 1) begin

            instruction_memory[i] = 32'h00000000;

            data_memory[i] = 32'h00000000;

        end



    end



endmodule