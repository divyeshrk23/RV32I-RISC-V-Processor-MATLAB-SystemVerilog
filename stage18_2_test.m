function stage18_2_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('          STAGE 18.2 - INSTRUCTION FETCH TEST\n');
fprintf('============================================================\n');


% ============================================================
% TEST INSTRUCTION MEMORY
% ============================================================

instructionMemory = uint32([ ...
    hex2dec('00C00093'); ...
    hex2dec('01200113'); ...
    hex2dec('002081B3'); ...
    hex2dec('00302023') ...
]);


testsPassed = 0;

totalTests = 8;


% ============================================================
% TEST 1 — FETCH FIRST INSTRUCTION
% ============================================================

[instruction,pcNext] = ...
    if_stage(uint32(0),instructionMemory);


if instruction == uint32(hex2dec('00C00093'))

    fprintf('FETCH PC 0               : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('FETCH PC 0               : FAIL\n');

end


% ============================================================
% TEST 2 — NEXT PC
% ============================================================

if pcNext == uint32(4)

    fprintf('PC + 4                   : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('PC + 4                   : FAIL (got %u)\n', ...
        pcNext);

end


% ============================================================
% TEST 3 — FETCH SECOND
% ============================================================

[instruction,pcNext] = ...
    if_stage(uint32(4),instructionMemory);


if instruction == uint32(hex2dec('01200113'))

    fprintf('FETCH PC 4               : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('FETCH PC 4               : FAIL\n');

end


% ============================================================
% TEST 4 — SECOND NEXT PC
% ============================================================

if pcNext == uint32(8)

    fprintf('SECOND PC + 4            : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('SECOND PC + 4            : FAIL\n');

end


% ============================================================
% TEST 5 — FETCH THIRD
% ============================================================

[instruction,pcNext] = ...
    if_stage(uint32(8),instructionMemory);


if instruction == uint32(hex2dec('002081B3'))

    fprintf('FETCH PC 8               : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('FETCH PC 8               : FAIL\n');

end


% ============================================================
% TEST 6 — FETCH FOURTH
% ============================================================

[instruction,pcNext] = ...
    if_stage(uint32(12),instructionMemory);


if instruction == uint32(hex2dec('00302023'))

    fprintf('FETCH PC 12              : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('FETCH PC 12              : FAIL\n');

end


% ============================================================
% TEST 7 — OUT OF RANGE
% ============================================================

[instruction,pcNext] = ...
    if_stage(uint32(16),instructionMemory);


if instruction == uint32(0)

    fprintf('OUT OF RANGE -> NOP       : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('OUT OF RANGE -> NOP       : FAIL\n');

end


% ============================================================
% TEST 8 — OUT OF RANGE NEXT PC
% ============================================================

if pcNext == uint32(20)

    fprintf('OUT OF RANGE PC + 4       : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('OUT OF RANGE PC + 4       : FAIL\n');

end


% ============================================================
% RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                  STAGE 18.2 RESULTS\n');
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
    fprintf('       STAGE 18.2 PASSED!\n');
    fprintf('       INSTRUCTION FETCH VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 18.2 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

endp