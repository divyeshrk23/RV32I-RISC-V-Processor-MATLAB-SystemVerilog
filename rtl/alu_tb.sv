module alu_tb;

    logic [31:0] A;
    logic [31:0] B;
    logic [3:0]  ALUControl;

    logic [31:0] Result;
    logic Zero;
    logic LessThanSigned;
    logic LessThanUnsigned;

    integer passed;
    integer total;

    alu dut (
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .Result(Result),
        .Zero(Zero),
        .LessThanSigned(LessThanSigned),
        .LessThanUnsigned(LessThanUnsigned)
    );

    task test;
        input [3:0] control;
        input [31:0] a;
        input [31:0] b;
        input [31:0] expected;
        input [31:0] test_number;

        begin
            A = a;
            B = b;
            ALUControl = control;

            #1;

            total = total + 1;

            if (Result == expected) begin
                $display("PASS: Test %0d  Result = 0x%08h",
                         test_number, Result);
                passed = passed + 1;
            end
            else begin
                $display("FAIL: Test %0d  Expected = 0x%08h  Got = 0x%08h",
                         test_number, expected, Result);
            end
        end
    endtask


    initial begin

        passed = 0;
        total  = 0;

        $display("==============================================");
        $display("STAGE 24.2 - ALU VERIFICATION");
        $display("==============================================");
        $display("");


        // ============================================================
        // ADD
        // ============================================================

        test(4'b0000, 32'd10, 32'd20, 32'd30, 1);
        test(4'b0000, 32'd0, 32'd0, 32'd0, 2);
        test(4'b0000, 32'hFFFFFFFF, 32'd1, 32'h00000000, 3);


        // ============================================================
        // SUB
        // ============================================================

        test(4'b0001, 32'd20, 32'd5, 32'd15, 4);
        test(4'b0001, 32'd5, 32'd20, 32'hFFFFFFF1, 5);


        // ============================================================
        // AND
        // ============================================================

        test(4'b0010,
             32'hFFFF0000,
             32'h00FF00FF,
             32'h00FF0000,
             6);


        // ============================================================
        // OR
        // ============================================================

        test(4'b0011,
             32'hF0000000,
             32'h0000000F,
             32'hF000000F,
             7);


        // ============================================================
        // XOR
        // ============================================================

        test(4'b0100,
             32'hAAAAAAAA,
             32'h55555555,
             32'hFFFFFFFF,
             8);


        // ============================================================
        // SLL
        // ============================================================

        test(4'b0101,
             32'h00000001,
             32'd4,
             32'h00000010,
             9);

        test(4'b0101,
             32'h00000001,
             32'd31,
             32'h80000000,
             10);


        // ============================================================
        // SRL
        // ============================================================

        test(4'b0110,
             32'h80000000,
             32'd4,
             32'h08000000,
             11);

        test(4'b0110,
             32'hFFFFFFFF,
             32'd4,
             32'h0FFFFFFF,
             12);


        // ============================================================
        // SRA
        // ============================================================

        test(4'b0111,
             32'h80000000,
             32'd4,
             32'hF8000000,
             13);

        test(4'b0111,
             32'hFFFFFFFF,
             32'd4,
             32'hFFFFFFFF,
             14);


        // ============================================================
        // SLT SIGNED
        // ============================================================

        test(4'b1000,
             32'hFFFFFFFF,
             32'd1,
             32'd1,
             15);

        test(4'b1000,
             32'd10,
             32'd5,
             32'd0,
             16);


        // ============================================================
        // SLTU UNSIGNED
        // ============================================================

        test(4'b1001,
             32'd5,
             32'd10,
             32'd1,
             17);

        test(4'b1001,
             32'hFFFFFFFF,
             32'd1,
             32'd0,
             18);


        // ============================================================
        // ZERO FLAG
        // ============================================================

        A = 32'd10;
        B = 32'd10;
        ALUControl = 4'b0001;

        #1;

        total = total + 1;

        if (Zero == 1'b1) begin
            $display("PASS: Test 19  Zero flag");
            passed = passed + 1;
        end
        else begin
            $display("FAIL: Test 19  Zero flag");
        end


        // ============================================================
        // NON-ZERO FLAG
        // ============================================================

        A = 32'd10;
        B = 32'd5;
        ALUControl = 4'b0001;

        #1;

        total = total + 1;

        if (Zero == 1'b0) begin
            $display("PASS: Test 20  Non-zero flag");
            passed = passed + 1;
        end
        else begin
            $display("FAIL: Test 20  Non-zero flag");
        end


        // ============================================================
        // SIGNED LESS-THAN FLAG
        // ============================================================

        A = 32'hFFFFFFFF;
        B = 32'd1;
        ALUControl = 4'b0000;

        #1;

        total = total + 1;

        if (LessThanSigned == 1'b1) begin
            $display("PASS: Test 21  Signed comparison flag");
            passed = passed + 1;
        end
        else begin
            $display("FAIL: Test 21  Signed comparison flag");
        end


        // ============================================================
        // UNSIGNED LESS-THAN FLAG
        // ============================================================

        A = 32'h00000001;
        B = 32'hFFFFFFFF;
        ALUControl = 4'b0000;

        #1;

        total = total + 1;

        if (LessThanUnsigned == 1'b1) begin
            $display("PASS: Test 22  Unsigned comparison flag");
            passed = passed + 1;
        end
        else begin
            $display("FAIL: Test 22  Unsigned comparison flag");
        end


        // ============================================================
        // SUMMARY
        // ============================================================

        $display("");
        $display("==============================================");
        $display("STAGE 24.2 SUMMARY");
        $display("==============================================");
        $display("");

        $display("Tests passed : %0d / %0d", passed, total);

        if (passed == total) begin
            $display("");
            $display("STAGE 24.2 PASSED!");
        end
        else begin
            $display("");
            $display("STAGE 24.2 FAILED");
        end

        $display("==============================================");

        $finish;

    end

endmodule