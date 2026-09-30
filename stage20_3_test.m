function stage20_3_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('          STAGE 20.3 - BRANCH TARGET / PC REDIRECTION\n');
fprintf('============================================================\n');

testsPassed = 0;
totalTests = 10;


% ============================================================
% TEST 1
% Branch taken
%
% PC = 100
% Immediate = 16
% Target = 116
% ============================================================

result = branch_target( ...
    uint32(100), ...
    16, ...
    true);

if result.redirect && ...
   result.targetPc == uint32(116) && ...
   result.nextPc == uint32(116)

    fprintf('TAKEN BRANCH TARGET         : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('TAKEN BRANCH TARGET         : FAIL\n');

end


% ============================================================
% TEST 2
% Branch not taken
%
% PC = 100
% Next PC = 104
% ============================================================

result = branch_target( ...
    uint32(100), ...
    16, ...
    false);

if ~result.redirect && ...
   result.nextPc == uint32(104)

    fprintf('NOT-TAKEN NEXT PC           : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('NOT-TAKEN NEXT PC           : FAIL\n');

end


% ============================================================
% TEST 3
% Negative branch offset
%
% PC = 100
% Immediate = -20
% Target = 80
% ============================================================

result = branch_target( ...
    uint32(100), ...
    -20, ...
    true);

if result.redirect && ...
   result.targetPc == uint32(80)

    fprintf('NEGATIVE BRANCH OFFSET      : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('NEGATIVE BRANCH OFFSET      : FAIL\n');

end


% ============================================================
% TEST 4
% Zero offset
%
% PC = 100
% Immediate = 0
% Target = 100
% ============================================================

result = branch_target( ...
    uint32(100), ...
    0, ...
    true);

if result.redirect && ...
   result.targetPc == uint32(100)

    fprintf('ZERO OFFSET                 : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('ZERO OFFSET                 : FAIL\n');

end


% ============================================================
% TEST 5
% Immediate = 4
%
% PC = 200
% Target = 204
% ============================================================

result = branch_target( ...
    uint32(200), ...
    4, ...
    true);

if result.targetPc == uint32(204)

    fprintf('FORWARD OFFSET              : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('FORWARD OFFSET              : FAIL\n');

end


% ============================================================
% TEST 6
% Negative offset
%
% PC = 200
% Immediate = -100
% Target = 100
% ============================================================

result = branch_target( ...
    uint32(200), ...
    -100, ...
    true);

if result.targetPc == uint32(100)

    fprintf('BACKWARD OFFSET             : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('BACKWARD OFFSET             : FAIL\n');

end


% ============================================================
% TEST 7
% Branch at PC = 0
%
% Immediate = 20
% Target = 20
% ============================================================

result = branch_target( ...
    uint32(0), ...
    20, ...
    true);

if result.targetPc == uint32(20)

    fprintf('ZERO PC TARGET              : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('ZERO PC TARGET              : FAIL\n');

end


% ============================================================
% TEST 8
% Large PC value
% ============================================================

result = branch_target( ...
    uint32(1000), ...
    200, ...
    true);

if result.targetPc == uint32(1200)

    fprintf('LARGE PC TARGET             : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('LARGE PC TARGET             : FAIL\n');

end


% ============================================================
% TEST 9
% 32-bit wraparound
%
% 0xFFFFFFFC + 4 = 0
% ============================================================

pcValue = uint32(hex2dec('FFFFFFFC'));

result = branch_target( ...
    pcValue, ...
    4, ...
    true);

if result.targetPc == uint32(0)

    fprintf('32-BIT PC WRAPAROUND        : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('32-BIT PC WRAPAROUND        : FAIL\n');

end


% ============================================================
% TEST 10
% Not taken must ignore branch immediate
%
% PC = 500
% Immediate = 1000
% Next PC must be 504
% ============================================================

result = branch_target( ...
    uint32(500), ...
    1000, ...
    false);

if ~result.redirect && ...
   result.nextPc == uint32(504)

    fprintf('NOT-TAKEN IGNORES OFFSET    : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('NOT-TAKEN IGNORES OFFSET    : FAIL\n');

end


% ============================================================
% FINAL RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                  STAGE 20.3 RESULTS\n');
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
    fprintf('       STAGE 20.3 PASSED!\n');
    fprintf('       BRANCH TARGET VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 20.3 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end