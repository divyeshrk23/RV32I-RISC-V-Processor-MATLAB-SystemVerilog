function stage21_2_9_test

clc;

fprintf('==============================================\n');
fprintf('STAGE 21.2.9 - JALR PIPELINE TEST\n');
fprintf('==============================================\n\n');

% ------------------------------------------------
% Program
% ------------------------------------------------
%
% PC = 0:
%   ADDI x1, x0, 20
%
% PC = 4:
%   JALR x5, 0(x1)
%
% Target = x1 + 0 = 20
%
% PC = 8:
%   ADDI x2, x0, 999       <-- flushed
%
% PC = 12:
%   ADDI x3, x0, 999       <-- flushed
%
% PC = 16:
%   ADDI x4, x0, 999       <-- flushed
%
% PC = 20:
%   ADDI x6, x0, 60        <-- target
%
% JALR return address:
%   x5 = PC + 4 = 8
%
% ------------------------------------------------

program = uint32([

    % PC = 0
    encoder('ADDI x1, x0, 20')

    % PC = 4
    encoder('JALR x5, 0(x1)')

    % These must be flushed
    encoder('ADDI x2, x0, 999')
    encoder('ADDI x3, x0, 999')
    encoder('ADDI x4, x0, 999')

    % PC = 20, JALR target
    encoder('ADDI x6, x0, 60')

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

expected = zeros(6,1,'uint32');

expected(1) = uint32(20);
expected(2) = uint32(0);
expected(3) = uint32(0);
expected(4) = uint32(0);
expected(5) = uint32(8);
expected(6) = uint32(60);

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

fprintf('x6 = %u   Expected = %u\n', ...
    registers(7), expected(6));

fprintf('\n');

% ------------------------------------------------
% Tests
% ------------------------------------------------

testsPassed = 0;
testsTotal = 6;

if registers(2) == expected(1)
    fprintf('JALR base register     : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('JALR base register     : FAIL\n');
end

if registers(3) == expected(2)
    fprintf('Flushed instruction 1   : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('Flushed instruction 1   : FAIL\n');
end

if registers(4) == expected(3)
    fprintf('Flushed instruction 2   : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('Flushed instruction 2   : FAIL\n');
end

if registers(5) == expected(4)
    fprintf('Flushed instruction 3   : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('Flushed instruction 3   : FAIL\n');
end

if registers(6) == expected(5)
    fprintf('JALR return address     : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('JALR return address     : FAIL\n');
end

if registers(7) == expected(6)
    fprintf('JALR target execution   : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('JALR target execution   : FAIL\n');
end

% ------------------------------------------------
% Final result
% ------------------------------------------------

fprintf('\n');
fprintf('Tests passed : %d / %d\n', testsPassed, testsTotal);

if testsPassed == testsTotal
    fprintf('STAGE 21.2.9 PASSED!\n');
else
    fprintf('STAGE 21.2.9 FAILED\n');
end

end