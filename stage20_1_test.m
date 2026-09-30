function stage20_1_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('              STAGE 20.1 - BRANCH DETECTION\n');
fprintf('============================================================\n');

testsPassed = 0;
totalTests = 10;


% ============================================================
% TEST 1 - BEQ
% ============================================================

result = branch_detection("BEQ");

if result.isBranch && ...
   result.branchType == "BEQ" && ...
   result.isBEQ

    fprintf('BEQ DETECTION               : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('BEQ DETECTION               : FAIL\n');

end


% ============================================================
% TEST 2 - BNE
% ============================================================

result = branch_detection("BNE");

if result.isBranch && ...
   result.branchType == "BNE" && ...
   result.isBNE

    fprintf('BNE DETECTION               : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('BNE DETECTION               : FAIL\n');

end


% ============================================================
% TEST 3 - BLT
% ============================================================

result = branch_detection("BLT");

if result.isBranch && ...
   result.branchType == "BLT" && ...
   result.isBLT

    fprintf('BLT DETECTION               : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('BLT DETECTION               : FAIL\n');

end


% ============================================================
% TEST 4 - BGE
% ============================================================

result = branch_detection("BGE");

if result.isBranch && ...
   result.branchType == "BGE" && ...
   result.isBGE

    fprintf('BGE DETECTION               : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('BGE DETECTION               : FAIL\n');

end


% ============================================================
% TEST 5 - BLTU
% ============================================================

result = branch_detection("BLTU");

if result.isBranch && ...
   result.branchType == "BLTU" && ...
   result.isBLTU

    fprintf('BLTU DETECTION              : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('BLTU DETECTION              : FAIL\n');

end


% ============================================================
% TEST 6 - BGEU
% ============================================================

result = branch_detection("BGEU");

if result.isBranch && ...
   result.branchType == "BGEU" && ...
   result.isBGEU

    fprintf('BGEU DETECTION              : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('BGEU DETECTION              : FAIL\n');

end


% ============================================================
% TEST 7 - ADD is not a branch
% ============================================================

result = branch_detection("ADD");

if ~result.isBranch && ...
   result.branchType == "NONE"

    fprintf('NON-BRANCH DETECTION        : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('NON-BRANCH DETECTION        : FAIL\n');

end


% ============================================================
% TEST 8 - LW is not a branch
% ============================================================

result = branch_detection("LW");

if ~result.isBranch && ...
   result.branchType == "NONE"

    fprintf('LOAD NON-BRANCH             : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('LOAD NON-BRANCH             : FAIL\n');

end


% ============================================================
% TEST 9 - JAL is not a conditional branch
% ============================================================

result = branch_detection("JAL");

if ~result.isBranch && ...
   result.branchType == "NONE"

    fprintf('JAL NON-BRANCH              : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('JAL NON-BRANCH              : FAIL\n');

end


% ============================================================
% TEST 10 - Case insensitive detection
% ============================================================

result = branch_detection("beq");

if result.isBranch && ...
   result.branchType == "BEQ"

    fprintf('CASE INSENSITIVE             : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('CASE INSENSITIVE             : FAIL\n');

end


% ============================================================
% FINAL RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                  STAGE 20.1 RESULTS\n');
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
    fprintf('       STAGE 20.1 PASSED!\n');
    fprintf('       BRANCH DETECTION VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 20.1 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end