function stage16_8_integrated_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('       STAGE 16.8 - ARRAY + FUNCTION + CONDITIONAL TEST\n');
fprintf('============================================================\n');

filename = fullfile( ...
    pwd, ...
    'programs', ...
    'stage16_8_integrated.asm');

fprintf('\n');
fprintf('Assembly file:\n%s\n',filename);

initialMemory = zeros(16,1,'uint8');

initialMemory(1:4) = typecast(uint32(10),'uint8');
initialMemory(5:8) = typecast(uint32(20),'uint8');
initialMemory(9:12) = typecast(uint32(30),'uint8');
initialMemory(13:16) = typecast(uint32(40),'uint8');

program = assembly_reader(filename);

fprintf('\n');
fprintf('Program:\n');
fprintf('------------------------------------------------------------\n');

for i = 1:length(program)
    fprintf('%d. %s\n',i,program{i});
end

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    CPU EXECUTION\n');
fprintf('============================================================\n');

[registers,pc,halted,dataMemory] = cpu( ...
    program, ...
    200, ...
    initialMemory);

storedResult = readWord(dataMemory,16);

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    FINAL RESULTS\n');
fprintf('============================================================\n');

fprintf('x1 = %u\n',registers(2));
fprintf('x2 = %u\n',registers(3));
fprintf('x3 = %u\n',registers(4));
fprintf('x4 = %u\n',registers(5));
fprintf('x5 = %u\n',registers(6));
fprintf('x6 = %u\n',registers(7));
fprintf('x7 = %u\n',registers(8));
fprintf('x8 = %u\n',registers(9));

fprintf('\n');
fprintf('Memory[16] = %u\n',storedResult);

fprintf('Final PC = %u\n',pc);

if halted
    fprintf('Status = HALTED\n');
else
    fprintf('Status = NOT HALTED\n');
end

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    TEST RESULTS\n');
fprintf('============================================================\n');

passed = 0;
totalTests = 5;

% ------------------------------------------------------------
% TEST 1
% ------------------------------------------------------------

if registers(4) == uint32(100)

    fprintf('x3 = 100       : PASS');
    passed = passed + 1;

else

    fprintf('x3 = 100       : FAIL (got %u)', ...
        registers(4));

end

fprintf('\n');


% ------------------------------------------------------------
% TEST 2
% ------------------------------------------------------------

if registers(7) == uint32(150)

    fprintf('x6 = 150       : PASS');
    passed = passed + 1;

else

    fprintf('x6 = 150       : FAIL (got %u)', ...
        registers(7));

end

fprintf('\n');


% ------------------------------------------------------------
% TEST 3
% ------------------------------------------------------------

if storedResult == uint32(150)

    fprintf('MEM[16] = 150  : PASS');
    passed = passed + 1;

else

    fprintf('MEM[16] = 150  : FAIL (got %u)', ...
        storedResult);

end

fprintf('\n');


% ------------------------------------------------------------
% TEST 4
%
% JAL is at PC = 36.
%
% RISC-V JAL stores PC + 4 into rd.
%
% Therefore:
%
% x7 = 36 + 4 = 40
%
% ------------------------------------------------------------

if registers(8) == uint32(40)

    fprintf('x7 return addr : PASS');
    passed = passed + 1;

else

    fprintf('x7 return addr : FAIL (got %u)', ...
        registers(8));

end

fprintf('\n');


% ------------------------------------------------------------
% TEST 5
% ------------------------------------------------------------

if halted

    fprintf('CPU HALTED     : PASS');
    passed = passed + 1;

else

    fprintf('CPU HALTED     : FAIL');

end

fprintf('\n');

fprintf('\n');
fprintf('============================================================\n');
fprintf('Tests passed : %d / %d\n',passed,totalTests);
fprintf('============================================================\n');

if passed == totalTests

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 16.8 PASSED!\n');
    fprintf('       ARRAY + FUNCTION + CONDITIONAL\n');
    fprintf('       INTEGRATION VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 16.8 FAILED\n');
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