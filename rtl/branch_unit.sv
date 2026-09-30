module branch_unit (
    input  logic [31:0] rs1_data,
    input  logic [31:0] rs2_data,

    input  logic [2:0]  BranchType,
    input  logic        Branch,

    input  logic [31:0] PC,
    input  logic [31:0] immediate,

    output logic        BranchTaken,
    output logic [31:0] BranchTarget
);

    // RV32I branch funct3 values
    localparam [2:0]
        BEQ  = 3'b000,
        BNE  = 3'b001,
        BLT  = 3'b100,
        BGE  = 3'b101,
        BLTU = 3'b110,
        BGEU = 3'b111;

    always_comb begin

        // Default values
        BranchTaken  = 1'b0;
        BranchTarget = PC + immediate;

        // ----------------------------------------
        // Branch condition
        // ----------------------------------------

        if (Branch) begin

            case (BranchType)

                // BEQ
                BEQ: begin
                    if (rs1_data == rs2_data)
                        BranchTaken = 1'b1;
                end

                // BNE
                BNE: begin
                    if (rs1_data != rs2_data)
                        BranchTaken = 1'b1;
                end

                // BLT - signed
                BLT: begin
                    if ($signed(rs1_data) < $signed(rs2_data))
                        BranchTaken = 1'b1;
                end

                // BGE - signed
                BGE: begin
                    if ($signed(rs1_data) >= $signed(rs2_data))
                        BranchTaken = 1'b1;
                end

                // BLTU - unsigned
                BLTU: begin
                    if (rs1_data < rs2_data)
                        BranchTaken = 1'b1;
                end

                // BGEU - unsigned
                BGEU: begin
                    if (rs1_data >= rs2_data)
                        BranchTaken = 1'b1;
                end

                default: begin
                    BranchTaken = 1'b0;
                end

            endcase

        end

    end

endmodule