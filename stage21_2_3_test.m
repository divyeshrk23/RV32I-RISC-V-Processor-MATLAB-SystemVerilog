function stage21_2_3_test

clc;

fprintf('==============================================\n');
fprintf('STAGE 21.2.3 - SHIFT PIPELINE TEST\n');
fprintf('==============================================\n\n');

% ------------------------------------------------
% Program
% ------------------------------------------------
%
% x1 = 1
% SLLI x2,x1,4  = 16
% SLLI x3,x2,2  = 64
%
% x4 = 64
% SRLI x5,x4,3  = 8
%
% x6 = -16
% SRAI x7,x6,2  = -4
%
% ------------------------------------------------

program = uint32([

    encoder('ADDI x1, x0, 1')
    encoder('SLLI x2, x1, 4')
    encoder('SLLI x3, x2, 2')

    encoder('ADDI x4, x0, 64')
    encoder('SRLI x5, x4, 3')

    encoder('ADDI x6, x0, -16')
    encoder('SRAI x7, x6, 2')

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

expected = zeros(7,1,'uint32');

expected(1) = uint32(1);
expected(2) = uint32(16);
expected(3) = uint32(64);
expected(4) = uint32(64);
expected(5) = uint32(8);

% -16 represented as 32-bit unsigned
expected(6) = uint32(4294967280);

% -4 represented as 32-bit unsigned
expected(7) = uint32(4294967292);

% ------------------------------------------------
% Display results
% ------------------------------------------------

fprintf('Register results:\n\n');

fprintf('x1  = %u   Expected = %u\n', registers(2), expected(1));
fprintf('x2  = %u   Expected = %u\n', registers(3), expected(2));
fprintf('x3  = %u   Expected = %u\n', registers(4), expected(3));
fprintf('x4  = %u   Expected = %u\n', registers(5), expected(4));
fprintf('x5  = %u   Expected = %u\n', registers(6), expected(5));
fprintf('x6  = %u   Expected = %u\n', registers(7), expected(6));
fprintf('x7  = %u   Expected = %u\n', registers(8), expected(7));

fprintf('\n');

% ------------------------------------------------
% Individual tests
% ------------------------------------------------

testsPassed = 0;
testsTotal = 7;

if registers(2) == expected(1)
    fprintf('Initial value          : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('Initial value          : FAIL\n');
end

if registers(3) == expected(2)
    fprintf('SLLI                   : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('SLLI                   : FAIL\n');
end

if registers(4) == expected(3)
    fprintf('SLLI dependency        : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('SLLI dependency        : FAIL\n');
end

if registers(5) == expected(4)
    fprintf('SRLI input             : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('SRLI input             : FAIL\n');
end

if registers(6) == expected(5)
    fprintf('SRLI                   : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('SRLI                   : FAIL\n');
end

if registers(7) == expected(6)
    fprintf('SRAI negative input    : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('SRAI negative input    : FAIL\n');
end

if registers(8) == expected(7)
    fprintf('SRAI                   : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('SRAI                   : FAIL\n');
end

% ------------------------------------------------
% Final result
% ------------------------------------------------

fprintf('\n');
fprintf('Tests passed : %d / %d\n', testsPassed, testsTotal);

if testsPassed == testsTotal
    fprintf('STAGE 21.2.3 PASSED!\n');
else
    fprintf('STAGE 21.2.3 FAILED\n');
end

end