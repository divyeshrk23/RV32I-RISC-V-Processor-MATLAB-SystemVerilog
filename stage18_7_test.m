function stage18_7_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('          STAGE 18.7 - EX/MEM PIPELINE REGISTER\n');
fprintf('============================================================\n');

testsPassed = 0;
totalTests = 10;


% ============================================================
% TEST DATA
% Example:
%
% LW x5, 16(x1)
%
% EX result = calculated memory address
% ============================================================

valid = true;

pc = uint32(12);

opcode = uint32(3);

aluResult = uint32(100);

storeData = uint32(0);

rd = 5;

memoryRead = true;

memoryWrite = false;

memoryOperation = "LW";


% ============================================================
% CREATE EX/MEM REGISTER
% ============================================================

register = ex_mem_register( ...
    valid, ...
    pc, ...
    opcode, ...
    aluResult, ...
    storeData, ...
    rd, ...
    memoryRead, ...
    memoryWrite, ...
    memoryOperation);


% ============================================================
% TEST 1 — VALID
% ============================================================

if register.valid == true

    fprintf('VALID = TRUE              : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('VALID = TRUE              : FAIL\n');

end


% ============================================================
% TEST 2 — PC
% ============================================================

if register.pc == uint32(12)

    fprintf('PC = 12                   : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('PC = 12                   : FAIL\n');

end


% ============================================================
% TEST 3 — OPCODE
% ============================================================

if register.opcode == uint32(3)

    fprintf('OPCODE = LOAD             : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('OPCODE = LOAD             : FAIL\n');

end


% ============================================================
% TEST 4 — ALU RESULT
% ============================================================

if register.aluResult == uint32(100)

    fprintf('ALU RESULT = 100          : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('ALU RESULT = 100          : FAIL\n');

end


% ============================================================
% TEST 5 — STORE DATA
% ============================================================

if register.storeData == uint32(0)

    fprintf('STORE DATA = 0            : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('STORE DATA = 0            : FAIL\n');

end


% ============================================================
% TEST 6 — RD
% ============================================================

if register.rd == 5

    fprintf('RD = x5                   : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('RD = x5                   : FAIL\n');

end


% ============================================================
% TEST 7 — MEMORY READ
% ============================================================

if register.memoryRead == true

    fprintf('MEMORY READ = TRUE        : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('MEMORY READ = TRUE        : FAIL\n');

end


% ============================================================
% TEST 8 — MEMORY WRITE
% ============================================================

if register.memoryWrite == false

    fprintf('MEMORY WRITE = FALSE      : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('MEMORY WRITE = FALSE      : FAIL\n');

end


% ============================================================
% TEST 9 — MEMORY OPERATION
% ============================================================

if register.memoryOperation == "LW"

    fprintf('MEMORY OPERATION = LW     : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('MEMORY OPERATION = LW     : FAIL\n');

end


% ============================================================
% TEST 10 — STORE ENTRY
% ============================================================

storeRegister = ex_mem_register( ...
    true, ...
    uint32(20), ...
    uint32(35), ...
    uint32(200), ...
    uint32(55), ...
    0, ...
    false, ...
    true, ...
    "SW");


if storeRegister.memoryWrite == true && ...
   storeRegister.storeData == uint32(55) && ...
   storeRegister.memoryOperation == "SW"

    fprintf('STORE INFORMATION        : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('STORE INFORMATION        : FAIL\n');

end


% ============================================================
% RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                  STAGE 18.7 RESULTS\n');
fprintf('============================================================\n');

fprintf('Tests passed : %d / %d\n', ...
    testsPassed,totalTests);

fprintf('============================================================\n');


% ============================================================
% FINAL RESULT
% ============================================================

if testsPassed == totalTests

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 18.7 PASSED!\n');
    fprintf('       EX/MEM REGISTER VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 18.7 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end