function stage17_8_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('             STAGE 17.8 - CPI CALCULATION\n');
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
    cpi] = cpu( ...
    program, ...
    3000, ...
    initialMemory);


% ============================================================
% TEST COUNTER
% ============================================================

testsPassed = 0;

totalTests = 6;


% ============================================================
% TEST 1
% ============================================================

if halted

    fprintf('CPU HALTED              : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('CPU HALTED              : FAIL\n');

end


% ============================================================
% TEST 2
% ============================================================

if instructionCount == 81

    fprintf('INSTRUCTION COUNT = 81  : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('INSTRUCTION COUNT       : FAIL (got %d)\n', ...
        instructionCount);

end


% ============================================================
% TEST 3
% ============================================================

if cycleCount == 82

    fprintf('CYCLE COUNT = 82        : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('CYCLE COUNT             : FAIL (got %d)\n', ...
        cycleCount);

end


% ============================================================
% EXPECTED CPI
% ============================================================

expectedCPI = 82 / 81;


% ============================================================
% TEST 4
% ============================================================

if abs(cpi - expectedCPI) < 1e-10

    fprintf('CPI = %.4f              : PASS\n', ...
        cpi);

    testsPassed = testsPassed + 1;

else

    fprintf('CPI                     : FAIL (got %.10f)\n', ...
        cpi);

end


% ============================================================
% TEST 5
% ============================================================

if cpi > 1

    fprintf('CPI > 1                 : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('CPI > 1                 : FAIL\n');

end


% ============================================================
% TEST 6
% ============================================================

calculatedCPI = ...
    double(cycleCount) / ...
    double(instructionCount);

if abs(cpi - calculatedCPI) < 1e-10

    fprintf('CPI FORMULA CONSISTENCY : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('CPI FORMULA CONSISTENCY : FAIL\n');

end


% ============================================================
% RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                  STAGE 17.8 RESULTS\n');
fprintf('============================================================\n');

fprintf('CPU cycles       : %d\n',cycleCount);

fprintf('Instructions     : %d\n',instructionCount);

fprintf('CPI              : %.4f\n',cpi);

fprintf('Expected CPI     : %.4f\n',expectedCPI);

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
    fprintf('       STAGE 17.8 PASSED!\n');
    fprintf('       CPI CALCULATION VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 17.8 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end