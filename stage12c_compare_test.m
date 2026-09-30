function stage12c_compare_test()

fprintf('\n');
fprintf('============================================================\n');
fprintf('          STAGE 12C - SLTI / SLTIU TEST\n');
fprintf('============================================================\n');

program = {
    'ADDI x1, x0, 10'
    'SLTI x2, x1, 20'
    'SLTI x3, x1, 5'
    'SLTI x4, x1, 10'
    'SLTIU x5, x1, 20'
    'SLTIU x6, x1, 5'
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

fprintf('x1 = %u\n',registers(2));
fprintf('x2 = %u\n',registers(3));
fprintf('x3 = %u\n',registers(4));
fprintf('x4 = %u\n',registers(5));
fprintf('x5 = %u\n',registers(6));
fprintf('x6 = %u\n',registers(7));

fprintf('\nFinal PC = %u\n',pc);

if halted
    fprintf('Status = HALTED\n');
else
    fprintf('Status = NOT HALTED\n');
end

pass1 = registers(2) == uint32(10);
pass2 = registers(3) == uint32(1);
pass3 = registers(4) == uint32(0);
pass4 = registers(5) == uint32(0);
pass5 = registers(6) == uint32(1);
pass6 = registers(7) == uint32(0);

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    TEST RESULTS\n');
fprintf('============================================================\n');

if pass1
    fprintf('x1 = 10              : PASS\n');
else
    fprintf('x1 = 10              : FAIL\n');
end

if pass2
    fprintf('SLTI 10 < 20         : PASS\n');
else
    fprintf('SLTI 10 < 20         : FAIL\n');
end

if pass3
    fprintf('SLTI 10 < 5          : PASS\n');
else
    fprintf('SLTI 10 < 5          : FAIL\n');
end

if pass4
    fprintf('SLTI 10 < 10         : PASS\n');
else
    fprintf('SLTI 10 < 10         : FAIL\n');
end

if pass5
    fprintf('SLTIU 10 < 20        : PASS\n');
else
    fprintf('SLTIU 10 < 20        : FAIL\n');
end

if pass6
    fprintf('SLTIU 10 < 5         : PASS\n');
else
    fprintf('SLTIU 10 < 5         : FAIL\n');
end

if pass1 && pass2 && pass3 && pass4 && pass5 && pass6

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('        STAGE 12C PASSED!\n');
    fprintf('       SLTI / SLTIU WORKING\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('        STAGE 12C FAILED\n');
    fprintf('********************************************\n');

end

fprintf('\n');

end