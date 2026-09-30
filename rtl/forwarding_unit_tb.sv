module forwarding_unit_tb;

    logic [4:0] ID_EX_rs1;
    logic [4:0] ID_EX_rs2;

    logic [4:0] EX_MEM_rd;
    logic EX_MEM_RegWrite;

    logic [4:0] MEM_WB_rd;
    logic MEM_WB_RegWrite;

    logic [1:0] ForwardA;
    logic [1:0] ForwardB;

    integer passed;
    integer total;


    forwarding_unit dut (
        .ID_EX_rs1(ID_EX_rs1),
        .ID_EX_rs2(ID_EX_rs2),
        .EX_MEM_rd(EX_MEM_rd),
        .EX_MEM_RegWrite(EX_MEM_RegWrite),
        .MEM_WB_rd(MEM_WB_rd),
        .MEM_WB_RegWrite(MEM_WB_RegWrite),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );


    task test_forward;

        input [4:0] rs1;
        input [4:0] rs2;

        input [4:0] ex_rd;
        input ex_write;

        input [4:0] wb_rd;
        input wb_write;

        input [1:0] expected_a;
        input [1:0] expected_b;

        input [31:0] test_number;

        begin

            ID_EX_rs1 = rs1;
            ID_EX_rs2 = rs2;

            EX_MEM_rd = ex_rd;
            EX_MEM_RegWrite = ex_write;

            MEM_WB_rd = wb_rd;
            MEM_WB_RegWrite = wb_write;

            #1;

            total = total + 1;

            if ((ForwardA == expected_a) &&
                (ForwardB == expected_b)) begin

                $display(
                    "PASS: Test %0d  ForwardA=%b ForwardB=%b",
                    test_number,
                    ForwardA,
                    ForwardB
                );

                passed = passed + 1;

            end
            else begin

                $display(
                    "FAIL: Test %0d  Expected A=%b B=%b  Got A=%b B=%b",
                    test_number,
                    expected_a,
                    expected_b,
                    ForwardA,
                    ForwardB
                );

            end

        end

    endtask


    initial begin

        passed = 0;
        total = 0;

        $display("==============================================");
        $display("STAGE 24.6 - FORWARDING VERIFICATION");
        $display("==============================================");
        $display("");


        // ============================================================
        // TEST 1
        // No forwarding
        // ============================================================

        test_forward(
            5'd1,
            5'd2,
            5'd3,
            1'b0,
            5'd4,
            1'b0,
            2'b00,
            2'b00,
            1
        );


        // ============================================================
        // TEST 2
        // EX/MEM -> RS1
        // ============================================================

        test_forward(
            5'd5,
            5'd2,
            5'd5,
            1'b1,
            5'd4,
            1'b0,
            2'b10,
            2'b00,
            2
        );


        // ============================================================
        // TEST 3
        // EX/MEM -> RS2
        // ============================================================

        test_forward(
            5'd1,
            5'd6,
            5'd6,
            1'b1,
            5'd4,
            1'b0,
            2'b00,
            2'b10,
            3
        );


        // ============================================================
        // TEST 4
        // MEM/WB -> RS1
        // ============================================================

        test_forward(
            5'd7,
            5'd2,
            5'd5,
            1'b0,
            5'd7,
            1'b1,
            2'b01,
            2'b00,
            4
        );


        // ============================================================
        // TEST 5
        // MEM/WB -> RS2
        // ============================================================

        test_forward(
            5'd1,
            5'd8,
            5'd5,
            1'b0,
            5'd8,
            1'b1,
            2'b00,
            2'b01,
            5
        );


        // ============================================================
        // TEST 6
        // Both sources from EX/MEM
        // ============================================================

        test_forward(
            5'd9,
            5'd9,
            5'd9,
            1'b1,
            5'd4,
            1'b0,
            2'b10,
            2'b10,
            6
        );


        // ============================================================
        // TEST 7
        // EX/MEM has priority over MEM/WB
        // ============================================================

        test_forward(
            5'd10,
            5'd2,
            5'd10,
            1'b1,
            5'd10,
            1'b1,
            2'b10,
            2'b00,
            7
        );


        // ============================================================
        // TEST 8
        // MEM/WB used when EX/MEM is different
        // ============================================================

        test_forward(
            5'd11,
            5'd2,
            5'd10,
            1'b1,
            5'd11,
            1'b1,
            2'b01,
            2'b00,
            8
        );


        // ============================================================
        // TEST 9
        // x0 must never forward
        // ============================================================

        test_forward(
            5'd0,
            5'd0,
            5'd0,
            1'b1,
            5'd0,
            1'b1,
            2'b00,
            2'b00,
            9
        );


        // ============================================================
        // TEST 10
        // RegWrite disabled
        // ============================================================

        test_forward(
            5'd12,
            5'd13,
            5'd12,
            1'b0,
            5'd13,
            1'b0,
            2'b00,
            2'b00,
            10
        );


        // ============================================================
        // TEST 11
        // Different register numbers
        // ============================================================

        test_forward(
            5'd14,
            5'd15,
            5'd13,
            1'b1,
            5'd12,
            1'b1,
            2'b00,
            2'b00,
            11
        );


        // ============================================================
        // TEST 12
        // MEM/WB -> RS1
        // ============================================================

        test_forward(
            5'd16,
            5'd17,
            5'd10,
            1'b0,
            5'd16,
            1'b1,
            2'b01,
            2'b00,
            12
        );


        // ============================================================
        // SUMMARY
        // ============================================================

        $display("");
        $display("==============================================");
        $display("STAGE 24.6 SUMMARY");
        $display("==============================================");
        $display("");

        $display(
            "Tests passed : %0d / %0d",
            passed,
            total
        );

        if (passed == total) begin

            $display("");
            $display("STAGE 24.6 PASSED!");

        end
        else begin

            $display("");
            $display("STAGE 24.6 FAILED");

        end

        $display("==============================================");

        $finish;

    end

endmodule