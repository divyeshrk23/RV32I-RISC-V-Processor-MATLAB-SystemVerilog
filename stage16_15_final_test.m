function stage16_15_final_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('       STAGE 16.15 - FINAL INTEGRATED CPU TEST\n');
fprintf('============================================================\n');

filename = fullfile( ...
    pwd, ...
    'programs', ...
    'stage16_15_final.asm');

% ============================================================
% INITIAL MEMORY
% ============================================================

initialMemory = zeros(64,1,'uint8');

initialMemory(1:4)   = typecast(uint32(12),'uint8');
initialMemory(5:8)   = typecast(uint32(18),'uint8');
initialMemory(9:12)  = typecast(uint32(7),'uint8');
initialMemory(13:16) = typecast(uint32(25),'uint8');

% ============================================================
% READ PROGRAM
% ============================================================

program = assembly_reader(filename);

% ============================================================
% RUN CPU
% ============================================================

[registers,pc,halted,dataMemory] = cpu( ...
    program, ...
    3000, ...
    initialMemory);

% ============================================================
% READ RESULTS
% ============================================================

sumResult = readWord(dataMemory,16);
maxResult = readWord(dataMemory,20);
minResult = readWord(dataMemory,24);
gcdResult = readWord(dataMemory,28);
powResult = readWord(dataMemory,32);

testsPassed = 0;
totalTests = 6;

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    TEST RESULTS\n');
fprintf('============================================================\n');

% ------------------------------------------------------------
% SUM
% ------------------------------------------------------------

if sumResult == 62
    fprintf('SUM = 62              : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('SUM = 62              : FAIL (got %u)\n',sumResult);
end

% ------------------------------------------------------------
% MAX
% ------------------------------------------------------------

if maxResult == 25
    fprintf('MAX = 25              : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('MAX = 25              : FAIL (got %u)\n',maxResult);
end

% ------------------------------------------------------------
% MIN
% ------------------------------------------------------------

if minResult == 7
    fprintf('MIN = 7               : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('MIN = 7               : FAIL (got %u)\n',minResult);
end

% ------------------------------------------------------------
% GCD
% ------------------------------------------------------------

if gcdResult == 1
    fprintf('GCD = 1               : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('GCD = 1               : FAIL (got %u)\n',gcdResult);
end

% ------------------------------------------------------------
% POWER
% ------------------------------------------------------------

if powResult == 32
    fprintf('2^5 = 32              : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('2^5 = 32              : FAIL (got %u)\n',powResult);
end

% ------------------------------------------------------------
% HALT
% ------------------------------------------------------------

if halted
    fprintf('CPU HALTED             : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('CPU HALTED             : FAIL\n');
end

% ============================================================
% FINAL RESULT
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('Tests passed : %d / %d\n',testsPassed,totalTests);
fprintf('============================================================\n');

if testsPassed == totalTests

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 16.15 PASSED!\n');
    fprintf('       FINAL CPU INTEGRATION VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 16.15 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end


% ============================================================
% READ 32-BIT WORD FROM BYTE MEMORY
% ============================================================

function value = readWord(memory,address)

index = double(address) + 1;

byte0 = uint32(memory(index));
byte1 = uint32(memory(index + 1));
byte2 = uint32(memory(index + 2));
byte3 = uint32(memory(index + 3));

value = bitor(byte0,bitshift(byte1,8));
value = bitor(value,bitshift(byte2,16));
value = bitor(value,bitshift(byte3,24));

value = uint32(value);

end