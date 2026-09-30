function stage21_2_7_test

clc;

fprintf('==============================================\n');
fprintf('STAGE 21.2.7 - BRANCH PIPELINE TEST\n');
fprintf('==============================================\n\n');

% ------------------------------------------------
% Branch test program
% ------------------------------------------------
%
% Each branch skips an ADDI instruction when taken.
%
% x1 = 10
% x2 = 10
%
% BEQ  -> taken
% BNE  -> not taken
%
% x3 should become 30
%
% x4 = 5
% x5 = 10
%
% BLT  -> taken
% BGE  -> not taken
%
% x6 should become 60
%
% x7 = 5
% x8 = 10
%
% BLTU -> taken
% BGEU -> not taken
%
% x9 should become 90
%
% ------------------------------------------------

program = uint32([

    % x1 = 10
    encoder('ADDI x1, x0, 10')

    % x2 = 10
    encoder('ADDI x2, x0, 10')

    % BEQ x1,x2,+8
    % Skip next ADDI
    encoder('BEQ x1, x2, 8')

    % This must be flushed
    encoder('ADDI x3, x0, 999')

    % Correct path
    encoder('ADDI x3, x0, 30')


    % BNE x1,x2,+8
    % Not taken, so next instruction executes
    encoder('BNE x1, x2, 8')

    encoder('ADDI x4, x0, 40')


    % x5 = 5
    encoder('ADDI x5, x0, 5')

    % x6 = 10
    encoder('ADDI x6, x0, 10')

    % BLT x5,x6,+8
    % Taken
    encoder('BLT x5, x6, 8')

    % Must be flushed
    encoder('ADDI x7, x0, 999')

    % Correct path
    encoder('ADDI x7, x0, 60')


    % x8 = 5
    encoder('ADDI x8, x0, 5')

    % x9 = 10
    encoder('ADDI x9, x0, 10')

    % BGE x8,x9,+8
    % Not taken
    encoder('BGE x8, x9, 8')

    encoder('ADDI x10, x0, 70')


    % x11 = 5
    encoder('ADDI x11, x0, 5')

    % x12 = 10
    encoder('ADDI x12, x0, 10')

    % BLTU x11,x12,+8
    % Taken
    encoder('BLTU x11, x12, 8')

    % Must be flushed
    encoder('ADDI x13, x0, 999')

    encoder('ADDI x13, x0, 90')


    % BGEU x11,x12,+8
    % Not taken
    encoder('BGEU x11, x12, 8')

    encoder('ADDI x14, x0, 100')

]);

% ------------------------------------------------
% Run CPU
% ------------------------------------------------

initialMemory = zeros(1024,1,'uint8');

result = pipeline_cpu(program, initialMemory, 200);

registers = result.registers;

% ------------------------------------------------
% Expected values
% ------------------------------------------------

expected = zeros(14,1,'uint32');

expected(1)  = uint32(10);
expected(2)  = uint32(10);
expected(3)  = uint32(30);
expected(4)  = uint32(40);
expected(5)  = uint32(5);
expected(6)  = uint32(10);
expected(7)  = uint32(60);
expected(8)  = uint32(5);
expected(9)  = uint32(10);
expected(10) = uint32(70);
expected(11) = uint32(5);
expected(12) = uint32(10);
expected(13) = uint32(90);
expected(14) = uint32(100);

% ------------------------------------------------
% Display results
% ------------------------------------------------

fprintf('Register results:\n\n');

for i = 1:14
    fprintf('x%-2d = %10u   Expected = %10u\n', ...
        i, registers(i+1), expected(i));
end

fprintf('\n');

% ------------------------------------------------
% Tests
% ------------------------------------------------

testsPassed = 0;
testsTotal = 14;

for i = 1:14

    if registers(i+1) == expected(i)
        fprintf('x%-2d branch result      : PASS\n', i);
        testsPassed = testsPassed + 1;
    else
        fprintf('x%-2d branch result      : FAIL\n', i);
    end

end

% ------------------------------------------------
% Final result
% ------------------------------------------------

fprintf('\n');
fprintf('Tests passed : %d / %d\n', testsPassed, testsTotal);

if testsPassed == testsTotal
    fprintf('STAGE 21.2.7 PASSED!\n');
else
    fprintf('STAGE 21.2.7 FAILED\n');
end

end