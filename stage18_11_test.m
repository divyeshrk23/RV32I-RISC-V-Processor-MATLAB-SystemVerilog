function stage18_11_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('        STAGE 18.11 - COMPLETE 5-STAGE PIPELINE\n');
fprintf('============================================================\n');

testsPassed = 0;
totalTests = 10;


% ============================================================
% HAZARD-FREE TEST PROGRAM
%
% Stage 18 does NOT have forwarding/stalling yet.
%
% Therefore NOPs are inserted between dependent instructions.
%
% Expected:
%
% x1 = 10
% x2 = 20
% x3 = 30
% memory[0] = 30
% x4 = 30
%
% ============================================================

program = uint32([ ...

    % x1 = 10
    encoder('ADDI x1, x0, 10'); ...

    % x2 = 20
    encoder('ADDI x2, x0, 20'); ...

    % Wait for x1/x2 to reach WB
    encoder('ADDI x0, x0, 0'); ...
    encoder('ADDI x0, x0, 0'); ...
    encoder('ADDI x0, x0, 0'); ...

    % x3 = x1 + x2
    encoder('ADD x3, x1, x2'); ...

    % Wait for x3 to reach WB
    encoder('ADDI x0, x0, 0'); ...
    encoder('ADDI x0, x0, 0'); ...
    encoder('ADDI x0, x0, 0'); ...

    % memory[0] = x3
    encoder('SW x3, 0(x0)'); ...

    % Load the value back
    encoder('LW x4, 0(x0)') ...
]);


% ============================================================
% INITIAL MEMORY
% ============================================================

memory = zeros(1024,1,'uint8');


% ============================================================
% RUN COMPLETE PIPELINE
% ============================================================

result = pipeline_cpu( ...
    program, ...
    memory, ...
    100);


registers = result.registers;
memory = result.memory;


% ============================================================
% TEST 1 — PIPELINE HALTED
% ============================================================

if result.halted

    fprintf('PIPELINE HALTED           : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('PIPELINE HALTED           : FAIL\n');

end


% ============================================================
% TEST 2 — x1 = 10
% ============================================================

if registers(2) == uint32(10)

    fprintf('x1 = 10                   : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('x1 = 10                   : FAIL\n');

end


% ============================================================
% TEST 3 — x2 = 20
% ============================================================

if registers(3) == uint32(20)

    fprintf('x2 = 20                   : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('x2 = 20                   : FAIL\n');

end


% ============================================================
% TEST 4 — x3 = 30
% ============================================================

if registers(4) == uint32(30)

    fprintf('x3 = 30                   : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('x3 = 30                   : FAIL\n');

end


% ============================================================
% TEST 5 — MEMORY STORE
% ============================================================

% 30 = 0x0000001E
%
% Little-endian:
% memory(1) = 0x1E
% memory(2) = 0x00
% memory(3) = 0x00
% memory(4) = 0x00

if memory(1) == uint8(30) && ...
   memory(2) == uint8(0) && ...
   memory(3) == uint8(0) && ...
   memory(4) == uint8(0)

    fprintf('MEMORY STORE              : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('MEMORY STORE              : FAIL\n');

end


% ============================================================
% TEST 6 — LW RESULT
% ============================================================

if registers(5) == uint32(30)

    fprintf('LW RESULT x4 = 30        : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('LW RESULT x4 = 30        : FAIL\n');

end


% ============================================================
% TEST 7 — x0 PROTECTION
% ============================================================

if registers(1) == uint32(0)

    fprintf('x0 PROTECTION             : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('x0 PROTECTION             : FAIL\n');

end


% ============================================================
% TEST 8 — PIPELINE EXECUTION
% ============================================================

if result.cycles > 5

    fprintf('PIPELINE EXECUTION        : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('PIPELINE EXECUTION        : FAIL\n');

end


% ============================================================
% TEST 9 — REGISTER FILE
% ============================================================

if length(registers) == 32

    fprintf('REGISTER FILE             : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('REGISTER FILE             : FAIL\n');

end


% ============================================================
% TEST 10 — DATA MEMORY
% ============================================================

if length(memory) == 1024

    fprintf('DATA MEMORY               : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('DATA MEMORY               : FAIL\n');

end


% ============================================================
% RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('              STAGE 18.11 RESULTS\n');
fprintf('============================================================\n');

fprintf('Pipeline cycles : %d\n',result.cycles);
fprintf('Final PC        : %d\n',result.pc);
fprintf('Tests passed    : %d / %d\n', ...
    testsPassed,totalTests);

fprintf('============================================================\n');


% ============================================================
% FINAL RESULT
% ============================================================

if testsPassed == totalTests

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 18.11 PASSED!\n');
    fprintf('       COMPLETE 5-STAGE PIPELINE VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 18.11 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end