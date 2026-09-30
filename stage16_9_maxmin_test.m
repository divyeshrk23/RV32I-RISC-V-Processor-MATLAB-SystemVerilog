function stage16_9_maxmin_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('          STAGE 16.9 - ARRAY MAXIMUM + MINIMUM TEST\n');
fprintf('============================================================\n');

filename = fullfile( ...
    pwd, ...
    'programs', ...
    'stage16_9_maxmin.asm');

fprintf('\n');
fprintf('Assembly file:\n%s\n',filename);


% =============================================================
% INITIAL DATA MEMORY
% =============================================================

initialMemory = zeros(32,1,'uint8');

% MEM[0] = 25
initialMemory(1:4) = typecast(uint32(25),'uint8');

% MEM[4] = 7
initialMemory(5:8) = typecast(uint32(7),'uint8');

% MEM[8] = 42
initialMemory(9:12) = typecast(uint32(42),'uint8');

% MEM[12] = 18
initialMemory(13:16) = typecast(uint32(18),'uint8');

% MEM[16] = 33
initialMemory(17:20) = typecast(uint32(33),'uint8');


% =============================================================
% READ ASSEMBLY PROGRAM
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
    200, ...
    initialMemory);


% =============================================================
% READ RESULTS FROM MEMORY
% =============================================================

maximumMemory = readWord(dataMemory,24);
minimumMemory = readWord(dataMemory,28);


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

fprintf('Maximum register x3 = %u\n',registers(4));
fprintf('Minimum register x4 = %u\n',registers(5));

fprintf('\n');

fprintf('Memory[24] = %u\n',maximumMemory);
fprintf('Memory[28] = %u\n',minimumMemory);

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
% TEST 1 - MAXIMUM REGISTER
% -------------------------------------------------------------

if registers(4) == uint32(42)

    fprintf('x3 = 42        : PASS');
    passed = passed + 1;

else

    fprintf('x3 = 42        : FAIL (got %u)', ...
        registers(4));

end

fprintf('\n');


% -------------------------------------------------------------
% TEST 2 - MINIMUM REGISTER
% -------------------------------------------------------------

if registers(5) == uint32(7)

    fprintf('x4 = 7         : PASS');
    passed = passed + 1;

else

    fprintf('x4 = 7         : FAIL (got %u)', ...
        registers(5));

end

fprintf('\n');


% -------------------------------------------------------------
% TEST 3 - MAXIMUM MEMORY
% -------------------------------------------------------------

if maximumMemory == uint32(42)

    fprintf('MEM[24] = 42   : PASS');
    passed = passed + 1;

else

    fprintf('MEM[24] = 42   : FAIL (got %u)', ...
        maximumMemory);

end

fprintf('\n');


% -------------------------------------------------------------
% TEST 4 - MINIMUM MEMORY
% -------------------------------------------------------------

if minimumMemory == uint32(7)

    fprintf('MEM[28] = 7    : PASS');
    passed = passed + 1;

else

    fprintf('MEM[28] = 7    : FAIL (got %u)', ...
        minimumMemory);

end

fprintf('\n');


% -------------------------------------------------------------
% TEST 5 - LOOP COMPLETION
% -------------------------------------------------------------

if registers(3) == uint32(0)

    fprintf('Loop counter = 0 : PASS');
    passed = passed + 1;

else

    fprintf('Loop counter = 0 : FAIL (got %u)', ...
        registers(3));

end

fprintf('\n');


% -------------------------------------------------------------
% TEST 6 - CPU HALTED
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
    fprintf('       STAGE 16.9 PASSED!\n');
    fprintf('       ARRAY MAX/MIN SEARCH VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 16.9 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end


% =============================================================
% READ 32-BIT WORD FROM BYTE-ADDRESSABLE MEMORY
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