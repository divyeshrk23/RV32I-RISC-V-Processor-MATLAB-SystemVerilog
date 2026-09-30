function stage18_1_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('       STAGE 18.1 - PIPELINE ARCHITECTURE TEST\n');
fprintf('============================================================\n');


% ============================================================
% CREATE PIPELINE STATE
% ============================================================

state = pipeline_state();


testsPassed = 0;

totalTests = 10;


% ============================================================
% TEST 1 — PC
% ============================================================

if state.pc == uint32(0)

    fprintf('PC INITIALIZED = 0        : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('PC INITIALIZED = 0        : FAIL\n');

end


% ============================================================
% TEST 2 — IF STAGE
% ============================================================

if isfield(state,'IF')

    fprintf('IF STAGE EXISTS           : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('IF STAGE EXISTS           : FAIL\n');

end


% ============================================================
% TEST 3 — ID STAGE
% ============================================================

if isfield(state,'ID')

    fprintf('ID STAGE EXISTS           : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('ID STAGE EXISTS           : FAIL\n');

end


% ============================================================
% TEST 4 — EX STAGE
% ============================================================

if isfield(state,'EX')

    fprintf('EX STAGE EXISTS           : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('EX STAGE EXISTS           : FAIL\n');

end


% ============================================================
% TEST 5 — MEM STAGE
% ============================================================

if isfield(state,'MEM')

    fprintf('MEM STAGE EXISTS          : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('MEM STAGE EXISTS          : FAIL\n');

end


% ============================================================
% TEST 6 — WB STAGE
% ============================================================

if isfield(state,'WB')

    fprintf('WB STAGE EXISTS           : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('WB STAGE EXISTS           : FAIL\n');

end


% ============================================================
% TEST 7 — FIVE STAGES
% ============================================================

if length(state.stageNames) == 5

    fprintf('FIVE PIPELINE STAGES      : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('FIVE PIPELINE STAGES      : FAIL\n');

end


% ============================================================
% TEST 8 — STAGE ORDER
% ============================================================

expectedNames = {'IF','ID','EX','MEM','WB'};

if isequal(state.stageNames,expectedNames)

    fprintf('STAGE ORDER IF-ID-EX-MEM-WB: PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('STAGE ORDER                : FAIL\n');

end


% ============================================================
% TEST 9 — INITIAL VALID STATE
% ============================================================

if all(state.stageValid == false)

    fprintf('PIPELINE INIT EMPTY       : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('PIPELINE INIT EMPTY       : FAIL\n');

end


% ============================================================
% TEST 10 — HALT STATE
% ============================================================

if state.halted == false && state.cycle == 0

    fprintf('INITIAL CPU CONTROL       : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('INITIAL CPU CONTROL       : FAIL\n');

end


% ============================================================
% RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                  STAGE 18.1 RESULTS\n');
fprintf('============================================================\n');

fprintf('Pipeline stages : IF -> ID -> EX -> MEM -> WB\n');

fprintf('Tests passed    : %d / %d\n', ...
    testsPassed,totalTests);

fprintf('============================================================\n');


% ============================================================
% FINAL RESULT
% ============================================================

if testsPassed == totalTests

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 18.1 PASSED!\n');
    fprintf('       PIPELINE ARCHITECTURE VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 18.1 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end