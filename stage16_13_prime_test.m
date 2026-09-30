function stage16_13_prime_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('       STAGE 16.13 - PRIME NUMBER DETECTION\n');
fprintf('       PART 2 - MULTIPLE NUMBERS\n');
fprintf('============================================================\n');

filename = fullfile( ...
    pwd, ...
    'programs', ...
    'stage16_13_prime.asm');

% ============================================================
% INITIAL MEMORY
% ============================================================

initialMemory = zeros(64,1,'uint8');

% ============================================================
% READ PROGRAM
% ============================================================

program = assembly_reader(filename);

% ============================================================
% RUN CPU
% ============================================================

[registers,pc,halted,dataMemory] = cpu( ...
    program, ...
    1000, ...
    initialMemory);

% ============================================================
% READ RESULTS
% ============================================================

result7  = readWord(dataMemory,16);
result10 = readWord(dataMemory,20);
result13 = readWord(dataMemory,24);
result15 = readWord(dataMemory,28);

testsPassed = 0;
totalTests = 5;

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    TEST RESULTS\n');
fprintf('============================================================\n');

% ============================================================
% TEST 7
% ============================================================

if result7 == 1
    fprintf('7  -> PRIME          : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('7  -> PRIME          : FAIL (got %u)\n',result7);
end

% ============================================================
% TEST 10
% ============================================================

if result10 == 0
    fprintf('10 -> NOT PRIME      : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('10 -> NOT PRIME      : FAIL (got %u)\n',result10);
end

% ============================================================
% TEST 13
% ============================================================

if result13 == 1
    fprintf('13 -> PRIME          : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('13 -> PRIME          : FAIL (got %u)\n',result13);
end

% ============================================================
% TEST 15
% ============================================================

if result15 == 0
    fprintf('15 -> NOT PRIME      : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('15 -> NOT PRIME      : FAIL (got %u)\n',result15);
end

% ============================================================
% CPU HALT TEST
% ============================================================

if halted
    fprintf('CPU HALTED            : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('CPU HALTED            : FAIL\n');
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
    fprintf('       STAGE 16.13 PART 2 PASSED!\n');
    fprintf('       MULTIPLE PRIME TESTS VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 16.13 PART 2 FAILED\n');
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