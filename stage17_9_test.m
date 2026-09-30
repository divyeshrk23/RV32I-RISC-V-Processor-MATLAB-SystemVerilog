function stage17_9_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('          STAGE 17.9 - PERFORMANCE REPORT\n');
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

totalTests = 10;


% ============================================================
% TEST 1
% ============================================================

if halted

    fprintf('CPU HALTED                : PASS');

    testsPassed = testsPassed + 1;

else

    fprintf('CPU HALTED                : FAIL');

end

fprintf('\n');


% ============================================================
% TEST 2
% ============================================================

if instructionCount == 81

    fprintf('INSTRUCTIONS = 81        : PASS');

    testsPassed = testsPassed + 1;

else

    fprintf('INSTRUCTIONS              : FAIL (got %d)', ...
        instructionCount);

end

fprintf('\n');


% ============================================================
% TEST 3
% ============================================================

if cycleCount == 82

    fprintf('CYCLES = 82              : PASS');

    testsPassed = testsPassed + 1;

else

    fprintf('CYCLES                    : FAIL (got %d)', ...
        cycleCount);

end

fprintf('\n');


% ============================================================
% TEST 4
% ============================================================

expectedCPI = 82/81;

if abs(cpi - expectedCPI) < 1e-10

    fprintf('CPI = 1.0123             : PASS');

    testsPassed = testsPassed + 1;

else

    fprintf('CPI                       : FAIL (got %.6f)', ...
        cpi);

end

fprintf('\n');


% ============================================================
% TEST 5
% ============================================================

if aluOperationCount == 24

    fprintf('ALU OPERATIONS = 24      : PASS');

    testsPassed = testsPassed + 1;

else

    fprintf('ALU OPERATIONS            : FAIL (got %d)', ...
        aluOperationCount);

end

fprintf('\n');


% ============================================================
% TEST 6
% ============================================================

if memoryOperationCount == 9

    fprintf('MEMORY OPERATIONS = 9    : PASS');

    testsPassed = testsPassed + 1;

else

    fprintf('MEMORY OPERATIONS         : FAIL (got %d)', ...
        memoryOperationCount);

end

fprintf('\n');


% ============================================================
% TEST 7
% ============================================================

if branchCount == 29

    fprintf('BRANCHES = 29             : PASS');

    testsPassed = testsPassed + 1;

else

    fprintf('BRANCHES                  : FAIL (got %d)', ...
        branchCount);

end

fprintf('\n');


% ============================================================
% TEST 8
% ============================================================

if jumpCount == 12

    fprintf('JUMPS = 12                : PASS');

    testsPassed = testsPassed + 1;

else

    fprintf('JUMPS                     : FAIL (got %d)', ...
        jumpCount);

end

fprintf('\n');


% ============================================================
% TEST 9
% ============================================================

if actualRegisterWriteCount == 35

    fprintf('ACTUAL REGISTER WRITES = 35: PASS');

    testsPassed = testsPassed + 1;

else

    fprintf('ACTUAL REGISTER WRITES    : FAIL (got %d)', ...
        actualRegisterWriteCount);

end

fprintf('\n');


% ============================================================
% TEST 10
% ============================================================

if performanceReport.controlFlow == 41

    fprintf('CONTROL FLOW = 41        : PASS');

    testsPassed = testsPassed + 1;

else

    fprintf('CONTROL FLOW              : FAIL (got %d)', ...
        performanceReport.controlFlow);

end

fprintf('\n');


% ============================================================
% RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                  STAGE 17.9 RESULTS\n');
fprintf('============================================================\n');

fprintf('\n');

fprintf('Instructions : %d\n', ...
    performanceReport.instructions);

fprintf('Cycles       : %d\n', ...
    performanceReport.cycles);

fprintf('CPI          : %.4f\n', ...
    performanceReport.cpi);

fprintf('\n');

fprintf('ALU          : %d (%.2f%%)\n', ...
    performanceReport.aluOperations, ...
    performanceReport.aluPercentage);

fprintf('Memory       : %d (%.2f%%)\n', ...
    performanceReport.memoryOperations, ...
    performanceReport.memoryPercentage);

fprintf('Branches     : %d (%.2f%%)\n', ...
    performanceReport.branches, ...
    performanceReport.branchPercentage);

fprintf('Jumps        : %d (%.2f%%)\n', ...
    performanceReport.jumps, ...
    performanceReport.jumpPercentage);

fprintf('\n');

fprintf('Memory reads : %d\n', ...
    performanceReport.memoryReads);

fprintf('Memory writes: %d\n', ...
    performanceReport.memoryWrites);

fprintf('Reg writes   : %d\n', ...
    performanceReport.registerWrites);

fprintf('Actual writes: %d\n', ...
    performanceReport.actualRegisterWrites);

fprintf('\n');

fprintf('Tests passed : %d / %d\n', ...
    testsPassed,totalTests);

fprintf('============================================================\n');


% ============================================================
% FINAL RESULT
% ============================================================

if testsPassed == totalTests

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 17.9 PASSED!\n');
    fprintf('       PERFORMANCE REPORT VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 17.9 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end