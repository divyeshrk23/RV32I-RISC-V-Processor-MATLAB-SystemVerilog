function machineCode = encoder(instruction)

instruction = upper(strtrim(instruction));
tokens = split(instruction, {' ', ','});
tokens = tokens(~cellfun('isempty',tokens));

opcode = tokens{1};

switch opcode

    % =========================================================
    % R-TYPE
    % =========================================================

    case {'ADD','SUB','AND','OR','XOR','SLT','SLTU'}

        rd  = parseRegister(tokens{2});
        rs1 = parseRegister(tokens{3});
        rs2 = parseRegister(tokens{4});

        opcodeBits = uint32(hex2dec('33'));

        funct3 = uint32(0);
        funct7 = uint32(0);

        switch opcode

            case 'ADD'
                funct3 = uint32(0);
                funct7 = uint32(0);

            case 'SUB'
                funct3 = uint32(0);
                funct7 = uint32(32);

            case 'AND'
                funct3 = uint32(7);
                funct7 = uint32(0);

            case 'OR'
                funct3 = uint32(6);
                funct7 = uint32(0);

            case 'XOR'
                funct3 = uint32(4);
                funct7 = uint32(0);

            case 'SLT'
                funct3 = uint32(2);
                funct7 = uint32(0);

            case 'SLTU'
                funct3 = uint32(3);
                funct7 = uint32(0);

        end

        machineCode = opcodeBits;

        machineCode = bitor( ...
            machineCode,bitshift(uint32(rd),7));

        machineCode = bitor( ...
            machineCode,bitshift(funct3,12));

        machineCode = bitor( ...
            machineCode,bitshift(uint32(rs1),15));

        machineCode = bitor( ...
            machineCode,bitshift(uint32(rs2),20));

        machineCode = bitor( ...
            machineCode,bitshift(funct7,25));


    % =========================================================
    % I-TYPE
    % =========================================================

    case {'ADDI','SLTI','SLTIU'}

        rd  = parseRegister(tokens{2});
        rs1 = parseRegister(tokens{3});
        imm = parseNumber(tokens{4});

        if imm < -2048 || imm > 2047
            error('%s immediate must be between -2048 and 2047.',opcode);
        end

        switch opcode

            case 'ADDI'
                funct3 = uint32(0);

            case 'SLTI'
                funct3 = uint32(2);

            case 'SLTIU'
                funct3 = uint32(3);

        end

        opcodeBits = uint32(hex2dec('13'));

        imm12 = uint32(mod(imm,2^12));

        machineCode = opcodeBits;

        machineCode = bitor( ...
            machineCode,bitshift(uint32(rd),7));

        machineCode = bitor( ...
            machineCode,bitshift(funct3,12));

        machineCode = bitor( ...
            machineCode,bitshift(uint32(rs1),15));

        machineCode = bitor( ...
            machineCode,bitshift(imm12,20));


    % =========================================================
    % SHIFT IMMEDIATE
    % =========================================================

    case {'SLLI','SRLI','SRAI'}

        rd  = parseRegister(tokens{2});
        rs1 = parseRegister(tokens{3});
        shamt = parseNumber(tokens{4});

        if shamt < 0 || shamt > 31
            error('Shift amount must be between 0 and 31.');
        end

        opcodeBits = uint32(hex2dec('13'));

        switch opcode

            case 'SLLI'
                funct3 = uint32(1);
                funct7 = uint32(0);

            case 'SRLI'
                funct3 = uint32(5);
                funct7 = uint32(0);

            case 'SRAI'
                funct3 = uint32(5);
                funct7 = uint32(32);

        end

        machineCode = opcodeBits;

        machineCode = bitor( ...
            machineCode,bitshift(uint32(rd),7));

        machineCode = bitor( ...
            machineCode,bitshift(funct3,12));

        machineCode = bitor( ...
            machineCode,bitshift(uint32(rs1),15));

        machineCode = bitor( ...
            machineCode,bitshift(uint32(shamt),20));

        machineCode = bitor( ...
            machineCode,bitshift(funct7,25));


    % =========================================================
    % JALR
    % =========================================================

    case 'JALR'

        rd = parseRegister(tokens{2});
        mem = parseMemoryOperand(tokens{3});

        imm = mem.immediate;
        rs1 = mem.rs1;

        if imm < -2048 || imm > 2047
            error('JALR immediate must be between -2048 and 2047.');
        end

        opcodeBits = uint32(hex2dec('67'));

        imm12 = uint32(mod(imm,2^12));

        machineCode = opcodeBits;

        machineCode = bitor( ...
            machineCode,bitshift(uint32(rd),7));

        machineCode = bitor( ...
            machineCode,bitshift(uint32(rs1),15));

        machineCode = bitor( ...
            machineCode,bitshift(imm12,20));


    % =========================================================
    % LOAD
    % =========================================================

    case {'LB','LBU','LH','LHU','LW'}

        rd = parseRegister(tokens{2});
        mem = parseMemoryOperand(tokens{3});

        imm = mem.immediate;
        rs1 = mem.rs1;

        if imm < -2048 || imm > 2047
            error('%s immediate must be between -2048 and 2047.',opcode);
        end

        switch opcode

            case 'LB'
                funct3 = uint32(0);

            case 'LH'
                funct3 = uint32(1);

            case 'LW'
                funct3 = uint32(2);

            case 'LBU'
                funct3 = uint32(4);

            case 'LHU'
                funct3 = uint32(5);

        end

        opcodeBits = uint32(hex2dec('03'));

        imm12 = uint32(mod(imm,2^12));

        machineCode = opcodeBits;

        machineCode = bitor( ...
            machineCode,bitshift(uint32(rd),7));

        machineCode = bitor( ...
            machineCode,bitshift(funct3,12));

        machineCode = bitor( ...
            machineCode,bitshift(uint32(rs1),15));

        machineCode = bitor( ...
            machineCode,bitshift(imm12,20));


    % =========================================================
    % STORE
    % =========================================================

    case {'SB','SH','SW'}

        rs2 = parseRegister(tokens{2});
        mem = parseMemoryOperand(tokens{3});

        rs1 = mem.rs1;
        imm = mem.immediate;

        if imm < -2048 || imm > 2047
            error('%s immediate must be between -2048 and 2047.',opcode);
        end

        switch opcode

            case 'SB'
                funct3 = uint32(0);

            case 'SH'
                funct3 = uint32(1);

            case 'SW'
                funct3 = uint32(2);

        end

        opcodeBits = uint32(hex2dec('23'));

        imm12 = uint32(mod(imm,2^12));

        immLow  = bitand(imm12,uint32(31));
        immHigh = bitshift(imm12,-5);

        machineCode = opcodeBits;

        machineCode = bitor( ...
            machineCode,bitshift(immLow,7));

        machineCode = bitor( ...
            machineCode,bitshift(funct3,12));

        machineCode = bitor( ...
            machineCode,bitshift(uint32(rs1),15));

        machineCode = bitor( ...
            machineCode,bitshift(uint32(rs2),20));

        machineCode = bitor( ...
            machineCode,bitshift(immHigh,25));


    % =========================================================
    % BRANCH
    % =========================================================

    case {'BEQ','BNE','BLT','BGE','BLTU','BGEU'}

        rs1 = parseRegister(tokens{2});
        rs2 = parseRegister(tokens{3});
        imm = parseNumber(tokens{4});

        if mod(imm,2) ~= 0
            error('Branch immediate must be 2-byte aligned.');
        end

        if imm < -4096 || imm > 4094
            error('Branch immediate out of range.');
        end

        switch opcode

            case 'BEQ'
                funct3 = uint32(0);

            case 'BNE'
                funct3 = uint32(1);

            case 'BLT'
                funct3 = uint32(4);

            case 'BGE'
                funct3 = uint32(5);

            case 'BLTU'
                funct3 = uint32(6);

            case 'BGEU'
                funct3 = uint32(7);

        end

        opcodeBits = uint32(hex2dec('63'));

        imm13 = uint32(mod(imm,2^13));

        bit12 = bitand(bitshift(imm13,-12),1);
        bit11 = bitand(bitshift(imm13,-11),1);
        bits10_5 = bitand(bitshift(imm13,-5),63);
        bits4_1 = bitand(bitshift(imm13,-1),15);

        machineCode = opcodeBits;

        machineCode = bitor( ...
            machineCode,bitshift(bits4_1,8));

        machineCode = bitor( ...
            machineCode,bitshift(bit12,31));

        machineCode = bitor( ...
            machineCode,bitshift(bits10_5,25));

        machineCode = bitor( ...
            machineCode,bitshift(bit11,7));

        machineCode = bitor( ...
            machineCode,bitshift(funct3,12));

        machineCode = bitor( ...
            machineCode,bitshift(uint32(rs1),15));

        machineCode = bitor( ...
            machineCode,bitshift(uint32(rs2),20));


    % =========================================================
    % JAL
    % =========================================================

    case 'JAL'

        rd = parseRegister(tokens{2});
        imm = parseNumber(tokens{3});

        if mod(imm,2) ~= 0
            error('JAL immediate must be 2-byte aligned.');
        end

        if imm < -1048576 || imm > 1048574
            error('JAL immediate out of range.');
        end

        opcodeBits = uint32(hex2dec('6F'));

        imm21 = uint32(mod(imm,2^21));

        bit20 = bitand(bitshift(imm21,-20),1);
        bits10_1 = bitand(bitshift(imm21,-1),1023);
        bit11 = bitand(bitshift(imm21,-11),1);
        bits19_12 = bitand(bitshift(imm21,-12),255);

        machineCode = opcodeBits;

        machineCode = bitor( ...
            machineCode,bitshift(uint32(rd),7));

        machineCode = bitor( ...
            machineCode,bitshift(bits19_12,12));

        machineCode = bitor( ...
            machineCode,bitshift(bit11,20));

        machineCode = bitor( ...
            machineCode,bitshift(bits10_1,21));

        machineCode = bitor( ...
            machineCode,bitshift(bit20,31));

    otherwise

        error('Unsupported instruction: %s',opcode);

end

machineCode = uint32(machineCode);

end


% =============================================================
% REGISTER PARSER
% =============================================================

function reg = parseRegister(name)

name = upper(strtrim(char(name)));

if name(1) == 'X'
    reg = str2double(name(2:end));
else
    error('Invalid register: %s',name);
end

if isnan(reg) || reg < 0 || reg > 31 || floor(reg) ~= reg
    error('Invalid register: %s',name);
end

end


% =============================================================
% NUMBER PARSER
% =============================================================

function value = parseNumber(text)

text = strtrim(char(text));

if startsWith(text,'0X')
    value = hex2dec(text(3:end));
else
    value = str2double(text);
end

if isnan(value)
    error('Invalid number: %s',text);
end

end


% =============================================================
% MEMORY OPERAND PARSER
% =============================================================

function mem = parseMemoryOperand(text)

text = upper(strtrim(char(text)));

openParen = strfind(text,'(');
closeParen = strfind(text,')');

if isempty(openParen) || isempty(closeParen)
    error('Invalid memory operand: %s',text);
end

immText = strtrim(text(1:openParen-1));
regText = strtrim(text(openParen+1:closeParen-1));

if isempty(immText)
    immediate = 0;
else
    immediate = parseNumber(immText);
end

rs1 = parseRegister(regText);

mem.immediate = immediate;
mem.rs1 = rs1;

end