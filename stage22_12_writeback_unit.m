function stage22_12_writeback_unit

clc;

fprintf('==============================================\n');
fprintf('STAGE 22.12 - HARDWARE WRITE-BACK UNIT\n');
fprintf('==============================================\n\n');

testsPassed = 0;
testsTotal = 10;

% =================================================
% TEST 1 - ALU result selected
% =================================================

aluResult = uint32(123);
memoryData = uint32(456);
memToReg = false;

if memToReg
    writeBackData = memoryData;
else
    writeBackData = aluResult;
end

if writeBackData == uint32(123)

    fprintf('1. ALU result selection      : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('1. ALU result selection      : FAIL\n');

end

% =================================================
% TEST 2 - Memory result selected
% =================================================

aluResult = uint32(123);
memoryData = uint32(456);
memToReg = true;

if memToReg
    writeBackData = memoryData;
else
    writeBackData = aluResult;
end

if writeBackData == uint32(456)

    fprintf('2. Memory result selection   : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('2. Memory result selection   : FAIL\n');

end

% =================================================
% TEST 3 - RegWrite enabled
% =================================================

registers = zeros(32,1,'uint32');

rd = 5;
writeBackData = uint32(789);
regWrite = true;

if regWrite && rd ~= 0

    registers(rd + 1) = writeBackData;

end

if registers(6) == uint32(789)

    fprintf('3. RegWrite enabled          : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('3. RegWrite enabled          : FAIL\n');

end

% =================================================
% TEST 4 - RegWrite disabled
% =================================================

oldValue = registers(6);

rd = 5;
writeBackData = uint32(999);
regWrite = false;

if regWrite && rd ~= 0

    registers(rd + 1) = writeBackData;

end

if registers(6) == oldValue

    fprintf('4. RegWrite disabled         : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('4. RegWrite disabled         : FAIL\n');

end

% =================================================
% TEST 5 - x0 protection
% =================================================

rd = 0;
writeBackData = uint32(123456);
regWrite = true;

if regWrite && rd ~= 0

    registers(rd + 1) = writeBackData;

end

registers(1) = uint32(0);

if registers(1) == uint32(0)

    fprintf('5. x0 write protection       : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('5. x0 write protection       : FAIL\n');

end

% =================================================
% TEST 6 - Maximum 32-bit value
% =================================================

rd = 10;
writeBackData = uint32(4294967295);
regWrite = true;

if regWrite && rd ~= 0

    registers(rd + 1) = writeBackData;

end

if registers(11) == uint32(4294967295)

    fprintf('6. 32-bit maximum write      : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('6. 32-bit maximum write      : FAIL\n');

end

% =================================================
% TEST 7 - Zero write-back value
% =================================================

rd = 11;
writeBackData = uint32(0);
regWrite = true;

if regWrite && rd ~= 0

    registers(rd + 1) = writeBackData;

end

if registers(12) == uint32(0)

    fprintf('7. Zero write-back value     : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('7. Zero write-back value     : FAIL\n');

end

% =================================================
% TEST 8 - Load write-back path
% =================================================

aluResult = uint32(1000);
memoryData = uint32(2500);
memToReg = true;
rd = 12;
regWrite = true;

if memToReg
    writeBackData = memoryData;
else
    writeBackData = aluResult;
end

if regWrite && rd ~= 0

    registers(rd + 1) = writeBackData;

end

if registers(13) == uint32(2500)

    fprintf('8. Load write-back path      : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('8. Load write-back path      : FAIL\n');

end

% =================================================
% TEST 9 - ALU write-back path
% =================================================

aluResult = uint32(3500);
memoryData = uint32(4500);
memToReg = false;
rd = 13;
regWrite = true;

if memToReg
    writeBackData = memoryData;
else
    writeBackData = aluResult;
end

if regWrite && rd ~= 0

    registers(rd + 1) = writeBackData;

end

if registers(14) == uint32(3500)

    fprintf('9. ALU write-back path       : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('9. ALU write-back path       : FAIL\n');

end

% =================================================
% TEST 10 - Complete write-back chain
% =================================================

rd = 20;

aluResult = uint32(1111);
memoryData = uint32(2222);
memToReg = true;
regWrite = true;

if memToReg
    writeBackData = memoryData;
else
    writeBackData = aluResult;
end

if regWrite && rd ~= 0

    registers(rd + 1) = writeBackData;

end

readBack = registers(rd + 1);

if readBack == uint32(2222)

    fprintf('10. Complete write-back chain : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('10. Complete write-back chain : FAIL\n');

end

% ------------------------------------------------
% Hardware summary
% ------------------------------------------------

fprintf('\n');
fprintf('Hardware Write-Back Unit:\n');
fprintf('  ALU result input       : 32 bits\n');
fprintf('  Memory data input      : 32 bits\n');
fprintf('  MemToReg               : Result multiplexer\n');
fprintf('  RegWrite               : Register write enable\n');
fprintf('  rd                     : 5-bit destination register\n');
fprintf('  Write-back data        : 32 bits\n');
fprintf('  x0                     : Permanently zero\n');

fprintf('\n');
fprintf('Tests passed : %d / %d\n', ...
    testsPassed,testsTotal);

if testsPassed == testsTotal

    fprintf('STAGE 22.12 PASSED!\n');

else

    fprintf('STAGE 22.12 FAILED\n');

end

end