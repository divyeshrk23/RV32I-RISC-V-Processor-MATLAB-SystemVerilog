function stage20_7_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('          STAGE 20.7 - FINAL BRANCH & JUMP VERIFICATION\n');
fprintf('============================================================\n');

testsPassed = 0;
totalTests = 10;


% ============================================================
% TEST 1 - BEQ taken
% ============================================================

result = branch_control( ...
    "BEQ", ...
    uint32(100), ...
    uint32(10), ...
    uint32(10), ...
    20, ...
    false);

if result.isBranch && ...
   result.taken && ...
   result.targetPc == uint32(120) && ...
   result.redirect && ...
   result.flush

    fprintf('BEQ TAKEN                   : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('BEQ TAKEN                   : FAIL\n');

end


% ============================================================
% TEST 2 - BNE not taken
% ============================================================

result = branch_control( ...
    "BNE", ...
    uint32(200), ...
    uint32(10), ...
    uint32(10), ...
    40, ...
    false);

if result.isBranch && ...
   ~result.taken && ...
   result.nextPc == uint32(204) && ...
   ~result.flush

    fprintf('BNE NOT TAKEN               : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('BNE NOT TAKEN               : FAIL\n');

end


% ============================================================
% TEST 3 - BLT signed
% ============================================================

negativeTen = typecast(int32(-10),'uint32');

result = branch_control( ...
    "BLT", ...
    uint32(300), ...
    negativeTen, ...
    uint32(5), ...
    16, ...
    false);

if result.taken && ...
   result.targetPc == uint32(316) && ...
   result.flush

    fprintf('BLT SIGNED                  : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('BLT SIGNED                  : FAIL\n');

end


% ============================================================
% TEST 4 - BGEU unsigned
% ============================================================

result = branch_control( ...
    "BGEU", ...
    uint32(400), ...
    uint32(20), ...
    uint32(10), ...
    12, ...
    false);

if result.taken && ...
   result.targetPc == uint32(412) && ...
   result.flush

    fprintf('BGEU UNSIGNED               : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('BGEU UNSIGNED               : FAIL\n');

end


% ============================================================
% TEST 5 - Backward branch
% ============================================================

result = branch_control( ...
    "BNE", ...
    uint32(500), ...
    uint32(1), ...
    uint32(2), ...
    -100, ...
    false);

if result.taken && ...
   result.targetPc == uint32(400) && ...
   result.flush

    fprintf('BACKWARD BRANCH             : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('BACKWARD BRANCH             : FAIL\n');

end


% ============================================================
% TEST 6 - Load-use stall
% ============================================================

result = branch_control( ...
    "ADD", ...
    uint32(600), ...
    uint32(10), ...
    uint32(20), ...
    0, ...
    true);

if ~result.isBranch && ...
   result.stall && ...
   ~result.pcWrite && ...
   ~result.ifIdWrite && ...
   result.idExFlush

    fprintf('LOAD-USE STALL              : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('LOAD-USE STALL              : FAIL\n');

end


% ============================================================
% TEST 7 - JAL
% ============================================================

result = jump_control( ...
    "JAL", ...
    uint32(700), ...
    uint32(0), ...
    40);

if result.isJump && ...
   result.isJAL && ...
   result.targetPc == uint32(740) && ...
   result.returnAddress == uint32(704) && ...
   result.redirect

    fprintf('JAL                         : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('JAL                         : FAIL\n');

end


% ============================================================
% TEST 8 - JALR
% ============================================================

result = jump_control( ...
    "JALR", ...
    uint32(800), ...
    uint32(1001), ...
    20);

if result.isJump && ...
   result.isJALR && ...
   result.targetPc == uint32(1020) && ...
   result.returnAddress == uint32(804) && ...
   result.redirect

    fprintf('JALR                        : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('JALR                        : FAIL\n');

end


% ============================================================
% TEST 9 - Taken branch flush
% ============================================================

flush = branch_flush(true);

if flush.flush && ...
   flush.flushIF && ...
   flush.flushID && ...
   flush.pcRedirect

    fprintf('TAKEN BRANCH FLUSH          : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('TAKEN BRANCH FLUSH          : FAIL\n');

end


% ============================================================
% TEST 10 - Normal instruction
% ============================================================

branch = branch_detection("ADD");

jump = jump_control( ...
    "ADD", ...
    uint32(900), ...
    uint32(0), ...
    100);

if ~branch.isBranch && ...
   ~jump.isJump && ...
   ~jump.redirect && ...
   jump.nextPc == uint32(904)

    fprintf('NORMAL INSTRUCTION          : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('NORMAL INSTRUCTION          : FAIL\n');

end


% ============================================================
% FINAL RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                  STAGE 20.7 RESULTS\n');
fprintf('============================================================\n');

fprintf('Tests passed : %d / %d\n', ...
    testsPassed,totalTests);

fprintf('============================================================\n');


% ============================================================
% FINAL STAGE RESULT
% ============================================================

if testsPassed == totalTests

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 20.7 PASSED!\n');
    fprintf('       FINAL BRANCH & JUMP VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 20.7 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end