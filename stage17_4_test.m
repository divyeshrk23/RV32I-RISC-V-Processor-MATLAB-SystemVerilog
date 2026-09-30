function stage17_4_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('          STAGE 17.4 - LOAD/STORE STATISTICS\n');
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
    instructionCount,cycleCount, ...
    addCount,subCount,andCount,orCount, ...
    xorCount,sltCount,sltuCount, ...
    aluOperationCount, ...
    loadCount,storeCount,memoryOperationCount] = cpu( ...
    program, ...
    3000, ...
    initialMemory);


% ============================================================
% TEST COUNTERS
% ============================================================

testsPassed = 0;

totalTests = 6;


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
% TEST 2 — INSTRUCTION COUNT
% ============================================================

if instructionCount == 81

    fprintf('INSTRUCTION COUNT = 81: PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('INSTRUCTION COUNT     : FAIL (got %d)\n', ...
        instructionCount);

end


% ============================================================
% TEST 3 — CYCLE COUNT
% ============================================================

if cycleCount == 82

    fprintf('CYCLE COUNT = 82      : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('CYCLE COUNT            : FAIL (got %d)\n', ...
        cycleCount);

end


% ============================================================
% TEST 4 — LOAD COUNT
% ============================================================

if loadCount == 4

    fprintf('LOAD COUNT = 4        : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('LOAD COUNT             : FAIL (got %d)\n', ...
        loadCount);

end


% ============================================================
% TEST 5 — STORE COUNT
% ============================================================

if storeCount == 5

    fprintf('STORE COUNT = 5       : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('STORE COUNT            : FAIL (got %d)\n', ...
        storeCount);

end


% ============================================================
% TEST 6 — TOTAL MEMORY OPERATIONS
% ============================================================

if memoryOperationCount == 9

    fprintf('MEMORY OPS = 9        : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('MEMORY OPS             : FAIL (got %d)\n', ...
        memoryOperationCount);

end


% ============================================================
% DISPLAY RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                  STAGE 17.4 RESULTS\n');
fprintf('============================================================\n');

fprintf('Instructions executed : %d\n', ...
    instructionCount);

fprintf('CPU cycles             : %d\n', ...
    cycleCount);

fprintf('\n');

fprintf('Memory operations      : %d\n', ...
    memoryOperationCount);

fprintf('  Loads                : %d\n', ...
    loadCount);

fprintf('  Stores               : %d\n', ...
    storeCount);

fprintf('\n');

fprintf('ALU operations         : %d\n', ...
    aluOperationCount);

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
    fprintf('       STAGE 17.4 PASSED!\n');
    fprintf('       LOAD/STORE STATISTICS VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 17.4 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end