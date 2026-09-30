module alu_control (
    input  logic [1:0] ALUOp,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,

    output logic [3:0] ALUControl
);

    // ----------------------------------------
    // ALU control encoding
    // ----------------------------------------

    localparam [3:0]
        ALU_ADD  = 4'b0000,
        ALU_SUB  = 4'b0001,
        ALU_AND  = 4'b0010,
        ALU_OR   = 4'b0011,
        ALU_XOR  = 4'b0100,
        ALU_SLL  = 4'b0101,
        ALU_SRL  = 4'b0110,
        ALU_SRA  = 4'b0111,
        ALU_SLT  = 4'b1000,
        ALU_SLTU = 4'b1001;

    always_comb begin

        // Default
        ALUControl = ALU_ADD;

        case (ALUOp)

            // --------------------------------
            // 00 = ADD
            //
            // Used by:
            // Loads
            // Stores
            // --------------------------------

            2'b00: begin

                ALUControl = ALU_ADD;

            end

            // --------------------------------
            // 01 = SUB
            //
            // Used by branches
            // --------------------------------

            2'b01: begin

                ALUControl = ALU_SUB;

            end

            // --------------------------------
            // 10 = R-Type / I-Type ALU
            // --------------------------------

            2'b10: begin

                case (funct3)

                    // ADD / SUB / ADDI
                    3'b000: begin

                        if (funct7 == 7'b0100000)
                            ALUControl = ALU_SUB;
                        else
                            ALUControl = ALU_ADD;

                    end

                    // SLL / SLLI
                    3'b001: begin

                        ALUControl = ALU_SLL;

                    end

                    // SLT / SLTI
                    3'b010: begin

                        ALUControl = ALU_SLT;

                    end

                    // SLTU / SLTIU
                    3'b011: begin

                        ALUControl = ALU_SLTU;

                    end

                    // XOR / XORI
                    3'b100: begin

                        ALUControl = ALU_XOR;

                    end

                    // SRL / SRA / SRLI / SRAI
                    3'b101: begin

                        if (funct7 == 7'b0100000)
                            ALUControl = ALU_SRA;
                        else
                            ALUControl = ALU_SRL;

                    end

                    // OR / ORI
                    3'b110: begin

                        ALUControl = ALU_OR;

                    end

                    // AND / ANDI
                    3'b111: begin

                        ALUControl = ALU_AND;

                    end

                    default: begin

                        ALUControl = ALU_ADD;

                    end

                endcase

            end

            // --------------------------------
            // Other
            // --------------------------------

            default: begin

                ALUControl = ALU_ADD;

            end

        endcase

    end

endmodule