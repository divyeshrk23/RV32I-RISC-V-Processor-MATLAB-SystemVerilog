function stage17_3_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('          STAGE 17.3 - ALU OPERATION STATISTICS\n');
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
    aluOperationCount] = cpu( ...
    program, ...
    3000, ...
    initialMemory);


% ============================================================
% TEST COUNTERS
% ============================================================

testsPassed = 0;

totalTests = 10;


% ============================================================
% TEST 1 — CPU HALTED
% ============================================================

if halted

    fprintf('CPU HALTED             : PASS');

    testsPassed = testsPassed + 1;

else

    fprintf('CPU HALTED             : FAIL');

end

fprintf('\n');


% ============================================================
% TEST 2 — INSTRUCTION COUNT
% ============================================================

if instructionCount == 81

    fprintf('INSTRUCTION COUNT = 81: PASS');

    testsPassed = testsPassed + 1;

else

    fprintf('INSTRUCTION COUNT     : FAIL (got %d)', ...
        instructionCount);

end

fprintf('\n');


% ============================================================
% TEST 3 — CYCLE COUNT
% ============================================================

if cycleCount == 82

    fprintf('CYCLE COUNT = 82      : PASS');

    testsPassed = testsPassed + 1;

else

    fprintf('CYCLE COUNT            : FAIL (got %d)', ...
        cycleCount);

end

fprintf('\n');


% ============================================================
% TEST 4 — ADD COUNT
% ============================================================

if addCount == 16

    fprintf('ADD COUNT = 16        : PASS');

    testsPassed = testsPassed + 1;

else

    fprintf('ADD COUNT              : FAIL (got %d)', ...
        addCount);

end

fprintf('\n');


% ============================================================
% TEST 5 — SUB COUNT
% ============================================================

if subCount == 8

    fprintf('SUB COUNT = 8         : PASS');

    testsPassed = testsPassed + 1;

else

    fprintf('SUB COUNT              : FAIL (got %d)', ...
        subCount);

end

fprintf('\n');


% ============================================================
% TEST 6 — AND COUNT
% ============================================================

if andCount == 0

    fprintf('AND COUNT = 0         : PASS');

    testsPassed = testsPassed + 1;

else

    fprintf('AND COUNT              : FAIL (got %d)', ...
        andCount);

end

fprintf('\n');


% ============================================================
% TEST 7 — OR COUNT
% ============================================================

if orCount == 0

    fprintf('OR COUNT = 0          : PASS');

    testsPassed = testsPassed + 1;

else

    fprintf('OR COUNT               : FAIL (got %d)', ...
        orCount);

end

fprintf('\n');


% ============================================================
% TEST 8 — XOR COUNT
% ============================================================

if xorCount == 0

    fprintf('XOR COUNT = 0         : PASS');

    testsPassed = testsPassed + 1;

else

    fprintf('XOR COUNT              : FAIL (got %d)', ...
        xorCount);

end

fprintf('\n');


% ============================================================
% TEST 9 — SLT / SLTU COUNT
% ============================================================

if sltCount == 0 && sltuCount == 0

    fprintf('SLT/SLTU COUNT = 0    : PASS');

    testsPassed = testsPassed + 1;

else

    fprintf('SLT/SLTU COUNT         : FAIL');

end

fprintf('\n');


% ============================================================
% TEST 10 — TOTAL ALU OPERATIONS
% ============================================================

if aluOperationCount == 24

    fprintf('TOTAL ALU OPS = 24    : PASS');

    testsPassed = testsPassed + 1;

else

    fprintf('TOTAL ALU OPS          : FAIL (got %d)', ...
        aluOperationCount);

end

fprintf('\n');


% ============================================================
% DISPLAY RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                  STAGE 17.3 RESULTS\n');
fprintf('============================================================\n');

fprintf('Instructions executed : %d\n', ...
    instructionCount);

fprintf('CPU cycles             : %d\n', ...
    cycleCount);

fprintf('\n');

fprintf('ALU operations         : %d\n', ...
    aluOperationCount);

fprintf('  ADD                  : %d\n', ...
    addCount);

fprintf('  SUB                  : %d\n', ...
    subCount);

fprintf('  AND                  : %d\n', ...
    andCount);

fprintf('  OR                   : %d\n', ...
    orCount);

fprintf('  XOR                  : %d\n', ...
    xorCount);

fprintf('  SLT                  : %d\n', ...
    sltCount);

fprintf('  SLTU                 : %d\n', ...
    sltuCount);

fprintf('\n');

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
    fprintf('       STAGE 17.3 PASSED!\n');
    fprintf('       ALU STATISTICS VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 17.3 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end