module register_file_tb;

    logic        clk;
    logic        reset;

    logic [4:0]  rs1;
    logic [4:0]  rs2;

    logic [4:0]  rd;
    logic [31:0] writeData;
    logic        RegWrite;

    logic [31:0] readData1;
    logic [31:0] readData2;

    integer passed;
    integer total;

    register_file dut (
        .clk(clk),
        .reset(reset),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .writeData(writeData),
        .RegWrite(RegWrite),
        .readData1(readData1),
        .readData2(readData2)
    );

    // ------------------------------------------------
    // Clock
    // ------------------------------------------------

    always #5 clk = ~clk;

    // ------------------------------------------------
    // Test task
    // ------------------------------------------------

    task check;

        input [31:0] expected1;
        input [31:0] expected2;
        input [255:0] testName;

        begin

            #1;

            total = total + 1;

            if ((readData1 === expected1) &&
                (readData2 === expected2)) begin

                $display(
                    "PASS: %0s | Read1=%h Read2=%h",
                    testName,
                    readData1,
                    readData2
                );

                passed = passed + 1;

            end
            else begin

                $display(
                    "FAIL: %0s | Read1=%h Expected1=%h | Read2=%h Expected2=%h",
                    testName,
                    readData1,
                    expected1,
                    readData2,
                    expected2
                );

            end

        end

    endtask

    // ------------------------------------------------
    // Main test
    // ------------------------------------------------

    initial begin

        clk = 1'b0;
        reset = 1'b1;

        rs1 = 5'd0;
        rs2 = 5'd0;

        rd = 5'd0;
        writeData = 32'd0;
        RegWrite = 1'b0;

        passed = 0;
        total = 0;

        $display("==============================================");
        $display("STAGE 23.2 - VERILOG REGISTER FILE");
        $display("==============================================");
        $display("");

        // ------------------------------------------------
        // TEST 1 - Reset
        // ------------------------------------------------

        #10;

        reset = 1'b0;

        rs1 = 5'd0;
        rs2 = 5'd1;

        check(
            32'd0,
            32'd0,
            "Reset"
        );

        // ------------------------------------------------
        // TEST 2 - Write x1 = 10
        // ------------------------------------------------

        rd = 5'd1;
        writeData = 32'd10;
        RegWrite = 1'b1;

        #10;

        RegWrite = 1'b0;

        rs1 = 5'd1;
        rs2 = 5'd0;

        check(
            32'd10,
            32'd0,
            "Write x1 = 10"
        );

        // ------------------------------------------------
        // TEST 3 - Write x2 = 20
        // ------------------------------------------------

        rd = 5'd2;
        writeData = 32'd20;
        RegWrite = 1'b1;

        #10;

        RegWrite = 1'b0;

        rs1 = 5'd1;
        rs2 = 5'd2;

        check(
            32'd10,
            32'd20,
            "Write x2 = 20"
        );

        // ------------------------------------------------
        // TEST 4 - Two read ports
        // ------------------------------------------------

        rs1 = 5'd1;
        rs2 = 5'd2;

        check(
            32'd10,
            32'd20,
            "Dual read ports"
        );

        // ------------------------------------------------
        // TEST 5 - Write x3 = 30
        // ------------------------------------------------

        rd = 5'd3;
        writeData = 32'd30;
        RegWrite = 1'b1;

        #10;

        RegWrite = 1'b0;

        rs1 = 5'd3;
        rs2 = 5'd1;

        check(
            32'd30,
            32'd10,
            "Write x3 = 30"
        );

        // ------------------------------------------------
        // TEST 6 - Maximum 32-bit value
        // ------------------------------------------------

        rd = 5'd4;
        writeData = 32'hFFFFFFFF;
        RegWrite = 1'b1;

        #10;

        RegWrite = 1'b0;

        rs1 = 5'd4;
        rs2 = 5'd0;

        check(
            32'hFFFFFFFF,
            32'd0,
            "Maximum 32-bit value"
        );

        // ------------------------------------------------
        // TEST 7 - x0 protection
        // ------------------------------------------------

        rd = 5'd0;
        writeData = 32'hDEADBEEF;
        RegWrite = 1'b1;

        #10;

        RegWrite = 1'b0;

        rs1 = 5'd0;
        rs2 = 5'd0;

        check(
            32'd0,
            32'd0,
            "x0 write protection"
        );

        // ------------------------------------------------
        // TEST 8 - Existing registers preserved
        // ------------------------------------------------

        rs1 = 5'd1;
        rs2 = 5'd4;

        check(
            32'd10,
            32'hFFFFFFFF,
            "Register preservation"
        );

        // ------------------------------------------------
        // Final summary
        // ------------------------------------------------

        $display("");
        $display("==============================================");
        $display("REGISTER FILE VERIFICATION SUMMARY");
        $display("==============================================");
        $display("");

        $display(
            "Tests passed : %0d / %0d",
            passed,
            total
        );

        if (passed == total) begin

            $display("");
            $display("STAGE 23.2 PASSED!");

        end
        else begin

            $display("");
            $display("STAGE 23.2 FAILED");

        end

        $display("==============================================");

        $finish;

    end

endmodule