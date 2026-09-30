module immediate_generator_tb;

    logic [31:0] instruction;
    logic [2:0]  ImmType;

    logic [31:0] immediate;

    integer passed;
    integer total;

    immediate_generator dut (
        .instruction(instruction),
        .ImmType(ImmType),
        .immediate(immediate)
    );

    // ------------------------------------------------
    // Test task
    // ------------------------------------------------

    task test;

        input [31:0] testInstruction;
        input [2:0]  testImmType;
        input [31:0] expected;
        input [255:0] testName;

        begin

            instruction = testInstruction;
            ImmType = testImmType;

            #1;

            total = total + 1;

            if (immediate === expected) begin

                $display(
                    "PASS: %0s | Instruction=%h Immediate=%h",
                    testName,
                    instruction,
                    immediate
                );

                passed = passed + 1;

            end
            else begin

                $display(
                    "FAIL: %0s | Instruction=%h Immediate=%h Expected=%h",
                    testName,
                    instruction,
                    immediate,
                    expected
                );

            end

        end

    endtask

    // ------------------------------------------------
    // Main test
    // ------------------------------------------------

    initial begin

        passed = 0;
        total = 0;

        instruction = 32'd0;
        ImmType = 3'b000;

        $display("==============================================");
        $display("STAGE 23.3 - VERILOG IMMEDIATE GENERATOR");
        $display("==============================================");
        $display("");

        // ----------------------------------------
        // TEST 1
        // I-Type positive
        //
        // immediate = 10
        // ----------------------------------------

        test(
            32'h00A00000,
            3'b000,
            32'd10,
            "I-Type positive"
        );

        // ----------------------------------------
        // TEST 2
        // I-Type negative
        //
        // immediate = -8
        // ----------------------------------------

        test(
            32'hFF800000,
            3'b000,
            32'hFFFFFFF8,
            "I-Type negative"
        );

        // ----------------------------------------
        // TEST 3
        // S-Type positive
        //
        // immediate = 12
        // ----------------------------------------

        test(
            32'h00000600,
            3'b001,
            32'd12,
            "S-Type positive"
        );

        // ----------------------------------------
        // TEST 4
        // S-Type negative
        //
        // immediate = -4
        // ----------------------------------------

        test(
            32'hFE000E00,
            3'b001,
            32'hFFFFFFFC,
            "S-Type negative"
        );

        // ----------------------------------------
        // TEST 5
        // B-Type positive
        //
        // immediate = 16
        // ----------------------------------------

        test(
            32'h00000800,
            3'b010,
            32'd16,
            "B-Type positive"
        );

        // ----------------------------------------
        // TEST 6
        // B-Type negative
        //
        // immediate = -4
        //
        // Correct encoded instruction:
        // 0xFE000E80
        // ----------------------------------------

        test(
            32'hFE000E80,
            3'b010,
            32'hFFFFFFFC,
            "B-Type negative"
        );

        // ----------------------------------------
        // TEST 7
        // U-Type
        //
        // upper immediate = 0x12345000
        // ----------------------------------------

        test(
            32'h12345000,
            3'b011,
            32'h12345000,
            "U-Type"
        );

        // ----------------------------------------
        // TEST 8
        // J-Type positive
        //
        // immediate = 2048
        // ----------------------------------------

        test(
            32'h00100000,
            3'b100,
            32'd2048,
            "J-Type positive"
        );

        // ----------------------------------------
        // TEST 9
        // J-Type negative
        //
        // immediate = -2048
        // ----------------------------------------

        test(
            32'h801FF000,
            3'b100,
            32'hFFFFF800,
            "J-Type negative"
        );

        // ----------------------------------------
        // TEST 10
        // Invalid immediate type
        // ----------------------------------------

        test(
            32'hFFFFFFFF,
            3'b111,
            32'd0,
            "Invalid immediate type"
        );

        // ----------------------------------------
        // Final summary
        // ----------------------------------------

        $display("");
        $display("==============================================");
        $display("IMMEDIATE GENERATOR VERIFICATION SUMMARY");
        $display("==============================================");
        $display("");

        $display(
            "Tests passed : %0d / %0d",
            passed,
            total
        );

        if (passed == total) begin

            $display("");
            $display("STAGE 23.3 PASSED!");

        end
        else begin

            $display("");
            $display("STAGE 23.3 FAILED");

        end

        $display("==============================================");

        $finish;

    end

endmodule