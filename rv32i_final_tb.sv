`timescale 1ns/1ps

module rv32i_final_tb;

    logic clk;
    logic reset;
    logic halted;

    integer tests_passed;
    integer tests_total;

    rv32i_cpu dut (
        .clk(clk),
        .reset(reset),
        .halted(halted)
    );

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
                    "PASS: %s Expected=%0d Got=%0d",
                    test_name,
                    expected,
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
                    "PASS: %s Expected=%0d Got=%0d",
                    test_name,
                    expected,
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
            encode_r = {
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

            encode_i = {
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

            encode_s = {
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

    function [31:0] encode_b;
        input integer imm;
        input [4:0] rs2;
        input [4:0] rs1;
        input [2:0] funct3;

        reg [12:0] imm13;

        begin
            imm13 = imm[12:0];

            encode_b = {
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

            encode_j = {
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
        // BASIC ARITHMETIC
        // ========================================================

        // x1 = 10
        dut.instruction_memory[0] =
            encode_i(
                10,
                5'd0,
                3'b000,
                5'd1,
                7'b0010011
            );

        // x2 = 20
        dut.instruction_memory[1] =
            encode_i(
                20,
                5'd0,
                3'b000,
                5'd2,
                7'b0010011
            );

        // x3 = x1 + x2
        dut.instruction_memory[2] =
            encode_r(
                7'b0000000,
                5'd2,
                5'd1,
                3'b000,
                5'd3
            );

        // x4 = x1 - x2
        dut.instruction_memory[3] =
            encode_r(
                7'b0100000,
                5'd2,
                5'd1,
                3'b000,
                5'd4
            );

        // x5 = x1 AND x2
        dut.instruction_memory[4] =
            encode_r(
                7'b0000000,
                5'd2,
                5'd1,
                3'b111,
                5'd5
            );

        // x6 = x1 OR x2
        dut.instruction_memory[5] =
            encode_r(
                7'b0000000,
                5'd2,
                5'd1,
                3'b110,
                5'd6
            );

        // x7 = x1 XOR x2
        dut.instruction_memory[6] =
            encode_r(
                7'b0000000,
                5'd2,
                5'd1,
                3'b100,
                5'd7
            );

        // ========================================================
        // MEMORY
        // ========================================================

        // x8 = 100
        dut.instruction_memory[7] =
            encode_i(
                100,
                5'd0,
                3'b000,
                5'd8,
                7'b0010011
            );

        // MEM[100] = x3
        dut.instruction_memory[8] =
            encode_s(
                0,
                5'd3,
                5'd8,
                3'b010
            );

        // x9 = MEM[100]
        dut.instruction_memory[9] =
            encode_i(
                0,
                5'd8,
                3'b010,
                5'd9,
                7'b0000011
            );

        // x10 = x9 + x1
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

        // BEQ x10,x10,+8
        dut.instruction_memory[11] =
            encode_b(
                8,
                5'd10,
                5'd10,
                3'b000
            );

        // Must be flushed
        dut.instruction_memory[12] =
            encode_i(
                99,
                5'd0,
                3'b000,
                5'd11,
                7'b0010011
            );

        // Target
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

        // BNE x1,x2,+8
        dut.instruction_memory[14] =
            encode_b(
                8,
                5'd2,
                5'd1,
                3'b001
            );

        // Must be flushed
        dut.instruction_memory[15] =
            encode_i(
                99,
                5'd0,
                3'b000,
                5'd13,
                7'b0010011
            );

        // Target
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

        // JAL x15,+8
        dut.instruction_memory[17] =
            encode_j(
                8,
                5'd15
            );

        // Must be flushed
        dut.instruction_memory[18] =
            encode_i(
                99,
                5'd0,
                3'b000,
                5'd18,
                7'b0010011
            );

        // Target
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

        // JALR x17,x16,0
        dut.instruction_memory[20] =
            encode_i(
                0,
                5'd16,
                3'b000,
                5'd17,
                7'b1100111
            );

        // Must be flushed
        dut.instruction_memory[21] =
            encode_i(
                99,
                5'd0,
                3'b000,
                5'd19,
                7'b0010011
            );

        // Must be flushed
        dut.instruction_memory[22] =
            encode_i(
                88,
                5'd0,
                3'b000,
                5'd18,
                7'b0010011
            );

        // ========================================================
        // JALR TARGET
        // ========================================================

        dut.instruction_memory[25] =
            encode_i(
                123,
                5'd0,
                3'b000,
                5'd20,
                7'b0010011
            );

        // ========================================================
        // END
        // ========================================================

        dut.instruction_memory[26] =
            32'h00000000;

        // ========================================================
        // RUN LONG ENOUGH FOR PIPELINE
        // ========================================================

        #1000;

        // ========================================================
        // FINAL RESULTS
        // ========================================================

        $display("");
        $display("==============================================");
        $display("STAGE 24.10 - FINAL RTL VERIFICATION");
        $display("==============================================");
        $display("");

        check_register(
            1,
            32'd10,
            "Arithmetic ADDI x1"
        );

        check_register(
            2,
            32'd20,
            "Arithmetic ADDI x2"
        );

        check_register(
            3,
            32'd30,
            "Arithmetic ADD x3"
        );

        check_register(
            4,
            32'hFFFFFFF6,
            "Arithmetic SUB x4"
        );

        check_register(
            5,
            32'd0,
            "Logic AND x5"
        );

        check_register(
            6,
            32'd30,
            "Logic OR x6"
        );

        check_register(
            7,
            32'd30,
            "Logic XOR x7"
        );

        check_memory(
            25,
            32'd30,
            "Store memory[100]"
        );

        check_register(
            9,
            32'd30,
            "Load x9"
        );

        check_register(
            10,
            32'd40,
            "Dependency x10"
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
            20,
            32'd123,
            "JALR target x20"
        );

        check_register(
            0,
            32'd0,
            "x0 hardwired zero"
        );

        // ========================================================
        // HALT CHECK
        // ========================================================

        tests_total = tests_total + 1;

        if (halted === 1'b1) begin
            tests_passed = tests_passed + 1;

            $display(
                "PASS: CPU HALTED"
            );
        end
        else begin
            $display(
                "FAIL: CPU HALTED Expected=1 Got=%b",
                halted
            );
        end

        // ========================================================
        // SUMMARY
        // ========================================================

        $display("");
        $display("==============================================");
        $display("FINAL RTL VERIFICATION RESULTS");
        $display("==============================================");

        $display(
            "Tests passed : %0d / %0d",
            tests_passed,
            tests_total
        );

        if (tests_passed == tests_total) begin
            $display("");
            $display("STAGE 24.10 PASSED!");
            $display("FINAL RTL VERIFICATION PASSED!");
        end
        else begin
            $display("");
            $display("STAGE 24.10 FAILED");
        end

        $display("==============================================");

        $finish;

    end

endmodule