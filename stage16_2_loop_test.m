function stage16_2_loop_test()

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('       STAGE 16.2 - LOOP + BRANCH INTEGRATION TEST\n');
fprintf('============================================================\n');

% ============================================================
% PROJECT AND ASSEMBLY FILE
% ============================================================

projectFolder = fileparts(mfilename('fullpath'));

asmFile = fullfile( ...
    projectFolder, ...
    'programs', ...
    'stage16_2_loop.asm');

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
% FINAL RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    FINAL RESULTS\n');
fprintf('============================================================\n');

fprintf('x1 = %d\n',registers(2));
fprintf('x2 = %d\n',registers(3));
fprintf('x3 = %d\n',registers(4));

fprintf('\nFinal PC = %d\n',pc);

if halted
    fprintf('Status = HALTED\n');
else
    fprintf('Status = RUNNING\n');
end

% ============================================================
% EXPECTED RESULTS
% ============================================================

expectedX1 = uint32(6);
expectedX2 = uint32(6);
expectedX3 = uint32(15);

% ============================================================
% TEST RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    TEST RESULTS\n');
fprintf('============================================================\n');

passCount = 0;
totalTests = 3;

if registers(2) == expectedX1

    fprintf('x1 = %d : PASS\n',registers(2));
    passCount = passCount + 1;

else

    fprintf('x1 : FAIL\n');
    fprintf('  Expected : %d\n',expectedX1);
    fprintf('  Actual   : %d\n',registers(2));

end

if registers(3) == expectedX2

    fprintf('x2 = %d : PASS\n',registers(3));
    passCount = passCount + 1;

else

    fprintf('x2 : FAIL\n');
    fprintf('  Expected : %d\n',expectedX2);
    fprintf('  Actual   : %d\n',registers(3));

end

if registers(4) == expectedX3

    fprintf('x3 = %d : PASS\n',registers(4));
    passCount = passCount + 1;

else

    fprintf('x3 : FAIL\n');
    fprintf('  Expected : %d\n',expectedX3);
    fprintf('  Actual   : %d\n',registers(4));

end

% ============================================================
% FINAL STATUS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('Tests passed : %d / %d\n',passCount,totalTests);

if passCount == totalTests && halted

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 16.2 PASSED!\n');
    fprintf('       LOOP + BRANCH VERIFIED\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 16.2 FAILED\n');
    fprintf('********************************************\n');

end

end