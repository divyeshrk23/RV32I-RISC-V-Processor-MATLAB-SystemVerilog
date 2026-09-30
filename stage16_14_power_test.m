function stage16_14_power_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('       STAGE 16.14 - POWER / EXPONENTIATION\n');
fprintf('============================================================\n');

filename = fullfile( ...
    pwd, ...
    'programs', ...
    'stage16_14_power.asm');

initialMemory = zeros(32,1,'uint8');

program = assembly_reader(filename);

[registers,pc,halted,dataMemory] = cpu( ...
    program, ...
    2000, ...
    initialMemory);

result2 = readWord(dataMemory,0);
result3 = readWord(dataMemory,4);
result5 = readWord(dataMemory,8);

testsPassed = 0;
totalTests = 4;

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    TEST RESULTS\n');
fprintf('============================================================\n');

if result2 == 32
    fprintf('2^5 = 32              : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('2^5 = 32              : FAIL (got %u)\n',result2);
end

if result3 == 81
    fprintf('3^4 = 81              : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('3^4 = 81              : FAIL (got %u)\n',result3);
end

if result5 == 125
    fprintf('5^3 = 125             : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('5^3 = 125             : FAIL (got %u)\n',result5);
end

if halted
    fprintf('CPU HALTED             : PASS\n');
    testsPassed = testsPassed + 1;
else
    fprintf('CPU HALTED             : FAIL\n');
end

fprintf('\n');
fprintf('============================================================\n');
fprintf('Tests passed : %d / %d\n',testsPassed,totalTests);
fprintf('============================================================\n');

if testsPassed == totalTests

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 16.14 PASSED!\n');
    fprintf('       POWER OPERATION VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 16.14 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end


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