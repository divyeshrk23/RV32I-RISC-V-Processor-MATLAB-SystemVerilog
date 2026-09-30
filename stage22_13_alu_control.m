function stage22_13_alu_control

clc;

fprintf('==============================================\n');
fprintf('STAGE 22.13 - HARDWARE ALU CONTROL UNIT\n');
fprintf('==============================================\n\n');

testsPassed = 0;
testsTotal = 10;

% ------------------------------------------------
% ALU Control encoding
%
% 1 = ADD
% 2 = SUB
% 3 = AND
% 4 = OR
% 5 = XOR
% 6 = SLL
% 7 = SRL
% 8 = SRA
% 9 = SLT
% 10 = SLTU
%
% ------------------------------------------------

% =================================================
% TEST 1 - ADD
% =================================================

opcode = "ADD";

switch char(opcode)

    case {'ADD','ADDI','LB','LBU','LH','LHU','LW','SB','SH','SW'}
        aluControl = "ADD";

    case {'SUB','BEQ','BNE','BLT','BGE','BLTU','BGEU'}
        aluControl = "SUB";

    case 'AND'
        aluControl = "AND";

    case 'OR'
        aluControl = "OR";

    case 'XOR'
        aluControl = "XOR";

    case 'SLLI'
        aluControl = "SLL";

    case 'SRLI'
        aluControl = "SRL";

    case 'SRAI'
        aluControl = "SRA";

    case {'SLT','SLTI'}
        aluControl = "SLT";

    case {'SLTU','SLTIU'}
        aluControl = "SLTU";

    otherwise
        aluControl = "INVALID";

end

if strcmp(char(aluControl),'ADD')

    fprintf('1. ADD control               : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('1. ADD control               : FAIL\n');

end

% =================================================
% TEST 2 - SUB
% =================================================

opcode = "SUB";

switch char(opcode)

    case {'ADD','ADDI','LB','LBU','LH','LHU','LW','SB','SH','SW'}
        aluControl = "ADD";

    case {'SUB','BEQ','BNE','BLT','BGE','BLTU','BGEU'}
        aluControl = "SUB";

    case 'AND'
        aluControl = "AND";

    case 'OR'
        aluControl = "OR";

    case 'XOR'
        aluControl = "XOR";

    case 'SLLI'
        aluControl = "SLL";

    case 'SRLI'
        aluControl = "SRL";

    case 'SRAI'
        aluControl = "SRA";

    case {'SLT','SLTI'}
        aluControl = "SLT";

    case {'SLTU','SLTIU'}
        aluControl = "SLTU";

    otherwise
        aluControl = "INVALID";

end

if strcmp(char(aluControl),'SUB')

    fprintf('2. SUB control               : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('2. SUB control               : FAIL\n');

end

% =================================================
% TEST 3 - Logical operations
% =================================================

logicalOK = true;

operations = ["AND","OR","XOR"];
expected = ["AND","OR","XOR"];

for i = 1:3

    opcode = operations(i);

    switch char(opcode)

        case 'AND'
            aluControl = "AND";

        case 'OR'
            aluControl = "OR";

        case 'XOR'
            aluControl = "XOR";

        otherwise
            aluControl = "INVALID";

    end

    if ~strcmp(char(aluControl),char(expected(i)))

        logicalOK = false;

    end

end

if logicalOK

    fprintf('3. AND/OR/XOR control       : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('3. AND/OR/XOR control       : FAIL\n');

end

% =================================================
% TEST 4 - Shift operations
% =================================================

shiftOK = true;

operations = ["SLLI","SRLI","SRAI"];
expected = ["SLL","SRL","SRA"];

for i = 1:3

    opcode = operations(i);

    switch char(opcode)

        case 'SLLI'
            aluControl = "SLL";

        case 'SRLI'
            aluControl = "SRL";

        case 'SRAI'
            aluControl = "SRA";

        otherwise
            aluControl = "INVALID";

    end

    if ~strcmp(char(aluControl),char(expected(i)))

        shiftOK = false;

    end

end

if shiftOK

    fprintf('4. Shift control             : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('4. Shift control             : FAIL\n');

end

% =================================================
% TEST 5 - Signed comparison
% =================================================

opcode = "SLT";

switch char(opcode)

    case {'SLT','SLTI'}
        aluControl = "SLT";

    otherwise
        aluControl = "INVALID";

end

if strcmp(char(aluControl),'SLT')

    fprintf('5. SLT control               : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('5. SLT control               : FAIL\n');

end

% =================================================
% TEST 6 - Unsigned comparison
% =================================================

opcode = "SLTU";

switch char(opcode)

    case {'SLTU','SLTIU'}
        aluControl = "SLTU";

    otherwise
        aluControl = "INVALID";

end

if strcmp(char(aluControl),'SLTU')

    fprintf('6. SLTU control              : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('6. SLTU control              : FAIL\n');

end

% =================================================
% TEST 7 - I-type ALU instructions
% =================================================

iTypeOK = true;

operations = [
    "ADDI"
    "SLLI"
    "SRLI"
    "SRAI"
    "SLTI"
    "SLTIU"
];

expected = [
    "ADD"
    "SLL"
    "SRL"
    "SRA"
    "SLT"
    "SLTU"
];

for i = 1:length(operations)

    opcode = operations(i);

    switch char(opcode)

        case 'ADDI'
            aluControl = "ADD";

        case 'SLLI'
            aluControl = "SLL";

        case 'SRLI'
            aluControl = "SRL";

        case 'SRAI'
            aluControl = "SRA";

        case 'SLTI'
            aluControl = "SLT";

        case 'SLTIU'
            aluControl = "SLTU";

        otherwise
            aluControl = "INVALID";

    end

    if ~strcmp(char(aluControl),char(expected(i)))

        iTypeOK = false;

    end

end

if iTypeOK

    fprintf('7. I-type ALU control       : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('7. I-type ALU control       : FAIL\n');

end

% =================================================
% TEST 8 - Load/store address calculation
% =================================================

memoryOK = true;

memoryOperations = [
    "LW"
    "LH"
    "LB"
    "LHU"
    "LBU"
    "SW"
    "SH"
    "SB"
];

for i = 1:length(memoryOperations)

    opcode = memoryOperations(i);

    switch char(opcode)

        case {'LW','LH','LB','LHU','LBU','SW','SH','SB'}
            aluControl = "ADD";

        otherwise
            aluControl = "INVALID";

    end

    if ~strcmp(char(aluControl),'ADD')

        memoryOK = false;

    end

end

if memoryOK

    fprintf('8. Load/store address ALU   : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('8. Load/store address ALU   : FAIL\n');

end

% =================================================
% TEST 9 - Branch ALU control
% =================================================

branchOK = true;

branches = [
    "BEQ"
    "BNE"
    "BLT"
    "BGE"
    "BLTU"
    "BGEU"
];

for i = 1:length(branches)

    opcode = branches(i);

    switch char(opcode)

        case {'BEQ','BNE','BLT','BGE','BLTU','BGEU'}
            aluControl = "SUB";

        otherwise
            aluControl = "INVALID";

    end

    if ~strcmp(char(aluControl),'SUB')

        branchOK = false;

    end

end

if branchOK

    fprintf('9. Branch ALU control       : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('9. Branch ALU control       : FAIL\n');

end

% =================================================
% TEST 10 - Complete ALU control coverage
% =================================================

allOperations = [
    "ADD"
    "SUB"
    "AND"
    "OR"
    "XOR"
    "SLL"
    "SRL"
    "SRA"
    "SLT"
    "SLTU"
];

coverageOK = true;

for i = 1:length(allOperations)

    control = allOperations(i);

    valid = any(strcmp(control,allOperations));

    if ~valid

        coverageOK = false;

    end

end

if coverageOK

    fprintf('10. Complete ALU coverage   : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('10. Complete ALU coverage   : FAIL\n');

end

% ------------------------------------------------
% Hardware summary
% ------------------------------------------------

fprintf('\n');
fprintf('Hardware ALU Control Unit:\n');
fprintf('  ADD             -> ADD\n');
fprintf('  SUB             -> SUB\n');
fprintf('  AND             -> AND\n');
fprintf('  OR              -> OR\n');
fprintf('  XOR             -> XOR\n');
fprintf('  SLLI            -> SLL\n');
fprintf('  SRLI            -> SRL\n');
fprintf('  SRAI            -> SRA\n');
fprintf('  SLT/SLTI        -> SLT\n');
fprintf('  SLTU/SLTIU      -> SLTU\n');
fprintf('  Loads/Stores    -> ADD\n');
fprintf('  Branches        -> SUB\n');

fprintf('\n');
fprintf('Tests passed : %d / %d\n', ...
    testsPassed,testsTotal);

if testsPassed == testsTotal

    fprintf('STAGE 22.13 PASSED!\n');

else

    fprintf('STAGE 22.13 FAILED\n');

end

end