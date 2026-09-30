function stage22_14_instruction_decoder

clc;

fprintf('==============================================\n');
fprintf('STAGE 22.14 - HARDWARE INSTRUCTION DECODER\n');
fprintf('==============================================\n\n');

testsPassed = 0;
testsTotal = 10;

% =================================================
% TEST 1 - ADD
% =================================================

instruction = encoder('ADD x5, x1, x2');

opcode = bitand(instruction,uint32(127));
rd = bitand(bitshift(instruction,-7),uint32(31));
funct3 = bitand(bitshift(instruction,-12),uint32(7));
rs1 = bitand(bitshift(instruction,-15),uint32(31));
rs2 = bitand(bitshift(instruction,-20),uint32(31));
funct7 = bitand(bitshift(instruction,-25),uint32(127));

if opcode == uint32(51) && ...
   rd == uint32(5) && ...
   funct3 == uint32(0) && ...
   rs1 == uint32(1) && ...
   rs2 == uint32(2) && ...
   funct7 == uint32(0)

    fprintf('1. ADD field extraction       : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('1. ADD field extraction       : FAIL\n');

end

% =================================================
% TEST 2 - SUB
% =================================================

instruction = encoder('SUB x6, x3, x4');

opcode = bitand(instruction,uint32(127));
rd = bitand(bitshift(instruction,-7),uint32(31));
rs1 = bitand(bitshift(instruction,-15),uint32(31));
rs2 = bitand(bitshift(instruction,-20),uint32(31));
funct7 = bitand(bitshift(instruction,-25),uint32(127));

if opcode == uint32(51) && ...
   rd == uint32(6) && ...
   rs1 == uint32(3) && ...
   rs2 == uint32(4) && ...
   funct7 == uint32(32)

    fprintf('2. SUB field extraction       : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('2. SUB field extraction       : FAIL\n');

end

% =================================================
% TEST 3 - ADDI
% =================================================

instruction = encoder('ADDI x7, x2, 25');

opcode = bitand(instruction,uint32(127));
rd = bitand(bitshift(instruction,-7),uint32(31));
funct3 = bitand(bitshift(instruction,-12),uint32(7));
rs1 = bitand(bitshift(instruction,-15),uint32(31));

if opcode == uint32(19) && ...
   rd == uint32(7) && ...
   funct3 == uint32(0) && ...
   rs1 == uint32(2)

    fprintf('3. ADDI field extraction      : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('3. ADDI field extraction      : FAIL\n');

end

% =================================================
% TEST 4 - LW
% =================================================

instruction = encoder('LW x8, 16(x3)');

opcode = bitand(instruction,uint32(127));
rd = bitand(bitshift(instruction,-7),uint32(31));
funct3 = bitand(bitshift(instruction,-12),uint32(7));
rs1 = bitand(bitshift(instruction,-15),uint32(31));

if opcode == uint32(3) && ...
   rd == uint32(8) && ...
   funct3 == uint32(2) && ...
   rs1 == uint32(3)

    fprintf('4. LW field extraction        : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('4. LW field extraction        : FAIL\n');

end

% =================================================
% TEST 5 - SW
% =================================================

instruction = encoder('SW x9, 20(x4)');

opcode = bitand(instruction,uint32(127));
funct3 = bitand(bitshift(instruction,-12),uint32(7));
rs1 = bitand(bitshift(instruction,-15),uint32(31));
rs2 = bitand(bitshift(instruction,-20),uint32(31));

if opcode == uint32(35) && ...
   funct3 == uint32(2) && ...
   rs1 == uint32(4) && ...
   rs2 == uint32(9)

    fprintf('5. SW field extraction        : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('5. SW field extraction        : FAIL\n');

end

% =================================================
% TEST 6 - BEQ
% =================================================

instruction = encoder('BEQ x5, x6, 12');

opcode = bitand(instruction,uint32(127));
funct3 = bitand(bitshift(instruction,-12),uint32(7));
rs1 = bitand(bitshift(instruction,-15),uint32(31));
rs2 = bitand(bitshift(instruction,-20),uint32(31));

if opcode == uint32(99) && ...
   funct3 == uint32(0) && ...
   rs1 == uint32(5) && ...
   rs2 == uint32(6)

    fprintf('6. BEQ field extraction       : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('6. BEQ field extraction       : FAIL\n');

end

% =================================================
% TEST 7 - JAL
% =================================================

instruction = encoder('JAL x10, 100');

opcode = bitand(instruction,uint32(127));
rd = bitand(bitshift(instruction,-7),uint32(31));

if opcode == uint32(111) && ...
   rd == uint32(10)

    fprintf('7. JAL field extraction       : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('7. JAL field extraction       : FAIL\n');

end

% =================================================
% TEST 8 - JALR
% =================================================

instruction = encoder('JALR x11, 24(x7)');

opcode = bitand(instruction,uint32(127));
rd = bitand(bitshift(instruction,-7),uint32(31));
funct3 = bitand(bitshift(instruction,-12),uint32(7));
rs1 = bitand(bitshift(instruction,-15),uint32(31));

if opcode == uint32(103) && ...
   rd == uint32(11) && ...
   funct3 == uint32(0) && ...
   rs1 == uint32(7)

    fprintf('8. JALR field extraction      : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('8. JALR field extraction      : FAIL\n');

end

% =================================================
% TEST 9 - Decoder opcode verification
% =================================================

instructions = {
    'ADD x1, x2, x3'
    'ADDI x4, x5, 10'
    'LW x6, 0(x7)'
    'SW x8, 4(x9)'
    'BEQ x10, x11, 8'
    'JAL x12, 20'
    'JALR x13, 16(x14)'
};

expected = {
    'ADD'
    'ADDI'
    'LW'
    'SW'
    'BEQ'
    'JAL'
    'JALR'
};

decoderOK = true;

for i = 1:length(instructions)

    machineCode = encoder(instructions{i});
    decoded = decoder(machineCode);

    if ~strcmp(char(decoded.opcode),expected{i})

        decoderOK = false;

    end

end

if decoderOK

    fprintf('9. Complete opcode decoding   : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('9. Complete opcode decoding   : FAIL\n');

end

% =================================================
% TEST 10 - Complete decoder interface
% =================================================

instruction = encoder('ADD x15, x12, x13');
decoded = decoder(instruction);

requiredFields = {
    'opcode'
    'rs1'
    'rs2'
    'rd'
    'immediate'
};

interfaceOK = true;

for i = 1:length(requiredFields)

    if ~isfield(decoded,requiredFields{i})

        interfaceOK = false;

    end

end

if interfaceOK && ...
   strcmp(char(decoded.opcode),'ADD') && ...
   decoded.rs1 == 12 && ...
   decoded.rs2 == 13 && ...
   decoded.rd == 15

    fprintf('10. Decoder interface         : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('10. Decoder interface         : FAIL\n');

end

% ------------------------------------------------
% Hardware summary
% ------------------------------------------------

fprintf('\n');
fprintf('Hardware Instruction Decoder:\n');
fprintf('  Instruction       : 32 bits\n');
fprintf('  Opcode            : bits [6:0]\n');
fprintf('  rd                : bits [11:7]\n');
fprintf('  funct3            : bits [14:12]\n');
fprintf('  rs1               : bits [19:15]\n');
fprintf('  rs2               : bits [24:20]\n');
fprintf('  funct7            : bits [31:25]\n');
fprintf('  Immediate         : Generated by Immediate Generator\n');

fprintf('\n');
fprintf('Tests passed : %d / %d\n', ...
    testsPassed,testsTotal);

if testsPassed == testsTotal

    fprintf('STAGE 22.14 PASSED!\n');

else

    fprintf('STAGE 22.14 FAILED\n');

end

end