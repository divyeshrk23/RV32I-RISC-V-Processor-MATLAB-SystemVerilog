function stage16_6_fibonacci_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('       STAGE 16.6 - FIBONACCI INTEGRATION TEST\n');
fprintf('============================================================\n');


% =============================================================
% ASSEMBLY FILE
% =============================================================

filename = fullfile( ...
    pwd, ...
    'programs', ...
    'stage16_6_fibonacci.asm');


fprintf('\n');
fprintf('Assembly file:\n%s\n',filename);


% =============================================================
% READ PROGRAM
% =============================================================

program = assembly_reader(filename);


fprintf('\n');
fprintf('Program:\n');
fprintf('------------------------------------------------------------\n');

for i = 1:length(program)

    fprintf('%d. %s\n',i,program{i});

end


% =============================================================
% CPU EXECUTION
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    CPU EXECUTION\n');
fprintf('============================================================\n');

[registers,pc,halted,~] = cpu( ...
    program, ...
    100);


% =============================================================
% FINAL RESULTS
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    FINAL RESULTS\n');
fprintf('============================================================\n');

fprintf('x1 = %u\n',registers(2));
fprintf('x2 = %u\n',registers(3));
fprintf('x3 = %u\n',registers(4));
fprintf('x4 = %u\n',registers(5));
fprintf('x5 = %u\n',registers(6));

fprintf('\n');
fprintf('Final PC = %u\n',pc);

if halted

    fprintf('Status = HALTED\n');

else

    fprintf('Status = NOT HALTED\n');

end


% =============================================================
% TEST RESULTS
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    TEST RESULTS\n');
fprintf('============================================================\n');

passed = 0;

totalTests = 6;


% -------------------------------------------------------------
% Test 1
% -------------------------------------------------------------

if registers(2) == uint32(8)

    fprintf('x1 = 8     : PASS');

    passed = passed + 1;

else

    fprintf('x1 = 8     : FAIL (got %u)',registers(2));

end

fprintf('\n');


% -------------------------------------------------------------
% Test 2
% -------------------------------------------------------------

if registers(3) == uint32(13)

    fprintf('x2 = 13    : PASS');

    passed = passed + 1;

else

    fprintf('x2 = 13    : FAIL (got %u)',registers(3));

end

fprintf('\n');


% -------------------------------------------------------------
% Test 3
% -------------------------------------------------------------

if registers(4) == uint32(13)

    fprintf('x3 = 13    : PASS');

    passed = passed + 1;

else

    fprintf('x3 = 13    : FAIL (got %u)',registers(4));

end

fprintf('\n');


% -------------------------------------------------------------
% Test 4
% -------------------------------------------------------------

if registers(5) == uint32(7)

    fprintf('x4 = 7     : PASS');

    passed = passed + 1;

else

    fprintf('x4 = 7     : FAIL (got %u)',registers(5));

end

fprintf('\n');


% -------------------------------------------------------------
% Test 5
% -------------------------------------------------------------

if registers(6) == uint32(7)

    fprintf('x5 = 7     : PASS');

    passed = passed + 1;

else

    fprintf('x5 = 7     : FAIL (got %u)',registers(6));

end

fprintf('\n');


% -------------------------------------------------------------
% Test 6
% -------------------------------------------------------------
% Final Fibonacci value:
%
% F(7) = 13
% -------------------------------------------------------------

if registers(3) == uint32(13)

    fprintf('F(7) = 13  : PASS');

    passed = passed + 1;

else

    fprintf('F(7) = 13  : FAIL (got %u)',registers(3));

end

fprintf('\n');


% =============================================================
% SUMMARY
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('Tests passed : %d / %d\n',passed,totalTests);
fprintf('============================================================\n');


if passed == totalTests

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 16.6 PASSED!\n');
    fprintf('       FIBONACCI VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 16.6 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end