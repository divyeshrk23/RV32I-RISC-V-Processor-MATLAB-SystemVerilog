function decoded = decoder(instruction)

instruction = uint32(instruction);

decoded.opcode = "END";
decoded.rd = 0;
decoded.rs1 = 0;
decoded.rs2 = 0;
decoded.immediate = 0;

if instruction == 0
    return;
end

% =============================================================
% EXTRACT COMMON FIELDS
% =============================================================

opcode = double(bitand(instruction,uint32(127)));

rd = double(bitand( ...
    bitshift(instruction,-7),uint32(31)));

funct3 = double(bitand( ...
    bitshift(instruction,-12),uint32(7)));

rs1 = double(bitand( ...
    bitshift(instruction,-15),uint32(31)));

rs2 = double(bitand( ...
    bitshift(instruction,-20),uint32(31)));

funct7 = double(bitand( ...
    bitshift(instruction,-25),uint32(127)));

decoded.rd = rd;
decoded.rs1 = rs1;
decoded.rs2 = rs2;


% =============================================================
% INSTRUCTION DECODER
% =============================================================

switch opcode

    % =========================================================
    % R-TYPE
    % ADD
    % SUB
    % SLT
    % SLTU
    % XOR
    % OR
    % AND
    % =========================================================

    case 51

        switch funct3

            % -------------------------------------------------
            % ADD / SUB
            % -------------------------------------------------

            case 0

                if funct7 == 0

                    decoded.opcode = "ADD";

                elseif funct7 == 32

                    decoded.opcode = "SUB";

                end


            % -------------------------------------------------
            % SLT
            % -------------------------------------------------

            case 2

                decoded.opcode = "SLT";


            % -------------------------------------------------
            % SLTU
            % -------------------------------------------------

            case 3

                decoded.opcode = "SLTU";


            % -------------------------------------------------
            % XOR
            % -------------------------------------------------

            case 4

                decoded.opcode = "XOR";


            % -------------------------------------------------
            % OR
            % -------------------------------------------------

            case 6

                decoded.opcode = "OR";


            % -------------------------------------------------
            % AND
            % -------------------------------------------------

            case 7

                decoded.opcode = "AND";

        end


    % =========================================================
    % I-TYPE ALU
    % ADDI
    % SLTI
    % SLTIU
    % SLLI
    % SRLI
    % SRAI
    % =========================================================

    case 19

        immediate = double( ...
            bitand( ...
            bitshift(instruction,-20), ...
            uint32(4095)));

        % Sign extend 12-bit immediate

        if immediate >= 2048

            immediate = immediate - 4096;

        end

        decoded.immediate = immediate;

        switch funct3

            % -------------------------------------------------
            % ADDI
            % -------------------------------------------------

            case 0

                decoded.opcode = "ADDI";


            % -------------------------------------------------
            % SLLI
            % -------------------------------------------------

            case 1

                decoded.opcode = "SLLI";

                decoded.immediate = double( ...
                    bitand( ...
                    bitshift(instruction,-20), ...
                    uint32(31)));


            % -------------------------------------------------
            % SLTI
            % -------------------------------------------------

            case 2

                decoded.opcode = "SLTI";


            % -------------------------------------------------
            % SLTIU
            % -------------------------------------------------

            case 3

                decoded.opcode = "SLTIU";


            % -------------------------------------------------
            % SRLI / SRAI
            % -------------------------------------------------

            case 5

                if funct7 == 0

                    decoded.opcode = "SRLI";

                elseif funct7 == 32

                    decoded.opcode = "SRAI";

                end

                decoded.immediate = double( ...
                    bitand( ...
                    bitshift(instruction,-20), ...
                    uint32(31)));

        end


    % =========================================================
    % LOAD
    % LB
    % LH
    % LW
    % LBU
    % LHU
    % =========================================================

    case 3

        immediate = double( ...
            bitand( ...
            bitshift(instruction,-20), ...
            uint32(4095)));

        % Sign extend 12-bit immediate

        if immediate >= 2048

            immediate = immediate - 4096;

        end

        decoded.immediate = immediate;

        switch funct3

            case 0

                decoded.opcode = "LB";

            case 1

                decoded.opcode = "LH";

            case 2

                decoded.opcode = "LW";

            case 4

                decoded.opcode = "LBU";

            case 5

                decoded.opcode = "LHU";

        end


    % =========================================================
    % STORE
    % SB
    % SH
    % SW
    % =========================================================

    case 35

        immLow = double( ...
            bitand( ...
            bitshift(instruction,-7), ...
            uint32(31)));

        immHigh = double( ...
            bitand( ...
            bitshift(instruction,-25), ...
            uint32(127)));

        immediate = immLow + 32 * immHigh;

        % Sign extend 12-bit immediate

        if immediate >= 2048

            immediate = immediate - 4096;

        end

        decoded.immediate = immediate;

        switch funct3

            case 0

                decoded.opcode = "SB";

            case 1

                decoded.opcode = "SH";

            case 2

                decoded.opcode = "SW";

        end


    % =========================================================
    % BRANCH
    % BEQ
    % BNE
    % BLT
    % BGE
    % BLTU
    % BGEU
    % =========================================================

    case 99

        bit12 = double( ...
            bitand( ...
            bitshift(instruction,-31), ...
            uint32(1)));

        bit11 = double( ...
            bitand( ...
            bitshift(instruction,-7), ...
            uint32(1)));

        bits10_5 = double( ...
            bitand( ...
            bitshift(instruction,-25), ...
            uint32(63)));

        bits4_1 = double( ...
            bitand( ...
            bitshift(instruction,-8), ...
            uint32(15)));

        immediate = ...
            bit12 * 4096 + ...
            bit11 * 2048 + ...
            bits10_5 * 32 + ...
            bits4_1 * 2;

        % Sign extend 13-bit branch immediate

        if immediate >= 4096

            immediate = immediate - 8192;

        end

        decoded.immediate = immediate;

        switch funct3

            case 0

                decoded.opcode = "BEQ";

            case 1

                decoded.opcode = "BNE";

            case 4

                decoded.opcode = "BLT";

            case 5

                decoded.opcode = "BGE";

            case 6

                decoded.opcode = "BLTU";

            case 7

                decoded.opcode = "BGEU";

        end


    % =========================================================
    % JAL
    % =========================================================

    case 111

        bit20 = double( ...
            bitand( ...
            bitshift(instruction,-31), ...
            uint32(1)));

        bits10_1 = double( ...
            bitand( ...
            bitshift(instruction,-21), ...
            uint32(1023)));

        bit11 = double( ...
            bitand( ...
            bitshift(instruction,-20), ...
            uint32(1)));

        bits19_12 = double( ...
            bitand( ...
            bitshift(instruction,-12), ...
            uint32(255)));

        immediate = ...
            bit20 * 1048576 + ...
            bits19_12 * 4096 + ...
            bit11 * 2048 + ...
            bits10_1 * 2;

        % Sign extend 21-bit JAL immediate

        if immediate >= 1048576

            immediate = immediate - 2097152;

        end

        decoded.opcode = "JAL";

        decoded.immediate = immediate;


    % =========================================================
    % JALR
    % =========================================================

    case 103

        immediate = double( ...
            bitand( ...
            bitshift(instruction,-20), ...
            uint32(4095)));

        % Sign extend 12-bit immediate

        if immediate >= 2048

            immediate = immediate - 4096;

        end

        decoded.opcode = "JALR";

        decoded.immediate = immediate;

end

end