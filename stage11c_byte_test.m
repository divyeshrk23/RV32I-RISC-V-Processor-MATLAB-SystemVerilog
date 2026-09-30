clc;
clear;

fprintf('\n');
fprintf('============================================================\n');
fprintf('       STAGE 11C - BYTE LOAD/STORE TEST\n');
fprintf('============================================================\n');


% ============================================================
% PROGRAM
% ============================================================

program = {

    'ADDI x1, x0, 100'
    'ADDI x2, x0, 127'
    'SB x2, 0(x1)'
    'LB x3, 0(x1)'

};


% ============================================================
% DISPLAY PROGRAM
% ============================================================

fprintf('\n');
fprintf('Program:\n');
fprintf('------------------------------------------------------------\n');


for i = 1:length(program)

    fprintf( ...
        '%d. %s\n', ...
        i, ...
        program{i});

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

fprintf( ...
    'x1 = %u\n', ...
    registers(2));


fprintf( ...
    'x2 = %u\n', ...
    registers(3));


fprintf( ...
    'x3 = %u\n', ...
    registers(4));


fprintf( ...
    'Memory[100] = 0x%02X\n', ...
    dataMemory(101));


% ============================================================
% EXPECTED
% ============================================================

expectedX1 = uint32(100);
expectedX2 = uint32(127);
expectedX3 = uint32(127);


test1 = registers(2) == expectedX1;
test2 = registers(3) == expectedX2;
test3 = registers(4) == expectedX3;


fprintf('\n');
fprintf('============================================================\n');
fprintf('                    TEST RESULTS\n');
fprintf('============================================================\n');


fprintf('\n');

fprintf('x1 = 100 : ');

if test1
    fprintf('PASS\n');
else
    fprintf('FAIL\n');
end


fprintf('x2 = 127 : ');

if test2
    fprintf('PASS\n');
else
    fprintf('FAIL\n');
end


fprintf('x3 = 127 : ');

if test3
    fprintf('PASS\n');
else
    fprintf('FAIL\n');
end


fprintf('\n');

if test1 && test2 && test3 && halted

    fprintf('********************************************\n');
    fprintf('          STAGE 11C BYTE TEST PASSED!     \n');
    fprintf('********************************************\n');

else

    fprintf('STAGE 11C BYTE TEST FAILED\n');

end


fprintf('\n');
fprintf('============================================================\n');