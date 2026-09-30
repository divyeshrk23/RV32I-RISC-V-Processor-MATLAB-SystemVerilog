clc;
clear;

fprintf('\n');
fprintf('============================================================\n');
fprintf('       STAGE 10D - REGISTER FILE TEST\n');
fprintf('============================================================\n');


% ============================================================
% INITIALIZE REGISTER FILE
% ============================================================

registers = zeros(32,1,'uint32');


% ============================================================
% TEST 1 - WRITE x1 = 10
% ============================================================

fprintf('\n');
fprintf('TEST 1: Write x1 = 10\n');

[read1,read2,registers] = register_file( ...
    0, ...       % rs1
    0, ...       % rs2
    1, ...       % rd = x1
    10, ...      % writeData
    true, ...    % writeEnable
    registers);


fprintf('x1 = %d\n',registers(2));


if registers(2) == 10
    fprintf('PASS\n');
else
    fprintf('FAIL\n');
end


% ============================================================
% TEST 2 - WRITE x2 = 20
% ============================================================

fprintf('\n');
fprintf('TEST 2: Write x2 = 20\n');

[read1,read2,registers] = register_file( ...
    0, ...
    0, ...
    2, ...
    20, ...
    true, ...
    registers);


fprintf('x2 = %d\n',registers(3));


if registers(3) == 20
    fprintf('PASS\n');
else
    fprintf('FAIL\n');
end


% ============================================================
% TEST 3 - READ x1 and x2
% ============================================================

fprintf('\n');
fprintf('TEST 3: Read x1 and x2\n');

[read1,read2,registers] = register_file( ...
    1, ...       % rs1 = x1
    2, ...       % rs2 = x2
    0, ...
    0, ...
    false, ...
    registers);


fprintf('Read x1 = %d\n',read1);
fprintf('Read x2 = %d\n',read2);


if read1 == 10 && read2 == 20
    fprintf('PASS\n');
else
    fprintf('FAIL\n');
end


% ============================================================
% TEST 4 - WRITE x3 = 30
% ============================================================

fprintf('\n');
fprintf('TEST 4: Write x3 = 30\n');

[read1,read2,registers] = register_file( ...
    1, ...
    2, ...
    3, ...
    30, ...
    true, ...
    registers);


fprintf('x3 = %d\n',registers(4));


if registers(4) == 30
    fprintf('PASS\n');
else
    fprintf('FAIL\n');
end


% ============================================================
% TEST 5 - READ x1, x2
% ============================================================

fprintf('\n');
fprintf('TEST 5: Read x1 and x2 again\n');

[read1,read2,registers] = register_file( ...
    1, ...
    2, ...
    0, ...
    0, ...
    false, ...
    registers);


fprintf('x1 = %d\n',read1);
fprintf('x2 = %d\n',read2);


if read1 == 10 && read2 == 20
    fprintf('PASS\n');
else
    fprintf('FAIL\n');
end


% ============================================================
% TEST 6 - x0 MUST ALWAYS BE ZERO
% ============================================================

fprintf('\n');
fprintf('TEST 6: Attempt to write x0 = 999\n');

[read1,read2,registers] = register_file( ...
    0, ...
    0, ...
    0, ...       % rd = x0
    999, ...
    true, ...
    registers);


fprintf('x0 = %d\n',registers(1));


if registers(1) == 0
    fprintf('PASS - x0 remains zero\n');
else
    fprintf('FAIL - x0 changed!\n');
end


% ============================================================
% TEST 7 - READ x3
% ============================================================

fprintf('\n');
fprintf('TEST 7: Read x3\n');

[read1,read2,registers] = register_file( ...
    3, ...
    0, ...
    0, ...
    0, ...
    false, ...
    registers);


fprintf('x3 = %d\n',read1);


if read1 == 30
    fprintf('PASS\n');
else
    fprintf('FAIL\n');
end


% ============================================================
% DISPLAY REGISTER FILE
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('              REGISTER FILE CONTENTS\n');
fprintf('============================================================\n');

for i = 1:32

    registerNumber = i - 1;

    fprintf('x%-2d = %10u\n', ...
        registerNumber, ...
        registers(i));

end


% ============================================================
% FINAL RESULT
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('          STAGE 10D - TEST COMPLETE\n');
fprintf('============================================================\n');

fprintf('\n');
fprintf('********************************************\n');
fprintf('      REGISTER FILE TEST COMPLETED         \n');
fprintf('********************************************\n');

fprintf('\n');
fprintf('Important:\n');
fprintf('x0 must always remain 0.\n');

fprintf('\n');
fprintf('============================================================\n');