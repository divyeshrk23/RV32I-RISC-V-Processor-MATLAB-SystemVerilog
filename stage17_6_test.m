function stage17_6_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('        STAGE 17.6 - REGISTER WRITE STATISTICS\n');
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
    actualRegisterWriteCount] = cpu( ...
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
% TEST 2 — INSTRUCTION COUNT
% ============================================================

if instructionCount == 81

    fprintf('INSTRUCTION COUNT = 81 : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('INSTRUCTION COUNT      : FAIL (got %d)\n', ...
        instructionCount);

end


% ============================================================
% TEST 3 — CYCLE COUNT
% ============================================================

if cycleCount == 82

    fprintf('CYCLE COUNT = 82       : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('CYCLE COUNT             : FAIL (got %d)\n', ...
        cycleCount);

end


% ============================================================
% TEST 4 — LOAD COUNT
% ============================================================

if loadCount == 4

    fprintf('LOAD COUNT = 4         : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('LOAD COUNT              : FAIL (got %d)\n', ...
        loadCount);

end


% ============================================================
% TEST 5 — STORE COUNT
% ============================================================

if storeCount == 5

    fprintf('STORE COUNT = 5        : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('STORE COUNT             : FAIL (got %d)\n', ...
        storeCount);

end


% ============================================================
% TEST 6 — ALU COUNT
% ============================================================

if aluOperationCount == 24

    fprintf('ALU OPERATIONS = 24    : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('ALU OPERATIONS          : FAIL (got %d)\n', ...
        aluOperationCount);

end


% ============================================================
% TEST 7 — REGISTER WRITE ATTEMPTS
% ============================================================

if registerWriteCount == 47

    fprintf('REGISTER WRITES = 47   : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('REGISTER WRITES         : FAIL (got %d)\n', ...
        registerWriteCount);

end


% ============================================================
% TEST 8 — x0 WRITE ATTEMPTS
% ============================================================

if x0WriteAttemptCount == 12

    fprintf('x0 WRITE ATTEMPTS = 12 : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('x0 WRITE ATTEMPTS       : FAIL (got %d)\n', ...
        x0WriteAttemptCount);

end


% ============================================================
% TEST 9 — ACTUAL REGISTER WRITES
% ============================================================

if actualRegisterWriteCount == 35

    fprintf('ACTUAL WRITES = 35     : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('ACTUAL WRITES           : FAIL (got %d)\n', ...
        actualRegisterWriteCount);

end


% ============================================================
% TEST 10 — WRITE COUNT CONSISTENCY
% ============================================================

if registerWriteCount == ...
        x0WriteAttemptCount + ...
        actualRegisterWriteCount

    fprintf('WRITE COUNT CONSISTENCY : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('WRITE COUNT CONSISTENCY : FAIL\n');

end


% ============================================================
% DISPLAY RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                 STAGE 17.6 RESULTS\n');
fprintf('============================================================\n');

fprintf('Register write attempts : %d\n', ...
    registerWriteCount);

fprintf('x0 write attempts       : %d\n', ...
    x0WriteAttemptCount);

fprintf('Actual register writes  : %d\n', ...
    actualRegisterWriteCount);

fprintf('\n');

fprintf('Instructions            : %d\n', ...
    instructionCount);

fprintf('Cycles                  : %d\n', ...
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
    fprintf('       STAGE 17.6 PASSED!\n');
    fprintf('       REGISTER WRITE STATISTICS VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 17.6 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end