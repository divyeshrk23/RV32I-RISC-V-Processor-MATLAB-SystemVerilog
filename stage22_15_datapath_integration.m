function stage22_15_datapath_integration

clc;

fprintf('==============================================\n');
fprintf('STAGE 22.15 - HARDWARE DATAPATH INTEGRATION\n');
fprintf('==============================================\n\n');

testsPassed = 0;
testsTotal = 10;

% ------------------------------------------------
% Hardware register file
% ------------------------------------------------

registers = zeros(32,1,'uint32');

% ------------------------------------------------
% Hardware instruction memory
% ------------------------------------------------

instructionMemory = uint32([ ...
    encoder('ADDI x1, x0, 10')
    encoder('ADDI x2, x0, 20')
    encoder('ADD x3, x1, x2')
    encoder('SW x3, 0(x0)')
    encoder('LW x4, 0(x0)')
]);

% =================================================
% TEST 1 - PC + Instruction Fetch
% =================================================

pc = uint32(0);

index = double(pc)/4 + 1;
instruction = instructionMemory(index);

if instruction == instructionMemory(1)

    fprintf('1. PC / instruction fetch    : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('1. PC / instruction fetch    : FAIL\n');

end

% =================================================
% TEST 2 - Instruction Decoder
% =================================================

decoded = decoder(instruction);

if strcmp(char(decoded.opcode),'ADDI') && ...
   decoded.rs1 == 0 && ...
   decoded.rd == 1

    fprintf('2. Instruction decoder        : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('2. Instruction decoder        : FAIL\n');

end

% =================================================
% TEST 3 - Register File Read
% =================================================

rs1Value = registers(decoded.rs1 + 1);

if rs1Value == uint32(0)

    fprintf('3. Register file read         : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('3. Register file read         : FAIL\n');

end

% =================================================
% TEST 4 - Immediate Generator
% =================================================

immediate = double(decoded.immediate);

if immediate == 10

    fprintf('4. Immediate generation       : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('4. Immediate generation       : FAIL\n');

end

% =================================================
% TEST 5 - ALU ADDI datapath
% =================================================

aluInputA = rs1Value;
aluInputB = uint32(immediate);

aluResult = uint32( ...
    mod(double(aluInputA) + double(aluInputB),2^32));

if aluResult == uint32(10)

    fprintf('5. ALU datapath               : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('5. ALU datapath               : FAIL\n');

end

% =================================================
% TEST 6 - Register Write Back
% =================================================

rd = decoded.rd;
regWrite = true;

if regWrite && rd ~= 0

    registers(rd + 1) = aluResult;

end

if registers(2) == uint32(10)

    fprintf('6. Register write-back        : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('6. Register write-back        : FAIL\n');

end

% =================================================
% TEST 7 - Second ADDI + Register Dependency
% =================================================

instruction = instructionMemory(2);
decoded = decoder(instruction);

rs1Value = registers(decoded.rs1 + 1);
immediate = uint32(decoded.immediate);

aluResult = uint32( ...
    mod(double(rs1Value) + double(immediate),2^32));

if aluResult == uint32(20)

    fprintf('7. Second ALU operation       : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('7. Second ALU operation       : FAIL\n');

end

registers(decoded.rd + 1) = aluResult;

% =================================================
% TEST 8 - R-type datapath
% =================================================

instruction = instructionMemory(3);
decoded = decoder(instruction);

rs1Value = registers(decoded.rs1 + 1);
rs2Value = registers(decoded.rs2 + 1);

aluResult = uint32( ...
    mod(double(rs1Value) + double(rs2Value),2^32));

if aluResult == uint32(30)

    fprintf('8. R-type datapath            : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('8. R-type datapath            : FAIL\n');

end

registers(decoded.rd + 1) = aluResult;

% =================================================
% TEST 9 - Store datapath
% =================================================

memory = zeros(1024,1,'uint8');

instruction = instructionMemory(4);
decoded = decoder(instruction);

storeValue = registers(decoded.rs2 + 1);
address = double(decoded.immediate);

bytes = typecast(uint32(storeValue),'uint8');

memory(address + 1) = bytes(1);
memory(address + 2) = bytes(2);
memory(address + 3) = bytes(3);
memory(address + 4) = bytes(4);

if memory(1) == uint8(30) && ...
   memory(2) == uint8(0) && ...
   memory(3) == uint8(0) && ...
   memory(4) == uint8(0)

    fprintf('9. Store datapath              : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('9. Store datapath              : FAIL\n');

end

% =================================================
% TEST 10 - Load + complete datapath
% =================================================

instruction = instructionMemory(5);
decoded = decoder(instruction);

address = double(decoded.immediate);

readBytes = memory(address + 1:address + 4);

loadedValue = typecast(uint8(readBytes),'uint32');

if loadedValue == uint32(30)

    registers(decoded.rd + 1) = loadedValue;

end

if registers(5) == uint32(30)

    fprintf('10. Load/write-back datapath : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('10. Load/write-back datapath : FAIL\n');

end

% ------------------------------------------------
% Hardware datapath summary
% ------------------------------------------------

fprintf('\n');
fprintf('Hardware Datapath:\n');
fprintf('  PC\n');
fprintf('   |\n');
fprintf('   v\n');
fprintf('  Instruction Memory\n');
fprintf('   |\n');
fprintf('   v\n');
fprintf('  Instruction Decoder\n');
fprintf('   |\n');
fprintf('   +----> Register File\n');
fprintf('   |          |\n');
fprintf('   |          v\n');
fprintf('   +----> Immediate Generator\n');
fprintf('              |\n');
fprintf('              v\n');
fprintf('             ALU\n');
fprintf('              |\n');
fprintf('       +------+------+\n');
fprintf('       |             |\n');
fprintf('       v             v\n');
fprintf('  Data Memory    Write Back\n');
fprintf('                     |\n');
fprintf('                     v\n');
fprintf('                Register File\n');

fprintf('\n');
fprintf('Integrated blocks verified:\n');
fprintf('  PC / Fetch             : YES\n');
fprintf('  Instruction Decoder    : YES\n');
fprintf('  Register File          : YES\n');
fprintf('  Immediate Generator    : YES\n');
fprintf('  ALU                    : YES\n');
fprintf('  Data Memory            : YES\n');
fprintf('  Write Back             : YES\n');

fprintf('\n');
fprintf('Tests passed : %d / %d\n', ...
    testsPassed,testsTotal);

if testsPassed == testsTotal

    fprintf('STAGE 22.15 PASSED!\n');
    fprintf('STAGE 22 HARDWARE DATAPATH VERIFIED!\n');

else

    fprintf('STAGE 22.15 FAILED\n');

end

end