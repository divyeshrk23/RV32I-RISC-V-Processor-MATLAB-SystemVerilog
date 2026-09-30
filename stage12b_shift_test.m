function stage12b_shift_test()

fprintf('\n');
fprintf('============================================================\n');
fprintf('          STAGE 12B - SRLI / SRAI TEST\n');
fprintf('============================================================\n');

program = {
    'ADDI x1, x0, 1'
    'SLLI x1, x1, 31'
    'SRLI x2, x1, 4'
    'SRAI x3, x1, 4'
    };

fprintf('\nProgram:\n');
fprintf('------------------------------------------------------------\n');

for i = 1:length(program)
    fprintf('%d. %s\n',i,program{i});
end

[registers,pc,halted,~] = cpu(program,20);

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    FINAL RESULTS\n');
fprintf('============================================================\n');

fprintf('x1 = 0x%08X\n',registers(2));
fprintf('x2 = 0x%08X\n',registers(3));
fprintf('x3 = 0x%08X\n',registers(4));

fprintf('\n');
fprintf('Final PC = %u\n',pc);

if halted
    fprintf('Status = HALTED\n');
else
    fprintf('Status = NOT HALTED\n');
end


% =========================================================
% TESTS
% =========================================================

pass1 = registers(2) == uint32(hex2dec('80000000'));

pass2 = registers(3) == uint32(hex2dec('08000000'));

pass3 = registers(4) == uint32(hex2dec('F8000000'));


fprintf('\n');
fprintf('============================================================\n');
fprintf('                    TEST RESULTS\n');
fprintf('============================================================\n');

if pass1
    fprintf('x1 = 0x80000000      : PASS\n');
else
    fprintf('x1 = 0x80000000      : FAIL\n');
end

if pass2
    fprintf('SRLI = 0x08000000    : PASS\n');
else
    fprintf('SRLI = 0x08000000    : FAIL\n');
end

if pass3
    fprintf('SRAI = 0xF8000000    : PASS\n');
else
    fprintf('SRAI = 0xF8000000    : FAIL\n');
end


if pass1 && pass2 && pass3

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('        STAGE 12B PASSED!\n');
    fprintf('       SRLI / SRAI WORKING\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('        STAGE 12B FAILED\n');
    fprintf('********************************************\n');

end

fprintf('\n');

end