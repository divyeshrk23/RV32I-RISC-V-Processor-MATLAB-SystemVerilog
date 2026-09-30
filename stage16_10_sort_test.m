function stage16_10_sort_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('             STAGE 16.10 - ARRAY SORT TEST\n');
fprintf('============================================================\n');

filename = fullfile( ...
    pwd, ...
    'programs', ...
    'stage16_10_sort.asm');

fprintf('\n');
fprintf('Assembly file:\n%s\n',filename);


% =============================================================
% INITIAL MEMORY
% =============================================================

initialMemory = zeros(32,1,'uint8');

% [25, 7, 42, 18, 33]

initialMemory(1:4) = typecast(uint32(25),'uint8');
initialMemory(5:8) = typecast(uint32(7),'uint8');
initialMemory(9:12) = typecast(uint32(42),'uint8');
initialMemory(13:16) = typecast(uint32(18),'uint8');
initialMemory(17:20) = typecast(uint32(33),'uint8');


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
    500, ...
    initialMemory);


% =============================================================
% READ SORTED ARRAY
% =============================================================

value0 = readWord(dataMemory,0);
value4 = readWord(dataMemory,4);
value8 = readWord(dataMemory,8);
value12 = readWord(dataMemory,12);
value16 = readWord(dataMemory,16);


% =============================================================
% FINAL RESULTS
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    FINAL RESULTS\n');
fprintf('============================================================\n');

fprintf('MEM[0]  = %u\n',value0);
fprintf('MEM[4]  = %u\n',value4);
fprintf('MEM[8]  = %u\n',value8);
fprintf('MEM[12] = %u\n',value12);
fprintf('MEM[16] = %u\n',value16);

fprintf('\n');

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
totalTests = 6;


% -------------------------------------------------------------
% TEST 1
% -------------------------------------------------------------

if value0 == uint32(7)

    fprintf('MEM[0] = 7     : PASS');
    passed = passed + 1;

else

    fprintf('MEM[0] = 7     : FAIL (got %u)',value0);

end

fprintf('\n');


% -------------------------------------------------------------
% TEST 2
% -------------------------------------------------------------

if value4 == uint32(18)

    fprintf('MEM[4] = 18    : PASS');
    passed = passed + 1;

else

    fprintf('MEM[4] = 18    : FAIL (got %u)',value4);

end

fprintf('\n');


% -------------------------------------------------------------
% TEST 3
% -------------------------------------------------------------

if value8 == uint32(25)

    fprintf('MEM[8] = 25    : PASS');
    passed = passed + 1;

else

    fprintf('MEM[8] = 25    : FAIL (got %u)',value8);

end

fprintf('\n');


% -------------------------------------------------------------
% TEST 4
% -------------------------------------------------------------

if value12 == uint32(33)

    fprintf('MEM[12] = 33   : PASS');
    passed = passed + 1;

else

    fprintf('MEM[12] = 33   : FAIL (got %u)',value12);

end

fprintf('\n');


% -------------------------------------------------------------
% TEST 5
% -------------------------------------------------------------

if value16 == uint32(42)

    fprintf('MEM[16] = 42   : PASS');
    passed = passed + 1;

else

    fprintf('MEM[16] = 42   : FAIL (got %u)',value16);

end

fprintf('\n');


% -------------------------------------------------------------
% TEST 6
% -------------------------------------------------------------

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
    fprintf('       STAGE 16.10 PASSED!\n');
    fprintf('       ARRAY SORTING VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 16.10 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end


% =============================================================
% READ 32-BIT WORD
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