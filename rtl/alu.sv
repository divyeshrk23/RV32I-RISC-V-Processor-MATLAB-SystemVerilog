module alu (
    input  logic [31:0] A,
    input  logic [31:0] B,
    input  logic [3:0]  ALUControl,

    output logic [31:0] Result,
    output logic        Zero,
    output logic        LessThanSigned,
    output logic        LessThanUnsigned
);

    always_comb begin

        case (ALUControl)

            // ADD
            4'b0000: begin
                Result = A + B;
            end

            // SUB
            4'b0001: begin
                Result = A - B;
            end

            // AND
            4'b0010: begin
                Result = A & B;
            end

            // OR
            4'b0011: begin
                Result = A | B;
            end

            // XOR
            4'b0100: begin
                Result = A ^ B;
            end

            // SLL
            4'b0101: begin
                Result = A << B[4:0];
            end

            // SRL
            4'b0110: begin
                Result = A >> B[4:0];
            end

            // SRA
            4'b0111: begin
                Result = $signed(A) >>> B[4:0];
            end

            // SLT - signed
            4'b1000: begin
                if ($signed(A) < $signed(B))
                    Result = 32'd1;
                else
                    Result = 32'd0;
            end

            // SLTU - unsigned
            4'b1001: begin
                if (A < B)
                    Result = 32'd1;
                else
                    Result = 32'd0;
            end

            // Invalid control
            default: begin
                Result = 32'd0;
            end

        endcase

    end

    // Zero flag
    assign Zero = (Result == 32'd0);

    // Signed comparison
    assign LessThanSigned =
        ($signed(A) < $signed(B));

    // Unsigned comparison
    assign LessThanUnsigned =
        (A < B);

endmodule