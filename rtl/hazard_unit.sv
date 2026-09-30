module hazard_unit (
    input  logic [4:0] ID_rs1,
    input  logic [4:0] ID_rs2,

    input  logic [4:0] EX_rd,
    input  logic       EX_MemRead,

    output logic       PCWrite,
    output logic       IF_ID_Write,
    output logic       ID_EX_Flush,

    output logic       HazardDetected
);

    always_comb begin

        // ----------------------------------------
        // Default: no hazard
        // ----------------------------------------

        PCWrite       = 1'b1;
        IF_ID_Write   = 1'b1;
        ID_EX_Flush   = 1'b0;
        HazardDetected = 1'b0;

        // ----------------------------------------
        // Load-use hazard detection
        //
        // EX instruction is a load:
        //       LW x5, ...
        //
        // ID instruction uses x5:
        //       ADD x6, x5, x7
        //
        // A one-cycle stall is required.
        // ----------------------------------------

        if (EX_MemRead &&
            (EX_rd != 5'd0) &&
            ((EX_rd == ID_rs1) ||
             (EX_rd == ID_rs2))) begin

            HazardDetected = 1'b1;

            // Freeze PC
            PCWrite = 1'b0;

            // Freeze IF/ID register
            IF_ID_Write = 1'b0;

            // Insert bubble into ID/EX
            ID_EX_Flush = 1'b1;

        end

    end

endmodule