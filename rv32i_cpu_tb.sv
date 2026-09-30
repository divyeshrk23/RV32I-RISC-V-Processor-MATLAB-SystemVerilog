`timescale 1ns/1ps

module rv32i_cpu_tb;

    logic clk;
    logic reset;
    logic halted;

    rv32i_cpu dut (
        .clk(clk),
        .reset(reset),
        .halted(halted)
    );

    integer tests_passed;
    integer tests_total;

    // ============================================================
    // CLOCK
    // ============================================================

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // ============================================================
    // REGISTER CHECK
    // ============================================================

    task check_register;
        input integer reg_num;
        input [31:0] expected;
        input [255:0] test_name;

        reg [31:0] actual;

        begin
            actual = dut.register_file_inst.registers[reg_num];

            tests_total = tests_total + 1;

            if (actual === expected) begin
                tests_passed = tests_passed + 1;
                $display(
                    "PASS: %s = %0d",
                    test_name,
                    actual
                );
            end
            else begin
                $display(
                    "FAIL: %s Expected=%0d Got=%0d",
                    test_name,
                    expected,
                    actual
                );
            end
        end
    endtask

    // ============================================================
    // MEMORY CHECK
    // ============================================================

    task check_memory;
        input integer mem_index;
        input [31:0] expected;
        input [255:0] test_name;

        reg [31:0] actual;

        begin
            actual = dut.data_memory[mem_index];

            tests_total = tests_total + 1;

            if (actual === expected) begin
                tests_passed = tests_passed + 1;
                $display(
                    "PASS: %s = %0d",
                    test_name,
                    actual
                );
            end
            else begin
                $display(
                    "FAIL: %s Expected=%0d Got=%0d",
                    test_name,
                    expected,
                    actual
                );
            end
        end
    endtask

    // ============================================================
    // R-TYPE ENCODER
    // ============================================================

    function [31:0] encode_r;
        input [6:0] funct7;
        input [4:0] rs2;
        input [4:0] rs1;
        input [2:0] funct3;
        input [4:0] rd;

        begin
            encode_r =
                {
                    funct7,
                    rs2,
                    rs1,
                    funct3,
                    rd,
                    7'b0110011
                };
        end
    endfunction

    // ============================================================
    // I-TYPE ENCODER
    // ============================================================

    function [31:0] encode_i;
        input integer imm;
        input [4:0] rs1;
        input [2:0] funct3;
        input [4:0] rd;
        input [6:0] opcode;

        reg [11:0] imm12;

        begin
            imm12 = imm[11:0];

            encode_i =
                {
                    imm12,
                    rs1,
                    funct3,
                    rd,
                    opcode
                };
        end
    endfunction

    // ============================================================
    // S-TYPE ENCODER
    // ============================================================

    function [31:0] encode_s;
        input integer imm;
        input [4:0] rs2;
        input [4:0] rs1;
        input [2:0] funct3;

        reg [11:0] imm12;

        begin
            imm12 = imm[11:0];

            encode_s =
                {
                    imm12[11:5],
                    rs2,
                    rs1,
                    funct3,
                    imm12[4:0],
                    7'b0100011
                };
        end
    endfunction

    // ============================================================
    // B-TYPE ENCODER
    // ============================================================
    //
    // Correct RV32I B-type format:
    //
    // [31]    = imm[12]
    // [30:25] = imm[10:5]
    // [24:20] = rs2
    // [19:15] = rs1
    // [14:12] = funct3
    // [11:8]  = imm[4:1]
    // [7]     = imm[11]
    // [6:0]   = opcode
    //
    // There is NO extra 1'b0 before the opcode.
    //
    // ============================================================

    function [31:0] encode_b;
        input integer imm;
        input [4:0] rs2;
        input [4:0] rs1;
        input [2:0] funct3;

        reg [12:0] imm13;

        begin
            imm13 = imm[12:0];

            encode_b =
                {
                    imm13[12],
                    imm13[10:5],
                    rs2,
                    rs1,
                    funct3,
                    imm13[4:1],
                    imm13[11],
                    7'b1100011
                };
        end
    endfunction

    // ============================================================
    // J-TYPE ENCODER
    // ============================================================

    function [31:0] encode_j;
        input integer imm;
        input [4:0] rd;

        reg [20:0] imm21;

        begin
            imm21 = imm[20:0];

            encode_j =
                {
                    imm21[20],
                    imm21[10:1],
                    imm21[11],
                    imm21[19:12],
                    rd,
                    7'b1101111
                };
        end
    endfunction

    // ============================================================
    // MAIN TEST
    // ============================================================

    integer i;

    initial begin

        tests_passed = 0;
        tests_total  = 0;

        // ========================================================
        // RESET
        // ========================================================

        reset = 1'b1;

        #20;

        reset = 1'b0;

        // ========================================================
        // CLEAR MEMORIES
        // ========================================================

        for (i = 0; i < 256; i = i + 1) begin
            dut.instruction_memory[i] = 32'h00000000;
            dut.data_memory[i]        = 32'h00000000;
        end

        // ========================================================
        // BASIC ALU TESTS
        // ========================================================

        // 0: ADDI x1, x0, 10
        dut.instruction_memory[0] =
            encode_i(
                10,
                5'd0,
                3'b000,
                5'd1,
                7'b0010011
            );

        // 1: ADDI x2, x0, 20
        dut.instruction_memory[1] =
            encode_i(
                20,
                5'd0,
                3'b000,
                5'd2,
                7'b0010011
            );

        // 2: ADD x3, x1, x2
        dut.instruction_memory[2] =
            encode_r(
                7'b0000000,
                5'd2,
                5'd1,
                3'b000,
                5'd3
            );

        // 3: SUB x4, x1, x2
        dut.instruction_memory[3] =
            encode_r(
                7'b0100000,
                5'd2,
                5'd1,
                3'b000,
                5'd4
            );

        // 4: AND x5, x1, x2
        dut.instruction_memory[4] =
            encode_r(
                7'b0000000,
                5'd2,
                5'd1,
                3'b111,
                5'd5
            );

        // 5: OR x6, x1, x2
        dut.instruction_memory[5] =
            encode_r(
                7'b0000000,
                5'd2,
                5'd1,
                3'b110,
                5'd6
            );

        // 6: XOR x7, x1, x2
        dut.instruction_memory[6] =
            encode_r(
                7'b0000000,
                5'd2,
                5'd1,
                3'b100,
                5'd7
            );

        // 7: ADDI x8, x0, 100
        dut.instruction_memory[7] =
            encode_i(
                100,
                5'd0,
                3'b000,
                5'd8,
                7'b0010011
            );

        // ========================================================
        // LOAD / STORE
        // ========================================================

        // 8: SW x3, 0(x8)
        dut.instruction_memory[8] =
            encode_s(
                0,
                5'd3,
                5'd8,
                3'b010
            );

        // 9: LW x9, 0(x8)
        dut.instruction_memory[9] =
            encode_i(
                0,
                5'd8,
                3'b010,
                5'd9,
                7'b0000011
            );

        // 10: ADD x10, x9, x1
        dut.instruction_memory[10] =
            encode_r(
                7'b0000000,
                5'd1,
                5'd9,
                3'b000,
                5'd10
            );

        // ========================================================
        // BEQ
        // ========================================================

        // 11: BEQ x10, x10, +8
        //
        // PC = 44
        // Target = 52
        // Instruction index 13
        //
        dut.instruction_memory[11] =
            encode_b(
                8,
                5'd10,
                5'd10,
                3'b000
            );

        // 12: Must be flushed
        dut.instruction_memory[12] =
            encode_i(
                99,
                5'd0,
                3'b000,
                5'd11,
                7'b0010011
            );

        // 13: BEQ target
        dut.instruction_memory[13] =
            encode_i(
                55,
                5'd0,
                3'b000,
                5'd12,
                7'b0010011
            );

        // ========================================================
        // BNE
        // ========================================================

        // 14: BNE x1, x2, +8
        //
        // PC = 56
        // Target = 64
        // Instruction index 16
        //
        dut.instruction_memory[14] =
            encode_b(
                8,
                5'd2,
                5'd1,
                3'b001
            );

        // 15: Must be flushed
        dut.instruction_memory[15] =
            encode_i(
                99,
                5'd0,
                3'b000,
                5'd13,
                7'b0010011
            );

        // 16: BNE target
        dut.instruction_memory[16] =
            encode_i(
                66,
                5'd0,
                3'b000,
                5'd14,
                7'b0010011
            );

        // ========================================================
        // JAL
        // ========================================================

        // 17: JAL x15, +8
        //
        // PC = 68
        // Link = 72
        // Target = 76
        // Instruction index 19
        //
        dut.instruction_memory[17] =
            encode_j(
                8,
                5'd15
            );

        // 18: Must be flushed
        dut.instruction_memory[18] =
            encode_i(
                99,
                5'd0,
                3'b000,
                5'd18,
                7'b0010011
            );

        // 19: JAL target
        dut.instruction_memory[19] =
            encode_i(
                100,
                5'd0,
                3'b000,
                5'd16,
                7'b0010011
            );

        // ========================================================
        // JALR
        // ========================================================

        // 20: JALR x17, x16, 0
        //
        // x16 = 100
        // Target = 100
        // Link = 84
        //
        dut.instruction_memory[20] =
            encode_i(
                0,
                5'd16,
                3'b000,
                5'd17,
                7'b1100111
            );

        // 21: Must be flushed
        dut.instruction_memory[21] =
            encode_i(
                99,
                5'd0,
                3'b000,
                5'd19,
                7'b0010011
            );

        // 22: Must be flushed
        dut.instruction_memory[22] =
            encode_i(
                88,
                5'd0,
                3'b000,
                5'd18,
                7'b0010011
            );

        // 23: NOP / END
        dut.instruction_memory[23] =
            32'h00000000;

        // 24: NOP / END
        dut.instruction_memory[24] =
            32'h00000000;

        // ========================================================
        // JALR TARGET
        // Address 100 = instruction index 25
        // ========================================================

        // 25: ADDI x20, x0, 123
        dut.instruction_memory[25] =
            encode_i(
                123,
                5'd0,
                3'b000,
                5'd20,
                7'b0010011
            );

        // 26: NOP / END
        dut.instruction_memory[26] =
            32'h00000000;

        // ========================================================
        // RUN CPU
        // ========================================================

        #1000;

        // ========================================================
        // RESULTS
        // ========================================================

        $display("");
        $display("==============================================");
        $display("STAGE 24.9 - RV32I REGRESSION TEST");
        $display("==============================================");
        $display("");

        check_register(
            1,
            32'd10,
            "ADDI x1"
        );

        check_register(
            2,
            32'd20,
            "ADDI x2"
        );

        check_register(
            3,
            32'd30,
            "ADD x3"
        );

        check_register(
            4,
            32'hFFFFFFF6,
            "SUB x4"
        );

        check_register(
            5,
            32'd0,
            "AND x5"
        );

        check_register(
            6,
            32'd30,
            "OR x6"
        );

        check_register(
            7,
            32'd30,
            "XOR x7"
        );

        check_register(
            9,
            32'd30,
            "LW x9"
        );

        check_memory(
            25,
            32'd30,
            "SW memory[100]"
        );

        check_register(
            10,
            32'd40,
            "Dependent ADD x10"
        );

        check_register(
            11,
            32'd0,
            "BEQ flush x11"
        );

        check_register(
            12,
            32'd55,
            "BEQ target x12"
        );

        check_register(
            13,
            32'd0,
            "BNE flush x13"
        );

        check_register(
            14,
            32'd66,
            "BNE target x14"
        );

        check_register(
            15,
            32'd72,
            "JAL link x15"
        );

        check_register(
            16,
            32'd100,
            "JAL target x16"
        );

        check_register(
            17,
            32'd84,
            "JALR link x17"
        );

        check_register(
            20,
            32'd123,
            "JALR target x20"
        );

        check_register(
            18,
            32'd0,
            "JALR flush x18"
        );

        check_register(
            19,
            32'd0,
            "JALR flush x19"
        );

        check_register(
            0,
            32'd0,
            "x0"
        );

        // ========================================================
        // SUMMARY
        // ========================================================

        $display("");
        $display("==============================================");
        $display("REGRESSION RESULTS");
        $display("==============================================");

        $display(
            "Tests passed : %0d / %0d",
            tests_passed,
            tests_total
        );

        if (tests_passed == tests_total) begin
            $display("STAGE 24.9 PASSED!");
        end
        else begin
            $display("STAGE 24.9 FAILED");
        end

        $display("==============================================");

        $finish;

    end

endmodule