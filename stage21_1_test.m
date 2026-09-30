function stage21_1_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('       STAGE 21.1 - COMPLETE PIPELINE CPU INTEGRATION\n');
fprintf('============================================================\n');


testsPassed = 0;

totalTests = 10;


% ============================================================
% TEST 1
% BASIC ADD
%
% x1 = 10
% x2 = 20
% x3 = x1 + x2
%
% Expected:
% x3 = 30
% ============================================================

program = uint32([ ...
    encoder('ADDI x1, x0, 10'), ...
    encoder('ADDI x2, x0, 20'), ...
    encoder('ADD x3, x1, x2') ...
    ]);

result = pipeline_cpu(program, [], 30);

if result.registers(4) == uint32(30)

    fprintf('BASIC ADD PIPELINE          : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('BASIC ADD PIPELINE          : FAIL\n');

    fprintf('  Expected x3 = 30\n');
    fprintf('  Actual   x3 = %u\n',result.registers(4));

end


% ============================================================
% TEST 2
% SUB
%
% x1 = 50
% x2 = 20
% x3 = x1 - x2
%
% Expected:
% x3 = 30
% ============================================================

program = uint32([ ...
    encoder('ADDI x1, x0, 50'), ...
    encoder('ADDI x2, x0, 20'), ...
    encoder('SUB x3, x1, x2') ...
    ]);

result = pipeline_cpu(program, [], 30);

if result.registers(4) == uint32(30)

    fprintf('SUB PIPELINE                : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('SUB PIPELINE                : FAIL\n');

    fprintf('  Expected x3 = 30\n');
    fprintf('  Actual   x3 = %u\n',result.registers(4));

end


% ============================================================
% TEST 3
% STORE
%
% x1 = 100
% x2 = 123
% SW x2, 0(x1)
%
% Expected:
% memory address 100 = 123
% ============================================================

program = uint32([ ...
    encoder('ADDI x1, x0, 100'), ...
    encoder('ADDI x2, x0, 123'), ...
    encoder('SW x2, 0(x1)') ...
    ]);

result = pipeline_cpu(program, [], 30);

storedValue = ...
    uint32(result.memory(101)) + ...
    bitshift(uint32(result.memory(102)),8) + ...
    bitshift(uint32(result.memory(103)),16) + ...
    bitshift(uint32(result.memory(104)),24);


if storedValue == uint32(123)

    fprintf('STORE PIPELINE              : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('STORE PIPELINE              : FAIL\n');

    fprintf('  Expected memory[100] = 123\n');
    fprintf('  Actual   memory[100] = %u\n',storedValue);

end


% ============================================================
% TEST 4
% x0 PROTECTION
%
% Attempt:
% ADDI x0, x0, 99
%
% x0 must remain zero.
% ============================================================

program = uint32([ ...
    encoder('ADDI x0, x0, 99'), ...
    encoder('ADDI x1, x0, 10') ...
    ]);

result = pipeline_cpu(program, [], 30);

if result.registers(1) == uint32(0) && ...
        result.registers(2) == uint32(10)

    fprintf('X0 PROTECTION               : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('X0 PROTECTION               : FAIL\n');

    fprintf('  x0 = %u\n',result.registers(1));
    fprintf('  x1 = %u\n',result.registers(2));

end


% ============================================================
% TEST 5
% PIPELINE HALT
% ============================================================

program = uint32([ ...
    encoder('ADDI x1, x0, 5') ...
    ]);

result = pipeline_cpu(program, [], 30);

if result.halted

    fprintf('PIPELINE HALT               : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('PIPELINE HALT               : FAIL\n');

end


% ============================================================
% TEST 6
% DEPENDENCY / FORWARDING
%
% x1 = 5
% x2 = 7
% x3 = x1 + x2
%
% Expected:
% x3 = 12
%
% No NOPs.
% ============================================================

program = uint32([ ...
    encoder('ADDI x1, x0, 5'), ...
    encoder('ADDI x2, x0, 7'), ...
    encoder('ADD x3, x1, x2') ...
    ]);

result = pipeline_cpu(program, [], 30);

if result.registers(4) == uint32(12)

    fprintf('DEPENDENCY EXECUTION        : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('DEPENDENCY EXECUTION        : FAIL\n');

    fprintf('  Expected x3 = 12\n');
    fprintf('  Actual   x3 = %u\n',result.registers(4));

end


% ============================================================
% TEST 7
% EXTERNAL MEMORY
%
% Put 42 into byte address 0.
% ============================================================

initialMemory = zeros(1024,1,'uint8');

initialMemory(1) = uint8(42);


program = uint32([ ...
    encoder('ADDI x1, x0, 0'), ...
    encoder('LW x2, 0(x1)') ...
    ]);


% The purpose of this test is to ensure the supplied memory
% reaches the CPU unchanged.

result = pipeline_cpu( ...
    program, ...
    initialMemory, ...
    30);


if result.memory(1) == uint8(42)

    fprintf('EXTERNAL MEMORY             : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('EXTERNAL MEMORY             : FAIL\n');

end


% ============================================================
% TEST 8
% PC ADVANCEMENT
% ============================================================

program = uint32([ ...
    encoder('ADDI x1, x0, 1'), ...
    encoder('ADDI x2, x0, 2') ...
    ]);


result = pipeline_cpu(program, [], 30);


if result.pc >= uint32(8)

    fprintf('PC ADVANCEMENT              : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('PC ADVANCEMENT              : FAIL\n');

    fprintf('  PC = %u\n',result.pc);

end


% ============================================================
% TEST 9
% PIPELINE CYCLE COUNT
% ============================================================

program = uint32([ ...
    encoder('ADDI x1, x0, 1'), ...
    encoder('ADDI x2, x0, 2'), ...
    encoder('ADD x3, x1, x2') ...
    ]);


result = pipeline_cpu(program, [], 30);


if result.cycles >= 3

    fprintf('PIPELINE CYCLE COUNT        : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('PIPELINE CYCLE COUNT        : FAIL\n');

end


% ============================================================
% TEST 10
% FINAL REGISTER STATE
%
% x1 = 10
% x2 = 20
% x3 = x1 + x2 = 30
% x4 = x3 - x1 = 20
%
% ============================================================

program = uint32([ ...
    encoder('ADDI x1, x0, 10'), ...
    encoder('ADDI x2, x0, 20'), ...
    encoder('ADD x3, x1, x2'), ...
    encoder('SUB x4, x3, x1') ...
    ]);


result = pipeline_cpu(program, [], 40);


if result.registers(4) == uint32(30) && ...
        result.registers(5) == uint32(20) && ...
        result.registers(1) == uint32(0)

    fprintf('FINAL REGISTER STATE        : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('FINAL REGISTER STATE        : FAIL\n');

    fprintf('  x0 = %u\n',result.registers(1));
    fprintf('  x3 = %u\n',result.registers(4));
    fprintf('  x4 = %u\n',result.registers(5));

end


% ============================================================
% FINAL RESULTS
% ============================================================

fprintf('\n');

fprintf('============================================================\n');

fprintf('                  STAGE 21.1 RESULTS\n');

fprintf('============================================================\n');

fprintf('Tests passed : %d / %d\n', ...
    testsPassed,totalTests);

fprintf('============================================================\n');


% ============================================================
% PASS / FAIL
% ============================================================

if testsPassed == totalTests

    fprintf('\n');

    fprintf('********************************************\n');

    fprintf('       STAGE 21.1 PASSED!\n');

    fprintf('       COMPLETE PIPELINE VERIFIED\n');

    fprintf('********************************************\n');

else

    fprintf('\n');

    fprintf('********************************************\n');

    fprintf('       STAGE 21.1 FAILED\n');

    fprintf('       CHECK RESULTS ABOVE\n');

    fprintf('********************************************\n');

end


end