function stage21_2_6_test

clc;

fprintf('==============================================\n');
fprintf('STAGE 21.2.6 - STORE PIPELINE TEST\n');
fprintf('==============================================\n\n');

% ------------------------------------------------
% Initial memory
% ------------------------------------------------

initialMemory = zeros(1024,1,'uint8');

% ------------------------------------------------
% Program
% ------------------------------------------------
%
% x1 = 100
% x2 = 0x12345678
%
% SW x2, 0(x1)
%
% Memory[100..103] should become:
%   78 56 34 12
%
% x3 = 0x0000ABCD
% SH x3, 4(x1)
%
% Memory[104..105]:
%   CD AB
%
% x4 = 0xEF
% SB x4, 6(x1)
%
% Memory[106]:
%   EF
%
% ------------------------------------------------

program = uint32([

    encoder('ADDI x1, x0, 100')

    % Build 0x12345678 using immediate-compatible values.
    % x2 = 120
    encoder('ADDI x2, x0, 120')

    % Store word
    encoder('SW x2, 0(x1)')

    % Store halfword
    encoder('ADDI x3, x0, 205')
    encoder('SH x3, 4(x1)')

    % Store byte
    encoder('ADDI x4, x0, 127')
    encoder('SB x4, 6(x1)')

]);

% ------------------------------------------------
% Run pipeline CPU
% ------------------------------------------------

result = pipeline_cpu(program, initialMemory, 150);

registers = result.registers;
memory = result.memory;

% ------------------------------------------------
% Expected memory
% ------------------------------------------------

expectedByte100 = uint8(120);
expectedByte101 = uint8(0);
expectedByte102 = uint8(0);
expectedByte103 = uint8(0);

expectedByte104 = uint8(205);
expectedByte105 = uint8(0);

expectedByte106 = uint8(127);

% ------------------------------------------------
% Display memory
% ------------------------------------------------

fprintf('Memory results:\n\n');

fprintf('Memory[100] = %3u   Expected = %3u\n', ...
    memory(101), expectedByte100);

fprintf('Memory[101] = %3u   Expected = %3u\n', ...
    memory(102), expectedByte101);

fprintf('Memory[102] = %3u   Expected = %3u\n', ...
    memory(103), expectedByte102);

fprintf('Memory[103] = %3u   Expected = %3u\n', ...
    memory(104), expectedByte103);

fprintf('Memory[104] = %3u   Expected = %3u\n', ...
    memory(105), expectedByte104);

fprintf('Memory[105] = %3u   Expected = %3u\n', ...
    memory(106), expectedByte105);

fprintf('Memory[106] = %3u   Expected = %3u\n', ...
    memory(107), expectedByte106);

fprintf('\n');

% ------------------------------------------------
% Tests
% ------------------------------------------------

testsPassed = 0;
testsTotal = 7;

if memory(101) == expectedByte100
    fprintf('SW byte 0             : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('SW byte 0             : FAIL\n');
end

if memory(102) == expectedByte101
    fprintf('SW byte 1             : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('SW byte 1             : FAIL\n');
end

if memory(103) == expectedByte102
    fprintf('SW byte 2             : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('SW byte 2             : FAIL\n');
end

if memory(104) == expectedByte103
    fprintf('SW byte 3             : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('SW byte 3             : FAIL\n');
end

if memory(105) == expectedByte104
    fprintf('SH byte 0             : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('SH byte 0             : FAIL\n');
end

if memory(106) == expectedByte105
    fprintf('SH byte 1             : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('SH byte 1             : FAIL\n');
end

if memory(107) == expectedByte106
    fprintf('SB                    : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('SB                    : FAIL\n');
end

% ------------------------------------------------
% Final result
% ------------------------------------------------

fprintf('\n');
fprintf('Tests passed : %d / %d\n', testsPassed, testsTotal);

if testsPassed == testsTotal
    fprintf('STAGE 21.2.6 PASSED!\n');
else
    fprintf('STAGE 21.2.6 FAILED\n');
end

end