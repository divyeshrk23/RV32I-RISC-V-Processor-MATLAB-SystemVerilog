function stage16_1_arithmetic_test()

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('       STAGE 16.1 - ARITHMETIC INTEGRATION TEST\n');
fprintf('============================================================\n');

% ============================================================
% PROJECT AND ASSEMBLY FILE
% ============================================================

projectFolder = fileparts(mfilename('fullpath'));

asmFile = fullfile( ...
    projectFolder, ...
    'programs', ...
    'stage16_1_arithmetic.asm');

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
fprintf('Program:\n');
fprintf('------------------------------------------------------------\n');

for i = 1:length(program)
    fprintf('%d. %s\n',i,program{i});
end

% ============================================================
% EXECUTE CPU
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    CPU EXECUTION\n');
fprintf('============================================================\n');

[registers,pc,halted,dataMemory] = cpu(program,100);

% ============================================================
% DISPLAY FINAL RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    FINAL RESULTS\n');
fprintf('============================================================\n');

for i = 1:12
    fprintf('x%d = %d\n',i,registers(i+1));
end

fprintf('\nFinal PC = %d\n',pc);

if halted
    fprintf('Status = HALTED\n');
else
    fprintf('Status = RUNNING\n');
end

% ============================================================
% EXPECTED RESULTS
% ============================================================

expected = zeros(12,1,'uint32');

expected(1)  = uint32(50);
expected(2)  = uint32(20);
expected(3)  = uint32(70);
expected(4)  = uint32(30);
expected(5)  = uint32(16);
expected(6)  = uint32(54);
expected(7)  = uint32(38);
expected(8)  = uint32(100);
expected(9)  = uint32(40);
expected(10) = uint32(6);
expected(11) = uint32(94);
expected(12) = uint32(88);

% ============================================================
% TEST RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    TEST RESULTS\n');
fprintf('============================================================\n');

passCount = 0;
totalTests = 12;

for i = 1:12

    registerNumber = i;

    actual = registers(i+1);

    if actual == expected(i)

        fprintf( ...
            'x%d = %d : PASS\n', ...
            registerNumber, ...
            actual);

        passCount = passCount + 1;

    else

        fprintf( ...
            'x%d : FAIL\n', ...
            registerNumber);

        fprintf( ...
            '  Expected : %d\n', ...
            expected(i));

        fprintf( ...
            '  Actual   : %d\n', ...
            actual);

    end
end

% ============================================================
% FINAL STATUS
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
    fprintf('       STAGE 16.1 PASSED!\n');
    fprintf('    ARITHMETIC PROGRAM VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 16.1 FAILED\n');
    fprintf('********************************************\n');

end

end