function stage18_10_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('              STAGE 18.10 - WB STAGE\n');
fprintf('============================================================\n');

testsPassed = 0;
totalTests = 10;


% ============================================================
% INITIAL REGISTER FILE
% ============================================================

registers = zeros(32,1,'uint32');


% ============================================================
% TEST 1 — ALU WRITE-BACK
% ============================================================

result = wb_stage( ...
    true, ...
    "ADD", ...
    uint32(123), ...
    uint32(0), ...
    5, ...
    false, ...
    true, ...
    registers);

registers = result.registers;

if registers(6) == uint32(123)

    fprintf('ALU WRITE-BACK            : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('ALU WRITE-BACK            : FAIL\n');

end


% ============================================================
% TEST 2 — MEMORY WRITE-BACK
% ============================================================

result = wb_stage( ...
    true, ...
    "LW", ...
    uint32(200), ...
    uint32(999), ...
    6, ...
    true, ...
    true, ...
    registers);

registers = result.registers;

if registers(7) == uint32(999)

    fprintf('MEMORY WRITE-BACK        : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('MEMORY WRITE-BACK        : FAIL\n');

end


% ============================================================
% TEST 3 — WRITE-DATA SELECTION
% ============================================================

result = wb_stage( ...
    true, ...
    "ADD", ...
    uint32(555), ...
    uint32(777), ...
    7, ...
    false, ...
    true, ...
    registers);

if result.writeData == uint32(555)

    fprintf('ALU DATA SELECTION       : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('ALU DATA SELECTION       : FAIL\n');

end


% ============================================================
% TEST 4 — MEMORY DATA SELECTION
% ============================================================

result = wb_stage( ...
    true, ...
    "LW", ...
    uint32(555), ...
    uint32(777), ...
    8, ...
    true, ...
    true, ...
    registers);

if result.writeData == uint32(777)

    fprintf('MEMORY DATA SELECTION    : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('MEMORY DATA SELECTION    : FAIL\n');

end


% ============================================================
% TEST 5 — x0 PROTECTION
% ============================================================

result = wb_stage( ...
    true, ...
    "ADD", ...
    uint32(12345), ...
    uint32(0), ...
    0, ...
    false, ...
    true, ...
    registers);

registers = result.registers;

if registers(1) == uint32(0) && ...
   result.writePerformed == false

    fprintf('x0 PROTECTION            : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('x0 PROTECTION            : FAIL\n');

end


% ============================================================
% TEST 6 — REGISTER WRITE DISABLED
% ============================================================

oldValue = registers(10);

result = wb_stage( ...
    true, ...
    "ADD", ...
    uint32(8888), ...
    uint32(0), ...
    9, ...
    false, ...
    false, ...
    registers);

registers = result.registers;

if registers(10) == oldValue && ...
   result.writePerformed == false

    fprintf('WRITE DISABLED           : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('WRITE DISABLED           : FAIL\n');

end


% ============================================================
% TEST 7 — INVALID PIPELINE ENTRY
% ============================================================

result = wb_stage( ...
    false, ...
    "ADD", ...
    uint32(500), ...
    uint32(600), ...
    10, ...
    false, ...
    true, ...
    registers);

if result.writePerformed == false && ...
   result.writeData == uint32(0)

    fprintf('INVALID ENTRY            : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('INVALID ENTRY            : FAIL\n');

end


% ============================================================
% TEST 8 — REGISTER WRITE FLAG
% ============================================================

result = wb_stage( ...
    true, ...
    "SUB", ...
    uint32(42), ...
    uint32(0), ...
    11, ...
    false, ...
    true, ...
    registers);

if result.writePerformed == true

    fprintf('REGISTER WRITE FLAG      : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('REGISTER WRITE FLAG      : FAIL\n');

end


% ============================================================
% TEST 9 — NEGATIVE VALUE AS uint32
% ============================================================

negativeValue = typecast(int32(-25),'uint32');

result = wb_stage( ...
    true, ...
    "SUB", ...
    negativeValue, ...
    uint32(0), ...
    12, ...
    false, ...
    true, ...
    registers);

registers = result.registers;

if registers(13) == negativeValue

    fprintf('SIGNED RESULT STORAGE    : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('SIGNED RESULT STORAGE    : FAIL\n');

end


% ============================================================
% TEST 10 — FINAL x0 CHECK
% ============================================================

result = wb_stage( ...
    true, ...
    "ADD", ...
    uint32(999999), ...
    uint32(0), ...
    0, ...
    false, ...
    true, ...
    registers);

if result.registers(1) == uint32(0)

    fprintf('FINAL x0 ZERO CHECK      : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('FINAL x0 ZERO CHECK      : FAIL\n');

end


% ============================================================
% RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                  STAGE 18.10 RESULTS\n');
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
    fprintf('       STAGE 18.10 PASSED!\n');
    fprintf('       WB STAGE VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 18.10 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end