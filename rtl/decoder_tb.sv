module decoder_tb;

    logic [31:0] instruction;

    logic [6:0] opcode;
    logic [4:0] rd;
    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [2:0] funct3;
    logic [6:0] funct7;

    logic [31:0] immediate;

    logic isRType;
    logic isIType;
    logic isSType;
    logic isBType;
    logic isJType;

    logic isALU;
    logic isLoad;
    logic isStore;
    logic isBranch;
    logic isJAL;
    logic isJALR;

    integer passed;
    integer total;

    decoder dut (
        .instruction(instruction),

        .opcode(opcode),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),
        .funct3(funct3),
        .funct7(funct7),

        .immediate(immediate),

        .isRType(isRType),
        .isIType(isIType),
        .isSType(isSType),
        .isBType(isBType),
        .isJType(isJType),

        .isALU(isALU),
        .isLoad(isLoad),
        .isStore(isStore),
        .isBranch(isBranch),
        .isJAL(isJAL),
        .isJALR(isJALR)
    );

    // ------------------------------------------------
    // Test task
    // ------------------------------------------------

    task test;

        input [31:0] testInstruction;

        input [6:0] expectedOpcode;
        input [4:0] expectedRd;
        input [4:0] expectedRs1;
        input [4:0] expectedRs2;

        input [31:0] expectedImmediate;

        input expectedRType;
        input expectedIType;
        input expectedSType;
        input expectedBType;
        input expectedJType;

        input expectedALU;
        input expectedLoad;
        input expectedStore;
        input expectedBranch;
        input expectedJAL;
        input expectedJALR;

        input [255:0] testName;

        begin

            instruction = testInstruction;

            #1;

            total = total + 1;

            if (
                opcode    === expectedOpcode &&
                rd        === expectedRd &&
                rs1       === expectedRs1 &&
                rs2       === expectedRs2 &&
                immediate === expectedImmediate &&

                isRType  === expectedRType &&
                isIType  === expectedIType &&
                isSType  === expectedSType &&
                isBType  === expectedBType &&
                isJType  === expectedJType &&

                isALU    === expectedALU &&
                isLoad   === expectedLoad &&
                isStore  === expectedStore &&
                isBranch === expectedBranch &&
                isJAL    === expectedJAL &&
                isJALR   === expectedJALR
            ) begin

                $display(
                    "PASS: %0s | Instruction=%h",
                    testName,
                    instruction
                );

                passed = passed + 1;

            end
            else begin

                $display(
                    "FAIL: %0s | Instruction=%h",
                    testName,
                    instruction
                );

                $display(
                    "     Opcode=%b Expected=%b",
                    opcode,
                    expectedOpcode
                );

                $display(
                    "     rd=%0d Expected=%0d",
                    rd,
                    expectedRd
                );

                $display(
                    "     rs1=%0d Expected=%0d",
                    rs1,
                    expectedRs1
                );

                $display(
                    "     rs2=%0d Expected=%0d",
                    rs2,
                    expectedRs2
                );

                $display(
                    "     Immediate=%h Expected=%h",
                    immediate,
                    expectedImmediate
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

        $display("==============================================");
        $display("STAGE 23.4 - VERILOG INSTRUCTION DECODER");
        $display("==============================================");
        $display("");

        // ----------------------------------------
        // TEST 1
        // ADD x3, x1, x2
        //
        // 0x002081B3
        // ----------------------------------------

        test(
            32'h002081B3,

            7'b0110011,
            5'd3,
            5'd1,
            5'd2,

            32'd0,

            1'b1,
            1'b0,
            1'b0,
            1'b0,
            1'b0,

            1'b1,
            1'b0,
            1'b0,
            1'b0,
            1'b0,
            1'b0,

            "R-Type ADD"
        );

        // ----------------------------------------
        // TEST 2
        // SUB x4, x3, x1
        //
        // 0x40118233
        // ----------------------------------------

        test(
            32'h40118233,

            7'b0110011,
            5'd4,
            5'd3,
            5'd1,

            32'd0,

            1'b1,
            1'b0,
            1'b0,
            1'b0,
            1'b0,

            1'b1,
            1'b0,
            1'b0,
            1'b0,
            1'b0,
            1'b0,

            "R-Type SUB"
        );

        // ----------------------------------------
        // TEST 3
        // ADDI x1, x0, 10
        //
        // 0x00A00093
        // ----------------------------------------

        test(
            32'h00A00093,

            7'b0010011,
            5'd1,
            5'd0,
            5'd10,

            32'd10,

            1'b0,
            1'b1,
            1'b0,
            1'b0,
            1'b0,

            1'b1,
            1'b0,
            1'b0,
            1'b0,
            1'b0,
            1'b0,

            "I-Type ADDI"
        );

        // ----------------------------------------
        // TEST 4
        // LW x7, 100(x0)
        //
        // 0x06402383
        // ----------------------------------------

        test(
            32'h06402383,

            7'b0000011,
            5'd7,
            5'd0,
            5'd4,

            32'd100,

            1'b0,
            1'b1,
            1'b0,
            1'b0,
            1'b0,

            1'b0,
            1'b1,
            1'b0,
            1'b0,
            1'b0,
            1'b0,

            "Load LW"
        );

        // ----------------------------------------
        // TEST 5
        // SW x3, 100(x0)
        //
        // 0x06302223
        // ----------------------------------------

        test(
            32'h06302223,

            7'b0100011,
            5'd4,
            5'd0,
            5'd3,

            32'd100,

            1'b0,
            1'b0,
            1'b1,
            1'b0,
            1'b0,

            1'b0,
            1'b0,
            1'b1,
            1'b0,
            1'b0,
            1'b0,

            "Store SW"
        );

        // ----------------------------------------
        // TEST 6
        // BEQ x3, x7, 8
        //
        // 0x00718463
        // ----------------------------------------

        test(
            32'h00718463,

            7'b1100011,
            5'd8,
            5'd3,
            5'd7,

            32'd8,

            1'b0,
            1'b0,
            1'b0,
            1'b1,
            1'b0,

            1'b0,
            1'b0,
            1'b0,
            1'b1,
            1'b0,
            1'b0,

            "Branch BEQ"
        );

        // ----------------------------------------
        // TEST 7
        // JAL x9, 8
        //
        // 0x008004EF
        // ----------------------------------------

        test(
            32'h008004EF,

            7'b1101111,
            5'd9,
            5'd0,
            5'd8,

            32'd8,

            1'b0,
            1'b0,
            1'b0,
            1'b0,
            1'b1,

            1'b0,
            1'b0,
            1'b0,
            1'b0,
            1'b1,
            1'b0,

            "JAL"
        );

        // ----------------------------------------
        // TEST 8
        // JALR x5, 4(x1)
        //
        // 0x004082E7
        // ----------------------------------------

        test(
            32'h004082E7,

            7'b1100111,
            5'd5,
            5'd1,
            5'd4,

            32'd4,

            1'b0,
            1'b1,
            1'b0,
            1'b0,
            1'b0,

            1'b0,
            1'b0,
            1'b0,
            1'b0,
            1'b0,
            1'b1,

            "JALR"
        );

        // ----------------------------------------
        // Final summary
        // ----------------------------------------

        $display("");
        $display("==============================================");
        $display("INSTRUCTION DECODER VERIFICATION SUMMARY");
        $display("==============================================");
        $display("");

        $display(
            "Tests passed : %0d / %0d",
            passed,
            total
        );

        if (passed == total) begin

            $display("");
            $display("STAGE 23.4 PASSED!");

        end
        else begin

            $display("");
            $display("STAGE 23.4 FAILED");

        end

        $display("==============================================");

        $finish;

    end

endmodule