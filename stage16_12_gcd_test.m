function stage16_12_gcd_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('       STAGE 16.12 - GCD / EUCLIDEAN ALGORITHM\n');
fprintf('============================================================\n');

filename = fullfile( ...
    pwd, ...
    'programs', ...
    'stage16_12_gcd.asm');

% ============================================================
% INITIAL MEMORY
% ============================================================

initialMemory = zeros(16,1,'uint8');

% MEM[0] = 48
initialMemory(1:4) = typecast(uint32(48),'uint8');

% MEM[4] = 18
initialMemory(5:8) = typecast(uint32(18),'uint8');

% ============================================================
% READ PROGRAM
% ============================================================

program = assembly_reader(filename);

% ============================================================
% RUN CPU
% ============================================================

[registers,pc,halted,dataMemory] = cpu( ...
    program, ...
    500, ...
    initialMemory);

% ============================================================
% READ RESULT
% ============================================================

result = readWord(dataMemory,8);

% ============================================================
% TESTS
% ============================================================

testsPassed = 0;
totalTests = 4;

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    TEST RESULTS\n');
fprintf('============================================================\n');

% ------------------------------------------------------------
% Test 1
% ------------------------------------------------------------

if result == 6
    fprintf('GCD(48,18) = 6       : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('GCD(48,18) = 6       : FAIL (got %u)\n',result);
end

% ------------------------------------------------------------
% Test 2
% ------------------------------------------------------------

if registers(3 + 1) == 6
    fprintf('x3 = 6                : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('x3 = 6                : FAIL (got %u)\n', ...
        registers(3 + 1));
end

% ------------------------------------------------------------
% Test 3
% ------------------------------------------------------------

if result == registers(3 + 1)
    fprintf('Memory/result match   : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('Memory/result match   : FAIL\n');
end

% ------------------------------------------------------------
% Test 4
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
    fprintf('       STAGE 16.12 PASSED!\n');
    fprintf('       GCD ALGORITHM VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 16.12 FAILED\n');
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