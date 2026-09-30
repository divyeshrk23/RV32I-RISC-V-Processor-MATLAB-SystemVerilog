function stage19_2_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('             STAGE 19.2 - EX TO EX FORWARDING\n');
fprintf('============================================================\n');

testsPassed = 0;
totalTests = 10;


% ============================================================
% TEST 1
% EX/MEM writes x1
% Current EX instruction reads x1 as rs1
% ============================================================

result = forwarding_unit( ...
    1, ...
    2, ...
    1, ...
    true, ...
    uint32(10));

if result.forwarding && ...
   result.rs1Forward && ...
   result.rs1Value == uint32(10)

    fprintf('RS1 EX FORWARDING         : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('RS1 EX FORWARDING         : FAIL\n');

end


% ============================================================
% TEST 2
% EX/MEM writes x2
% Current EX instruction reads x2 as rs2
% ============================================================

result = forwarding_unit( ...
    1, ...
    2, ...
    2, ...
    true, ...
    uint32(20));

if result.forwarding && ...
   result.rs2Forward && ...
   result.rs2Value == uint32(20)

    fprintf('RS2 EX FORWARDING         : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('RS2 EX FORWARDING         : FAIL\n');

end


% ============================================================
% TEST 3
% Both operands need forwarding
% ============================================================

result1 = forwarding_unit( ...
    5, ...
    5, ...
    5, ...
    true, ...
    uint32(55));

if result1.forwarding && ...
   result1.rs1Forward && ...
   result1.rs2Forward && ...
   result1.rs1Value == uint32(55) && ...
   result1.rs2Value == uint32(55)

    fprintf('DUAL OPERAND FORWARDING   : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('DUAL OPERAND FORWARDING   : FAIL\n');

end


% ============================================================
% TEST 4
% No register match
% ============================================================

result = forwarding_unit( ...
    1, ...
    2, ...
    3, ...
    true, ...
    uint32(30));

if ~result.forwarding

    fprintf('NO FORWARDING CASE        : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('NO FORWARDING CASE        : FAIL\n');

end


% ============================================================
% TEST 5
% RegWrite disabled
% ============================================================

result = forwarding_unit( ...
    4, ...
    5, ...
    4, ...
    false, ...
    uint32(40));

if ~result.forwarding

    fprintf('REGWRITE DISABLED         : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('REGWRITE DISABLED         : FAIL\n');

end


% ============================================================
% TEST 6
% x0 must never be forwarded
% ============================================================

result = forwarding_unit( ...
    0, ...
    0, ...
    0, ...
    true, ...
    uint32(99));

if ~result.forwarding && ...
   ~result.rs1Forward && ...
   ~result.rs2Forward

    fprintf('x0 FORWARDING PROTECTION  : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('x0 FORWARDING PROTECTION  : FAIL\n');

end


% ============================================================
% TEST 7
% Correct forwarded value
% ============================================================

result = forwarding_unit( ...
    7, ...
    8, ...
    7, ...
    true, ...
    uint32(1234));

if result.rs1Value == uint32(1234)

    fprintf('FORWARDED VALUE           : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('FORWARDED VALUE           : FAIL\n');

end


% ============================================================
% TEST 8
% rs1 and rs2 are different
% Only rs1 forwards
% ============================================================

result = forwarding_unit( ...
    9, ...
    10, ...
    9, ...
    true, ...
    uint32(90));

if result.rs1Forward && ...
   ~result.rs2Forward && ...
   result.rs1Value == uint32(90)

    fprintf('SELECTIVE FORWARDING      : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('SELECTIVE FORWARDING      : FAIL\n');

end


% ============================================================
% TEST 9
% rs2 forwarding only
% ============================================================

result = forwarding_unit( ...
    11, ...
    12, ...
    12, ...
    true, ...
    uint32(120));

if ~result.rs1Forward && ...
   result.rs2Forward && ...
   result.rs2Value == uint32(120)

    fprintf('RS2 ONLY FORWARDING       : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('RS2 ONLY FORWARDING       : FAIL\n');

end


% ============================================================
% TEST 10
% Large 32-bit value must remain uint32
% ============================================================

value = uint32(hex2dec('FFFFFFFF'));

result = forwarding_unit( ...
    15, ...
    16, ...
    15, ...
    true, ...
    value);

if result.rs1Forward && ...
   result.rs1Value == value && ...
   isa(result.rs1Value,'uint32')

    fprintf('32-BIT VALUE FORWARDING   : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('32-BIT VALUE FORWARDING   : FAIL\n');

end


% ============================================================
% FINAL RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                  STAGE 19.2 RESULTS\n');
fprintf('============================================================\n');

fprintf('Tests passed : %d / %d\n', ...
    testsPassed,totalTests);

fprintf('============================================================\n');

if testsPassed == totalTests

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 19.2 PASSED!\n');
    fprintf('       EX -> EX FORWARDING VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 19.2 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end