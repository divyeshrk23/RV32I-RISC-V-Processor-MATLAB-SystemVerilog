function stage18_3_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('          STAGE 18.3 - IF/ID PIPELINE REGISTER\n');
fprintf('============================================================\n');

testsPassed = 0;
totalTests = 8;


% ============================================================
% TEST DATA
% ============================================================

pc = uint32(0);

instruction = uint32(hex2dec('00C00093'));

pcNext = uint32(4);


% ============================================================
% CREATE IF/ID REGISTER
% ============================================================

register = if_id_register( ...
    instruction, ...
    pc, ...
    pcNext, ...
    true);


% ============================================================
% TEST 1 — VALID
% ============================================================

if register.valid == true

    fprintf('IF/ID VALID = TRUE       : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('IF/ID VALID = TRUE       : FAIL\n');

end


% ============================================================
% TEST 2 — PC
% ============================================================

if register.pc == uint32(0)

    fprintf('IF/ID PC = 0             : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('IF/ID PC = 0             : FAIL\n');

end


% ============================================================
% TEST 3 — INSTRUCTION
% ============================================================

if register.instruction == ...
        uint32(hex2dec('00C00093'))

    fprintf('INSTRUCTION STORED       : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('INSTRUCTION STORED       : FAIL\n');

end


% ============================================================
% TEST 4 — PC + 4
% ============================================================

if register.pcNext == uint32(4)

    fprintf('PC + 4 STORED             : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('PC + 4 STORED             : FAIL\n');

end


% ============================================================
% TEST 5 — SECOND INSTRUCTION
% ============================================================

register2 = if_id_register( ...
    uint32(hex2dec('01200113')), ...
    uint32(4), ...
    uint32(8), ...
    true);


if register2.instruction == ...
        uint32(hex2dec('01200113'))

    fprintf('SECOND INSTRUCTION       : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('SECOND INSTRUCTION       : FAIL\n');

end


% ============================================================
% TEST 6 — SECOND PC
% ============================================================

if register2.pc == uint32(4)

    fprintf('SECOND PC = 4            : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('SECOND PC = 4            : FAIL\n');

end


% ============================================================
% TEST 7 — INVALID REGISTER
% ============================================================

invalidRegister = if_id_register( ...
    uint32(0), ...
    uint32(8), ...
    uint32(12), ...
    false);


if invalidRegister.valid == false

    fprintf('INVALID PIPELINE ENTRY   : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('INVALID PIPELINE ENTRY   : FAIL\n');

end


% ============================================================
% TEST 8 — INVALID ENTRY DATA
% ============================================================

if invalidRegister.pc == uint32(8) && ...
   invalidRegister.pcNext == uint32(12)

    fprintf('INVALID ENTRY DATA       : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('INVALID ENTRY DATA       : FAIL\n');

end


% ============================================================
% RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                  STAGE 18.3 RESULTS\n');
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
    fprintf('       STAGE 18.3 PASSED!\n');
    fprintf('       IF/ID REGISTER VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 18.3 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

endp