module control_unit_tb;

    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;

    logic RegWrite;
    logic MemRead;
    logic MemWrite;
    logic MemToReg;
    logic ALUSrc;
    logic Branch;
    logic Jump;
    logic Jalr;

    logic [3:0] ALUControl;
    logic [2:0] BranchType;
    logic [1:0] PCSrc;

    integer passed;
    integer total;

    control_unit dut (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),

        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemToReg(MemToReg),
        .ALUSrc(ALUSrc),
        .Branch(Branch),
        .Jump(Jump),
        .Jalr(Jalr),

        .ALUControl(ALUControl),
        .BranchType(BranchType),
        .PCSrc(PCSrc)
    );

    task test;

        input [6:0] testOpcode;
        input [2:0] testFunct3;
        input [6:0] testFunct7;

        input expectedRegWrite;
        input expectedMemRead;
        input expectedMemWrite;
        input expectedMemToReg;
        input expectedALUSrc;
        input expectedBranch;
        input expectedJump;
        input expectedJalr;

        input [3:0] expectedALUControl;
        input [2:0] expectedBranchType;
        input [1:0] expectedPCSrc;

        input [255:0] testName;

        begin

            opcode = testOpcode;
            funct3 = testFunct3;
            funct7 = testFunct7;

            #1;

            total = total + 1;

            if (
                RegWrite === expectedRegWrite &&
                MemRead === expectedMemRead &&
                MemWrite === expectedMemWrite &&
                MemToReg === expectedMemToReg &&
                ALUSrc === expectedALUSrc &&
                Branch === expectedBranch &&
                Jump === expectedJump &&
                Jalr === expectedJalr &&
                ALUControl === expectedALUControl &&
                BranchType === expectedBranchType &&
                PCSrc === expectedPCSrc
            ) begin

                $display(
                    "PASS: %0s",
                    testName
                );

                passed = passed + 1;

            end
            else begin

                $display(
                    "FAIL: %0s",
                    testName
                );

                $display(
                    "     RegWrite=%b Expected=%b",
                    RegWrite,
                    expectedRegWrite
                );

                $display(
                    "     MemRead=%b Expected=%b",
                    MemRead,
                    expectedMemRead
                );

                $display(
                    "     MemWrite=%b Expected=%b",
                    MemWrite,
                    expectedMemWrite
                );

                $display(
                    "     ALUSrc=%b Expected=%b",
                    ALUSrc,
                    expectedALUSrc
                );

                $display(
                    "     Branch=%b Expected=%b",
                    Branch,
                    expectedBranch
                );

                $display(
                    "     Jump=%b Expected=%b",
                    Jump,
                    expectedJump
                );

                $display(
                    "     Jalr=%b Expected=%b",
                    Jalr,
                    expectedJalr
                );

                $display(
                    "     ALUControl=%b Expected=%b",
                    ALUControl,
                    expectedALUControl
                );

                $display(
                    "     PCSrc=%b Expected=%b",
                    PCSrc,
                    expectedPCSrc
                );

            end

        end

    endtask

    initial begin

        passed = 0;
        total = 0;

        $display("==============================================");
        $display("STAGE 23.5 - VERILOG CONTROL UNIT");
        $display("==============================================");
        $display("");

        // ----------------------------------------
        // 1. ADD
        // ----------------------------------------

        test(
            7'b0110011,
            3'b000,
            7'b0000000,

            1'b1,
            1'b0,
            1'b0,
            1'b0,
            1'b0,
            1'b0,
            1'b0,
            1'b0,

            4'b0000,
            3'b000,
            2'b00,

            "R-Type ADD"
        );

        // ----------------------------------------
        // 2. SUB
        // ----------------------------------------

        test(
            7'b0110011,
            3'b000,
            7'b0100000,

            1'b1,
            1'b0,
            1'b0,
            1'b0,
            1'b0,
            1'b0,
            1'b0,
            1'b0,

            4'b0001,
            3'b000,
            2'b00,

            "R-Type SUB"
        );

        // ----------------------------------------
        // 3. AND
        // ----------------------------------------

        test(
            7'b0110011,
            3'b111,
            7'b0000000,

            1'b1,
            1'b0,
            1'b0,
            1'b0,
            1'b0,
            1'b0,
            1'b0,
            1'b0,

            4'b0010,
            3'b000,
            2'b00,

            "R-Type AND"
        );

        // ----------------------------------------
        // 4. ADDI
        // ----------------------------------------

        test(
            7'b0010011,
            3'b000,
            7'b0000000,

            1'b1,
            1'b0,
            1'b0,
            1'b0,
            1'b1,
            1'b0,
            1'b0,
            1'b0,

            4'b0000,
            3'b000,
            2'b00,

            "I-Type ADDI"
        );

        // ----------------------------------------
        // 5. LW
        // ----------------------------------------

        test(
            7'b0000011,
            3'b010,
            7'b0000000,

            1'b1,
            1'b1,
            1'b0,
            1'b1,
            1'b1,
            1'b0,
            1'b0,
            1'b0,

            4'b0000,
            3'b000,
            2'b00,

            "LOAD"
        );

        // ----------------------------------------
        // 6. SW
        // ----------------------------------------

        test(
            7'b0100011,
            3'b010,
            7'b0000000,

            1'b0,
            1'b0,
            1'b1,
            1'b0,
            1'b1,
            1'b0,
            1'b0,
            1'b0,

            4'b0000,
            3'b000,
            2'b00,

            "STORE"
        );

        // ----------------------------------------
        // 7. BEQ
        // ----------------------------------------

        test(
            7'b1100011,
            3'b000,
            7'b0000000,

            1'b0,
            1'b0,
            1'b0,
            1'b0,
            1'b0,
            1'b1,
            1'b0,
            1'b0,

            4'b0001,
            3'b000,
            2'b01,

            "BEQ"
        );

        // ----------------------------------------
        // 8. BLT
        // ----------------------------------------

        test(
            7'b1100011,
            3'b100,
            7'b0000000,

            1'b0,
            1'b0,
            1'b0,
            1'b0,
            1'b0,
            1'b1,
            1'b0,
            1'b0,

            4'b0001,
            3'b100,
            2'b01,

            "BLT"
        );

        // ----------------------------------------
        // 9. JAL
        // ----------------------------------------

        test(
            7'b1101111,
            3'b000,
            7'b0000000,

            1'b1,
            1'b0,
            1'b0,
            1'b0,
            1'b0,
            1'b0,
            1'b1,
            1'b0,

            4'b0000,
            3'b000,
            2'b10,

            "JAL"
        );

        // ----------------------------------------
        // 10. JALR
        // ----------------------------------------

        test(
            7'b1100111,
            3'b000,
            7'b0000000,

            1'b1,
            1'b0,
            1'b0,
            1'b0,
            1'b1,
            1'b0,
            1'b1,
            1'b1,

            4'b0000,
            3'b000,
            2'b11,

            "JALR"
        );

        // ----------------------------------------
        // Summary
        // ----------------------------------------

        $display("");
        $display("==============================================");
        $display("CONTROL UNIT VERIFICATION SUMMARY");
        $display("==============================================");
        $display("");

        $display(
            "Tests passed : %0d / %0d",
            passed,
            total
        );

        if (passed == total) begin

            $display("");
            $display("STAGE 23.5 PASSED!");

        end
        else begin

            $display("");
            $display("STAGE 23.5 FAILED");

        end

        $display("==============================================");

        $finish;

    end

endmodule