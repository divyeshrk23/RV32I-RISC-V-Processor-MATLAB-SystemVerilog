module register_file (
    input  logic        clk,
    input  logic        reset,

    input  logic [4:0]  rs1,
    input  logic [4:0]  rs2,

    input  logic [4:0]  rd,
    input  logic [31:0] writeData,
    input  logic        RegWrite,

    output logic [31:0] readData1,
    output logic [31:0] readData2
);

    logic [31:0] registers [0:31];

    integer i;

    // ============================================================
    // Register write
    // ============================================================

    always_ff @(posedge clk) begin

        if (reset) begin

            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'd0;

        end
        else begin

            // x0 is always zero
            if (RegWrite && (rd != 5'd0))
                registers[rd] <= writeData;

            registers[0] <= 32'd0;

        end

    end

    // ============================================================
    // Register reads
    //
    // Write-through bypass:
    //
    // If the register being read is simultaneously being written,
    // return the new writeData instead of the old stored value.
    // ============================================================

    always_comb begin

        // -----------------------------
        // Read port 1
        // -----------------------------

        if (rs1 == 5'd0) begin

            readData1 = 32'd0;

        end

        else if (RegWrite &&
                 (rd != 5'd0) &&
                 (rd == rs1)) begin

            readData1 = writeData;

        end

        else begin

            readData1 = registers[rs1];

        end


        // -----------------------------
        // Read port 2
        // -----------------------------

        if (rs2 == 5'd0) begin

            readData2 = 32'd0;

        end

        else if (RegWrite &&
                 (rd != 5'd0) &&
                 (rd == rs2)) begin

            readData2 = writeData;

        end

        else begin

            readData2 = registers[rs2];

        end

    end

endmodule