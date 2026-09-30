function stage22_5_immediate_generator

clc;

fprintf('==============================================\n');
fprintf('STAGE 22.5 - HARDWARE IMMEDIATE GENERATOR\n');
fprintf('==============================================\n\n');

testsPassed = 0;
testsTotal = 8;

% ------------------------------------------------
% Test 1 - ADDI positive immediate
% ADDI x1,x0,25
% ------------------------------------------------

instruction = encoder('ADDI x1, x0, 25');
decoded = decoder(instruction);

immediate = double(decoded.immediate);

if immediate == 25

    fprintf('1. I-type positive immediate : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('1. I-type positive immediate : FAIL\n');
    fprintf('   Expected = 25, Got = %d\n',immediate);

end

% ------------------------------------------------
% Test 2 - ADDI negative immediate
% ADDI x1,x0,-25
% ------------------------------------------------

instruction = encoder('ADDI x1, x0, -25');
decoded = decoder(instruction);

immediate = double(decoded.immediate);

if immediate == -25

    fprintf('2. I-type negative immediate : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('2. I-type negative immediate : FAIL\n');
    fprintf('   Expected = -25, Got = %d\n',immediate);

end

% ------------------------------------------------
% Test 3 - Load immediate
% LW x2,16(x1)
% ------------------------------------------------

instruction = encoder('LW x2, 16(x1)');
decoded = decoder(instruction);

immediate = double(decoded.immediate);

if immediate == 16

    fprintf('3. Load immediate             : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('3. Load immediate             : FAIL\n');
    fprintf('   Expected = 16, Got = %d\n',immediate);

end

% ------------------------------------------------
% Test 4 - Store immediate
% SW x2,-20(x1)
% ------------------------------------------------

instruction = encoder('SW x2, -20(x1)');
decoded = decoder(instruction);

immediate = double(decoded.immediate);

if immediate == -20

    fprintf('4. Store immediate            : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('4. Store immediate            : FAIL\n');
    fprintf('   Expected = -20, Got = %d\n',immediate);

end

% ------------------------------------------------
% Test 5 - Branch immediate
% BEQ x1,x2,12
% ------------------------------------------------

instruction = encoder('BEQ x1, x2, 12');
decoded = decoder(instruction);

immediate = double(decoded.immediate);

if immediate == 12

    fprintf('5. Branch immediate           : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('5. Branch immediate           : FAIL\n');
    fprintf('   Expected = 12, Got = %d\n',immediate);

end

% ------------------------------------------------
% Test 6 - Negative branch immediate
% BNE x1,x2,-16
% ------------------------------------------------

instruction = encoder('BNE x1, x2, -16');
decoded = decoder(instruction);

immediate = double(decoded.immediate);

if immediate == -16

    fprintf('6. Negative branch immediate : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('6. Negative branch immediate : FAIL\n');
    fprintf('   Expected = -16, Got = %d\n',immediate);

end

% ------------------------------------------------
% Test 7 - JAL immediate
% ------------------------------------------------

instruction = encoder('JAL x1, 100');
decoded = decoder(instruction);

immediate = double(decoded.immediate);

if immediate == 100

    fprintf('7. JAL immediate              : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('7. JAL immediate              : FAIL\n');
    fprintf('   Expected = 100, Got = %d\n',immediate);

end

% ------------------------------------------------
% Test 8 - JALR immediate
% ------------------------------------------------

instruction = encoder('JALR x1, 24(x2)');
decoded = decoder(instruction);

immediate = double(decoded.immediate);

if immediate == 24

    fprintf('8. JALR immediate             : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('8. JALR immediate             : FAIL\n');
    fprintf('   Expected = 24, Got = %d\n',immediate);

end

% ------------------------------------------------
% Hardware summary
% ------------------------------------------------

fprintf('\n');
fprintf('Immediate Generator:\n');
fprintf('  Input              : Instruction[31:0]\n');
fprintf('  Output             : Immediate[31:0]\n');
fprintf('  I-type             : bits [31:20]\n');
fprintf('  S-type             : bits [31:25] + [11:7]\n');
fprintf('  B-type             : bits [31],[7],[30:25],[11:8],0\n');
fprintf('  J-type             : bits [31],[19:12],[20],[30:21],0\n');
fprintf('  Sign extension     : 32 bits\n');

fprintf('\n');
fprintf('Tests passed : %d / %d\n', ...
    testsPassed,testsTotal);

if testsPassed == testsTotal

    fprintf('STAGE 22.5 PASSED!\n');

else

    fprintf('STAGE 22.5 FAILED\n');

end

end