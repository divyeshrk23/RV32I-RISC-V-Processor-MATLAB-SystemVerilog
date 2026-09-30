function stage17_7_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('        STAGE 17.7 - MEMORY ACCESS STATISTICS\n');
fprintf('============================================================\n');


% ============================================================
% PROGRAM
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
    loadCount,storeCount,memoryOperationCount, ...
    beqCount,bneCount,bltCount,bgeCount, ...
    bltuCount,bgeuCount, ...
    branchCount,branchTakenCount,branchNotTakenCount, ...
    jalCount,jalrCount,jumpCount, ...
    controlFlowCount, ...
    registerWriteCount,x0WriteAttemptCount, ...
    actualRegisterWriteCount, ...
    memoryReadCount,memoryWriteCount, ...
    totalMemoryAccessCount, ...
    lbCount,lbuCount,lhCount,lhuCount,lwCount, ...
    sbCount,shCount,swCount] = cpu( ...
    program, ...
    3000, ...
    initialMemory);


% ============================================================
% TEST COUNTER
% ============================================================

testsPassed = 0;

totalTests = 10;


% ============================================================
% TEST 1 — CPU HALTED
% ============================================================

if halted

    fprintf('CPU HALTED              : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('CPU HALTED              : FAIL\n');

end


% ============================================================
% TEST 2 — MEMORY READS
% ============================================================

if memoryReadCount == 4

    fprintf('MEMORY READS = 4       : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('MEMORY READS            : FAIL (got %d)\n', ...
        memoryReadCount);

end


% ============================================================
% TEST 3 — MEMORY WRITES
% ============================================================

if memoryWriteCount == 5

    fprintf('MEMORY WRITES = 5      : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('MEMORY WRITES           : FAIL (got %d)\n', ...
        memoryWriteCount);

end


% ============================================================
% TEST 4 — TOTAL MEMORY ACCESS
% ============================================================

if totalMemoryAccessCount == 9

    fprintf('TOTAL MEMORY ACCESS = 9: PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('TOTAL MEMORY ACCESS     : FAIL (got %d)\n', ...
        totalMemoryAccessCount);

end


% ============================================================
% TEST 5 — LW
% ============================================================

if lwCount == 4

    fprintf('LW COUNT = 4           : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('LW COUNT                : FAIL (got %d)\n', ...
        lwCount);

end


% ============================================================
% TEST 6 — SW
% ============================================================

if swCount == 5

    fprintf('SW COUNT = 5           : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('SW COUNT                : FAIL (got %d)\n', ...
        swCount);

end


% ============================================================
% TEST 7 — OTHER LOAD TYPES
% ============================================================

if lbCount == 0 && ...
   lbuCount == 0 && ...
   lhCount == 0 && ...
   lhuCount == 0

    fprintf('OTHER LOAD TYPES = 0   : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('OTHER LOAD TYPES        : FAIL\n');

end


% ============================================================
% TEST 8 — OTHER STORE TYPES
% ============================================================

if sbCount == 0 && shCount == 0

    fprintf('OTHER STORE TYPES = 0  : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('OTHER STORE TYPES       : FAIL\n');

end


% ============================================================
% TEST 9 — GENERAL MEMORY CONSISTENCY
% ============================================================

if memoryOperationCount == ...
        totalMemoryAccessCount

    fprintf('MEMORY COUNT CONSISTENCY: PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('MEMORY COUNT CONSISTENCY: FAIL\n');

end


% ============================================================
% TEST 10 — READ/WRITE CONSISTENCY
% ============================================================

if totalMemoryAccessCount == ...
        memoryReadCount + memoryWriteCount

    fprintf('READ/WRITE CONSISTENCY : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('READ/WRITE CONSISTENCY  : FAIL\n');

end


% ============================================================
% RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                 STAGE 17.7 RESULTS\n');
fprintf('============================================================\n');

fprintf('Memory reads           : %d\n', ...
    memoryReadCount);

fprintf('Memory writes          : %d\n', ...
    memoryWriteCount);

fprintf('Total memory accesses  : %d\n', ...
    totalMemoryAccessCount);

fprintf('\n');

fprintf('Load types:\n');

fprintf('  LB                   : %d\n',lbCount);
fprintf('  LBU                  : %d\n',lbuCount);
fprintf('  LH                   : %d\n',lhCount);
fprintf('  LHU                  : %d\n',lhuCount);
fprintf('  LW                   : %d\n',lwCount);

fprintf('\n');

fprintf('Store types:\n');

fprintf('  SB                   : %d\n',sbCount);
fprintf('  SH                   : %d\n',shCount);
fprintf('  SW                   : %d\n',swCount);

fprintf('\n');

fprintf('Instructions           : %d\n', ...
    instructionCount);

fprintf('Cycles                 : %d\n', ...
    cycleCount);

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
    fprintf('       STAGE 17.7 PASSED!\n');
    fprintf('       MEMORY ACCESS STATISTICS VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 17.7 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end