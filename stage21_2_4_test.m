function stage21_2_4_test

clc;

fprintf('==============================================\n');
fprintf('STAGE 21.2.4 - SLT / SLTU PIPELINE TEST\n');
fprintf('==============================================\n\n');

% ------------------------------------------------
% Program
% ------------------------------------------------
%
% Signed comparisons:
%
% x1 = -10
% x2 = 5
%
% SLT  x3, x1, x2 = 1
% SLT  x4, x2, x1 = 0
%
% x5 = 10
% x6 = 20
%
% SLT  x7, x5, x6 = 1
% SLT  x8, x6, x5 = 0
%
% Unsigned comparisons:
%
% x9  = 10
% x10 = 20
%
% SLTU x11, x9, x10 = 1
% SLTU x12, x10, x9 = 0
%
% ------------------------------------------------

program = uint32([

    encoder('ADDI x1, x0, -10')
    encoder('ADDI x2, x0, 5')

    encoder('SLT x3, x1, x2')
    encoder('SLT x4, x2, x1')

    encoder('ADDI x5, x0, 10')
    encoder('ADDI x6, x0, 20')

    encoder('SLT x7, x5, x6')
    encoder('SLT x8, x6, x5')

    encoder('ADDI x9,  x0, 10')
    encoder('ADDI x10, x0, 20')

    encoder('SLTU x11, x9, x10')
    encoder('SLTU x12, x10, x9')

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

expected = zeros(12,1,'uint32');

expected(1)  = uint32(4294967286); % -10
expected(2)  = uint32(5);
expected(3)  = uint32(1);
expected(4)  = uint32(0);
expected(5)  = uint32(10);
expected(6)  = uint32(20);
expected(7)  = uint32(1);
expected(8)  = uint32(0);
expected(9)  = uint32(10);
expected(10) = uint32(20);
expected(11) = uint32(1);
expected(12) = uint32(0);

% ------------------------------------------------
% Display results
% ------------------------------------------------

fprintf('Register results:\n\n');

for i = 1:12
    fprintf('x%-2d = %10u   Expected = %10u\n', ...
        i, registers(i+1), expected(i));
end

fprintf('\n');

% ------------------------------------------------
% Individual tests
% ------------------------------------------------

testsPassed = 0;
testsTotal = 12;

for i = 1:12

    if registers(i+1) == expected(i)

        switch i
            case 1
                fprintf('Signed negative input : PASS\n');
            case 2
                fprintf('Signed positive input: PASS\n');
            case 3
                fprintf('SLT negative < positive : PASS\n');
            case 4
                fprintf('SLT positive < negative : PASS\n');
            case 5
                fprintf('SLT input A           : PASS\n');
            case 6
                fprintf('SLT input B           : PASS\n');
            case 7
                fprintf('SLT A < B             : PASS\n');
            case 8
                fprintf('SLT B < A             : PASS\n');
            case 9
                fprintf('SLTU input A          : PASS\n');
            case 10
                fprintf('SLTU input B          : PASS\n');
            case 11
                fprintf('SLTU A < B            : PASS\n');
            case 12
                fprintf('SLTU B < A            : PASS\n');
        end

        testsPassed = testsPassed + 1;

    else

        switch i
            case 1
                fprintf('Signed negative input : FAIL\n');
            case 2
                fprintf('Signed positive input: FAIL\n');
            case 3
                fprintf('SLT negative < positive : FAIL\n');
            case 4
                fprintf('SLT positive < negative : FAIL\n');
            case 5
                fprintf('SLT input A           : FAIL\n');
            case 6
                fprintf('SLT input B           : FAIL\n');
            case 7
                fprintf('SLT A < B             : FAIL\n');
            case 8
                fprintf('SLT B < A             : FAIL\n');
            case 9
                fprintf('SLTU input A          : FAIL\n');
            case 10
                fprintf('SLTU input B          : FAIL\n');
            case 11
                fprintf('SLTU A < B            : FAIL\n');
            case 12
                fprintf('SLTU B < A            : FAIL\n');
        end

    end
end

% ------------------------------------------------
% Final result
% ------------------------------------------------

fprintf('\n');
fprintf('Tests passed : %d / %d\n', testsPassed, testsTotal);

if testsPassed == testsTotal
    fprintf('STAGE 21.2.4 PASSED!\n');
else
    fprintf('STAGE 21.2.4 FAILED\n');
end

end