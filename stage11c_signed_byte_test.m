clc;
clear;

fprintf('\n');
fprintf('============================================================\n');
fprintf('       STAGE 11C-2 - SIGNED/UNSIGNED BYTE TEST\n');
fprintf('============================================================\n');


% ============================================================
% PROGRAM
% ============================================================

program = {

    'ADDI x1, x0, 100'
    'ADDI x2, x0, 255'
    'SB x2, 0(x1)'
    'LB x3, 0(x1)'
    'LBU x4, 0(x1)'

};


% ============================================================
% DISPLAY PROGRAM
% ============================================================

fprintf('\n');
fprintf('Program:\n');
fprintf('------------------------------------------------------------\n');

for i = 1:length(program)

    fprintf('%d. %s\n',i,program{i});

end


% ============================================================
% RUN CPU
% ============================================================

[registers,pc,halted,dataMemory] = cpu( ...
    program, ...
    20);


% ============================================================
% RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    FINAL RESULTS\n');
fprintf('============================================================\n');

fprintf('\n');

fprintf('x1 = %u\n',registers(2));

fprintf('x2 = %u\n',registers(3));

fprintf('x3 = 0x%08X\n',registers(4));

fprintf('x4 = 0x%08X\n',registers(5));

fprintf( ...
    'Memory[100] = 0x%02X\n', ...
    dataMemory(101));


% ============================================================
% EXPECTED VALUES
% ============================================================

expectedX1 = uint32(100);

expectedX2 = uint32(255);

% LB sign extends 0xFF to 0xFFFFFFFF
expectedLB = uint32(hex2dec('FFFFFFFF'));

% LBU zero extends 0xFF to 0x000000FF
expectedLBU = uint32(255);


% ============================================================
% TESTS
% ============================================================

test1 = registers(2) == expectedX1;

test2 = registers(3) == expectedX2;

test3 = registers(4) == expectedLB;

test4 = registers(5) == expectedLBU;


% ============================================================
% DISPLAY TEST RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    TEST RESULTS\n');
fprintf('============================================================\n');

fprintf('\n');


fprintf('x1 = 100               : ');

if test1
    fprintf('PASS\n');
else
    fprintf('FAIL\n');
end


fprintf('x2 = 255               : ');

if test2
    fprintf('PASS\n');
else
    fprintf('FAIL\n');
end


fprintf('LB  = 0xFFFFFFFF      : ');

if test3
    fprintf('PASS\n');
else
    fprintf('FAIL\n');
end


fprintf('LBU = 0x000000FF      : ');

if test4
    fprintf('PASS\n');
else
    fprintf('FAIL\n');
end


% ============================================================
% FINAL RESULT
% ============================================================

fprintf('\n');

if test1 && test2 && test3 && test4 && halted

    fprintf('********************************************\n');
    fprintf('      STAGE 11C-2 TEST PASSED!             \n');
    fprintf('    LB / LBU SIGN EXTENSION WORKING        \n');
    fprintf('********************************************\n');

else

    fprintf('********************************************\n');
    fprintf('      STAGE 11C-2 TEST FAILED              \n');
    fprintf('********************************************\n');

end


fprintf('\n');
fprintf('============================================================\n');