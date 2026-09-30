function stage20_4_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('                STAGE 20.4 - PIPELINE FLUSH\n');
fprintf('============================================================\n');

testsPassed = 0;
totalTests = 10;


% ============================================================
% TEST 1
% Taken branch must flush
% ============================================================

result = branch_flush(true);

if result.flush

    fprintf('TAKEN BRANCH FLUSH          : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('TAKEN BRANCH FLUSH          : FAIL\n');

end


% ============================================================
% TEST 2
% IF stage must be flushed
% ============================================================

result = branch_flush(true);

if result.flushIF

    fprintf('IF FLUSH                    : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('IF FLUSH                    : FAIL\n');

end


% ============================================================
% TEST 3
% ID stage must be flushed
% ============================================================

result = branch_flush(true);

if result.flushID

    fprintf('ID FLUSH                    : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('ID FLUSH                    : FAIL\n');

end


% ============================================================
% TEST 4
% PC must redirect after taken branch
% ============================================================

result = branch_flush(true);

if result.pcRedirect

    fprintf('PC REDIRECT CONTROL         : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('PC REDIRECT CONTROL         : FAIL\n');

end


% ============================================================
% TEST 5
% Not taken branch must not flush
% ============================================================

result = branch_flush(false);

if ~result.flush

    fprintf('NOT-TAKEN NO FLUSH          : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('NOT-TAKEN NO FLUSH          : FAIL\n');

end


% ============================================================
% TEST 6
% Not taken branch must not flush IF
% ============================================================

result = branch_flush(false);

if ~result.flushIF

    fprintf('NOT-TAKEN IF ACTIVE         : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('NOT-TAKEN IF ACTIVE         : FAIL\n');

end


% ============================================================
% TEST 7
% Not taken branch must not flush ID
% ============================================================

result = branch_flush(false);

if ~result.flushID

    fprintf('NOT-TAKEN ID ACTIVE         : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('NOT-TAKEN ID ACTIVE         : FAIL\n');

end


% ============================================================
% TEST 8
% Complete taken-branch flush
% ============================================================

result = branch_flush(true);

if result.flush && ...
   result.flushIF && ...
   result.flushID && ...
   result.pcRedirect

    fprintf('COMPLETE FLUSH CONTROL      : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('COMPLETE FLUSH CONTROL      : FAIL\n');

end


% ============================================================
% TEST 9
% Complete normal flow
% ============================================================

result = branch_flush(false);

if ~result.flush && ...
   ~result.flushIF && ...
   ~result.flushID && ...
   ~result.pcRedirect

    fprintf('NORMAL PIPELINE FLOW        : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('NORMAL PIPELINE FLOW        : FAIL\n');

end


% ============================================================
% TEST 10
% Repeated flush requests
% ============================================================

result1 = branch_flush(true);
result2 = branch_flush(true);

if result1.flush && ...
   result2.flush && ...
   result1.flushIF && ...
   result2.flushID

    fprintf('REPEATED FLUSH CONTROL      : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('REPEATED FLUSH CONTROL      : FAIL\n');

end


% ============================================================
% FINAL RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                  STAGE 20.4 RESULTS\n');
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
    fprintf('       STAGE 20.4 PASSED!\n');
    fprintf('       PIPELINE FLUSH VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 20.4 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end