function stage21_2_10_test

clc;

fprintf('==============================================\n');
fprintf('STAGE 21.2.10 - COMPLETE RV32I PIPELINE TEST\n');
fprintf('==============================================\n\n');

% ------------------------------------------------
% Initial memory
% ------------------------------------------------

initialMemory = zeros(1024,1,'uint8');

% ------------------------------------------------
% Program
% ------------------------------------------------
%
% This program combines:
%
%   ADDI
%   ADD
%   SUB
%   AND
%   OR
%   XOR
%   SLLI
%   SRLI
%   SLT
%   SLTU
%   SW
%   LW
%   Load-use dependency
%   BEQ
%   BNE
%   BLT
%   JAL
%   JALR
%
% ------------------------------------------------

program = uint32([

    % --------------------------------------------
    % Basic ALU
    % --------------------------------------------

    encoder('ADDI x1, x0, 10')
    encoder('ADDI x2, x0, 5')

    encoder('ADD  x3, x1, x2')
    encoder('SUB  x4, x1, x2')
    encoder('AND  x5, x1, x2')
    encoder('OR   x6, x1, x2')
    encoder('XOR  x7, x1, x2')

    % --------------------------------------------
    % Shift operations
    % --------------------------------------------

    encoder('SLLI x8, x2, 2')
    encoder('SRLI x9, x8, 1')

    % --------------------------------------------
    % Comparisons
    % --------------------------------------------

    encoder('SLT  x10, x2, x1')
    encoder('SLTU x11, x2, x1')

    % --------------------------------------------
    % Store / Load
    % --------------------------------------------

    encoder('ADDI x12, x0, 100')
    encoder('SW x3, 0(x12)')

    encoder('LW x13, 0(x12)')

    % Load-use dependency
    encoder('ADDI x14, x13, 1')

    % --------------------------------------------
    % BEQ
    % --------------------------------------------

    encoder('BEQ x3, x13, 8')

    % Must be flushed
    encoder('ADDI x15, x0, 999')

    encoder('ADDI x15, x0, 15')

    % --------------------------------------------
    % BNE not taken
    % --------------------------------------------

    encoder('BNE x3, x13, 8')

    encoder('ADDI x16, x0, 16')

    % --------------------------------------------
    % BLT
    % --------------------------------------------

    encoder('ADDI x17, x0, 3')
    encoder('BLT x17, x2, 8')

    % Must be flushed
    encoder('ADDI x18, x0, 999')

    encoder('ADDI x18, x0, 18')

    % --------------------------------------------
    % JAL
    % --------------------------------------------

    encoder('JAL x19, 8')

    % Must be flushed
    encoder('ADDI x20, x0, 999')

    encoder('ADDI x20, x0, 20')

    % --------------------------------------------
    % JALR
    % --------------------------------------------

    % x21 = address of final target = 120
    encoder('ADDI x21, x0, 120')

    encoder('JALR x22, 0(x21)')

    % Must be flushed
    encoder('ADDI x23, x0, 999')

    % Target area
    encoder('ADDI x23, x0, 23')

]);

% ------------------------------------------------
% Run pipeline
% ------------------------------------------------

result = pipeline_cpu(program, initialMemory, 300);

registers = result.registers;
memory = result.memory;

% ------------------------------------------------
% Expected results
% ------------------------------------------------

expected = zeros(23,1,'uint32');

expected(1)  = uint32(10);
expected(2)  = uint32(5);
expected(3)  = uint32(15);
expected(4)  = uint32(5);
expected(5)  = uint32(0);
expected(6)  = uint32(15);
expected(7)  = uint32(15);
expected(8)  = uint32(20);
expected(9)  = uint32(10);
expected(10) = uint32(1);
expected(11) = uint32(1);
expected(12) = uint32(100);
expected(13) = uint32(15);
expected(14) = uint32(16);
expected(15) = uint32(15);
expected(16) = uint32(16);
expected(17) = uint32(3);
expected(18) = uint32(18);

% ------------------------------------------------
% JAL return address
% ------------------------------------------------
%
% In this program JAL is located at PC = 96.
%
% JAL writes PC + 4 into x19:
%
% 96 + 4 = 100
%
expected(19) = uint32(100);

expected(20) = uint32(20);

expected(21) = uint32(120);

% ------------------------------------------------
% JALR return address
% ------------------------------------------------
%
% JALR is located at PC = 112.
%
% JALR writes PC + 4 into x22:
%
% 112 + 4 = 116
%
expected(22) = uint32(116);

expected(23) = uint32(23);

% ------------------------------------------------
% Display register results
% ------------------------------------------------

fprintf('Register results:\n\n');

for i = 1:23

    fprintf('x%-2d = %10u   Expected = %10u\n', ...
        i, registers(i+1), expected(i));

end

fprintf('\n');

% ------------------------------------------------
% Memory check
% ------------------------------------------------

fprintf('Memory check:\n\n');

fprintf('Memory[100] = %3u   Expected = %3u\n', ...
    memory(101), uint8(15));

fprintf('Memory[101] = %3u   Expected = %3u\n', ...
    memory(102), uint8(0));

fprintf('Memory[102] = %3u   Expected = %3u\n', ...
    memory(103), uint8(0));

fprintf('Memory[103] = %3u   Expected = %3u\n', ...
    memory(104), uint8(0));

fprintf('\n');

% ------------------------------------------------
% Tests
% ------------------------------------------------

testsPassed = 0;
testsTotal = 27;

% ------------------------------------------------
% Register tests
% ------------------------------------------------

for i = 1:23

    if registers(i+1) == expected(i)

        fprintf('x%-2d                  : PASS\n', i);

        testsPassed = testsPassed + 1;

    else

        fprintf('x%-2d                  : FAIL\n', i);

    end

end

% ------------------------------------------------
% Memory tests
% ------------------------------------------------

if memory(101) == uint8(15)

    fprintf('Memory byte 0         : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('Memory byte 0         : FAIL\n');

end

if memory(102) == uint8(0)

    fprintf('Memory byte 1         : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('Memory byte 1         : FAIL\n');

end

if memory(103) == uint8(0)

    fprintf('Memory byte 2         : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('Memory byte 2         : FAIL\n');

end

if memory(104) == uint8(0)

    fprintf('Memory byte 3         : PASS\n');

    testsPassed = testsPassed + 1;

else

    fprintf('Memory byte 3         : FAIL\n');

end

% ------------------------------------------------
% Final result
% ------------------------------------------------

fprintf('\n');

fprintf('Tests passed : %d / %d\n', ...
    testsPassed, testsTotal);

if testsPassed == testsTotal

    fprintf('STAGE 21.2.10 PASSED!\n');
    fprintf('STAGE 21.2 COMPLETE!\n');

else

    fprintf('STAGE 21.2.10 FAILED\n');

end

end