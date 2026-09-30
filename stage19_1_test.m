function stage19_1_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('             STAGE 19.1 - RAW HAZARD DETECTION\n');
fprintf('============================================================\n');

testsPassed = 0;
totalTests = 10;


% ============================================================
% TEST 1
%
% ID reads x1
% EX writes x1
%
% Expected: hazard
% ============================================================

result = hazard_detection( ...
    1, ...
    2, ...
    1, ...
    true, ...
    0, ...
    false);

if result.hazard && result.rs1Hazard && result.exHazard

    fprintf('EX → RS1 RAW HAZARD       : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('EX → RS1 RAW HAZARD       : FAIL\n');

end


% ============================================================
% TEST 2
%
% ID reads x2
% EX writes x2
% ============================================================

result = hazard_detection( ...
    1, ...
    2, ...
    2, ...
    true, ...
    0, ...
    false);

if result.hazard && result.rs2Hazard && result.exHazard

    fprintf('EX → RS2 RAW HAZARD       : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('EX → RS2 RAW HAZARD       : FAIL\n');

end


% ============================================================
% TEST 3
%
% ID reads x3
% EX writes x4
%
% Expected: no hazard
% ============================================================

result = hazard_detection( ...
    3, ...
    5, ...
    4, ...
    true, ...
    0, ...
    false);

if ~result.hazard

    fprintf('NO EX RAW HAZARD          : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('NO EX RAW HAZARD          : FAIL\n');

end


% ============================================================
% TEST 4
%
% MEM writes x6
% ID reads x6
% ============================================================

result = hazard_detection( ...
    6, ...
    7, ...
    0, ...
    false, ...
    6, ...
    true);

if result.hazard && result.rs1Hazard && result.memHazard

    fprintf('MEM → RS1 RAW HAZARD      : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('MEM → RS1 RAW HAZARD      : FAIL\n');

end


% ============================================================
% TEST 5
%
% MEM writes x8
% ID reads x8 as rs2
% ============================================================

result = hazard_detection( ...
    5, ...
    8, ...
    0, ...
    false, ...
    8, ...
    true);

if result.hazard && result.rs2Hazard && result.memHazard

    fprintf('MEM → RS2 RAW HAZARD      : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('MEM → RS2 RAW HAZARD      : FAIL\n');

end


% ============================================================
% TEST 6
%
% EX writes x5
% MEM writes x6
% ID reads both x5 and x6
%
% Expected: both hazards
% ============================================================

result = hazard_detection( ...
    5, ...
    6, ...
    5, ...
    true, ...
    6, ...
    true);

if result.hazard && ...
   result.rs1Hazard && ...
   result.rs2Hazard && ...
   result.exHazard && ...
   result.memHazard

    fprintf('DUAL RAW HAZARD           : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('DUAL RAW HAZARD           : FAIL\n');

end


% ============================================================
% TEST 7
%
% EX writes x0
% ID reads x0
%
% x0 never creates a RAW hazard.
% ============================================================

result = hazard_detection( ...
    0, ...
    0, ...
    0, ...
    true, ...
    0, ...
    true);

if ~result.hazard

    fprintf('x0 HAZARD PROTECTION     : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('x0 HAZARD PROTECTION     : FAIL\n');

end


% ============================================================
% TEST 8
%
% EX has RegWrite disabled.
% Matching register must not create hazard.
% ============================================================

result = hazard_detection( ...
    4, ...
    7, ...
    4, ...
    false, ...
    0, ...
    false);

if ~result.hazard

    fprintf('REGWRITE DISABLED         : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('REGWRITE DISABLED         : FAIL\n');

end


% ============================================================
% TEST 9
%
% MEM has RegWrite disabled.
% ============================================================

result = hazard_detection( ...
    9, ...
    10, ...
    0, ...
    false, ...
    9, ...
    false);

if ~result.hazard

    fprintf('MEM REGWRITE DISABLED     : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('MEM REGWRITE DISABLED     : FAIL\n');

end


% ============================================================
% TEST 10
%
% No matching registers.
% ============================================================

result = hazard_detection( ...
    1, ...
    2, ...
    3, ...
    true, ...
    4, ...
    true);

if ~result.hazard && ...
   ~result.rs1Hazard && ...
   ~result.rs2Hazard

    fprintf('NO HAZARD CASE            : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('NO HAZARD CASE            : FAIL\n');

end


% ============================================================
% RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                  STAGE 19.1 RESULTS\n');
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
    fprintf('       STAGE 19.1 PASSED!\n');
    fprintf('       RAW HAZARD DETECTION VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 19.1 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end