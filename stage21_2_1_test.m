function stage21_2_1_test

clc;

fprintf('==============================================\n');
fprintf('STAGE 21.2.1 - R-TYPE ALU PIPELINE TEST\n');
fprintf('==============================================\n\n');

% ------------------------------------------------
% Program
% ------------------------------------------------
%
% x1 = 20
% x2 = 5
%
% ADD  x3, x1, x2  = 25
% SUB  x4, x1, x2  = 15
% AND  x5, x1, x2  = 4
% OR   x6, x1, x2  = 21
% XOR  x7, x1, x2  = 17
% SLT  x8, x2, x1  = 1
% SLTU x9, x2, x1  = 1
%
% ------------------------------------------------

program = uint32([

    encoder('ADDI x1, x0, 20')
    encoder('ADDI x2, x0, 5')

    encoder('ADD  x3, x1, x2')
    encoder('SUB  x4, x1, x2')
    encoder('AND  x5, x1, x2')
    encoder('OR   x6, x1, x2')
    encoder('XOR  x7, x1, x2')
    encoder('SLT  x8, x2, x1')
    encoder('SLTU x9, x2, x1')

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

expected = zeros(9,1,'uint32');

expected(1) = uint32(20);
expected(2) = uint32(5);
expected(3) = uint32(25);
expected(4) = uint32(15);
expected(5) = uint32(4);
expected(6) = uint32(21);
expected(7) = uint32(17);
expected(8) = uint32(1);
expected(9) = uint32(1);

% ------------------------------------------------
% Display results
% ------------------------------------------------

fprintf('Register results:\n\n');

fprintf('x1  = %u   Expected = %u\n', ...
    registers(2), expected(1));

fprintf('x2  = %u   Expected = %u\n', ...
    registers(3), expected(2));

fprintf('x3  = %u   Expected = %u\n', ...
    registers(4), expected(3));

fprintf('x4  = %u   Expected = %u\n', ...
    registers(5), expected(4));

fprintf('x5  = %u   Expected = %u\n', ...
    registers(6), expected(5));

fprintf('x6  = %u   Expected = %u\n', ...
    registers(7), expected(6));

fprintf('x7  = %u   Expected = %u\n', ...
    registers(8), expected(7));

fprintf('x8  = %u   Expected = %u\n', ...
    registers(9), expected(8));

fprintf('x9  = %u   Expected = %u\n', ...
    registers(10), expected(9));

fprintf('\n');

% ------------------------------------------------
% Individual tests
% ------------------------------------------------

testsPassed = 0;
testsTotal = 9;

if registers(2) == expected(1)
    fprintf('ADDI x1                : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('ADDI x1                : FAIL\n');
end

if registers(3) == expected(2)
    fprintf('ADDI x2                : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('ADDI x2                : FAIL\n');
end

if registers(4) == expected(3)
    fprintf('ADD                   : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('ADD                   : FAIL\n');
end

if registers(5) == expected(4)
    fprintf('SUB                   : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('SUB                   : FAIL\n');
end

if registers(6) == expected(5)
    fprintf('AND                   : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('AND                   : FAIL\n');
end

if registers(7) == expected(6)
    fprintf('OR                    : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('OR                    : FAIL\n');
end

if registers(8) == expected(7)
    fprintf('XOR                   : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('XOR                   : FAIL\n');
end

if registers(9) == expected(8)
    fprintf('SLT                   : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('SLT                   : FAIL\n');
end

if registers(10) == expected(9)
    fprintf('SLTU                  : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('SLTU                  : FAIL\n');
end

% ------------------------------------------------
% Final result
% ------------------------------------------------

fprintf('\n');
fprintf('Tests passed : %d / %d\n', testsPassed, testsTotal);

if testsPassed == testsTotal
    fprintf('STAGE 21.2.1 PASSED!\n');
else
    fprintf('STAGE 21.2.1 FAILED\n');
end

end