module immediate_generator (
    input  logic [31:0] instruction,
    input  logic [2:0]  ImmType,

    output logic [31:0] immediate
);

    /*
        ImmType encoding

        000 = I-Type
        001 = S-Type
        010 = B-Type
        011 = U-Type
        100 = J-Type
    */

    always_comb begin

        immediate = 32'd0;

        case (ImmType)

            // ----------------------------------------
            // I-Type
            // bits [31:20]
            // ----------------------------------------

            3'b000: begin

                immediate = {{20{instruction[31]}},
                             instruction[31:20]};

            end

            // ----------------------------------------
            // S-Type
            // bits [31:25] + [11:7]
            // ----------------------------------------

            3'b001: begin

                immediate = {{20{instruction[31]}},
                             instruction[31:25],
                             instruction[11:7]};

            end

            // ----------------------------------------
            // B-Type
            //
            // imm[12]    = instruction[31]
            // imm[11]    = instruction[7]
            // imm[10:5]  = instruction[30:25]
            // imm[4:1]   = instruction[11:8]
            // imm[0]     = 0
            // ----------------------------------------

            3'b010: begin

                immediate = {{19{instruction[31]}},
                             instruction[31],
                             instruction[7],
                             instruction[30:25],
                             instruction[11:8],
                             1'b0};

            end

            // ----------------------------------------
            // U-Type
            //
            // LUI/AUIPC
            // ----------------------------------------

            3'b011: begin

                immediate = {
                    instruction[31:12],
                    12'b0
                };

            end

            // ----------------------------------------
            // J-Type
            //
            // imm[20]    = instruction[31]
            // imm[10:1]  = instruction[30:21]
            // imm[11]    = instruction[20]
            // imm[19:12] = instruction[19:12]
            // imm[0]     = 0
            // ----------------------------------------

            3'b100: begin

                immediate = {{11{instruction[31]}},
                             instruction[31],
                             instruction[19:12],
                             instruction[20],
                             instruction[30:21],
                             1'b0};

            end

            default: begin

                immediate = 32'd0;

            end

        endcase

    end

endmodule