function stage15_1_loader_test()

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('       STAGE 15.1 - ROBUST PROGRAM LOADER TEST\n');
fprintf('============================================================\n');

%% ============================================================
% TEST PROGRAM
% ============================================================

program = {

    '% This is a comment'

    '   ADDI x1, x0, 10   '

    ''

    'ADDI x2, x0, 20     % Load 20 into x2'

    'ADD x3, x1, x2'

    '    '

    '% Another comment'

    'SUB x4, x3, x1'

};

%% ============================================================
% DISPLAY ORIGINAL PROGRAM
% ============================================================

fprintf('\nOriginal program entries:\n');
fprintf('------------------------------------------------------------\n');

for i = 1:length(program)

    fprintf('%2d : "%s"\n',i,program{i});

end

%% ============================================================
% LOAD PROGRAM
% ============================================================

memory = program_loader(program);

%% ============================================================
% EXPECTED MACHINE CODE
% ============================================================

expected = uint32([

    encoder('ADDI x1, x0, 10')
    encoder('ADDI x2, x0, 20')
    encoder('ADD x3, x1, x2')
    encoder('SUB x4, x3, x1')

]);

%% ============================================================
% RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    TEST RESULTS\n');
fprintf('============================================================\n');

passCount = 0;

if length(memory) ~= length(expected)

    fprintf('Instruction count : FAIL\n');
    fprintf('Expected : %d\n',length(expected));
    fprintf('Actual   : %d\n',length(memory));

else

    fprintf('Instruction count : PASS\n');
    passCount = passCount + 1;

end

%% ============================================================
% MACHINE CODE VERIFICATION
% ============================================================

numberOfTests = length(expected);

for i = 1:min(length(memory),length(expected))

    fprintf('\nInstruction %d\n',i);

    fprintf('Expected : 0x%08X\n',expected(i));
    fprintf('Actual   : 0x%08X\n',memory(i));

    if memory(i) == expected(i)

        fprintf('Result   : PASS\n');
        passCount = passCount + 1;

    else

        fprintf('Result   : FAIL\n');

    end

end

%% ============================================================
% FINAL STATUS
% ============================================================

totalTests = numberOfTests + 1;

fprintf('\n');
fprintf('============================================================\n');
fprintf('Tests passed : %d / %d\n',passCount,totalTests);

if passCount == totalTests

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 15.1 PASSED!\n');
    fprintf('        ROBUST LOADER WORKING\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 15.1 FAILED\n');
    fprintf('********************************************\n');

end

fprintf('\n');

end