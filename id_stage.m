function decoded = id_stage(instruction)

% =============================================================
% RISC-V PIPELINE
%
% STAGE 18.4
% INSTRUCTION DECODE (ID)
%
% Input:
%   instruction - 32-bit RISC-V instruction
%
% Output:
%   decoded structure containing:
%       opcode
%       rs1
%       rs2
%       rd
%       immediate
%       funct3
%       funct7
%
% =============================================================

instruction = uint32(instruction);

decoded = struct();

% =============================================================
% EXTRACT FIELDS
% =============================================================

decoded.opcode = uint32(bitand(instruction,uint32(127)));

decoded.rd = double( ...
    bitand(bitshift(instruction,-7),uint32(31)));

decoded.funct3 = double( ...
    bitand(bitshift(instruction,-12),uint32(7)));

decoded.rs1 = double( ...
    bitand(bitshift(instruction,-15),uint32(31)));

decoded.rs2 = double( ...
    bitand(bitshift(instruction,-20),uint32(31)));

decoded.funct7 = double( ...
    bitand(bitshift(instruction,-25),uint32(127)));

decoded.immediate = 0;

% =============================================================
% IMMEDIATE DECODING
% =============================================================

switch decoded.opcode

    % ----------------------------------------------------------
    % I-TYPE
    % ADDI, SLTI, SLTIU, SLLI, SRLI, SRAI,
    % LOAD, JALR
    % ----------------------------------------------------------

    case {19,3,103}

        imm = double( ...
            bitand(bitshift(instruction,-20),uint32(4095)));

        if imm >= 2048
            imm = imm - 4096;
        end

        decoded.immediate = imm;


    % ----------------------------------------------------------
    % S-TYPE
    % SB, SH, SW
    % ----------------------------------------------------------

    case 35

        immLow = double( ...
            bitand(bitshift(instruction,-7),uint32(31)));

        immHigh = double( ...
            bitand(bitshift(instruction,-25),uint32(127)));

        imm = immLow + immHigh * 32;

        if imm >= 2048
            imm = imm - 4096;
        end

        decoded.immediate = imm;


    % ----------------------------------------------------------
    % B-TYPE
    % BEQ, BNE, BLT, BGE, BLTU, BGEU
    % ----------------------------------------------------------

    case 99

        bit12 = double( ...
            bitand(bitshift(instruction,-31),uint32(1)));

        bit11 = double( ...
            bitand(bitshift(instruction,-7),uint32(1)));

        bits10_5 = double( ...
            bitand(bitshift(instruction,-25),uint32(63)));

        bits4_1 = double( ...
            bitand(bitshift(instruction,-8),uint32(15)));

        imm = bit12 * 4096 + ...
              bit11 * 2048 + ...
              bits10_5 * 32 + ...
              bits4_1 * 2;

        if imm >= 4096
            imm = imm - 8192;
        end

        decoded.immediate = imm;


    % ----------------------------------------------------------
    % J-TYPE
    % JAL
    % ----------------------------------------------------------

    case 111

        bit20 = double( ...
            bitand(bitshift(instruction,-31),uint32(1)));

        bits10_1 = double( ...
            bitand(bitshift(instruction,-21),uint32(1023)));

        bit11 = double( ...
            bitand(bitshift(instruction,-20),uint32(1)));

        bits19_12 = double( ...
            bitand(bitshift(instruction,-12),uint32(255)));

        imm = bit20 * 1048576 + ...
              bits19_12 * 4096 + ...
              bit11 * 2048 + ...
              bits10_1 * 2;

        if imm >= 1048576
            imm = imm - 2097152;
        end

        decoded.immediate = imm;

end

% =============================================================
% DETERMINE INSTRUCTION TYPE
% =============================================================

switch decoded.opcode

    case 51
        decoded.type = "R";

    case {19,3,103}
        decoded.type = "I";

    case 35
        decoded.type = "S";

    case 99
        decoded.type = "B";

    case 111
        decoded.type = "J";

    otherwise
        decoded.type = "UNKNOWN";

end

end