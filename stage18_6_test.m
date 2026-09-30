function stage18_6_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('              STAGE 18.6 - EX STAGE\n');
fprintf('============================================================\n');

testsPassed = 0;
totalTests = 10;


% ============================================================
% TEST 1 — ADD
% ADD x3, x1, x2
% x1 = 10, x2 = 20
% ============================================================

result = ex_stage( ...
    uint32(51), ...
    uint32(0), ...
    uint32(0), ...
    uint32(10), ...
    uint32(20), ...
    0);

if result.aluResult == uint32(30) && ...
   result.operation == "ADD"

    fprintf('ADD                       : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('ADD                       : FAIL\n');

end


% ============================================================
% TEST 2 — SUB
% ============================================================

result = ex_stage( ...
    uint32(51), ...
    uint32(0), ...
    uint32(32), ...
    uint32(30), ...
    uint32(10), ...
    0);

if result.aluResult == uint32(20) && ...
   result.operation == "SUB"

    fprintf('SUB                       : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('SUB                       : FAIL\n');

end


% ============================================================
% TEST 3 — AND
% ============================================================

result = ex_stage( ...
    uint32(51), ...
    uint32(7), ...
    uint32(0), ...
    uint32(15), ...
    uint32(6), ...
    0);

if result.aluResult == uint32(6) && ...
   result.operation == "AND"

    fprintf('AND                       : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('AND                       : FAIL\n');

end


% ============================================================
% TEST 4 — OR
% ============================================================

result = ex_stage( ...
    uint32(51), ...
    uint32(6), ...
    uint32(0), ...
    uint32(8), ...
    uint32(4), ...
    0);

if result.aluResult == uint32(12) && ...
   result.operation == "OR"

    fprintf('OR                        : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('OR                        : FAIL\n');

end


% ============================================================
% TEST 5 — XOR
% ============================================================

result = ex_stage( ...
    uint32(51), ...
    uint32(4), ...
    uint32(0), ...
    uint32(15), ...
    uint32(10), ...
    0);

if result.aluResult == uint32(5) && ...
   result.operation == "XOR"

    fprintf('XOR                       : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('XOR                       : FAIL\n');

end


% ============================================================
% TEST 6 — SLT
% ============================================================

result = ex_stage( ...
    uint32(51), ...
    uint32(2), ...
    uint32(0), ...
    uint32(5), ...
    uint32(10), ...
    0);

if result.aluResult == uint32(1) && ...
   result.operation == "SLT"

    fprintf('SLT                       : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('SLT                       : FAIL\n');

end


% ============================================================
% TEST 7 — ADDI
% ============================================================

result = ex_stage( ...
    uint32(19), ...
    uint32(0), ...
    uint32(0), ...
    uint32(25), ...
    uint32(0), ...
    10);

if result.aluResult == uint32(35) && ...
   result.operation == "ADDI"

    fprintf('ADDI                      : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('ADDI                      : FAIL\n');

end


% ============================================================
% TEST 8 — SLLI
% ============================================================

result = ex_stage( ...
    uint32(19), ...
    uint32(1), ...
    uint32(0), ...
    uint32(1), ...
    uint32(0), ...
    3);

if result.aluResult == uint32(8) && ...
   result.operation == "SLLI"

    fprintf('SLLI                      : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('SLLI                      : FAIL\n');

end


% ============================================================
% TEST 9 — SRLI
% ============================================================

result = ex_stage( ...
    uint32(19), ...
    uint32(5), ...
    uint32(0), ...
    uint32(32), ...
    uint32(0), ...
    2);

if result.aluResult == uint32(8) && ...
   result.operation == "SRLI"

    fprintf('SRLI                      : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('SRLI                      : FAIL\n');

end


% ============================================================
% TEST 10 — SRAI
% ============================================================

negativeValue = typecast(int32(-16),'uint32');

result = ex_stage( ...
    uint32(19), ...
    uint32(5), ...
    uint32(32), ...
    negativeValue, ...
    uint32(0), ...
    2);

expected = typecast(int32(-4),'uint32');

if result.aluResult == expected && ...
   result.operation == "SRAI"

    fprintf('SRAI                      : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('SRAI                      : FAIL\n');

end


% ============================================================
% RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                  STAGE 18.6 RESULTS\n');
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
    fprintf('       STAGE 18.6 PASSED!\n');
    fprintf('       EX STAGE VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 18.6 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end