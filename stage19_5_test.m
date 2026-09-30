function stage19_5_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('               STAGE 19.5 - PIPELINE STALL\n');
fprintf('============================================================\n');

testsPassed = 0;
totalTests = 10;


% ============================================================
% TEST 1
% No hazard
% ============================================================

result = pipeline_stall(false);

if ~result.stall && ...
   result.pcWrite && ...
   result.ifIdWrite && ...
   ~result.idExFlush && ...
   ~result.insertBubble

    fprintf('NO HAZARD - NORMAL FLOW     : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('NO HAZARD - NORMAL FLOW     : FAIL\n');

end


% ============================================================
% TEST 2
% Hazard detected
% ============================================================

result = pipeline_stall(true);

if result.stall

    fprintf('HAZARD DETECTED             : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('HAZARD DETECTED             : FAIL\n');

end


% ============================================================
% TEST 3
% PC must be held
% ============================================================

result = pipeline_stall(true);

if ~result.pcWrite

    fprintf('PC HOLD                     : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('PC HOLD                     : FAIL\n');

end


% ============================================================
% TEST 4
% IF/ID must be held
% ============================================================

result = pipeline_stall(true);

if ~result.ifIdWrite

    fprintf('IF/ID HOLD                  : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('IF/ID HOLD                  : FAIL\n');

end


% ============================================================
% TEST 5
% ID/EX must be flushed
% ============================================================

result = pipeline_stall(true);

if result.idExFlush

    fprintf('ID/EX FLUSH                 : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('ID/EX FLUSH                 : FAIL\n');

end


% ============================================================
% TEST 6
% Bubble must be inserted
% ============================================================

result = pipeline_stall(true);

if result.insertBubble

    fprintf('PIPELINE BUBBLE             : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('PIPELINE BUBBLE             : FAIL\n');

end


% ============================================================
% TEST 7
% No hazard means PC continues
% ============================================================

result = pipeline_stall(false);

if result.pcWrite

    fprintf('PC NORMAL WRITE             : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('PC NORMAL WRITE             : FAIL\n');

end


% ============================================================
% TEST 8
% No hazard means IF/ID continues
% ============================================================

result = pipeline_stall(false);

if result.ifIdWrite

    fprintf('IF/ID NORMAL WRITE          : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('IF/ID NORMAL WRITE          : FAIL\n');

end


% ============================================================
% TEST 9
% No hazard means no bubble
% ============================================================

result = pipeline_stall(false);

if ~result.idExFlush && ...
   ~result.insertBubble

    fprintf('NO UNNECESSARY BUBBLE       : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('NO UNNECESSARY BUBBLE       : FAIL\n');

end


% ============================================================
% TEST 10
% Complete stall control
% ============================================================

result = pipeline_stall(true);

if result.stall && ...
   ~result.pcWrite && ...
   ~result.ifIdWrite && ...
   result.idExFlush && ...
   result.insertBubble

    fprintf('COMPLETE STALL CONTROL      : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('COMPLETE STALL CONTROL      : FAIL\n');

end


% ============================================================
% FINAL RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                  STAGE 19.5 RESULTS\n');
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
    fprintf('       STAGE 19.5 PASSED!\n');
    fprintf('       PIPELINE STALL VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 19.5 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end