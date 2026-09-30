function stage21_2_5_test

clc;

fprintf('==============================================\n');
fprintf('STAGE 21.2.5 - LOAD PIPELINE TEST\n');
fprintf('==============================================\n\n');

% ------------------------------------------------
% Memory layout
% ------------------------------------------------
%
% Address 100:
%   byte 0 = 0x78
%   byte 1 = 0x56
%   byte 2 = 0x34
%   byte 3 = 0x12
%
% Therefore:
%
% LW  100 -> 0x12345678
% LB  100 -> 0x00000078
% LBU 100 -> 0x00000078
% LH  100 -> 0x00005678
% LHU 100 -> 0x00005678
%
% Address 104:
%   byte 0 = 0x80
%   byte 1 = 0xFF
%
% LH  104 -> 0xFFFFFF80
% LHU 104 -> 0x0000FF80
%
% ------------------------------------------------

initialMemory = zeros(1024,1,'uint8');

initialMemory(101) = uint8(hex2dec('78'));
initialMemory(102) = uint8(hex2dec('56'));
initialMemory(103) = uint8(hex2dec('34'));
initialMemory(104) = uint8(hex2dec('12'));

initialMemory(105) = uint8(hex2dec('80'));
initialMemory(106) = uint8(hex2dec('FF'));

% ------------------------------------------------
% Program
% ------------------------------------------------
%
% x1 = 100
%
% x2 = LW  0(x1)
% x3 = LB  0(x1)
% x4 = LBU 0(x1)
% x5 = LH  0(x1)
% x6 = LHU 0(x1)
%
% x7 = LH  4(x1)
% x8 = LHU 4(x1)
%
% x9 = dependent instruction using loaded value
%
% ------------------------------------------------

program = uint32([

    encoder('ADDI x1, x0, 100')

    encoder('LW   x2, 0(x1)')
    encoder('LB   x3, 0(x1)')
    encoder('LBU  x4, 0(x1)')
    encoder('LH   x5, 0(x1)')
    encoder('LHU  x6, 0(x1)')

    encoder('LH   x7, 4(x1)')
    encoder('LHU  x8, 4(x1)')

    % Load-use dependency test
    encoder('LW   x9, 0(x1)')
    encoder('ADDI x10, x9, 1')

]);

% ------------------------------------------------
% Run pipeline CPU
% ------------------------------------------------

result = pipeline_cpu(program, initialMemory, 150);

registers = result.registers;

% ------------------------------------------------
% Expected values
% ------------------------------------------------

expected = zeros(10,1,'uint32');

expected(1)  = uint32(100);

expected(2)  = uint32(hex2dec('12345678'));
expected(3)  = uint32(hex2dec('00000078'));
expected(4)  = uint32(hex2dec('00000078'));
expected(5)  = uint32(hex2dec('00005678'));
expected(6)  = uint32(hex2dec('00005678'));

expected(7)  = uint32(hex2dec('FFFFFF80'));
expected(8)  = uint32(hex2dec('0000FF80'));

expected(9)  = uint32(hex2dec('12345678'));

expected(10) = uint32(hex2dec('12345679'));

% ------------------------------------------------
% Display results
% ------------------------------------------------

fprintf('Register results:\n\n');

for i = 1:10
    fprintf('x%-2d = %10u   Expected = %10u\n', ...
        i, registers(i+1), expected(i));
end

fprintf('\n');

% ------------------------------------------------
% Individual tests
% ------------------------------------------------

testsPassed = 0;
testsTotal = 10;

testNames = {
    'Address register'
    'LW'
    'LB'
    'LBU'
    'LH'
    'LHU'
    'LH signed'
    'LHU unsigned'
    'LW load-use'
    'Load-use ADDI'
};

for i = 1:10

    if registers(i+1) == expected(i)

        fprintf('%-22s : PASS\n', testNames{i});

        testsPassed = testsPassed + 1;

    else

        fprintf('%-22s : FAIL\n', testNames{i});

    end

end

% ------------------------------------------------
% Final result
% ------------------------------------------------

fprintf('\n');
fprintf('Tests passed : %d / %d\n', testsPassed, testsTotal);

if testsPassed == testsTotal
    fprintf('STAGE 21.2.5 PASSED!\n');
else
    fprintf('STAGE 21.2.5 FAILED\n');
end

end