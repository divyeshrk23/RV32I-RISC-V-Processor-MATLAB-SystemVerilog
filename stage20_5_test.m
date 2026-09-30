function stage20_5_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('          STAGE 20.5 - BRANCH CONTROL INTEGRATION\n');
fprintf('============================================================\n');

testsPassed = 0;
totalTests = 10;


% ============================================================
% TEST 1
% BEQ taken
% ============================================================

result = branch_control( ...
    "BEQ", ...
    uint32(100), ...
    uint32(10), ...
    uint32(10), ...
    16, ...
    false);

if result.isBranch && ...
   result.taken && ...
   result.redirect && ...
   result.targetPc == uint32(116) && ...
   result.flush

    fprintf('BEQ TAKEN CONTROL            : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('BEQ TAKEN CONTROL            : FAIL\n');

end


% ============================================================
% TEST 2
% BEQ not taken
% ============================================================

result = branch_control( ...
    "BEQ", ...
    uint32(100), ...
    uint32(10), ...
    uint32(20), ...
    16, ...
    false);

if result.isBranch && ...
   ~result.taken && ...
   ~result.redirect && ...
   result.nextPc == uint32(104) && ...
   ~result.flush

    fprintf('BEQ NOT TAKEN CONTROL        : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('BEQ NOT TAKEN CONTROL        : FAIL\n');

end


% ============================================================
% TEST 3
% BLT signed taken
% ============================================================

negativeFive = typecast(int32(-5),'uint32');

result = branch_control( ...
    "BLT", ...
    uint32(200), ...
    negativeFive, ...
    uint32(10), ...
    20, ...
    false);

if result.taken && ...
   result.targetPc == uint32(220) && ...
   result.flush

    fprintf('BLT TAKEN CONTROL            : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('BLT TAKEN CONTROL            : FAIL\n');

end


% ============================================================
% TEST 4
% BNE taken
% ============================================================

result = branch_control( ...
    "BNE", ...
    uint32(300), ...
    uint32(1), ...
    uint32(2), ...
    -20, ...
    false);

if result.taken && ...
   result.targetPc == uint32(280) && ...
   result.flush

    fprintf('BNE BACKWARD BRANCH          : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('BNE BACKWARD BRANCH          : FAIL\n');

end


% ============================================================
% TEST 5
% Load-use stall
% ============================================================

result = branch_control( ...
    "ADD", ...
    uint32(100), ...
    uint32(10), ...
    uint32(20), ...
    0, ...
    true);

if ~result.isBranch && ...
   result.stall && ...
   ~result.pcWrite && ...
   ~result.ifIdWrite && ...
   result.idExFlush

    fprintf('LOAD-USE STALL CONTROL       : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('LOAD-USE STALL CONTROL       : FAIL\n');

end


% ============================================================
% TEST 6
% Normal non-branch operation
% ============================================================

result = branch_control( ...
    "ADD", ...
    uint32(500), ...
    uint32(10), ...
    uint32(20), ...
    100, ...
    false);

if ~result.isBranch && ...
   ~result.stall && ...
   ~result.flush && ...
   result.nextPc == uint32(504)

    fprintf('NORMAL CONTROL FLOW          : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('NORMAL CONTROL FLOW          : FAIL\n');

end


% ============================================================
% TEST 7
% BGE not taken
% ============================================================

result = branch_control( ...
    "BGE", ...
    uint32(600), ...
    uint32(5), ...
    uint32(10), ...
    40, ...
    false);

if result.isBranch && ...
   ~result.taken && ...
   ~result.flush && ...
   result.nextPc == uint32(604)

    fprintf('BGE NOT TAKEN                : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('BGE NOT TAKEN                : FAIL\n');

end


% ============================================================
% TEST 8
% Taken branch must flush wrong path
% ============================================================

result = branch_control( ...
    "BNE", ...
    uint32(700), ...
    uint32(50), ...
    uint32(60), ...
    12, ...
    false);

if result.taken && ...
   result.flush && ...
   result.flushIF && ...
   result.flushID && ...
   result.idExFlush

    fprintf('WRONG-PATH FLUSH             : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('WRONG-PATH FLUSH             : FAIL\n');

end


% ============================================================
% TEST 9
% x0 comparison
% ============================================================

result = branch_control( ...
    "BEQ", ...
    uint32(800), ...
    uint32(0), ...
    uint32(0), ...
    20, ...
    false);

if result.taken && ...
   result.targetPc == uint32(820) && ...
   result.flush

    fprintf('x0 BRANCH CONTROL            : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('x0 BRANCH CONTROL            : FAIL\n');

end


% ============================================================
% TEST 10
% Branch + load-use condition
%
% Branch itself is taken, so redirect + flush are required.
% ============================================================

result = branch_control( ...
    "BEQ", ...
    uint32(1000), ...
    uint32(5), ...
    uint32(5), ...
    -100, ...
    true);

if result.taken && ...
   result.redirect && ...
   result.flush && ...
   result.flushIF && ...
   result.flushID && ...
   result.idExFlush

    fprintf('BRANCH + HAZARD CONTROL      : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('BRANCH + HAZARD CONTROL      : FAIL\n');

end


% ============================================================
% FINAL RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                  STAGE 20.5 RESULTS\n');
fprintf('============================================================\n');

fprintf('Tests passed : %d / %d\n', ...
    testsPassed,totalTests);

fprintf('============================================================\n');


if testsPassed == totalTests

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 20.5 PASSED!\n');
    fprintf('       BRANCH CONTROL INTEGRATED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 20.5 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end