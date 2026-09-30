function stage18_8_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('              STAGE 18.8 - MEM STAGE\n');
fprintf('============================================================\n');

testsPassed = 0;
totalTests = 10;


% ============================================================
% CREATE EMPTY MEMORY
% ============================================================

memory = zeros(1024,1,'uint8');


% ============================================================
% TEST 1 — SW
% ============================================================

result = mem_stage( ...
    uint32(35), ...
    uint32(100), ...
    uint32(hex2dec('12345678')), ...
    false, ...
    true, ...
    "SW", ...
    memory);

memory = result.memory;

if result.memoryWrite == true

    fprintf('SW MEMORY WRITE           : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('SW MEMORY WRITE           : FAIL\n');

end


% ============================================================
% TEST 2 — LW
% ============================================================

result = mem_stage( ...
    uint32(3), ...
    uint32(100), ...
    uint32(0), ...
    true, ...
    false, ...
    "LW", ...
    memory);

if result.memoryData == uint32(hex2dec('12345678'))

    fprintf('LW MEMORY READ            : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('LW MEMORY READ            : FAIL\n');

end


% ============================================================
% TEST 3 — SH
% ============================================================

result = mem_stage( ...
    uint32(35), ...
    uint32(200), ...
    uint32(hex2dec('00001234')), ...
    false, ...
    true, ...
    "SH", ...
    memory);

memory = result.memory;

if result.memoryWrite == true

    fprintf('SH MEMORY WRITE           : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('SH MEMORY WRITE           : FAIL\n');

end


% ============================================================
% TEST 4 — LH
% ============================================================

result = mem_stage( ...
    uint32(3), ...
    uint32(200), ...
    uint32(0), ...
    true, ...
    false, ...
    "LH", ...
    memory);

if result.memoryData == uint32(hex2dec('00001234'))

    fprintf('LH MEMORY READ            : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('LH MEMORY READ            : FAIL\n');

end


% ============================================================
% TEST 5 — SB
% ============================================================

result = mem_stage( ...
    uint32(35), ...
    uint32(300), ...
    uint32(hex2dec('000000AB')), ...
    false, ...
    true, ...
    "SB", ...
    memory);

memory = result.memory;

if result.memoryWrite == true

    fprintf('SB MEMORY WRITE           : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('SB MEMORY WRITE           : FAIL\n');

end


% ============================================================
% TEST 6 — LBU
% ============================================================

result = mem_stage( ...
    uint32(3), ...
    uint32(300), ...
    uint32(0), ...
    true, ...
    false, ...
    "LBU", ...
    memory);

if result.memoryData == uint32(171)

    fprintf('LBU MEMORY READ           : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('LBU MEMORY READ           : FAIL\n');

end


% ============================================================
% TEST 7 — LB SIGN EXTENSION
% ============================================================

result = mem_stage( ...
    uint32(3), ...
    uint32(300), ...
    uint32(0), ...
    true, ...
    false, ...
    "LB", ...
    memory);

expected = typecast(int32(-85),'uint32');

if result.memoryData == expected

    fprintf('LB SIGN EXTENSION         : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('LB SIGN EXTENSION         : FAIL\n');

end


% ============================================================
% TEST 8 — LHU
% ============================================================

result = mem_stage( ...
    uint32(3), ...
    uint32(200), ...
    uint32(0), ...
    true, ...
    false, ...
    "LHU", ...
    memory);

if result.memoryData == uint32(hex2dec('00001234'))

    fprintf('LHU MEMORY READ           : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('LHU MEMORY READ           : FAIL\n');

end


% ============================================================
% TEST 9 — ALU RESULT PASSTHROUGH
% ============================================================

result = mem_stage( ...
    uint32(51), ...
    uint32(500), ...
    uint32(0), ...
    false, ...
    false, ...
    "NONE", ...
    memory);

if result.aluResult == uint32(500)

    fprintf('ALU RESULT PASSTHROUGH    : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('ALU RESULT PASSTHROUGH    : FAIL\n');

end


% ============================================================
% TEST 10 — NO MEMORY OPERATION
% ============================================================

result = mem_stage( ...
    uint32(51), ...
    uint32(600), ...
    uint32(0), ...
    false, ...
    false, ...
    "NONE", ...
    memory);

if result.memoryData == uint32(0) && ...
   result.memoryRead == false && ...
   result.memoryWrite == false

    fprintf('NO MEMORY OPERATION       : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('NO MEMORY OPERATION       : FAIL\n');

end


% ============================================================
% RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                  STAGE 18.8 RESULTS\n');
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
    fprintf('       STAGE 18.8 PASSED!\n');
    fprintf('       MEM STAGE VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 18.8 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end