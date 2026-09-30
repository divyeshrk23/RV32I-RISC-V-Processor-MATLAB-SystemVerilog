function stage15_3_file_execution_test()

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('       STAGE 15.3 - ASSEMBLY FILE EXECUTION TEST\n');
fprintf('============================================================\n');

% ============================================================
% FIND ASSEMBLY FILE
% ============================================================

projectFolder = fileparts(mfilename('fullpath'));

asmFile = fullfile( ...
    projectFolder, ...
    'programs', ...
    'stage15_2_test.asm');

fprintf('\nAssembly file:\n');
fprintf('%s\n',asmFile);

if ~isfile(asmFile)
    error('Assembly file not found: %s',asmFile);
end

% ============================================================
% READ ASSEMBLY FILE
% ============================================================

program = assembly_reader(asmFile);

fprintf('\n');
fprintf('Program to execute:\n');
fprintf('------------------------------------------------------------\n');

for i = 1:length(program)
    fprintf('%d. %s\n',i,program{i});
end

% ============================================================
% EXECUTE PROGRAM
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    CPU EXECUTION\n');
fprintf('============================================================\n');

[registers,pc,halted,dataMemory] = cpu(program,100);

% ============================================================
% FINAL RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    FINAL RESULTS\n');
fprintf('============================================================\n');

fprintf('x1 = %d\n',registers(2));
fprintf('x2 = %d\n',registers(3));
fprintf('x3 = %d\n',registers(4));
fprintf('x4 = %d\n',registers(5));
fprintf('x5 = %d\n',registers(6));
fprintf('x6 = %d\n',registers(7));
fprintf('x7 = %d\n',registers(8));

fprintf('\nFinal PC = %d\n',pc);

if halted
    fprintf('Status = HALTED\n');
else
    fprintf('Status = RUNNING\n');
end

% ============================================================
% EXPECTED RESULTS
% ============================================================

expected = zeros(8,1,'uint32');

expected(2) = uint32(10);
expected(3) = uint32(20);
expected(4) = uint32(30);
expected(5) = uint32(20);
expected(6) = uint32(0);
expected(7) = uint32(30);
expected(8) = uint32(30);

% ============================================================
% TEST RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    TEST RESULTS\n');
fprintf('============================================================\n');

passCount = 0;
totalTests = 7;

for i = 2:8

    registerNumber = i - 1;

    if registers(i) == expected(i)

        fprintf( ...
            'x%d = %d : PASS\n', ...
            registerNumber, ...
            expected(i));

        passCount = passCount + 1;

    else

        fprintf( ...
            'x%d : FAIL\n', ...
            registerNumber);

        fprintf( ...
            '  Expected : 0x%08X\n', ...
            expected(i));

        fprintf( ...
            '  Actual   : 0x%08X\n', ...
            registers(i));

    end
end

% ============================================================
% STAGE RESULT
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf( ...
    'Tests passed : %d / %d\n', ...
    passCount, ...
    totalTests);

if passCount == totalTests && halted

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 15.3 PASSED!\n');
    fprintf('     .ASM FILE EXECUTION WORKING\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 15.3 FAILED\n');
    fprintf('********************************************\n');

end

end