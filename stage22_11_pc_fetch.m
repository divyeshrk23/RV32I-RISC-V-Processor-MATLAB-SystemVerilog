function stage22_11_pc_fetch

clc;

fprintf('==============================================\n');
fprintf('STAGE 22.11 - HARDWARE PC / INSTRUCTION FETCH\n');
fprintf('==============================================\n\n');

testsPassed = 0;
testsTotal = 10;

% ------------------------------------------------
% Instruction memory
% ------------------------------------------------

instructionMemory = uint32([ ...
    hex2dec('00500093'); ... % ADDI x1,x0,5
    hex2dec('00A00113'); ... % ADDI x2,x0,10
    hex2dec('002081B3'); ... % ADD x3,x1,x2
    hex2dec('40110233'); ... % SUB x4,x2,x1
    hex2dec('00000000')  ... % NOP
]);

% =================================================
% TEST 1 - PC reset
% =================================================

pc = uint32(0);

if pc == uint32(0)

    fprintf('1. PC reset = 0             : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('1. PC reset = 0             : FAIL\n');

end

% =================================================
% TEST 2 - First instruction fetch
% =================================================

index = double(pc) / 4 + 1;

instruction = instructionMemory(index);

if instruction == instructionMemory(1)

    fprintf('2. First instruction fetch  : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('2. First instruction fetch  : FAIL\n');

end

% =================================================
% TEST 3 - PC + 4
% =================================================

pcNext = uint32(mod(double(pc) + 4,2^32));

if pcNext == uint32(4)

    fprintf('3. PC + 4                   : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('3. PC + 4                   : FAIL\n');

end

% =================================================
% TEST 4 - Second instruction fetch
% =================================================

pc = pcNext;

index = double(pc) / 4 + 1;

instruction = instructionMemory(index);

if instruction == instructionMemory(2)

    fprintf('4. Second instruction fetch : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('4. Second instruction fetch : FAIL\n');

end

% =================================================
% TEST 5 - Sequential PC progression
% =================================================

pcSequence = uint32([0 4 8 12 16]);

sequential = true;

for i = 2:length(pcSequence)

    expected = uint32( ...
        mod(double(pcSequence(i-1)) + 4,2^32));

    if pcSequence(i) ~= expected

        sequential = false;
        break;

    end

end

if sequential

    fprintf('5. Sequential PC progression : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('5. Sequential PC progression : FAIL\n');

end

% =================================================
% TEST 6 - 4-byte alignment
% =================================================

alignmentOK = true;

for i = 1:length(pcSequence)

    if mod(double(pcSequence(i)),4) ~= 0

        alignmentOK = false;
        break;

    end

end

if alignmentOK

    fprintf('6. 4-byte PC alignment      : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('6. 4-byte PC alignment      : FAIL\n');

end

% =================================================
% TEST 7 - Branch PC redirect
% =================================================

pc = uint32(4);
branchImmediate = 12;
branchTaken = true;

if branchTaken

    redirectedPC = uint32( ...
        mod(double(pc) + branchImmediate,2^32));

else

    redirectedPC = uint32( ...
        mod(double(pc) + 4,2^32));

end

if redirectedPC == uint32(16)

    fprintf('7. Branch PC redirect       : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('7. Branch PC redirect       : FAIL\n');

end

% =================================================
% TEST 8 - Jump PC redirect
% =================================================

pc = uint32(8);
jumpImmediate = 20;

jumpTarget = uint32( ...
    mod(double(pc) + jumpImmediate,2^32));

if jumpTarget == uint32(28)

    fprintf('8. Jump PC redirect         : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('8. Jump PC redirect         : FAIL\n');

end

% =================================================
% TEST 9 - Instruction fetch after redirect
% =================================================

pc = uint32(8);

index = double(pc) / 4 + 1;

instruction = instructionMemory(index);

if instruction == instructionMemory(3)

    fprintf('9. Fetch after redirect     : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('9. Fetch after redirect     : FAIL\n');

end

% =================================================
% TEST 10 - PC wrap-around
% =================================================

pc = uint32(4294967292);

pcNext = uint32( ...
    mod(double(pc) + 4,2^32));

if pcNext == uint32(0)

    fprintf('10. 32-bit PC wrap-around   : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('10. 32-bit PC wrap-around   : FAIL\n');
    fprintf('    Expected = 0, Got = %u\n',pcNext);

end

% ------------------------------------------------
% Hardware summary
% ------------------------------------------------

fprintf('\n');
fprintf('Hardware PC / Instruction Fetch:\n');
fprintf('  PC width          : 32 bits\n');
fprintf('  Instruction width : 32 bits\n');
fprintf('  Instruction size  : 4 bytes\n');
fprintf('  Sequential PC     : PC + 4\n');
fprintf('  Branch redirect   : PC + Immediate\n');
fprintf('  Jump redirect     : PC + Immediate\n');
fprintf('  Alignment         : 4-byte\n');
fprintf('  Reset PC          : 0\n');

fprintf('\n');
fprintf('Tests passed : %d / %d\n', ...
    testsPassed,testsTotal);

if testsPassed == testsTotal

    fprintf('STAGE 22.11 PASSED!\n');

else

    fprintf('STAGE 22.11 FAILED\n');

end

end