function stage20_2_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('               STAGE 20.2 - BRANCH DECISION\n');
fprintf('============================================================\n');

testsPassed = 0;
totalTests = 10;


% ============================================================
% TEST 1 - BEQ TAKEN
% ============================================================

result = branch_decision( ...
    "BEQ", ...
    uint32(10), ...
    uint32(10));

if result.isBranch && ...
   result.taken && ...
   ~result.notTaken

    fprintf('BEQ TAKEN                   : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('BEQ TAKEN                   : FAIL\n');

end


% ============================================================
% TEST 2 - BEQ NOT TAKEN
% ============================================================

result = branch_decision( ...
    "BEQ", ...
    uint32(10), ...
    uint32(20));

if result.isBranch && ...
   ~result.taken && ...
   result.notTaken

    fprintf('BEQ NOT TAKEN               : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('BEQ NOT TAKEN               : FAIL\n');

end


% ============================================================
% TEST 3 - BNE
% ============================================================

result = branch_decision( ...
    "BNE", ...
    uint32(10), ...
    uint32(20));

if result.isBranch && result.taken

    fprintf('BNE TAKEN                   : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('BNE TAKEN                   : FAIL\n');

end


% ============================================================
% TEST 4 - BLT signed
%
% -5 < 10
% ============================================================

negativeFive = typecast(int32(-5),'uint32');

result = branch_decision( ...
    "BLT", ...
    negativeFive, ...
    uint32(10));

if result.isBranch && result.taken

    fprintf('BLT SIGNED                  : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('BLT SIGNED                  : FAIL\n');

end


% ============================================================
% TEST 5 - BGE signed
%
% 10 >= -5
% ============================================================

negativeFive = typecast(int32(-5),'uint32');

result = branch_decision( ...
    "BGE", ...
    uint32(10), ...
    negativeFive);

if result.isBranch && result.taken

    fprintf('BGE SIGNED                  : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('BGE SIGNED                  : FAIL\n');

end


% ============================================================
% TEST 6 - BLTU unsigned
%
% 5 < 10
% ============================================================

result = branch_decision( ...
    "BLTU", ...
    uint32(5), ...
    uint32(10));

if result.isBranch && result.taken

    fprintf('BLTU UNSIGNED               : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('BLTU UNSIGNED               : FAIL\n');

end


% ============================================================
% TEST 7 - BGEU unsigned
%
% 20 >= 10
% ============================================================

result = branch_decision( ...
    "BGEU", ...
    uint32(20), ...
    uint32(10));

if result.isBranch && result.taken

    fprintf('BGEU UNSIGNED               : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('BGEU UNSIGNED               : FAIL\n');

end


% ============================================================
% TEST 8 - Signed vs unsigned difference
%
% 0xFFFFFFFF = -1 signed
%
% -1 < 1       -> BLT TRUE
% 0xFFFFFFFF < 1 unsigned -> FALSE
% ============================================================

value = uint32(hex2dec('FFFFFFFF'));

signedResult = branch_decision( ...
    "BLT", ...
    value, ...
    uint32(1));

unsignedResult = branch_decision( ...
    "BLTU", ...
    value, ...
    uint32(1));

if signedResult.taken && ...
   ~unsignedResult.taken

    fprintf('SIGNED/UNSIGNED DIFFERENCE : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('SIGNED/UNSIGNED DIFFERENCE : FAIL\n');

end


% ============================================================
% TEST 9 - Non-branch instruction
% ============================================================

result = branch_decision( ...
    "ADD", ...
    uint32(10), ...
    uint32(10));

if ~result.isBranch && ...
   ~result.taken && ...
   result.branchType == "NONE"

    fprintf('NON-BRANCH                  : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('NON-BRANCH                  : FAIL\n');

end


% ============================================================
% TEST 10 - Case insensitive
% ============================================================

result = branch_decision( ...
    "bne", ...
    uint32(10), ...
    uint32(20));

if result.isBranch && ...
   result.branchType == "BNE" && ...
   result.taken

    fprintf('CASE INSENSITIVE            : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('CASE INSENSITIVE            : FAIL\n');

end


% ============================================================
% FINAL RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                  STAGE 20.2 RESULTS\n');
fprintf('============================================================\n');

fprintf('Tests passed : %d / %d\n', ...
    testsPassed,totalTests);

fprintf('============================================================\n');


if testsPassed == totalTests

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 20.2 PASSED!\n');
    fprintf('       BRANCH DECISION VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 20.2 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end