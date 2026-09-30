function stage17_10_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('       STAGE 17.10 - FINAL STAGE 17 BENCHMARK\n');
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
    sbCount,shCount,swCount, ...
    cpi,performanceReport] = cpu( ...
    program, ...
    3000, ...
    initialMemory);


% ============================================================
% TEST COUNTER
% ============================================================

testsPassed = 0;

totalTests = 20;


% ============================================================
% TEST 1 — CPU HALTED
% ============================================================

if halted

    fprintf('CPU HALTED                  : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('CPU HALTED                  : FAIL\n');

end


% ============================================================
% TEST 2 — INSTRUCTION COUNT
% ============================================================

if instructionCount == 81

    fprintf('INSTRUCTIONS = 81          : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('INSTRUCTIONS = 81          : FAIL (got %d)\n', ...
        instructionCount);

end


% ============================================================
% TEST 3 — CYCLE COUNT
% ============================================================

if cycleCount == 82

    fprintf('CYCLES = 82                : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('CYCLES = 82                : FAIL (got %d)\n', ...
        cycleCount);

end


% ============================================================
% TEST 4 — CPI
% ============================================================

expectedCPI = 82 / 81;

if abs(cpi - expectedCPI) < 1e-10

    fprintf('CPI = 1.0123               : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('CPI = 1.0123               : FAIL (got %.6f)\n', ...
        cpi);

end


% ============================================================
% TEST 5 — ADD
% ============================================================

if addCount == 16

    fprintf('ADD = 16                   : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('ADD = 16                   : FAIL (got %d)\n', ...
        addCount);

end


% ============================================================
% TEST 6 — SUB
% ============================================================

if subCount == 8

    fprintf('SUB = 8                    : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('SUB = 8                    : FAIL (got %d)\n', ...
        subCount);

end


% ============================================================
% TEST 7 — TOTAL ALU OPERATIONS
% ============================================================

if aluOperationCount == 24

    fprintf('ALU OPERATIONS = 24        : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('ALU OPERATIONS = 24        : FAIL (got %d)\n', ...
        aluOperationCount);

end


% ============================================================
% TEST 8 — LOADS
% ============================================================

if loadCount == 4

    fprintf('LOADS = 4                  : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('LOADS = 4                  : FAIL (got %d)\n', ...
        loadCount);

end


% ============================================================
% TEST 9 — STORES
% ============================================================

if storeCount == 5

    fprintf('STORES = 5                 : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('STORES = 5                 : FAIL (got %d)\n', ...
        storeCount);

end


% ============================================================
% TEST 10 — TOTAL MEMORY OPERATIONS
% ============================================================

if memoryOperationCount == 9

    fprintf('MEMORY OPERATIONS = 9      : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('MEMORY OPERATIONS = 9      : FAIL (got %d)\n', ...
        memoryOperationCount);

end


% ============================================================
% TEST 11 — BRANCHES
% ============================================================

if branchCount == 29

    fprintf('BRANCHES = 29              : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('BRANCHES = 29              : FAIL (got %d)\n', ...
        branchCount);

end


% ============================================================
% TEST 12 — TAKEN BRANCHES
% ============================================================

if branchTakenCount == 11

    fprintf('TAKEN BRANCHES = 11        : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('TAKEN BRANCHES = 11        : FAIL (got %d)\n', ...
        branchTakenCount);

end


% ============================================================
% TEST 13 — NOT TAKEN BRANCHES
% ============================================================

if branchNotTakenCount == 18

    fprintf('NOT TAKEN BRANCHES = 18    : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('NOT TAKEN BRANCHES = 18    : FAIL (got %d)\n', ...
        branchNotTakenCount);

end


% ============================================================
% TEST 14 — JUMPS
% ============================================================

if jumpCount == 12

    fprintf('JUMPS = 12                 : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('JUMPS = 12                 : FAIL (got %d)\n', ...
        jumpCount);

end


% ============================================================
% TEST 15 — JAL
% ============================================================

if jalCount == 12

    fprintf('JAL = 12                   : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('JAL = 12                   : FAIL (got %d)\n', ...
        jalCount);

end


% ============================================================
% TEST 16 — REGISTER WRITES
% ============================================================

if registerWriteCount == 47

    fprintf('REGISTER WRITES = 47       : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('REGISTER WRITES = 47       : FAIL (got %d)\n', ...
        registerWriteCount);

end


% ============================================================
% TEST 17 — X0 WRITE ATTEMPTS
% ============================================================

if x0WriteAttemptCount == 12

    fprintf('X0 WRITE ATTEMPTS = 12     : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('X0 WRITE ATTEMPTS = 12     : FAIL (got %d)\n', ...
        x0WriteAttemptCount);

end


% ============================================================
% TEST 18 — ACTUAL REGISTER WRITES
% ============================================================

if actualRegisterWriteCount == 35

    fprintf('ACTUAL REGISTER WRITES = 35: PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('ACTUAL REGISTER WRITES = 35: FAIL (got %d)\n', ...
        actualRegisterWriteCount);

end


% ============================================================
% TEST 19 — MEMORY READ/WRITE TOTAL
% ============================================================

if memoryReadCount == 4 && ...
   memoryWriteCount == 5 && ...
   totalMemoryAccessCount == 9

    fprintf('MEMORY READ/WRITE TOTAL    : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('MEMORY READ/WRITE TOTAL    : FAIL\n');

end


% ============================================================
% TEST 20 — CONTROL FLOW
% ============================================================

if controlFlowCount == 41

    fprintf('CONTROL FLOW = 41          : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('CONTROL FLOW = 41          : FAIL (got %d)\n', ...
        controlFlowCount);

end


% ============================================================
% FINAL REPORT
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('             FINAL STAGE 17 PERFORMANCE DATA\n');
fprintf('============================================================\n');

fprintf('\n');

fprintf('Instructions          : %d\n', ...
    instructionCount);

fprintf('Cycles                : %d\n', ...
    cycleCount);

fprintf('CPI                   : %.4f\n', ...
    cpi);


fprintf('\n');

fprintf('ALU operations        : %d\n', ...
    aluOperationCount);

fprintf('  ADD                 : %d\n', ...
    addCount);

fprintf('  SUB                 : %d\n', ...
    subCount);


fprintf('\n');

fprintf('Memory operations     : %d\n', ...
    memoryOperationCount);

fprintf('  Loads               : %d\n', ...
    loadCount);

fprintf('  Stores              : %d\n', ...
    storeCount);

fprintf('Memory reads          : %d\n', ...
    memoryReadCount);

fprintf('Memory writes         : %d\n', ...
    memoryWriteCount);


fprintf('\n');

fprintf('Branches              : %d\n', ...
    branchCount);

fprintf('  Taken               : %d\n', ...
    branchTakenCount);

fprintf('  Not taken           : %d\n', ...
    branchNotTakenCount);


fprintf('\n');

fprintf('Jumps                 : %d\n', ...
    jumpCount);

fprintf('  JAL                 : %d\n', ...
    jalCount);

fprintf('  JALR                : %d\n', ...
    jalrCount);


fprintf('\n');

fprintf('Register writes       : %d\n', ...
    registerWriteCount);

fprintf('Actual writes         : %d\n', ...
    actualRegisterWriteCount);

fprintf('x0 write attempts     : %d\n', ...
    x0WriteAttemptCount);


fprintf('\n');

fprintf('Control-flow total    : %d\n', ...
    controlFlowCount);


% ============================================================
% TEST SUMMARY
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                  STAGE 17.10 RESULTS\n');
fprintf('============================================================\n');

fprintf('Tests passed : %d / %d\n', ...
    testsPassed,totalTests);

fprintf('============================================================\n');


% ============================================================
% FINAL STAGE 17 RESULT
% ============================================================

if testsPassed == totalTests

    fprintf('\n');
    fprintf('************************************************************\n');
    fprintf('*                                                          *\n');
    fprintf('*              STAGE 17.10 PASSED!                       *\n');
    fprintf('*                                                          *\n');
    fprintf('*          COMPLETE STAGE 17 VERIFIED                     *\n');
    fprintf('*                                                          *\n');
    fprintf('************************************************************\n');

else

    fprintf('\n');
    fprintf('************************************************************\n');
    fprintf('*                                                          *\n');
    fprintf('*              STAGE 17.10 FAILED                          *\n');
    fprintf('*                                                          *\n');
    fprintf('*              CHECK RESULTS ABOVE                        *\n');
    fprintf('*                                                          *\n');
    fprintf('************************************************************\n');

end

end