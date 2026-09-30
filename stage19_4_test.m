function stage19_4_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('             STAGE 19.4 - LOAD-USE HAZARD\n');
fprintf('============================================================\n');

testsPassed = 0;
totalTests = 10;


% ============================================================
% TEST 1
% LW writes x1
% ID reads x1 as rs1
% ============================================================

result = load_use_hazard( ...
    1, ...
    2, ...
    1, ...
    true, ...
    "LW");

if result.hazard && ...
   result.rs1Hazard && ...
   result.stall

    fprintf('LW -> RS1 HAZARD           : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('LW -> RS1 HAZARD           : FAIL\n');

end


% ============================================================
% TEST 2
% LW writes x2
% ID reads x2 as rs2
% ============================================================

result = load_use_hazard( ...
    3, ...
    2, ...
    2, ...
    true, ...
    "LW");

if result.hazard && ...
   result.rs2Hazard && ...
   result.stall

    fprintf('LW -> RS2 HAZARD           : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('LW -> RS2 HAZARD           : FAIL\n');

end


% ============================================================
% TEST 3
% Both operands depend on loaded value
% ============================================================

result = load_use_hazard( ...
    5, ...
    5, ...
    5, ...
    true, ...
    "LW");

if result.hazard && ...
   result.rs1Hazard && ...
   result.rs2Hazard && ...
   result.stall

    fprintf('DUAL LOAD-USE HAZARD      : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('DUAL LOAD-USE HAZARD      : FAIL\n');

end


% ============================================================
% TEST 4
% EX is not performing a memory read
% Matching rd must not create load-use hazard
% ============================================================

result = load_use_hazard( ...
    4, ...
    7, ...
    4, ...
    false, ...
    "NONE");

if ~result.hazard && ~result.stall

    fprintf('NON-LOAD NO HAZARD         : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('NON-LOAD NO HAZARD         : FAIL\n');

end


% ============================================================
% TEST 5
% Different registers
% ============================================================

result = load_use_hazard( ...
    1, ...
    2, ...
    3, ...
    true, ...
    "LW");

if ~result.hazard && ~result.stall

    fprintf('NO REGISTER MATCH          : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('NO REGISTER MATCH          : FAIL\n');

end


% ============================================================
% TEST 6
% x0 must not cause a hazard
% ============================================================

result = load_use_hazard( ...
    0, ...
    0, ...
    0, ...
    true, ...
    "LW");

if ~result.hazard && ~result.stall

    fprintf('x0 PROTECTION              : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('x0 PROTECTION              : FAIL\n');

end


% ============================================================
% TEST 7
% LBU should also be detected
% ============================================================

result = load_use_hazard( ...
    8, ...
    9, ...
    8, ...
    true, ...
    "LBU");

if result.hazard && ...
   result.rs1Hazard && ...
   result.stall

    fprintf('LBU LOAD-USE HAZARD        : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('LBU LOAD-USE HAZARD        : FAIL\n');

end


% ============================================================
% TEST 8
% LH should also be detected
% ============================================================

result = load_use_hazard( ...
    10, ...
    11, ...
    10, ...
    true, ...
    "LH");

if result.hazard && ...
   result.rs1Hazard && ...
   result.stall

    fprintf('LH LOAD-USE HAZARD         : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('LH LOAD-USE HAZARD         : FAIL\n');

end


% ============================================================
% TEST 9
% Store instruction reading loaded register
%
% LW x1, 0(x2)
% SW x1, 4(x3)
%
% x1 is rs2 of the store.
% ============================================================

result = load_use_hazard( ...
    3, ...
    1, ...
    1, ...
    true, ...
    "LW");

if result.hazard && ...
   result.rs2Hazard && ...
   result.stall

    fprintf('LW -> STORE HAZARD         : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('LW -> STORE HAZARD         : FAIL\n');

end


% ============================================================
% TEST 10
% Store address depends on loaded register
%
% LW x5, 0(x1)
% SW x6, 0(x5)
%
% x5 is rs1 of the store.
% ============================================================

result = load_use_hazard( ...
    5, ...
    6, ...
    5, ...
    true, ...
    "LW");

if result.hazard && ...
   result.rs1Hazard && ...
   result.stall

    fprintf('LW -> ADDRESS HAZARD       : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('LW -> ADDRESS HAZARD       : FAIL\n');

end


% ============================================================
% FINAL RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                  STAGE 19.4 RESULTS\n');
fprintf('============================================================\n');

fprintf('Tests passed : %d / %d\n', ...
    testsPassed,totalTests);

fprintf('============================================================\n');


% ============================================================
% PASS / FAIL
% ============================================================

if testsPassed == totalTests

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 19.4 PASSED!\n');
    fprintf('       LOAD-USE HAZARD VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 19.4 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end