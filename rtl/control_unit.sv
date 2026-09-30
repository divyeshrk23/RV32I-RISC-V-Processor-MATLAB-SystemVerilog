module control_unit (
    input  logic [6:0] opcode,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,

    output logic       RegWrite,
    output logic       MemRead,
    output logic       MemWrite,
    output logic       MemToReg,
    output logic       ALUSrc,
    output logic       Branch,
    output logic       Jump,
    output logic       Jalr,

    output logic [3:0] ALUControl,
    output logic [2:0] BranchType,
    output logic [1:0] PCSrc
);

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

    localparam [1:0]
        PC_PLUS4 = 2'b00,
        PC_BRANCH = 2'b01,
        PC_JAL = 2'b10,
        PC_JALR = 2'b11;

    always_comb begin

        RegWrite = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        MemToReg = 1'b0;
        ALUSrc = 1'b0;
        Branch = 1'b0;
        Jump = 1'b0;
        Jalr = 1'b0;

        ALUControl = ALU_ADD;
        BranchType = 3'b000;
        PCSrc = PC_PLUS4;

        case (opcode)

            7'b0110011: begin

                RegWrite = 1'b1;

                case (funct3)

                    3'b000:
                        if (funct7 == 7'b0100000)
                            ALUControl = ALU_SUB;
                        else
                            ALUControl = ALU_ADD;

                    3'b001:
                        ALUControl = ALU_SLL;

                    3'b010:
                        ALUControl = ALU_SLT;

                    3'b011:
                        ALUControl = ALU_SLTU;

                    3'b100:
                        ALUControl = ALU_XOR;

                    3'b101:
                        if (funct7 == 7'b0100000)
                            ALUControl = ALU_SRA;
                        else
                            ALUControl = ALU_SRL;

                    3'b110:
                        ALUControl = ALU_OR;

                    3'b111:
                        ALUControl = ALU_AND;

                    default:
                        ALUControl = ALU_ADD;

                endcase

            end

            7'b0010011: begin

                RegWrite = 1'b1;
                ALUSrc = 1'b1;

                case (funct3)

                    3'b000: ALUControl = ALU_ADD;
                    3'b001: ALUControl = ALU_SLL;
                    3'b010: ALUControl = ALU_SLT;
                    3'b011: ALUControl = ALU_SLTU;
                    3'b100: ALUControl = ALU_XOR;

                    3'b101:
                        if (funct7 == 7'b0100000)
                            ALUControl = ALU_SRA;
                        else
                            ALUControl = ALU_SRL;

                    3'b110: ALUControl = ALU_OR;
                    3'b111: ALUControl = ALU_AND;

                    default: ALUControl = ALU_ADD;

                endcase

            end

            7'b0000011: begin

                RegWrite = 1'b1;
                MemRead = 1'b1;
                MemToReg = 1'b1;
                ALUSrc = 1'b1;
                ALUControl = ALU_ADD;

            end

            7'b0100011: begin

                MemWrite = 1'b1;
                ALUSrc = 1'b1;
                ALUControl = ALU_ADD;

            end

            7'b1100011: begin

                Branch = 1'b1;
                ALUControl = ALU_SUB;
                BranchType = funct3;
                PCSrc = PC_BRANCH;

            end

            7'b1101111: begin

                RegWrite = 1'b1;
                Jump = 1'b1;
                PCSrc = PC_JAL;

            end

            7'b1100111: begin

                RegWrite = 1'b1;
                ALUSrc = 1'b1;
                Jump = 1'b1;
                Jalr = 1'b1;
                ALUControl = ALU_ADD;
                PCSrc = PC_JALR;

            end

            default: begin

            end

        endcase

    end

endmodule