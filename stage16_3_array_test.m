function stage16_3_array_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('       STAGE 16.3 - ARRAY + MEMORY INTEGRATION TEST\n');
fprintf('============================================================\n');


% =============================================================
% ASSEMBLY FILE
% =============================================================

filename = fullfile( ...
    pwd, ...
    'programs', ...
    'stage16_3_array.asm');

fprintf('\n');
fprintf('Assembly file:\n%s\n',filename);


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
% INITIAL DATA MEMORY
% =============================================================
%
% Memory layout:
%
% Address 0  = 10
% Address 4  = 20
% Address 8  = 30
% Address 12 = 40
%
% Each value is stored as a 32-bit little-endian word.
% =============================================================

initialMemory = zeros(16,1,'uint8');


% -------------------------------------------------------------
% Address 0 = 10
% -------------------------------------------------------------

bytes10 = typecast(uint32(10),'uint8');

initialMemory(1:4) = bytes10(:);


% -------------------------------------------------------------
% Address 4 = 20
% -------------------------------------------------------------

bytes20 = typecast(uint32(20),'uint8');

initialMemory(5:8) = bytes20(:);


% -------------------------------------------------------------
% Address 8 = 30
% -------------------------------------------------------------

bytes30 = typecast(uint32(30),'uint8');

initialMemory(9:12) = bytes30(:);


% -------------------------------------------------------------
% Address 12 = 40
% -------------------------------------------------------------

bytes40 = typecast(uint32(40),'uint8');

initialMemory(13:16) = bytes40(:);


% =============================================================
% DISPLAY INITIAL MEMORY
% =============================================================

fprintf('\n');
fprintf('Initial data memory:\n');
fprintf('------------------------------------------------------------\n');

fprintf('Address 0  = %u\n',readWord(initialMemory,0));
fprintf('Address 4  = %u\n',readWord(initialMemory,4));
fprintf('Address 8  = %u\n',readWord(initialMemory,8));
fprintf('Address 12 = %u\n',readWord(initialMemory,12));


% =============================================================
% CPU EXECUTION
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    CPU EXECUTION\n');
fprintf('============================================================\n');

[registers,pc,halted,dataMemory] = cpu( ...
    program, ...
    100, ...
    initialMemory);


% =============================================================
% FINAL REGISTER RESULTS
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
fprintf('Final PC = %u\n',pc);

if halted

    fprintf('Status = HALTED\n');

else

    fprintf('Status = NOT HALTED\n');

end


% =============================================================
% READ STORED RESULT
% =============================================================
%
% The program executes:
%
% SW x3, 16(x0)
%
% Therefore address 16 should contain 100.
% =============================================================

storedResult = readWord(dataMemory,16);


fprintf('\n');
fprintf('============================================================\n');
fprintf('                    MEMORY RESULT\n');
fprintf('============================================================\n');

fprintf('Address 16 = %u\n',storedResult);


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
% Test 1
% -------------------------------------------------------------

if registers(2) == uint32(16)

    fprintf('x1 = 16   : PASS');

    passed = passed + 1;

else

    fprintf('x1 = 16   : FAIL (got %u)',registers(2));

end

fprintf('\n');


% -------------------------------------------------------------
% Test 2
% -------------------------------------------------------------

if registers(3) == uint32(4)

    fprintf('x2 = 4    : PASS');

    passed = passed + 1;

else

    fprintf('x2 = 4    : FAIL (got %u)',registers(3));

end

fprintf('\n');


% -------------------------------------------------------------
% Test 3
% -------------------------------------------------------------

if registers(4) == uint32(100)

    fprintf('x3 = 100  : PASS');

    passed = passed + 1;

else

    fprintf('x3 = 100  : FAIL (got %u)',registers(4));

end

fprintf('\n');


% -------------------------------------------------------------
% Test 4
% -------------------------------------------------------------

if registers(5) == uint32(40)

    fprintf('x4 = 40   : PASS');

    passed = passed + 1;

else

    fprintf('x4 = 40   : FAIL (got %u)',registers(5));

end

fprintf('\n');


% -------------------------------------------------------------
% Test 5
% -------------------------------------------------------------

if registers(6) == uint32(4)

    fprintf('x5 = 4    : PASS');

    passed = passed + 1;

else

    fprintf('x5 = 4    : FAIL (got %u)',registers(6));

end

fprintf('\n');


% -------------------------------------------------------------
% Test 6
% -------------------------------------------------------------

if storedResult == uint32(100)

    fprintf('MEM[16]=100: PASS');

    passed = passed + 1;

else

    fprintf('MEM[16]=100: FAIL (got %u)',storedResult);

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
    fprintf('       STAGE 16.3 PASSED!\n');
    fprintf('       ARRAY + MEMORY VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 16.3 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end


% =============================================================
% HELPER FUNCTION
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