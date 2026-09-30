module branch_unit_tb;

    logic [31:0] rs1_data;
    logic [31:0] rs2_data;
    logic [2:0] BranchType;
    logic Branch;
    logic [31:0] PC;
    logic [31:0] immediate;

    logic BranchTaken;
    logic [31:0] BranchTarget;

    integer passed;
    integer total;

    branch_unit dut (
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .BranchType(BranchType),
        .Branch(Branch),
        .PC(PC),
        .immediate(immediate),
        .BranchTaken(BranchTaken),
        .BranchTarget(BranchTarget)
    );

    task test_branch;
        input [2:0] branch_type;
        input [31:0] a;
        input [31:0] b;
        input expected_taken;
        input [31:0] test_number;

        begin
            rs1_data = a;
            rs2_data = b;
            BranchType = branch_type;
            Branch = 1'b1;
            PC = 32'd100;
            immediate = 32'd20;

            #1;

            total = total + 1;

            if (BranchTaken == expected_taken) begin
                $display("PASS: Test %0d", test_number);
                passed = passed + 1;
            end
            else begin
                $display("FAIL: Test %0d  Expected=%0d Got=%0d",
                         test_number,
                         expected_taken,
                         BranchTaken);
            end
        end
    endtask


    initial begin

        passed = 0;
        total = 0;

        $display("==============================================");
        $display("STAGE 24.3 - BRANCH VERIFICATION");
        $display("==============================================");
        $display("");


        // ============================================================
        // BEQ
        // ============================================================

        test_branch(3'b000, 32'd10, 32'd10, 1'b1, 1);
        test_branch(3'b000, 32'd10, 32'd20, 1'b0, 2);


        // ============================================================
        // BNE
        // ============================================================

        test_branch(3'b001, 32'd10, 32'd20, 1'b1, 3);
        test_branch(3'b001, 32'd10, 32'd10, 1'b0, 4);


        // ============================================================
        // BLT SIGNED
        // ============================================================

        test_branch(
            3'b100,
            32'hFFFFFFFF,
            32'd1,
            1'b1,
            5
        );

        test_branch(
            3'b100,
            32'd10,
            32'd5,
            1'b0,
            6
        );


        // ============================================================
        // BGE SIGNED
        // ============================================================

        test_branch(
            3'b101,
            32'd10,
            32'd5,
            1'b1,
            7
        );

        test_branch(
            3'b101,
            32'hFFFFFFFF,
            32'd1,
            1'b0,
            8
        );


        // ============================================================
        // BLTU UNSIGNED
        // ============================================================

        test_branch(
            3'b110,
            32'd5,
            32'd10,
            1'b1,
            9
        );

        test_branch(
            3'b110,
            32'hFFFFFFFF,
            32'd1,
            1'b0,
            10
        );


        // ============================================================
        // BGEU UNSIGNED
        // ============================================================

        test_branch(
            3'b111,
            32'd10,
            32'd5,
            1'b1,
            11
        );

        test_branch(
            3'b111,
            32'd5,
            32'd10,
            1'b0,
            12
        );


        // ============================================================
        // BRANCH DISABLED
        // ============================================================

        rs1_data = 32'd10;
        rs2_data = 32'd10;
        BranchType = 3'b000;
        Branch = 1'b0;
        PC = 32'd100;
        immediate = 32'd20;

        #1;

        total = total + 1;

        if (BranchTaken == 1'b0) begin
            $display("PASS: Test 13 - Branch disabled");
            passed = passed + 1;
        end
        else begin
            $display("FAIL: Test 13 - Branch disabled");
        end


        // ============================================================
        // BRANCH TARGET
        // ============================================================

        rs1_data = 32'd10;
        rs2_data = 32'd10;
        BranchType = 3'b000;
        Branch = 1'b1;
        PC = 32'd1000;
        immediate = 32'd128;

        #1;

        total = total + 1;

        if (BranchTarget == 32'd1128) begin
            $display("PASS: Test 14 - Branch target");
            passed = passed + 1;
        end
        else begin
            $display("FAIL: Test 14 - Branch target");
        end


        // ============================================================
        // NEGATIVE BRANCH OFFSET
        // ============================================================

        PC = 32'd1000;
        immediate = -32'sd100;

        #1;

        total = total + 1;

        if (BranchTarget == 32'd900) begin
            $display("PASS: Test 15 - Negative branch target");
            passed = passed + 1;
        end
        else begin
            $display("FAIL: Test 15 - Negative branch target");
        end


        // ============================================================
        // SUMMARY
        // ============================================================

        $display("");
        $display("==============================================");
        $display("STAGE 24.3 SUMMARY");
        $display("==============================================");
        $display("");

        $display("Tests passed : %0d / %0d", passed, total);

        if (passed == total) begin
            $display("");
            $display("STAGE 24.3 PASSED!");
        end
        else begin
            $display("");
            $display("STAGE 24.3 FAILED");
        end

        $display("==============================================");

        $finish;

    end

endmodule