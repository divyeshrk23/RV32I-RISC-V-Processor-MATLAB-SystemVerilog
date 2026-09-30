module alu_control_tb;

    logic [1:0] ALUOp;
    logic [2:0] funct3;
    logic [6:0] funct7;

    logic [3:0] ALUControl;

    integer passed;
    integer total;

    alu_control dut (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .ALUControl(ALUControl)
    );

    // ------------------------------------------------
    // Test task
    // ------------------------------------------------

    task test;

        input [1:0] testALUOp;
        input [2:0] testFunct3;
        input [6:0] testFunct7;
        input [3:0] expected;
        input [255:0] testName;

        begin

            ALUOp = testALUOp;
            funct3 = testFunct3;
            funct7 = testFunct7;

            #1;

            total = total + 1;

            if (ALUControl === expected) begin

                $display(
                    "PASS: %0s | ALUControl=%b",
                    testName,
                    ALUControl
                );

                passed = passed + 1;

            end
            else begin

                $display(
                    "FAIL: %0s | ALUControl=%b Expected=%b",
                    testName,
                    ALUControl,
                    expected
                );

            end

        end

    endtask

    initial begin

        passed = 0;
        total = 0;

        $display("==============================================");
        $display("STAGE 23.6 - VERILOG ALU CONTROL UNIT");
        $display("==============================================");
        $display("");

        // ----------------------------------------
        // ALUOp = 00
        // ADD
        // ----------------------------------------

        test(
            2'b00,
            3'b000,
            7'b0000000,
            4'b0000,
            "ALUOp 00 - ADD"
        );

        // ----------------------------------------
        // ALUOp = 01
        // SUB
        // ----------------------------------------

        test(
            2'b01,
            3'b000,
            7'b0000000,
            4'b0001,
            "ALUOp 01 - SUB"
        );

        // ----------------------------------------
        // R-Type ADD
        // ----------------------------------------

        test(
            2'b10,
            3'b000,
            7'b0000000,
            4'b0000,
            "R-Type ADD"
        );

        // ----------------------------------------
        // R-Type SUB
        // ----------------------------------------

        test(
            2'b10,
            3'b000,
            7'b0100000,
            4'b0001,
            "R-Type SUB"
        );

        // ----------------------------------------
        // AND
        // ----------------------------------------

        test(
            2'b10,
            3'b111,
            7'b0000000,
            4'b0010,
            "AND"
        );

        // ----------------------------------------
        // OR
        // ----------------------------------------

        test(
            2'b10,
            3'b110,
            7'b0000000,
            4'b0011,
            "OR"
        );

        // ----------------------------------------
        // XOR
        // ----------------------------------------

        test(
            2'b10,
            3'b100,
            7'b0000000,
            4'b0100,
            "XOR"
        );

        // ----------------------------------------
        // SLL
        // ----------------------------------------

        test(
            2'b10,
            3'b001,
            7'b0000000,
            4'b0101,
            "SLL"
        );

        // ----------------------------------------
        // SRL
        // ----------------------------------------

        test(
            2'b10,
            3'b101,
            7'b0000000,
            4'b0110,
            "SRL"
        );

        // ----------------------------------------
        // SRA
        // ----------------------------------------

        test(
            2'b10,
            3'b101,
            7'b0100000,
            4'b0111,
            "SRA"
        );

        // ----------------------------------------
        // SLT
        // ----------------------------------------

        test(
            2'b10,
            3'b010,
            7'b0000000,
            4'b1000,
            "SLT"
        );

        // ----------------------------------------
        // SLTU
        // ----------------------------------------

        test(
            2'b10,
            3'b011,
            7'b0000000,
            4'b1001,
            "SLTU"
        );

        // ----------------------------------------
        // Final summary
        // ----------------------------------------

        $display("");
        $display("==============================================");
        $display("ALU CONTROL VERIFICATION SUMMARY");
        $display("==============================================");
        $display("");

        $display(
            "Tests passed : %0d / %0d",
            passed,
            total
        );

        if (passed == total) begin

            $display("");
            $display("STAGE 23.6 PASSED!");

        end
        else begin

            $display("");
            $display("STAGE 23.6 FAILED");

        end

        $display("==============================================");

        $finish;

    end

endmodule