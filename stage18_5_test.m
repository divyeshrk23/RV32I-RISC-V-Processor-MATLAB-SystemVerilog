function stage18_5_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('          STAGE 18.5 - ID/EX PIPELINE REGISTER\n');
fprintf('============================================================\n');

testsPassed = 0;
totalTests = 10;


% ============================================================
% TEST DATA
% ADD x3, x1, x2
% ============================================================

valid = true;

pc = uint32(4);

opcode = uint32(51);

rs1Value = uint32(10);

rs2Value = uint32(20);

rd = 3;

immediate = 0;

funct3 = uint32(0);

funct7 = uint32(0);


% ============================================================
% CREATE ID/EX REGISTER
% ============================================================

register = id_ex_register( ...
    valid, ...
    pc, ...
    opcode, ...
    rs1Value, ...
    rs2Value, ...
    rd, ...
    immediate, ...
    funct3, ...
    funct7);


% ============================================================
% TEST 1 — VALID
% ============================================================

if register.valid == true

    fprintf('VALID = TRUE              : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('VALID = TRUE              : FAIL\n');

end


% ============================================================
% TEST 2 — PC
% ============================================================

if register.pc == uint32(4)

    fprintf('PC = 4                    : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('PC = 4                    : FAIL\n');

end


% ============================================================
% TEST 3 — OPCODE
% ============================================================

if register.opcode == uint32(51)

    fprintf('OPCODE = 51               : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('OPCODE = 51               : FAIL\n');

end


% ============================================================
% TEST 4 — RS1 VALUE
% ============================================================

if register.rs1Value == uint32(10)

    fprintf('RS1 VALUE = 10            : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('RS1 VALUE = 10            : FAIL\n');

end


% ============================================================
% TEST 5 — RS2 VALUE
% ============================================================

if register.rs2Value == uint32(20)

    fprintf('RS2 VALUE = 20            : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('RS2 VALUE = 20            : FAIL\n');

end


% ============================================================
% TEST 6 — RD
% ============================================================

if register.rd == 3

    fprintf('RD = x3                   : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('RD = x3                   : FAIL\n');

end


% ============================================================
% TEST 7 — IMMEDIATE
% ============================================================

if register.immediate == 0

    fprintf('IMMEDIATE = 0             : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('IMMEDIATE = 0             : FAIL\n');

end


% ============================================================
% TEST 8 — FUNCT3
% ============================================================

if register.funct3 == uint32(0)

    fprintf('FUNCT3 = 0                : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('FUNCT3 = 0                : FAIL\n');

end


% ============================================================
% TEST 9 — FUNCT7
% ============================================================

if register.funct7 == uint32(0)

    fprintf('FUNCT7 = 0                : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('FUNCT7 = 0                : FAIL\n');

end


% ============================================================
% TEST 10 — BUBBLE / INVALID ENTRY
% ============================================================

bubble = id_ex_register( ...
    false, ...
    uint32(8), ...
    uint32(0), ...
    uint32(0), ...
    uint32(0), ...
    0, ...
    0, ...
    uint32(0), ...
    uint32(0));


if bubble.valid == false && ...
   bubble.pc == uint32(8)

    fprintf('INVALID / BUBBLE ENTRY    : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('INVALID / BUBBLE ENTRY    : FAIL\n');

end


% ============================================================
% RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                  STAGE 18.5 RESULTS\n');
fprintf('============================================================\n');

fprintf('Tests passed : %d / %d\n', ...
    testsPassed,totalTests);

fprintf('============================================================\n');


% ============================================================
% FINAL RESULT
% ============================================================

if testsPassed == totalTests

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 18.5 PASSED!\n');
    fprintf('       ID/EX REGISTER VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 18.5 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end