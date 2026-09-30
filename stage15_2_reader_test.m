function stage15_2_reader_test()

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('       STAGE 15.2 - ASSEMBLY FILE READER TEST\n');
fprintf('============================================================\n');

%% ============================================================
% FIND PROJECT FOLDER
% ============================================================

testFilePath = mfilename('fullpath');

projectFolder = fileparts(testFilePath);

filename = fullfile( ...
    projectFolder, ...
    'programs', ...
    'stage15_2_test.asm');

fprintf('\n');
fprintf('Project folder:\n');
fprintf('%s\n',projectFolder);

fprintf('\n');
fprintf('Assembly file:\n');
fprintf('%s\n',filename);

%% ============================================================
% CHECK ASSEMBLY FILE
% ============================================================

if ~isfile(filename)

    fprintf('\n');
    fprintf('ERROR:\n');
    fprintf('Assembly file was not found.\n');
    fprintf('\n');
    fprintf('Please make sure this file exists:\n');
    fprintf('%s\n',filename);
    fprintf('\n');
    fprintf('Required folder:\n');
    fprintf('%s\n',fullfile(projectFolder,'programs'));

    error('Stage 15.2 assembly file is missing.');

end

%% ============================================================
% READ ASSEMBLY FILE
% ============================================================

program = assembly_reader(filename);

%% ============================================================
% EXPECTED PROGRAM
% ============================================================

expectedProgram = {

    'ADDI x1, x0, 10'
    'ADDI x2, x0, 20'
    'ADD x3, x1, x2'
    'SUB x4, x3, x1'
    'AND x5, x1, x2'
    'OR x6, x1, x2'
    'XOR x7, x1, x2'

};

%% ============================================================
% TEST RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    TEST RESULTS\n');
fprintf('============================================================\n');

passCount = 0;

totalTests = length(expectedProgram) + 1;

%% ============================================================
% INSTRUCTION COUNT
% ============================================================

if length(program) == length(expectedProgram)

    fprintf('Instruction count : PASS\n');

    passCount = passCount + 1;

else

    fprintf('Instruction count : FAIL\n');

    fprintf('Expected : %d\n',length(expectedProgram));
    fprintf('Actual   : %d\n',length(program));

end

%% ============================================================
% INSTRUCTION VERIFICATION
% ============================================================

for i = 1:min(length(program),length(expectedProgram))

    fprintf('\n');
    fprintf('Instruction %d\n',i);

    fprintf('Expected : %s\n',expectedProgram{i});
    fprintf('Actual   : %s\n',program{i});

    if strcmp(program{i},expectedProgram{i})

        fprintf('Result   : PASS\n');

        passCount = passCount + 1;

    else

        fprintf('Result   : FAIL\n');

    end

end

%% ============================================================
% FINAL STATUS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('Tests passed : %d / %d\n',passCount,totalTests);

if passCount == totalTests

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 15.2 PASSED!\n');
    fprintf('       ASSEMBLY FILE READER WORKING\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 15.2 FAILED\n');
    fprintf('********************************************\n');

end

fprintf('\n');

end