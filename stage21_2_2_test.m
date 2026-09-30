function stage21_2_2_test

clc;

fprintf('==============================================\n');
fprintf('STAGE 21.2.2 - I-TYPE ALU PIPELINE TEST\n');
fprintf('==============================================\n\n');

% ------------------------------------------------
% Program
% ------------------------------------------------
%
% x1 = 20
%
% ADDI  x2, x1, 10   = 30
% ADDI  x3, x2, -5   = 25
% SLTI  x4, x3, 30    = 1
% SLTI  x5, x3, 20    = 0
%
% Unsigned comparisons:
%
% x6 = 5
% x7 = 10
% SLTIU x8, x6, 10   = 1
% SLTIU x9, x7, 5    = 0
%
% ------------------------------------------------

program = uint32([

    encoder('ADDI  x1, x0, 20')
    encoder('ADDI  x2, x1, 10')
    encoder('ADDI  x3, x2, -5')

    encoder('SLTI  x4, x3, 30')
    encoder('SLTI  x5, x3, 20')

    encoder('ADDI  x6, x0, 5')
    encoder('ADDI  x7, x0, 10')

    encoder('SLTIU x8, x6, 10')
    encoder('SLTIU x9, x7, 5')

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
expected(2) = uint32(30);
expected(3) = uint32(25);
expected(4) = uint32(1);
expected(5) = uint32(0);
expected(6) = uint32(5);
expected(7) = uint32(10);
expected(8) = uint32(1);
expected(9) = uint32(0);

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
fprintf('x8  = %u   Expected = %u\n', registers(9), expected(8));
fprintf('x9  = %u   Expected = %u\n', registers(10), expected(9));

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
    fprintf('ADDI negative          : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('ADDI negative          : FAIL\n');
end

if registers(5) == expected(4)
    fprintf('SLTI true              : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('SLTI true              : FAIL\n');
end

if registers(6) == expected(5)
    fprintf('SLTI false             : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('SLTI false             : FAIL\n');
end

if registers(7) == expected(6)
    fprintf('ADDI x6                : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('ADDI x6                : FAIL\n');
end

if registers(8) == expected(7)
    fprintf('ADDI x7                : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('ADDI x7                : FAIL\n');
end

if registers(9) == expected(8)
    fprintf('SLTIU true             : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('SLTIU true             : FAIL\n');
end

if registers(10) == expected(9)
    fprintf('SLTIU false            : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('SLTIU false            : FAIL\n');
end

% ------------------------------------------------
% Final result
% ------------------------------------------------

fprintf('\n');
fprintf('Tests passed : %d / %d\n', testsPassed, testsTotal);

if testsPassed == testsTotal
    fprintf('STAGE 21.2.2 PASSED!\n');
else
    fprintf('STAGE 21.2.2 FAILED\n');
end

end