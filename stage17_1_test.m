function stage17_1_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('          STAGE 17.1 - INSTRUCTION COUNTER\n');
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
% READ ASSEMBLY PROGRAM
% ============================================================

program = assembly_reader(filename);


% ============================================================
% RUN CPU
% ============================================================

[registers,pc,halted,dataMemory,instructionCount] = cpu( ...
    program, ...
    3000, ...
    initialMemory);


% ============================================================
% TESTS
% ============================================================

testsPassed = 0;

totalTests = 2;


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

if instructionCount > 0

    fprintf('INSTRUCTION COUNTER   : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('INSTRUCTION COUNTER   : FAIL\n');

end


% ============================================================
% DISPLAY STATISTICS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                  STAGE 17.1 RESULTS\n');
fprintf('============================================================\n');

fprintf('Instructions executed : %d\n', ...
    instructionCount);

fprintf('Final PC              : %u\n', ...
    pc);

fprintf('CPU halted            : %s\n', ...
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
    fprintf('       STAGE 17.1 PASSED!\n');
    fprintf('       INSTRUCTION COUNTER VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 17.1 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end