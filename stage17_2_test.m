function stage17_2_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('             STAGE 17.2 - CYCLE COUNTER\n');
fprintf('============================================================\n');


% ============================================================
% ASSEMBLY PROGRAM
% ============================================================

filename = fullfile( ...
    pwd, ...
    'programs', ...
    'stage16_15_final.asm');


% ============================================================
% INITIAL MEMORY
% ============================================================

initialMemory = zeros(64,1,'uint8');

initialMemory(1:4) = ...
    typecast(uint32(12),'uint8');

initialMemory(5:8) = ...
    typecast(uint32(18),'uint8');

initialMemory(9:12) = ...
    typecast(uint32(7),'uint8');

initialMemory(13:16) = ...
    typecast(uint32(25),'uint8');


% ============================================================
% READ PROGRAM
% ============================================================

program = assembly_reader(filename);


% ============================================================
% RUN CPU
% ============================================================

[registers,pc,halted,dataMemory, ...
    instructionCount,cycleCount] = cpu( ...
    program, ...
    3000, ...
    initialMemory);


% ============================================================
% TEST COUNTERS
% ============================================================

testsPassed = 0;

totalTests = 3;


% ============================================================
% TEST 1 — CPU HALTED
% ============================================================

if halted

    fprintf('CPU HALTED             : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('CPU HALTED             : FAIL\n');

end


% ============================================================
% TEST 2 — INSTRUCTION COUNTER
% ============================================================

if instructionCount == 81

    fprintf('INSTRUCTION COUNT = 81: PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('INSTRUCTION COUNT     : FAIL (got %d)\n', ...
        instructionCount);

end


% ============================================================
% TEST 3 — CYCLE COUNTER
% ============================================================

if cycleCount == 82

    fprintf('CYCLE COUNT = 82      : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('CYCLE COUNT            : FAIL (got %d)\n', ...
        cycleCount);

end


% ============================================================
% DISPLAY RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                  STAGE 17.2 RESULTS\n');
fprintf('============================================================\n');

fprintf('Instructions executed : %d\n', ...
    instructionCount);

fprintf('CPU cycles             : %d\n', ...
    cycleCount);

fprintf('Final PC               : %u\n', ...
    pc);

fprintf('CPU halted             : %s\n', ...
    string(halted));

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
    fprintf('       STAGE 17.2 PASSED!\n');
    fprintf('       CYCLE COUNTER VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 17.2 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end