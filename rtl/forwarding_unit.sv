module forwarding_unit (
    input  logic [4:0] ID_EX_rs1,
    input  logic [4:0] ID_EX_rs2,

    input  logic [4:0] EX_MEM_rd,
    input  logic       EX_MEM_RegWrite,

    input  logic [4:0] MEM_WB_rd,
    input  logic       MEM_WB_RegWrite,

    output logic [1:0] ForwardA,
    output logic [1:0] ForwardB
);

    // Forwarding selection:
    //
    // 00 = Use value from ID/EX register
    // 01 = Forward from MEM/WB
    // 10 = Forward from EX/MEM
    //
    // EX/MEM has priority because it contains
    // the most recent result.

    always_comb begin

        // Default: no forwarding
        ForwardA = 2'b00;
        ForwardB = 2'b00;

        // ----------------------------------------
        // Forward operand A
        // ----------------------------------------

        if (EX_MEM_RegWrite &&
            (EX_MEM_rd != 5'd0) &&
            (EX_MEM_rd == ID_EX_rs1)) begin

            ForwardA = 2'b10;

        end
        else if (MEM_WB_RegWrite &&
                 (MEM_WB_rd != 5'd0) &&
                 (MEM_WB_rd == ID_EX_rs1)) begin

            ForwardA = 2'b01;

        end

        // ----------------------------------------
        // Forward operand B
        // ----------------------------------------

        if (EX_MEM_RegWrite &&
            (EX_MEM_rd != 5'd0) &&
            (EX_MEM_rd == ID_EX_rs2)) begin

            ForwardB = 2'b10;

        end
        else if (MEM_WB_RegWrite &&
                 (MEM_WB_rd != 5'd0) &&
                 (MEM_WB_rd == ID_EX_rs2)) begin

            ForwardB = 2'b01;

        end

    end

endmodule