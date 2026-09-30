function stage16_11_matrix_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('        STAGE 16.11 - 2x2 MATRIX MULTIPLICATION TEST\n');
fprintf('============================================================\n');

filename = fullfile( ...
    pwd, ...
    'programs', ...
    'stage16_11_matrix.asm');

fprintf('\n');
fprintf('Assembly file:\n%s\n',filename);


% =============================================================
% INITIAL MEMORY
% =============================================================

initialMemory = zeros(64,1,'uint8');

% Matrix A
initialMemory(1:4)   = typecast(uint32(1),'uint8');
initialMemory(5:8)   = typecast(uint32(2),'uint8');
initialMemory(9:12)  = typecast(uint32(3),'uint8');
initialMemory(13:16) = typecast(uint32(4),'uint8');

% Matrix B
initialMemory(17:20) = typecast(uint32(5),'uint8');
initialMemory(21:24) = typecast(uint32(6),'uint8');
initialMemory(25:28) = typecast(uint32(7),'uint8');
initialMemory(29:32) = typecast(uint32(8),'uint8');


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
    1000, ...
    initialMemory);


% =============================================================
% READ RESULT MATRIX
% =============================================================

c00 = readWord(dataMemory,32);
c01 = readWord(dataMemory,36);
c10 = readWord(dataMemory,40);
c11 = readWord(dataMemory,44);


% =============================================================
% FINAL RESULTS
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    FINAL RESULTS\n');
fprintf('============================================================\n');

fprintf('\n');
fprintf('Result matrix C:\n');

fprintf('[ %u   %u ]\n',c00,c01);
fprintf('[ %u   %u ]\n',c10,c11);

fprintf('\n');

fprintf('MEM[32] = %u\n',c00);
fprintf('MEM[36] = %u\n',c01);
fprintf('MEM[40] = %u\n',c10);
fprintf('MEM[44] = %u\n',c11);

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
totalTests = 5;


% -------------------------------------------------------------
% TEST 1
% -------------------------------------------------------------

if c00 == uint32(19)

    fprintf('C[0][0] = 19   : PASS');
    passed = passed + 1;

else

    fprintf('C[0][0] = 19   : FAIL (got %u)',c00);

end

fprintf('\n');


% -------------------------------------------------------------
% TEST 2
% -------------------------------------------------------------

if c01 == uint32(22)

    fprintf('C[0][1] = 22   : PASS');
    passed = passed + 1;

else

    fprintf('C[0][1] = 22   : FAIL (got %u)',c01);

end

fprintf('\n');


% -------------------------------------------------------------
% TEST 3
% -------------------------------------------------------------

if c10 == uint32(43)

    fprintf('C[1][0] = 43   : PASS');
    passed = passed + 1;

else

    fprintf('C[1][0] = 43   : FAIL (got %u)',c10);

end

fprintf('\n');


% -------------------------------------------------------------
% TEST 4
% -------------------------------------------------------------

if c11 == uint32(50)

    fprintf('C[1][1] = 50   : PASS');
    passed = passed + 1;

else

    fprintf('C[1][1] = 50   : FAIL (got %u)',c11);

end

fprintf('\n');


% -------------------------------------------------------------
% TEST 5
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
    fprintf('       STAGE 16.11 PASSED!\n');
    fprintf('       MATRIX MULTIPLICATION VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 16.11 FAILED\n');
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