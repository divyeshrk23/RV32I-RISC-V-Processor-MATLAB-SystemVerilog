function stage21_2_8_test

clc;

fprintf('==============================================\n');
fprintf('STAGE 21.2.8 - JAL PIPELINE TEST\n');
fprintf('==============================================\n\n');

% ------------------------------------------------
% Program
% ------------------------------------------------
%
% Address      Instruction
%
% 0            ADDI x1, x0, 10
% 4            JAL  x5, 12
% 8            ADDI x2, x0, 999   <-- must be flushed
% 12           ADDI x3, x0, 999   <-- must be flushed
% 16           ADDI x4, x0, 40    <-- jump target
%
% JAL at PC=4:
%
%   x5 = PC + 4 = 8
%   target = 4 + 12 = 16
%
% Therefore:
%
% x1 = 10
% x2 = 0
% x3 = 0
% x4 = 40
% x5 = 8
%
% ------------------------------------------------

program = uint32([

    encoder('ADDI x1, x0, 10')

    encoder('JAL x5, 12')

    % These instructions must be flushed
    encoder('ADDI x2, x0, 999')
    encoder('ADDI x3, x0, 999')

    % JAL target
    encoder('ADDI x4, x0, 40')

]);

% ------------------------------------------------
% Run pipeline CPU
% ------------------------------------------------

initialMemory = zeros(1024,1,'uint8');

result = pipeline_cpu(program, initialMemory, 100);

registers = result.registers;

% ------------------------------------------------
% Expected values
% ------------------------------------------------

expected = zeros(5,1,'uint32');

expected(1) = uint32(10);
expected(2) = uint32(0);
expected(3) = uint32(0);
expected(4) = uint32(40);
expected(5) = uint32(8);

% ------------------------------------------------
% Display results
% ------------------------------------------------

fprintf('Register results:\n\n');

fprintf('x1 = %u   Expected = %u\n', ...
    registers(2), expected(1));

fprintf('x2 = %u   Expected = %u\n', ...
    registers(3), expected(2));

fprintf('x3 = %u   Expected = %u\n', ...
    registers(4), expected(3));

fprintf('x4 = %u   Expected = %u\n', ...
    registers(5), expected(4));

fprintf('x5 = %u   Expected = %u\n', ...
    registers(6), expected(5));

fprintf('\n');

% ------------------------------------------------
% Tests
% ------------------------------------------------

testsPassed = 0;
testsTotal = 5;

if registers(2) == expected(1)
    fprintf('Before JAL             : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('Before JAL             : FAIL\n');
end

if registers(3) == expected(2)
    fprintf('Flushed instruction 1  : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('Flushed instruction 1  : FAIL\n');
end

if registers(4) == expected(3)
    fprintf('Flushed instruction 2  : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('Flushed instruction 2  : FAIL\n');
end

if registers(5) == expected(4)
    fprintf('JAL target execution   : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('JAL target execution   : FAIL\n');
end

if registers(6) == expected(5)
    fprintf('JAL return address     : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('JAL return address     : FAIL\n');
end

% ------------------------------------------------
% Final result
% ------------------------------------------------

fprintf('\n');
fprintf('Tests passed : %d / %d\n', testsPassed, testsTotal);

if testsPassed == testsTotal
    fprintf('STAGE 21.2.8 PASSED!\n');
else
    fprintf('STAGE 21.2.8 FAILED\n');
end

end