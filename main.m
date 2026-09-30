clc;
clear;
close all;

% =========================================================
% RISC-V RV32I PROCESSOR SIMULATOR
% STAGE 8
%
% Byte-addressable memory
%
% Supported:
% ADD
% SUB
% AND
% OR
% XOR
% ADDI
% BEQ
% BNE
% BLT
% BGE
% BLTU
% BGEU
% LB
% LBU
% LH
% LHU
% LW
% SB
% SH
% SW
% JAL
% JALR
% =========================================================

fprintf('\n');
fprintf('====================================================\n');
fprintf('             RISC-V RV32I SIMULATOR\n');
fprintf('====================================================\n');

%% ========================================================
% 1. REGISTER FILE
% =========================================================

registers = zeros(32,1,'uint32');

% x0 is permanently zero
registers(1) = uint32(0);

fprintf('\n');
fprintf('REGISTER FILE\n');
fprintf('----------------------------------------------------\n');
fprintf('32 registers\n');
fprintf('32-bit register width\n');
fprintf('x0 = 0\n');

%% ========================================================
% 2. BYTE-ADDRESSABLE DATA MEMORY
% ========================================================

memory = zeros(256,1,'uint8');

fprintf('\n');
fprintf('DATA MEMORY\n');
fprintf('----------------------------------------------------\n');
fprintf('256 bytes\n');
fprintf('8-bit byte width\n');
fprintf('Little-endian\n');

%% ========================================================
% 3. PROGRAM COUNTER
% ========================================================

PC = 0;

%% ========================================================
% 4. TEST PROGRAM
% ========================================================

program = {

    'ADDI x1, x0, 120'
    'ADDI x2, x0, 0'
    'ADDI x3, x0, 0'
    'ADDI x4, x0, 0'

    % Create 0x12345678
    'ADDI x5, x0, 120'
    'ADDI x6, x0, 86'
    'ADDI x7, x0, 52'
    'ADDI x8, x0, 18'

    % Store individual bytes
    'SB x5, 0(x0)'
    'SB x6, 1(x0)'
    'SB x7, 2(x0)'
    'SB x8, 3(x0)'

    % Load full word
    'LW x9, 0(x0)'

    % Load individual bytes
    'LB x10, 0(x0)'
    'LB x11, 1(x0)'
    'LB x12, 2(x0)'
    'LB x13, 3(x0)'

    % Unsigned byte loads
    'LBU x14, 0(x0)'
    'LBU x15, 1(x0)'
    'LBU x16, 2(x0)'
    'LBU x17, 3(x0)'

    % Halfword loads
    'LH x18, 0(x0)'
    'LHU x19, 0(x0)'

    % Store halfword
    'SH x9, 4(x0)'

    % Load halfword from new location
    'LH x20, 4(x0)'
    'LHU x21, 4(x0)'

    % Store complete word
    'SW x9, 8(x0)'

    % Load complete word
    'LW x22, 8(x0)'
};

%% ========================================================
% 5. CPU EXECUTION
% ========================================================

fprintf('\n');
fprintf('====================================================\n');
fprintf('                 CPU EXECUTION\n');
fprintf('====================================================\n');

cycle = 0;
maxCycles = 100;

while PC >= 0 && PC < length(program) * 4

    cycle = cycle + 1;

    if cycle > maxCycles
        fprintf('\nMaximum cycle count reached.\n');
        break;
    end

    instructionIndex = (PC / 4) + 1;

    instruction = program{instructionIndex};

    fprintf('\n');
    fprintf('----------------------------------------------------\n');
    fprintf('Cycle       : %d\n',cycle);
    fprintf('PC          : %d\n',PC);
    fprintf('Instruction : %s\n',instruction);

    nextPC = PC + 4;

    instruction = strrep(instruction,',','');
    instruction = strtrim(instruction);

    parts = split(instruction);

    opcode = upper(parts{1});

    fprintf('Operation   : %s\n',opcode);

    %% ====================================================
    % R-TYPE
    % ====================================================

    if strcmp(opcode,'ADD') || ...
       strcmp(opcode,'SUB') || ...
       strcmp(opcode,'AND') || ...
       strcmp(opcode,'OR')  || ...
       strcmp(opcode,'XOR')

        rd = str2double(extractAfter(parts{2},'x'));
        rs1 = str2double(extractAfter(parts{3},'x'));
        rs2 = str2double(extractAfter(parts{4},'x'));

        A = registers(rs1 + 1);
        B = registers(rs2 + 1);

        result = alu(opcode,A,B);

        fprintf('rd          : x%d\n',rd);
        fprintf('rs1         : x%d\n',rs1);
        fprintf('rs2         : x%d\n',rs2);

        fprintf('A unsigned  : %u\n',A);
        fprintf('A signed    : %d\n',typecast(A,'int32'));

        fprintf('B unsigned  : %u\n',B);
        fprintf('B signed    : %d\n',typecast(B,'int32'));

        fprintf('ALU unsigned: %u\n',result);
        fprintf('ALU signed  : %d\n',typecast(result,'int32'));

        if rd ~= 0
            registers(rd + 1) = result;
        end

    %% ====================================================
    % ADDI
    % ====================================================

    elseif strcmp(opcode,'ADDI')

        rd = str2double(extractAfter(parts{2},'x'));
        rs1 = str2double(extractAfter(parts{3},'x'));
        immediate = str2double(parts{4});

        A = registers(rs1 + 1);

        result = uint32(mod(double(A) + immediate,2^32));

        fprintf('rd          : x%d\n',rd);
        fprintf('rs1         : x%d\n',rs1);
        fprintf('Register    : %u\n',A);
        fprintf('Immediate   : %d\n',immediate);
        fprintf('Result      : %u\n',result);
        fprintf('Signed      : %d\n',typecast(result,'int32'));

        if rd ~= 0
            registers(rd + 1) = result;
        end

    %% ====================================================
    % BEQ
    % ====================================================

    elseif strcmp(opcode,'BEQ')

        rs1 = str2double(extractAfter(parts{2},'x'));
        rs2 = str2double(extractAfter(parts{3},'x'));
        offset = str2double(parts{4});

        A = registers(rs1 + 1);
        B = registers(rs2 + 1);

        if A == B
            nextPC = PC + offset;
            fprintf('Branch      : TAKEN\n');
            fprintf('New PC      : %d\n',nextPC);
        else
            fprintf('Branch      : NOT TAKEN\n');
        end

    %% ====================================================
    % BNE
    % ====================================================

    elseif strcmp(opcode,'BNE')

        rs1 = str2double(extractAfter(parts{2},'x'));
        rs2 = str2double(extractAfter(parts{3},'x'));
        offset = str2double(parts{4});

        A = registers(rs1 + 1);
        B = registers(rs2 + 1);

        if A ~= B
            nextPC = PC + offset;
            fprintf('Branch      : TAKEN\n');
            fprintf('New PC      : %d\n',nextPC);
        else
            fprintf('Branch      : NOT TAKEN\n');
        end

    %% ====================================================
    % BLT
    % ====================================================

    elseif strcmp(opcode,'BLT')

        rs1 = str2double(extractAfter(parts{2},'x'));
        rs2 = str2double(extractAfter(parts{3},'x'));
        offset = str2double(parts{4});

        A = typecast(registers(rs1 + 1),'int32');
        B = typecast(registers(rs2 + 1),'int32');

        if A < B
            nextPC = PC + offset;
            fprintf('Branch      : TAKEN\n');
            fprintf('New PC      : %d\n',nextPC);
        else
            fprintf('Branch      : NOT TAKEN\n');
        end

    %% ====================================================
    % BGE
    % ====================================================

    elseif strcmp(opcode,'BGE')

        rs1 = str2double(extractAfter(parts{2},'x'));
        rs2 = str2double(extractAfter(parts{3},'x'));
        offset = str2double(parts{4});

        A = typecast(registers(rs1 + 1),'int32');
        B = typecast(registers(rs2 + 1),'int32');

        if A >= B
            nextPC = PC + offset;
            fprintf('Branch      : TAKEN\n');
            fprintf('New PC      : %d\n',nextPC);
        else
            fprintf('Branch      : NOT TAKEN\n');
        end

    %% ====================================================
    % BLTU
    % ====================================================

    elseif strcmp(opcode,'BLTU')

        rs1 = str2double(extractAfter(parts{2},'x'));
        rs2 = str2double(extractAfter(parts{3},'x'));
        offset = str2double(parts{4});

        A = registers(rs1 + 1);
        B = registers(rs2 + 1);

        if A < B
            nextPC = PC + offset;
            fprintf('Branch      : TAKEN\n');
            fprintf('New PC      : %d\n',nextPC);
        else
            fprintf('Branch      : NOT TAKEN\n');
        end

    %% ====================================================
    % BGEU
    % ====================================================

    elseif strcmp(opcode,'BGEU')

        rs1 = str2double(extractAfter(parts{2},'x'));
        rs2 = str2double(extractAfter(parts{3},'x'));
        offset = str2double(parts{4});

        A = registers(rs1 + 1);
        B = registers(rs2 + 1);

        if A >= B
            nextPC = PC + offset;
            fprintf('Branch      : TAKEN\n');
            fprintf('New PC      : %d\n',nextPC);
        else
            fprintf('Branch      : NOT TAKEN\n');
        end

    %% ====================================================
    % JAL
    % ====================================================

    elseif strcmp(opcode,'JAL')

        rd = str2double(extractAfter(parts{2},'x'));
        offset = str2double(parts{3});

        returnAddress = PC + 4;
        jumpAddress = PC + offset;

        if rd ~= 0
            registers(rd + 1) = uint32(returnAddress);
        end

        nextPC = jumpAddress;

        fprintf('JAL target  : %d\n',jumpAddress);

    %% ====================================================
    % JALR
    % ====================================================

    elseif strcmp(opcode,'JALR')

        rd = str2double(extractAfter(parts{2},'x'));

        addressPart = parts{3};

        openBracket = strfind(addressPart,'(');
        closeBracket = strfind(addressPart,')');

        immediate = str2double( ...
            extractBefore(addressPart,openBracket(1)));

        baseRegister = extractBetween( ...
            addressPart, ...
            openBracket(1)+1, ...
            closeBracket(1)-1);

        rs1 = str2double( ...
            extractAfter(baseRegister{1},'x'));

        baseValue = registers(rs1+1);

        returnAddress = PC + 4;

        jumpAddress = double(baseValue) + immediate;

        jumpAddress = bitand( ...
            int64(jumpAddress),int64(-2));

        if rd ~= 0
            registers(rd+1) = uint32(returnAddress);
        end

        nextPC = double(jumpAddress);

        fprintf('JALR target  : %d\n',nextPC);

    %% ====================================================
    % SB - STORE BYTE
    % ====================================================

    elseif strcmp(opcode,'SB')

        rs2 = str2double(extractAfter(parts{2},'x'));

        addressPart = parts{3};

        openBracket = strfind(addressPart,'(');
        closeBracket = strfind(addressPart,')');

        immediate = str2double( ...
            extractBefore(addressPart,openBracket(1)));

        baseRegister = extractBetween( ...
            addressPart, ...
            openBracket(1)+1, ...
            closeBracket(1)-1);

        rs1 = str2double( ...
            extractAfter(baseRegister{1},'x'));

        address = double(registers(rs1+1)) + immediate;

        value = registers(rs2+1);

        if address < 0 || address >= length(memory)
            error('Memory address out of range');
        end

        memory(address+1) = uint8(bitand(value,uint32(255)));

        fprintf('Address     : %d\n',address);
        fprintf('Stored byte : 0x%02X\n',memory(address+1));

    %% ====================================================
    % SH - STORE HALFWORD
    % ====================================================

    elseif strcmp(opcode,'SH')

        rs2 = str2double(extractAfter(parts{2},'x'));

        addressPart = parts{3};

        openBracket = strfind(addressPart,'(');
        closeBracket = strfind(addressPart,')');

        immediate = str2double( ...
            extractBefore(addressPart,openBracket(1)));

        baseRegister = extractBetween( ...
            addressPart, ...
            openBracket(1)+1, ...
            closeBracket(1)-1);

        rs1 = str2double( ...
            extractAfter(baseRegister{1},'x'));

        address = double(registers(rs1+1)) + immediate;

        value = registers(rs2+1);

        if address < 0 || address+1 >= length(memory)
            error('Memory address out of range');
        end

        memory(address+1) = uint8(bitand(value,uint32(255)));

        memory(address+2) = uint8( ...
            bitand(bitshift(value,-8),uint32(255)));

        fprintf('Address     : %d\n',address);

    %% ====================================================
    % SW - STORE WORD
    % ====================================================

    elseif strcmp(opcode,'SW')

        rs2 = str2double(extractAfter(parts{2},'x'));

        addressPart = parts{3};

        openBracket = strfind(addressPart,'(');
        closeBracket = strfind(addressPart,')');

        immediate = str2double( ...
            extractBefore(addressPart,openBracket(1)));

        baseRegister = extractBetween( ...
            addressPart, ...
            openBracket(1)+1, ...
            closeBracket(1)-1);

        rs1 = str2double( ...
            extractAfter(baseRegister{1},'x'));

        address = double(registers(rs1+1)) + immediate;

        value = registers(rs2+1);

        if address < 0 || address+3 >= length(memory)
            error('Memory address out of range');
        end

        memory(address+1) = uint8( ...
            bitand(value,uint32(255)));

        memory(address+2) = uint8( ...
            bitand(bitshift(value,-8),uint32(255)));

        memory(address+3) = uint8( ...
            bitand(bitshift(value,-16),uint32(255)));

        memory(address+4) = uint8( ...
            bitand(bitshift(value,-24),uint32(255)));

        fprintf('Address     : %d\n',address);
        fprintf('Stored word : 0x%08X\n',value);

    %% ====================================================
    % LB - LOAD BYTE SIGNED
    % ====================================================

    elseif strcmp(opcode,'LB')

        rd = str2double(extractAfter(parts{2},'x'));

        addressPart = parts{3};

        openBracket = strfind(addressPart,'(');
        closeBracket = strfind(addressPart,')');

        immediate = str2double( ...
            extractBefore(addressPart,openBracket(1)));

        baseRegister = extractBetween( ...
            addressPart, ...
            openBracket(1)+1, ...
            closeBracket(1)-1);

        rs1 = str2double( ...
            extractAfter(baseRegister{1},'x'));

        address = double(registers(rs1+1)) + immediate;

        if address < 0 || address >= length(memory)
            error('Memory address out of range');
        end

        value = uint32(memory(address+1));

        if bitget(value,8)
            value = bitor(value,uint32(hex2dec('FFFFFF00')));
        end

        if rd ~= 0
            registers(rd+1) = value;
        end

        fprintf('Loaded byte : %u\n',value);
        fprintf('Signed      : %d\n',typecast(value,'int32'));

    %% ====================================================
    % LBU - LOAD BYTE UNSIGNED
    % ====================================================

    elseif strcmp(opcode,'LBU')

        rd = str2double(extractAfter(parts{2},'x'));

        addressPart = parts{3};

        openBracket = strfind(addressPart,'(');
        closeBracket = strfind(addressPart,')');

        immediate = str2double( ...
            extractBefore(addressPart,openBracket(1)));

        baseRegister = extractBetween( ...
            addressPart, ...
            openBracket(1)+1, ...
            closeBracket(1)-1);

        rs1 = str2double( ...
            extractAfter(baseRegister{1},'x'));

        address = double(registers(rs1+1)) + immediate;

        value = uint32(memory(address+1));

        if rd ~= 0
            registers(rd+1) = value;
        end

        fprintf('Loaded byte : %u\n',value);

    %% ====================================================
    % LH - LOAD HALFWORD SIGNED
    % ====================================================

    elseif strcmp(opcode,'LH')

        rd = str2double(extractAfter(parts{2},'x'));

        addressPart = parts{3};

        openBracket = strfind(addressPart,'(');
        closeBracket = strfind(addressPart,')');

        immediate = str2double( ...
            extractBefore(addressPart,openBracket(1)));

        baseRegister = extractBetween( ...
            addressPart, ...
            openBracket(1)+1, ...
            closeBracket(1)-1);

        rs1 = str2double( ...
            extractAfter(baseRegister{1},'x'));

        address = double(registers(rs1+1)) + immediate;

        if address < 0 || address+1 >= length(memory)
            error('Memory address out of range');
        end

        low = uint32(memory(address+1));
        high = uint32(memory(address+2));

        value = bitor( ...
            low, ...
            bitshift(high,8));

        if bitget(value,16)
            value = bitor( ...
                value, ...
                uint32(hex2dec('FFFF0000')));
        end

        if rd ~= 0
            registers(rd+1) = value;
        end

        fprintf('Loaded halfword: %u\n',value);
        fprintf('Signed         : %d\n',typecast(value,'int32'));

    %% ====================================================
    % LHU - LOAD HALFWORD UNSIGNED
    % ====================================================

    elseif strcmp(opcode,'LHU')

        rd = str2double(extractAfter(parts{2},'x'));

        addressPart = parts{3};

        openBracket = strfind(addressPart,'(');
        closeBracket = strfind(addressPart,')');

        immediate = str2double( ...
            extractBefore(addressPart,openBracket(1)));

        baseRegister = extractBetween( ...
            addressPart, ...
            openBracket(1)+1, ...
            closeBracket(1)-1);

        rs1 = str2double( ...
            extractAfter(baseRegister{1},'x'));

        address = double(registers(rs1+1)) + immediate;

        low = uint32(memory(address+1));
        high = uint32(memory(address+2));

        value = bitor( ...
            low, ...
            bitshift(high,8));

        if rd ~= 0
            registers(rd+1) = value;
        end

        fprintf('Loaded halfword: %u\n',value);

    %% ====================================================
    % LW - LOAD WORD
    % ====================================================

    elseif strcmp(opcode,'LW')

        rd = str2double(extractAfter(parts{2},'x'));

        addressPart = parts{3};

        openBracket = strfind(addressPart,'(');
        closeBracket = strfind(addressPart,')');

        immediate = str2double( ...
            extractBefore(addressPart,openBracket(1)));

        baseRegister = extractBetween( ...
            addressPart, ...
            openBracket(1)+1, ...
            closeBracket(1)-1);

        rs1 = str2double( ...
            extractAfter(baseRegister{1},'x'));

        address = double(registers(rs1+1)) + immediate;

        if address < 0 || address+3 >= length(memory)
            error('Memory address out of range');
        end

        b0 = uint32(memory(address+1));
        b1 = uint32(memory(address+2));
        b2 = uint32(memory(address+3));
        b3 = uint32(memory(address+4));

        value = bitor( ...
            b0, ...
            bitor( ...
                bitshift(b1,8), ...
                bitor( ...
                    bitshift(b2,16), ...
                    bitshift(b3,24))));

        if rd ~= 0
            registers(rd+1) = value;
        end

        fprintf('Loaded word : 0x%08X\n',value);

    %% ====================================================
    % UNKNOWN INSTRUCTION
    % ====================================================

    else

        error('Unsupported instruction: %s',opcode);

    end

    %% ====================================================
    % x0 ALWAYS ZERO
    % ====================================================

    registers(1) = uint32(0);

    %% ====================================================
    % UPDATE PC
    % ====================================================

    PC = nextPC;

end

%% ========================================================
% 6. FINAL REGISTER FILE
% ========================================================

fprintf('\n');
fprintf('====================================================\n');
fprintf('              FINAL REGISTER FILE\n');
fprintf('====================================================\n');

for i = 0:31

    unsignedValue = registers(i+1);

    signedValue = typecast( ...
        unsignedValue,'int32');

    fprintf( ...
        'x%-2d = %11u   signed = %12d\n', ...
        i, ...
        unsignedValue, ...
        signedValue);

end

%% ========================================================
% 7. MEMORY DUMP
% ========================================================

fprintf('\n');
fprintf('====================================================\n');
fprintf('                  MEMORY DUMP\n');
fprintf('====================================================\n');

fprintf('\n');

for address = 0:15

    fprintf( ...
        'Memory[%3d] = 0x%02X\n', ...
        address, ...
        memory(address+1));

end

%% ========================================================
% 8. RESULTS
% ========================================================

fprintf('\n');
fprintf('====================================================\n');
fprintf('                  RESULTS\n');
fprintf('====================================================\n');

fprintf('\n');

fprintf('x9  = 0x%08X\n',registers(10));
fprintf('x10 = 0x%08X   signed = %d\n', ...
    registers(11), ...
    typecast(registers(11),'int32'));

fprintf('x11 = 0x%08X   signed = %d\n', ...
    registers(12), ...
    typecast(registers(12),'int32'));

fprintf('x12 = 0x%08X   signed = %d\n', ...
    registers(13), ...
    typecast(registers(13),'int32'));

fprintf('x13 = 0x%08X   signed = %d\n', ...
    registers(14), ...
    typecast(registers(14),'int32'));

fprintf('x14 = 0x%08X\n',registers(15));
fprintf('x15 = 0x%08X\n',registers(16));
fprintf('x16 = 0x%08X\n',registers(17));
fprintf('x17 = 0x%08X\n',registers(18));

fprintf('x18 = 0x%08X   signed = %d\n', ...
    registers(19), ...
    typecast(registers(19),'int32'));

fprintf('x19 = 0x%08X\n',registers(20));

fprintf('x20 = 0x%08X   signed = %d\n', ...
    registers(21), ...
    typecast(registers(21),'int32'));

fprintf('x21 = 0x%08X\n',registers(22));

fprintf('x22 = 0x%08X\n',registers(23));

fprintf('\n');
fprintf('Expected full word:\n');
fprintf('0x12345678\n');

fprintf('\n');
fprintf('Expected little-endian memory:\n');
fprintf('Address 0 = 0x78\n');
fprintf('Address 1 = 0x56\n');
fprintf('Address 2 = 0x34\n');
fprintf('Address 3 = 0x12\n');

fprintf('\n');
fprintf('====================================================\n');
fprintf('             STAGE 8 COMPLETE\n');
fprintf('====================================================\n');