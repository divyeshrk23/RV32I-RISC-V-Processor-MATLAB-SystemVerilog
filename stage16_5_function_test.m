function stage16_5_function_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('       STAGE 16.5 - FUNCTION CALL + RETURN TEST\n');
fprintf('============================================================\n');


% =============================================================
% ASSEMBLY FILE
% =============================================================

filename = fullfile( ...
    pwd, ...
    'programs', ...
    'stage16_5_function.asm');


fprintf('\n');
fprintf('Assembly file:\n%s\n',filename);


% =============================================================
% READ ASSEMBLY PROGRAM
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

totalTests = 5;


% -------------------------------------------------------------
% Test 1
% -------------------------------------------------------------

if registers(2) == uint32(10)

    fprintf('x1 = 10       : PASS');

    passed = passed + 1;

else

    fprintf('x1 = 10       : FAIL (got %u)',registers(2));

end

fprintf('\n');


% -------------------------------------------------------------
% Test 2
% -------------------------------------------------------------

if registers(3) == uint32(20)

    fprintf('x2 = 20       : PASS');

    passed = passed + 1;

else

    fprintf('x2 = 20       : FAIL (got %u)',registers(3));

end

fprintf('\n');


% -------------------------------------------------------------
% Test 3
% -------------------------------------------------------------
% Function:
%
% x3 = x1 + x2
%
% 10 + 20 = 30
%
% Then main executes:
%
% x3 = x3 + 5
%
% Final x3 = 35
% -------------------------------------------------------------

if registers(4) == uint32(35)

    fprintf('x3 = 35       : PASS');

    passed = passed + 1;

else

    fprintf('x3 = 35       : FAIL (got %u)',registers(4));

end

fprintf('\n');


% -------------------------------------------------------------
% Test 4
% -------------------------------------------------------------
% JAL x5 stores the return address.
%
% The call starts at PC = 8.
%
% Return address = PC + 4 = 12.
% -------------------------------------------------------------

if registers(6) == uint32(12)

    fprintf('x5 = 12       : PASS');

    passed = passed + 1;

else

    fprintf('x5 = 12       : FAIL (got %u)',registers(6));

end

fprintf('\n');


% -------------------------------------------------------------
% Test 5
% -------------------------------------------------------------
% Program should return from the function and eventually halt.
% -------------------------------------------------------------

if halted

    fprintf('CPU HALTED    : PASS');

    passed = passed + 1;

else

    fprintf('CPU HALTED    : FAIL');

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
    fprintf('       STAGE 16.5 PASSED!\n');
    fprintf('       FUNCTION CALL + RETURN VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 16.5 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end