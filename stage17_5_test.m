function stage17_5_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('       STAGE 17.5 - BRANCH & JUMP STATISTICS\n');
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
    controlFlowCount] = cpu( ...
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
% TEST 4 — BRANCH COUNT
% ============================================================

if branchCount == 29

    fprintf('BRANCH COUNT = 29     : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('BRANCH COUNT           : FAIL (got %d)\n', ...
        branchCount);

end


% ============================================================
% TEST 5 — TAKEN BRANCHES
% ============================================================

if branchTakenCount == 11

    fprintf('BRANCH TAKEN = 11     : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('BRANCH TAKEN           : FAIL (got %d)\n', ...
        branchTakenCount);

end


% ============================================================
% TEST 6 — NOT TAKEN BRANCHES
% ============================================================

if branchNotTakenCount == 18

    fprintf('BRANCH NOT TAKEN = 18 : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('BRANCH NOT TAKEN       : FAIL (got %d)\n', ...
        branchNotTakenCount);

end


% ============================================================
% TEST 7 — BEQ COUNT
% ============================================================

if beqCount == 10

    fprintf('BEQ COUNT = 10        : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('BEQ COUNT              : FAIL (got %d)\n', ...
        beqCount);

end


% ============================================================
% TEST 8 — BNE COUNT
% ============================================================

if bneCount == 5

    fprintf('BNE COUNT = 5         : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('BNE COUNT              : FAIL (got %d)\n', ...
        bneCount);

end


% ============================================================
% TEST 9 — BLT COUNT
% ============================================================

if bltCount == 14

    fprintf('BLT COUNT = 14        : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('BLT COUNT              : FAIL (got %d)\n', ...
        bltCount);

end


% ============================================================
% TEST 10 — JUMP COUNT
% ============================================================

if jumpCount == 12

    fprintf('JUMP COUNT = 12       : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('JUMP COUNT             : FAIL (got %d)\n', ...
        jumpCount);

end


% ============================================================
% RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                 STAGE 17.5 RESULTS\n');
fprintf('============================================================\n');

fprintf('Branches              : %d\n',branchCount);

fprintf('  BEQ                 : %d\n',beqCount);
fprintf('  BNE                 : %d\n',bneCount);
fprintf('  BLT                 : %d\n',bltCount);
fprintf('  BGE                 : %d\n',bgeCount);
fprintf('  BLTU                : %d\n',bltuCount);
fprintf('  BGEU                : %d\n',bgeuCount);

fprintf('\n');

fprintf('Taken branches        : %d\n', ...
    branchTakenCount);

fprintf('Not-taken branches    : %d\n', ...
    branchNotTakenCount);

fprintf('\n');

fprintf('Jumps                 : %d\n',jumpCount);

fprintf('  JAL                 : %d\n',jalCount);
fprintf('  JALR                : %d\n',jalrCount);

fprintf('\n');

fprintf('Control-flow total    : %d\n', ...
    controlFlowCount);

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
    fprintf('       STAGE 17.5 PASSED!\n');
    fprintf('       BRANCH/JUMP STATISTICS VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 17.5 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end