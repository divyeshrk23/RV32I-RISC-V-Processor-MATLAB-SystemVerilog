function stage18_4_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('           STAGE 18.4 - INSTRUCTION DECODE\n');
fprintf('============================================================\n');

testsPassed = 0;
totalTests = 10;


% ============================================================
% TEST 1 — ADD
% ADD x3, x1, x2
% ============================================================

instruction = uint32(hex2dec('002081B3'));

decoded = id_stage(instruction);

if decoded.type == "R"

    fprintf('R-TYPE DETECTED          : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('R-TYPE DETECTED          : FAIL\n');

end


% ============================================================
% TEST 2 — RS1
% ============================================================

if decoded.rs1 == 1

    fprintf('RS1 = x1                  : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('RS1 = x1                  : FAIL\n');

end


% ============================================================
% TEST 3 — RS2
% ============================================================

if decoded.rs2 == 2

    fprintf('RS2 = x2                  : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('RS2 = x2                  : FAIL\n');

end


% ============================================================
% TEST 4 — RD
% ============================================================

if decoded.rd == 3

    fprintf('RD = x3                   : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('RD = x3                   : FAIL\n');

end


% ============================================================
% TEST 5 — ADDI
% ADDI x5, x6, 10
% ============================================================

instruction = uint32(hex2dec('00A30293'));

decoded = id_stage(instruction);

if decoded.type == "I" && ...
   decoded.rs1 == 6 && ...
   decoded.rd == 5 && ...
   decoded.immediate == 10

    fprintf('ADDI DECODE              : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('ADDI DECODE              : FAIL\n');

end


% ============================================================
% TEST 6 — NEGATIVE IMMEDIATE
% ADDI x5, x6, -8
% ============================================================

instruction = uint32(hex2dec('FF830293'));

decoded = id_stage(instruction);

if decoded.immediate == -8

    fprintf('NEGATIVE IMMEDIATE       : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('NEGATIVE IMMEDIATE       : FAIL\n');

end


% ============================================================
% TEST 7 — LOAD
% LW x3, 16(x1)
% ============================================================

instruction = uint32(hex2dec('0100A183'));

decoded = id_stage(instruction);

if decoded.type == "I" && ...
   decoded.rs1 == 1 && ...
   decoded.rd == 3 && ...
   decoded.immediate == 16

    fprintf('LOAD DECODE              : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('LOAD DECODE              : FAIL\n');

end


% ============================================================
% TEST 8 — STORE
% SW x2, 20(x1)
% ============================================================

instruction = uint32(hex2dec('0020AA23'));

decoded = id_stage(instruction);

if decoded.type == "S" && ...
   decoded.rs1 == 1 && ...
   decoded.rs2 == 2 && ...
   decoded.immediate == 20

    fprintf('STORE DECODE             : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('STORE DECODE             : FAIL\n');

end


% ============================================================
% TEST 9 — BRANCH
% BEQ x1, x2, 8
% ============================================================

instruction = uint32(hex2dec('00208463'));

decoded = id_stage(instruction);

if decoded.type == "B" && ...
   decoded.rs1 == 1 && ...
   decoded.rs2 == 2 && ...
   decoded.immediate == 8

    fprintf('BRANCH DECODE            : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('BRANCH DECODE            : FAIL\n');

end


% ============================================================
% TEST 10 — JAL
% ============================================================

instruction = uint32(hex2dec('008000EF'));

decoded = id_stage(instruction);

if decoded.type == "J" && ...
   decoded.rd == 1 && ...
   decoded.immediate == 8

    fprintf('JAL DECODE               : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('JAL DECODE               : FAIL\n');

end


% ============================================================
% RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                  STAGE 18.4 RESULTS\n');
fprintf('============================================================\n');

fprintf('Tests passed : %d / %d\n', ...
    testsPassed,totalTests);

fprintf('============================================================\n');


if testsPassed == totalTests

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 18.4 PASSED!\n');
    fprintf('       ID STAGE VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 18.4 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end