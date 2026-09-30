module decoder (
    input  logic [31:0] instruction,

    output logic [6:0]  opcode,
    output logic [4:0]  rd,
    output logic [4:0]  rs1,
    output logic [4:0]  rs2,
    output logic [2:0]  funct3,
    output logic [6:0]  funct7,

    output logic [31:0] immediate,

    output logic        isRType,
    output logic        isIType,
    output logic        isSType,
    output logic        isBType,
    output logic        isJType,

    output logic        isALU,
    output logic        isLoad,
    output logic        isStore,
    output logic        isBranch,
    output logic        isJAL,
    output logic        isJALR
);

    always_comb begin

        // ----------------------------------------
        // Basic instruction fields
        // ----------------------------------------

        opcode = instruction[6:0];
        rd     = instruction[11:7];
        funct3 = instruction[14:12];
        rs1    = instruction[19:15];
        rs2    = instruction[24:20];
        funct7 = instruction[31:25];

        // ----------------------------------------
        // Default values
        // ----------------------------------------

        immediate = 32'd0;

        isRType = 1'b0;
        isIType = 1'b0;
        isSType = 1'b0;
        isBType = 1'b0;
        isJType = 1'b0;

        isALU    = 1'b0;
        isLoad   = 1'b0;
        isStore  = 1'b0;
        isBranch = 1'b0;
        isJAL    = 1'b0;
        isJALR   = 1'b0;

        // ----------------------------------------
        // Opcode decoding
        // ----------------------------------------

        case (opcode)

            // ------------------------------------
            // R-Type
            // ADD SUB AND OR XOR SLT SLTU
            // ------------------------------------

            7'b0110011: begin

                isRType = 1'b1;
                isALU   = 1'b1;

            end

            // ------------------------------------
            // I-Type ALU
            // ADDI SLTI SLTIU SLLI SRLI SRAI
            // ------------------------------------

            7'b0010011: begin

                isIType = 1'b1;
                isALU   = 1'b1;

                immediate = {
                    {20{instruction[31]}},
                    instruction[31:20]
                };

            end

            // ------------------------------------
            // Loads
            // LB LBU LH LHU LW
            // ------------------------------------

            7'b0000011: begin

                isIType = 1'b1;
                isLoad  = 1'b1;

                immediate = {
                    {20{instruction[31]}},
                    instruction[31:20]
                };

            end

            // ------------------------------------
            // Stores
            // SB SH SW
            // ------------------------------------

            7'b0100011: begin

                isSType = 1'b1;
                isStore = 1'b1;

                immediate = {
                    {20{instruction[31]}},
                    instruction[31:25],
                    instruction[11:7]
                };

            end

            // ------------------------------------
            // Branches
            // BEQ BNE BLT BGE BLTU BGEU
            // ------------------------------------

            7'b1100011: begin

                isBType = 1'b1;
                isBranch = 1'b1;

                immediate = {
                    {19{instruction[31]}},
                    instruction[31],
                    instruction[7],
                    instruction[30:25],
                    instruction[11:8],
                    1'b0
                };

            end

            // ------------------------------------
            // JAL
            // ------------------------------------

            7'b1101111: begin

                isJType = 1'b1;
                isJAL   = 1'b1;

                immediate = {
                    {11{instruction[31]}},
                    instruction[31],
                    instruction[19:12],
                    instruction[20],
                    instruction[30:21],
                    1'b0
                };

            end

            // ------------------------------------
            // JALR
            // ------------------------------------

            7'b1100111: begin

                isIType = 1'b1;
                isJALR  = 1'b1;

                immediate = {
                    {20{instruction[31]}},
                    instruction[31:20]
                };

            end

            default: begin

                immediate = 32'd0;

            end

        endcase

    end

endmodule