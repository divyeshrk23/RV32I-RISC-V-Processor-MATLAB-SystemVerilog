function stage20_6_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('                 STAGE 20.6 - JUMP HANDLING\n');
fprintf('============================================================\n');

testsPassed = 0;
totalTests = 10;


% ============================================================
% TEST 1
% JAL forward
%
% PC = 100
% immediate = 20
% target = 120
% return = 104
% ============================================================

result = jump_control( ...
    "JAL", ...
    uint32(100), ...
    uint32(0), ...
    20);

if result.isJump && ...
   result.isJAL && ...
   ~result.isJALR && ...
   result.targetPc == uint32(120) && ...
   result.returnAddress == uint32(104) && ...
   result.redirect && ...
   result.rdWrite

    fprintf('JAL FORWARD                 : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('JAL FORWARD                 : FAIL\n');

end


% ============================================================
% TEST 2
% JAL backward
%
% PC = 200
% immediate = -40
% target = 160
% ============================================================

result = jump_control( ...
    "JAL", ...
    uint32(200), ...
    uint32(0), ...
    -40);

if result.targetPc == uint32(160) && ...
   result.returnAddress == uint32(204)

    fprintf('JAL BACKWARD                : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('JAL BACKWARD                : FAIL\n');

end


% ============================================================
% TEST 3
% JAL return address
% ============================================================

result = jump_control( ...
    "JAL", ...
    uint32(500), ...
    uint32(0), ...
    100);

if result.returnAddress == uint32(504)

    fprintf('JAL RETURN ADDRESS          : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('JAL RETURN ADDRESS          : FAIL\n');

end


% ============================================================
% TEST 4
% JALR basic
%
% rs1 = 100
% immediate = 20
% target = 120
% ============================================================

result = jump_control( ...
    "JALR", ...
    uint32(500), ...
    uint32(100), ...
    20);

if result.isJump && ...
   result.isJALR && ...
   result.targetPc == uint32(120) && ...
   result.returnAddress == uint32(504) && ...
   result.redirect && ...
   result.rdWrite

    fprintf('JALR BASIC                  : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('JALR BASIC                  : FAIL\n');

end


% ============================================================
% TEST 5
% JALR clears bit 0
%
% rs1 = 101
% immediate = 0
% raw target = 101
% final target = 100
% ============================================================

result = jump_control( ...
    "JALR", ...
    uint32(101), ...
    uint32(101), ...
    0);

if result.targetPc == uint32(100)

    fprintf('JALR ALIGNMENT              : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('JALR ALIGNMENT              : FAIL\n');

end


% ============================================================
% TEST 6
% JALR with negative offset
%
% rs1 = 200
% immediate = -40
% target = 160
% ============================================================

result = jump_control( ...
    "JALR", ...
    uint32(1000), ...
    uint32(200), ...
    -40);

if result.targetPc == uint32(160)

    fprintf('JALR NEGATIVE OFFSET        : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('JALR NEGATIVE OFFSET        : FAIL\n');

end


% ============================================================
% TEST 7
% JALR return address
% ============================================================

result = jump_control( ...
    "JALR", ...
    uint32(700), ...
    uint32(100), ...
    4);

if result.returnAddress == uint32(704)

    fprintf('JALR RETURN ADDRESS         : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('JALR RETURN ADDRESS         : FAIL\n');

end


% ============================================================
% TEST 8
% Non-jump instruction
% ============================================================

result = jump_control( ...
    "ADD", ...
    uint32(100), ...
    uint32(50), ...
    20);

if ~result.isJump && ...
   ~result.redirect && ...
   ~result.rdWrite && ...
   result.nextPc == uint32(104)

    fprintf('NON-JUMP OPERATION          : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('NON-JUMP OPERATION          : FAIL\n');

end


% ============================================================
% TEST 9
% JAL 32-bit PC wraparound
%
% 0xFFFFFFFC + 8 = 4
% ============================================================

pcValue = uint32(hex2dec('FFFFFFFC'));

result = jump_control( ...
    "JAL", ...
    pcValue, ...
    uint32(0), ...
    8);

if result.targetPc == uint32(4) && ...
   result.returnAddress == uint32(0)

    fprintf('JAL PC WRAPAROUND            : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('JAL PC WRAPAROUND            : FAIL\n');

end


% ============================================================
% TEST 10
% Case insensitive JALR
% ============================================================

result = jump_control( ...
    "jalr", ...
    uint32(300), ...
    uint32(400), ...
    20);

if result.isJump && ...
   result.isJALR && ...
   result.targetPc == uint32(420)

    fprintf('CASE INSENSITIVE JALR        : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('CASE INSENSITIVE JALR        : FAIL\n');

end


% ============================================================
% FINAL RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                  STAGE 20.6 RESULTS\n');
fprintf('============================================================\n');

fprintf('Tests passed : %d / %d\n', ...
    testsPassed,totalTests);

fprintf('============================================================\n');


% ============================================================
% PASS / FAIL
% ============================================================

if testsPassed == totalTests

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 20.6 PASSED!\n');
    fprintf('       JUMP HANDLING VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 20.6 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end