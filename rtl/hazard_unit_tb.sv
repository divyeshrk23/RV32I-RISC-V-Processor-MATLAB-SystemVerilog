module hazard_unit_tb;

    logic [4:0] ID_rs1;
    logic [4:0] ID_rs2;

    logic [4:0] EX_rd;
    logic EX_MemRead;

    logic PCWrite;
    logic IF_ID_Write;
    logic ID_EX_Flush;
    logic HazardDetected;

    integer passed;
    integer total;

    hazard_unit dut (
        .ID_rs1(ID_rs1),
        .ID_rs2(ID_rs2),
        .EX_rd(EX_rd),
        .EX_MemRead(EX_MemRead),
        .PCWrite(PCWrite),
        .IF_ID_Write(IF_ID_Write),
        .ID_EX_Flush(ID_EX_Flush),
        .HazardDetected(HazardDetected)
    );


    task test_hazard;
        input [4:0] rs1;
        input [4:0] rs2;
        input [4:0] rd;
        input memread;
        input expected_hazard;
        input [31:0] test_number;

        begin

            ID_rs1 = rs1;
            ID_rs2 = rs2;
            EX_rd = rd;
            EX_MemRead = memread;

            #1;

            total = total + 1;

            if (HazardDetected == expected_hazard) begin

                $display(
                    "PASS: Test %0d  Hazard=%0d",
                    test_number,
                    HazardDetected
                );

                passed = passed + 1;

            end
            else begin

                $display(
                    "FAIL: Test %0d  Expected=%0d Got=%0d",
                    test_number,
                    expected_hazard,
                    HazardDetected
                );

            end

        end

    endtask


    initial begin

        passed = 0;
        total = 0;

        $display("==============================================");
        $display("STAGE 24.5 - HAZARD VERIFICATION");
        $display("==============================================");
        $display("");


        // ============================================================
        // LOAD-USE HAZARDS
        // ============================================================

        // lw x5,...
        // instruction using x5 as rs1
        test_hazard(
            5'd5,
            5'd0,
            5'd5,
            1'b1,
            1'b1,
            1
        );


        // lw x6,...
        // instruction using x6 as rs2
        test_hazard(
            5'd0,
            5'd6,
            5'd6,
            1'b1,
            1'b1,
            2
        );


        // Both source registers depend on loaded register
        test_hazard(
            5'd7,
            5'd7,
            5'd7,
            1'b1,
            1'b1,
            3
        );


        // Different registers -> no hazard
        test_hazard(
            5'd1,
            5'd2,
            5'd7,
            1'b1,
            1'b0,
            4
        );


        // ============================================================
        // EX INSTRUCTION IS NOT A LOAD
        // ============================================================

        test_hazard(
            5'd5,
            5'd0,
            5'd5,
            1'b0,
            1'b0,
            5
        );


        test_hazard(
            5'd6,
            5'd7,
            5'd6,
            1'b0,
            1'b0,
            6
        );


        // ============================================================
        // x0 MUST NOT CREATE A HAZARD
        // ============================================================

        test_hazard(
            5'd0,
            5'd0,
            5'd0,
            1'b1,
            1'b0,
            7
        );


        // ============================================================
        // HAZARD ON RS1 ONLY
        // ============================================================

        test_hazard(
            5'd10,
            5'd2,
            5'd10,
            1'b1,
            1'b1,
            8
        );


        // ============================================================
        // HAZARD ON RS2 ONLY
        // ============================================================

        test_hazard(
            5'd2,
            5'd11,
            5'd11,
            1'b1,
            1'b1,
            9
        );


        // ============================================================
        // NO HAZARD
        // ============================================================

        test_hazard(
            5'd12,
            5'd13,
            5'd14,
            1'b1,
            1'b0,
            10
        );


        // ============================================================
        // VERIFY CONTROL SIGNALS WHEN HAZARD EXISTS
        // ============================================================

        ID_rs1 = 5'd15;
        ID_rs2 = 5'd2;
        EX_rd = 5'd15;
        EX_MemRead = 1'b1;

        #1;

        total = total + 1;

        if ((HazardDetected == 1'b1) &&
            (PCWrite == 1'b0) &&
            (IF_ID_Write == 1'b0) &&
            (ID_EX_Flush == 1'b1)) begin

            $display(
                "PASS: Test 11 - Hazard control signals"
            );

            passed = passed + 1;

        end
        else begin

            $display(
                "FAIL: Test 11 - Hazard control signals"
            );

        end


        // ============================================================
        // VERIFY NORMAL CONTROL SIGNALS
        // ============================================================

        ID_rs1 = 5'd1;
        ID_rs2 = 5'd2;
        EX_rd = 5'd3;
        EX_MemRead = 1'b0;

        #1;

        total = total + 1;

        if ((HazardDetected == 1'b0) &&
            (PCWrite == 1'b1) &&
            (IF_ID_Write == 1'b1) &&
            (ID_EX_Flush == 1'b0)) begin

            $display(
                "PASS: Test 12 - Normal control signals"
            );

            passed = passed + 1;

        end
        else begin

            $display(
                "FAIL: Test 12 - Normal control signals"
            );

        end


        // ============================================================
        // SUMMARY
        // ============================================================

        $display("");
        $display("==============================================");
        $display("STAGE 24.5 SUMMARY");
        $display("==============================================");
        $display("");

        $display(
            "Tests passed : %0d / %0d",
            passed,
            total
        );

        if (passed == total) begin

            $display("");
            $display("STAGE 24.5 PASSED!");

        end
        else begin

            $display("");
            $display("STAGE 24.5 FAILED");

        end

        $display("==============================================");

        $finish;

    end

