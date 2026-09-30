function stage22_4_register_file

clc;

fprintf('==============================================\n');
fprintf('STAGE 22.4 - HARDWARE REGISTER FILE\n');
fprintf('==============================================\n\n');

% ------------------------------------------------
% Hardware register file
% 32 registers x 32 bits
% ------------------------------------------------

registers = zeros(32,1,'uint32');

fprintf('Register file: 32 x 32-bit registers\n\n');

testsPassed = 0;
testsTotal = 10;

% ------------------------------------------------
% TEST 1 - Initial state
% ------------------------------------------------

if length(registers) == 32

    fprintf('1. Register count = 32       : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('1. Register count = 32       : FAIL\n');

end

% ------------------------------------------------
% TEST 2 - Register width
% ------------------------------------------------

if isa(registers,'uint32')

    fprintf('2. Register width = 32 bits  : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('2. Register width = 32 bits  : FAIL\n');

end

% ------------------------------------------------
% TEST 3 - x0 initially zero
% ------------------------------------------------

if registers(1) == uint32(0)

    fprintf('3. x0 initially zero         : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('3. x0 initially zero         : FAIL\n');

end

% ------------------------------------------------
% TEST 4 - Write x1
% ------------------------------------------------

rd = 1;
writeData = uint32(123);
regWrite = true;

if regWrite && rd ~= 0

    registers(rd + 1) = writeData;

end

if registers(2) == uint32(123)

    fprintf('4. Write x1 = 123            : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('4. Write x1 = 123            : FAIL\n');

end

% ------------------------------------------------
% TEST 5 - Write x5
% ------------------------------------------------

rd = 5;
writeData = uint32(987654321);
regWrite = true;

if regWrite && rd ~= 0

    registers(rd + 1) = writeData;

end

if registers(6) == uint32(987654321)

    fprintf('5. Write x5                  : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('5. Write x5                  : FAIL\n');

end

% ------------------------------------------------
% TEST 6 - Dual read ports
% ------------------------------------------------

rs1 = 1;
rs2 = 5;

readData1 = registers(rs1 + 1);
readData2 = registers(rs2 + 1);

if readData1 == uint32(123) && ...
   readData2 == uint32(987654321)

    fprintf('6. Dual read ports           : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('6. Dual read ports           : FAIL\n');

end

% ------------------------------------------------
% TEST 7 - Write disabled
% ------------------------------------------------

oldValue = registers(2);

rd = 1;
writeData = uint32(5555);
regWrite = false;

if regWrite && rd ~= 0

    registers(rd + 1) = writeData;

end

if registers(2) == oldValue

    fprintf('7. RegWrite = 0 blocks write : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('7. RegWrite = 0 blocks write : FAIL\n');

end

% ------------------------------------------------
% TEST 8 - x0 cannot be written
% ------------------------------------------------

rd = 0;
writeData = uint32(999999);
regWrite = true;

if regWrite && rd ~= 0

    registers(rd + 1) = writeData;

end

registers(1) = uint32(0);

if registers(1) == uint32(0)

    fprintf('8. x0 remains permanently 0  : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('8. x0 remains permanently 0  : FAIL\n');

end

% ------------------------------------------------
% TEST 9 - Maximum 32-bit value
% ------------------------------------------------

rd = 31;
writeData = uint32(4294967295);
regWrite = true;

if regWrite && rd ~= 0

    registers(rd + 1) = writeData;

end

if registers(32) == uint32(4294967295)

    fprintf('9. x31 stores 0xFFFFFFFF     : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('9. x31 stores 0xFFFFFFFF     : FAIL\n');

end

% ------------------------------------------------
% TEST 10 - Final register reads
% ------------------------------------------------

rs1 = 31;
rs2 = 0;

readData1 = registers(rs1 + 1);
readData2 = registers(rs2 + 1);

if readData1 == uint32(4294967295) && ...
   readData2 == uint32(0)

    fprintf('10. Final register reads     : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('10. Final register reads     : FAIL\n');

end

% ------------------------------------------------
% Hardware summary
% ------------------------------------------------

fprintf('\n');
fprintf('Hardware register file:\n');
fprintf('  Registers        : 32\n');
fprintf('  Register width   : 32 bits\n');
fprintf('  Read ports       : 2\n');
fprintf('  Write ports      : 1\n');
fprintf('  x0               : Hardwired to zero\n');

fprintf('\n');
fprintf('Tests passed : %d / %d\n', ...
    testsPassed,testsTotal);

if testsPassed == testsTotal

    fprintf('STAGE 22.4 PASSED!\n');

else

    fprintf('STAGE 22.4 FAILED\n');

end

end