function stage18_9_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('          STAGE 18.9 - MEM/WB PIPELINE REGISTER\n');
fprintf('============================================================\n');

testsPassed = 0;
totalTests = 10;


% ============================================================
% TEST 1 — VALID
% ============================================================

result = mem_wb_register( ...
    true, ...
    uint32(100), ...
    "ADD", ...
    uint32(50), ...
    uint32(0), ...
    5, ...
    false, ...
    true);

if result.valid == true

    fprintf('VALID FIELD               : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('VALID FIELD               : FAIL\n');

end


% ============================================================
% TEST 2 — PC
% ============================================================

if result.pc == uint32(100)

    fprintf('PC FIELD                  : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('PC FIELD                  : FAIL\n');

end


% ============================================================
% TEST 3 — OPCODE
% ============================================================

if result.opcode == "ADD"

    fprintf('OPCODE FIELD              : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('OPCODE FIELD              : FAIL\n');

end


% ============================================================
% TEST 4 — ALU RESULT
% ============================================================

if result.aluResult == uint32(50)

    fprintf('ALU RESULT FIELD          : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('ALU RESULT FIELD          : FAIL\n');

end


% ============================================================
% TEST 5 — MEMORY DATA
% ============================================================

result = mem_wb_register( ...
    true, ...
    uint32(104), ...
    "LW", ...
    uint32(200), ...
    uint32(1234), ...
    8, ...
    true, ...
    true);

if result.memoryData == uint32(1234)

    fprintf('MEMORY DATA FIELD         : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('MEMORY DATA FIELD         : FAIL\n');

end


% ============================================================
% TEST 6 — RD
% ============================================================

if result.rd == 8

    fprintf('RD FIELD                  : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('RD FIELD                  : FAIL\n');

end


% ============================================================
% TEST 7 — MEMORY TO REGISTER
% ============================================================

if result.memoryToReg == true

    fprintf('MEMORY-TO-REG CONTROL     : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('MEMORY-TO-REG CONTROL     : FAIL\n');

end


% ============================================================
% TEST 8 — REGISTER WRITE
% ============================================================

if result.regWrite == true

    fprintf('REGISTER WRITE CONTROL    : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('REGISTER WRITE CONTROL    : FAIL\n');

end


% ============================================================
% TEST 9 — ALU WRITE-BACK CASE
% ============================================================

result = mem_wb_register( ...
    true, ...
    uint32(200), ...
    "SUB", ...
    uint32(75), ...
    uint32(0), ...
    10, ...
    false, ...
    true);

if result.aluResult == uint32(75) && ...
   result.memoryToReg == false && ...
   result.regWrite == true

    fprintf('ALU WRITE-BACK CASE      : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('ALU WRITE-BACK CASE      : FAIL\n');

end


% ============================================================
% TEST 10 — MEMORY WRITE-BACK CASE
% ============================================================

result = mem_wb_register( ...
    true, ...
    uint32(300), ...
    "LW", ...
    uint32(300), ...
    uint32(999), ...
    12, ...
    true, ...
    true);

if result.memoryData == uint32(999) && ...
   result.rd == 12 && ...
   result.memoryToReg == true && ...
   result.regWrite == true

    fprintf('MEMORY WRITE-BACK CASE   : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('MEMORY WRITE-BACK CASE   : FAIL\n');

end


% ============================================================
% RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                  STAGE 18.9 RESULTS\n');
fprintf('============================================================');

fprintf('\n');
fprintf('Tests passed : %d / %d\n', ...
    testsPassed,totalTests);

fprintf('============================================================\n');


% ============================================================
% FINAL RESULT
% ============================================================

if testsPassed == totalTests

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 18.9 PASSED!\n');
    fprintf('       MEM/WB REGISTER VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 18.9 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end