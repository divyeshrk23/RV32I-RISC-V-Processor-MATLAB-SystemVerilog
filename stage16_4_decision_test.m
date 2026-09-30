function stage16_4_decision_test

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('       STAGE 16.4 - CONDITIONAL DECISION TEST\n');
fprintf('============================================================\n');


% =============================================================
% ASSEMBLY FILE
% =============================================================

filename = fullfile( ...
    pwd, ...
    'programs', ...
    'stage16_4_decision.asm');


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
fprintf('x6 = %u\n',registers(7));

fprintf('\n');
fprintf('Final PC = %u\n',pc);

if halted

    fprintf('Status = HALTED\n');

else

    fprintf('Status = NOT HALTED\n');

end


% =============================================================
% TESTS
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

if registers(2) == uint32(10)

    fprintf('x1 = 10   : PASS');

    passed = passed + 1;

else

    fprintf('x1 = 10   : FAIL (got %u)',registers(2));

end

fprintf('\n');


% -------------------------------------------------------------
% Test 2
% -------------------------------------------------------------

if registers(3) == uint32(20)

    fprintf('x2 = 20   : PASS');

    passed = passed + 1;

else

    fprintf('x2 = 20   : FAIL (got %u)',registers(3));

end

fprintf('\n');


% -------------------------------------------------------------
% Test 3
% -------------------------------------------------------------
% BLT path:
%
% 10 < 20
%
% Therefore:
%
% x3 = 10 + 20 = 30
% -------------------------------------------------------------

if registers(4) == uint32(30)

    fprintf('x3 = 30   : PASS');

    passed = passed + 1;

else

    fprintf('x3 = 30   : FAIL (got %u)',registers(4));

end

fprintf('\n');


% -------------------------------------------------------------
% Test 4
% -------------------------------------------------------------

if registers(5) == uint32(20)

    fprintf('x4 = 20   : PASS');

    passed = passed + 1;

else

    fprintf('x4 = 20   : FAIL (got %u)',registers(5));

end

fprintf('\n');


% -------------------------------------------------------------
% Test 5
% -------------------------------------------------------------

if registers(6) == uint32(10)

    fprintf('x5 = 10   : PASS');

    passed = passed + 1;

else

    fprintf('x5 = 10   : FAIL (got %u)',registers(6));

end

fprintf('\n');


% -------------------------------------------------------------
% Test 6
% -------------------------------------------------------------
% BGE path:
%
% 20 >= 10
%
% Therefore:
%
% x6 = 20 - 10 = 10
% -------------------------------------------------------------

if registers(7) == uint32(10)

    fprintf('x6 = 10   : PASS');

    passed = passed + 1;

else

    fprintf('x6 = 10   : FAIL (got %u)',registers(7));

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
    fprintf('       STAGE 16.4 PASSED!\n');
    fprintf('       CONDITIONAL EXECUTION VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 16.4 FAILED\n');
    fprintf('       CHECK RESULTS ABOVE\n');
    fprintf('********************************************\n');

end

end