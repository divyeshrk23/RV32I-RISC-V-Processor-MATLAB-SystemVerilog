function stage16_7_factorial_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('       STAGE 16.7 - FACTORIAL + MEMORY TEST\n');
fprintf('============================================================\n');


% =============================================================
% ASSEMBLY FILE
% =============================================================

filename = fullfile( ...
    pwd, ...
    'programs', ...
    'stage16_7_factorial.asm');


fprintf('\n');
fprintf('Assembly file:\n%s\n',filename);


% =============================================================
% READ PROGRAM
% =============================================================

program = assembly_reader(filename);


fprintf('\n');
fprintf('Program:\n');
fprintf('------------------------------------------------------------\n');

for i = 1:length(program)

    fprintf('%d. %s\n',i,program{i});

end


% =============================================================
% CPU EXECUTION
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    CPU EXECUTION\n');
fprintf('============================================================\n');

[registers,pc,halted,dataMemory] = cpu( ...
    program, ...
    200);


% =============================================================
% READ MEMORY RESULT
% =============================================================

storedResult = readWord(dataMemory,20);


% =============================================================
% FINAL RESULTS
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    FINAL RESULTS\n');
fprintf('============================================================\n');

fprintf('x1 = %u\n',registers(2));
fprintf('x2 = %u\n',registers(3));
fprintf('x3 = %u\n',registers(4));
fprintf('x4 = %u\n',registers(5));
fprintf('x5 = %u\n',registers(6));

fprintf('\n');
fprintf('Memory[20] = %u\n',storedResult);

fprintf('Final PC = %u\n',pc);

if halted

    fprintf('Status = HALTED\n');

else

    fprintf('Status = NOT HALTED\n');

end


% =============================================================
% TEST RESULTS
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    TEST RESULTS\n');
fprintf('============================================================\n');

passed = 0;

totalTests = 3;


% =============================================================
% TEST 1
% =============================================================

if registers(3) == uint32(120)

    fprintf('x2 = 120       : PASS');

    passed = passed + 1;

else

    fprintf('x2 = 120       : FAIL (got %u)', ...
        registers(3));

end

fprintf('\n');


% =============================================================
% TEST 2
% =============================================================

if storedResult == uint32(120)

    fprintf('MEM[20] = 120  : PASS');

    passed = passed + 1;

else

    fprintf('MEM[20] = 120  : FAIL (got %u)', ...
        storedResult);

end

fprintf('\n');


% =============================================================
% TEST 3
% =============================================================

if halted

    fprintf('CPU HALTED     : PASS');

    passed = passed + 1;

else

    fprintf('CPU HALTED     : FAIL');

end

fprintf('\n');


% =============================================================
% SUMMARY
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('Tests passed : %d / %d\n',passed,totalTests);
fprintf('============================================================\n');


if passed == totalTests

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 16.7 PASSED!\n');
    fprintf('       FACTORIAL + MEMORY VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 16.7 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end


% =============================================================
% READ 32-BIT LITTLE-ENDIAN WORD
% =============================================================

function value = readWord(memory,address)

index = double(address) + 1;

byte0 = uint32(memory(index));

byte1 = uint32(memory(index + 1));

byte2 = uint32(memory(index + 2));

byte3 = uint32(memory(index + 3));

value = bitor( ...
    byte0, ...
    bitshift(byte1,8));

value = bitor( ...
    value, ...
    bitshift(byte2,16));

value = bitor( ...
    value, ...
    bitshift(byte3,24));

value = uint32(value);

end