function stage22_8_branch_unit

clc;

fprintf('==============================================\n');
fprintf('STAGE 22.8 - HARDWARE BRANCH UNIT\n');
fprintf('==============================================\n\n');

testsPassed = 0;
testsTotal = 10;

% =================================================
% TEST 1 - BEQ taken
% =================================================

rs1 = uint32(25);
rs2 = uint32(25);
pc = uint32(100);
immediate = 20;

taken = (rs1 == rs2);

if taken

    target = uint32(mod(double(pc) + immediate,2^32));

    if target == uint32(120)

        fprintf('1. BEQ taken                : PASS\n');
        testsPassed = testsPassed + 1;

    else

        fprintf('1. BEQ taken                : FAIL\n');

    end

else

    fprintf('1. BEQ taken                : FAIL\n');

end

% =================================================
% TEST 2 - BEQ not taken
% =================================================

rs1 = uint32(25);
rs2 = uint32(30);

taken = (rs1 == rs2);

if ~taken

    fprintf('2. BEQ not taken            : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('2. BEQ not taken            : FAIL\n');

end

% =================================================
% TEST 3 - BNE taken
% =================================================

rs1 = uint32(25);
rs2 = uint32(30);

taken = (rs1 ~= rs2);

if taken

    fprintf('3. BNE taken                : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('3. BNE taken                : FAIL\n');

end

% =================================================
% TEST 4 - BLT signed
% =================================================

rs1 = typecast(int32(-10),'uint32');
rs2 = typecast(int32(5),'uint32');

signedRs1 = typecast(rs1,'int32');
signedRs2 = typecast(rs2,'int32');

taken = signedRs1 < signedRs2;

if taken

    fprintf('4. BLT signed               : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('4. BLT signed               : FAIL\n');

end

% =================================================
% TEST 5 - BGE signed
% =================================================

rs1 = typecast(int32(10),'uint32');
rs2 = typecast(int32(5),'uint32');

signedRs1 = typecast(rs1,'int32');
signedRs2 = typecast(rs2,'int32');

taken = signedRs1 >= signedRs2;

if taken

    fprintf('5. BGE signed               : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('5. BGE signed               : FAIL\n');

end

% =================================================
% TEST 6 - BLTU unsigned
% =================================================

rs1 = uint32(5);
rs2 = uint32(10);

taken = rs1 < rs2;

if taken

    fprintf('6. BLTU unsigned            : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('6. BLTU unsigned            : FAIL\n');

end

% =================================================
% TEST 7 - BGEU unsigned
% =================================================

rs1 = uint32(20);
rs2 = uint32(10);

taken = rs1 >= rs2;

if taken

    fprintf('7. BGEU unsigned            : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('7. BGEU unsigned            : FAIL\n');

end

% =================================================
% TEST 8 - Signed/unsigned distinction
% =================================================

% 0xFFFFFFFF = -1 signed, but 4294967295 unsigned

rs1 = uint32(4294967295);
rs2 = uint32(1);

signedRs1 = typecast(rs1,'int32');
signedRs2 = typecast(rs2,'int32');

signedResult = signedRs1 < signedRs2;
unsignedResult = rs1 < rs2;

if signedResult && ~unsignedResult

    fprintf('8. Signed/unsigned distinction : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('8. Signed/unsigned distinction : FAIL\n');

end

% =================================================
% TEST 9 - Negative branch target
% =================================================

pc = uint32(100);
immediate = -20;

target = uint32( ...
    mod(double(pc) + immediate,2^32));

if target == uint32(80)

    fprintf('9. Negative branch target   : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('9. Negative branch target   : FAIL\n');
    fprintf('   Expected = 80, Got = %u\n',target);

end

% =================================================
% TEST 10 - PCSrc generation
% =================================================

branchTaken = true;

if branchTaken

    pcSrc = "BRANCH";

else

    pcSrc = "PC+4";

end

if strcmp(char(pcSrc),'BRANCH')

    fprintf('10. PCSrc branch redirect   : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('10. PCSrc branch redirect   : FAIL\n');

end

% ------------------------------------------------
% Hardware summary
% ------------------------------------------------

fprintf('\n');
fprintf('Hardware Branch Unit:\n');
fprintf('  BEQ/BNE              : Equality comparison\n');
fprintf('  BLT/BGE              : Signed comparison\n');
fprintf('  BLTU/BGEU            : Unsigned comparison\n');
fprintf('  Branch target        : PC + Immediate\n');
fprintf('  Taken                : PC redirected\n');
fprintf('  Not taken            : PC + 4\n');
fprintf('  PCSrc                : BRANCH when taken\n');

fprintf('\n');
fprintf('Tests passed : %d / %d\n', ...
    testsPassed,testsTotal);

if testsPassed == testsTotal

    fprintf('STAGE 22.8 PASSED!\n');

else

    fprintf('STAGE 22.8 FAILED\n');

end

end