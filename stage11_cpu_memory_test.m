clc;
clear;

fprintf('\n');
fprintf('============================================================\n');
fprintf('       STAGE 11B - CPU + DATA MEMORY TEST\n');
fprintf('============================================================\n');


% ============================================================
% PROGRAM
% ============================================================

program = {

    'ADDI x1, x0, 100'
    'ADDI x2, x0, 123'
    'SW x2, 0(x1)'
    'LW x3, 0(x1)'

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
% DISPLAY RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    FINAL RESULTS\n');
fprintf('============================================================\n');

fprintf('\n');

fprintf('x1 = %u\n',registers(2));
fprintf('x2 = %u\n',registers(3));
fprintf('x3 = %u\n',registers(4));


% ============================================================
% CHECK MEMORY
% ============================================================

memoryAddress = 100;

memoryValue = ...
    uint32(dataMemory(memoryAddress+1)) + ...
    bitshift(uint32(dataMemory(memoryAddress+2)),8) + ...
    bitshift(uint32(dataMemory(memoryAddress+3)),16) + ...
    bitshift(uint32(dataMemory(memoryAddress+4)),24);


fprintf('\n');
fprintf('Memory[100] = %u\n',memoryValue);


% ============================================================
% EXPECTED RESULTS
% ============================================================

expectedX1 = uint32(100);
expectedX2 = uint32(123);
expectedX3 = uint32(123);
expectedMemory = uint32(123);


% ============================================================
% TEST
% ============================================================

test1 = registers(2) == expectedX1;
test2 = registers(3) == expectedX2;
test3 = registers(4) == expectedX3;
test4 = memoryValue == expectedMemory;


fprintf('\n');
fprintf('============================================================\n');
fprintf('                    TEST RESULTS\n');
fprintf('============================================================\n');


fprintf('\n');

fprintf('x1 = 100       : ');

if test1
    fprintf('PASS\n');
else
    fprintf('FAIL\n');
end


fprintf('x2 = 123       : ');

if test2
    fprintf('PASS\n');
else
    fprintf('FAIL\n');
end


fprintf('x3 = 123       : ');

if test3
    fprintf('PASS\n');
else
    fprintf('FAIL\n');
end


fprintf('Memory[100]=123: ');

if test4
    fprintf('PASS\n');
else
    fprintf('FAIL\n');
end


% ============================================================
% FINAL RESULT
% ============================================================

fprintf('\n');
fprintf('============================================================\n');

if test1 && test2 && test3 && test4 && halted

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('          STAGE 11B PASSED!                \n');
    fprintf('     CPU + DATA MEMORY WORKING             \n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('STAGE 11B FAILED\n');

end

fprintf('\n');
fprintf('============================================================\n');