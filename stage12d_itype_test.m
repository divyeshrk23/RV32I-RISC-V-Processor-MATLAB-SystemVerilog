function stage12d_itype_test()

fprintf('\n');
fprintf('============================================================\n');
fprintf('       STAGE 12D - COMPLETE I-TYPE ALU TEST\n');
fprintf('============================================================\n');

program = {
    'ADDI x1, x0, -8'
    'ADDI x2, x0, 8'
    'SLTI x3, x1, 0'
    'SLTI x4, x2, 0'
    'SLTIU x5, x1, 0'
    'SLTIU x6, x2, 16'
    'SLLI x7, x2, 2'
    'SRLI x8, x7, 2'
    'SRAI x9, x1, 2'
};

fprintf('\nProgram:\n');
fprintf('------------------------------------------------------------\n');

for i = 1:length(program)
    fprintf('%d. %s\n',i,program{i});
end

[registers,pc,halted,~] = cpu(program,30);

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    FINAL RESULTS\n');
fprintf('============================================================\n');

fprintf('x1 = 0x%08X\n',registers(2));
fprintf('x2 = 0x%08X\n',registers(3));
fprintf('x3 = %u\n',registers(4));
fprintf('x4 = %u\n',registers(5));
fprintf('x5 = %u\n',registers(6));
fprintf('x6 = %u\n',registers(7));
fprintf('x7 = 0x%08X\n',registers(8));
fprintf('x8 = 0x%08X\n',registers(9));
fprintf('x9 = 0x%08X\n',registers(10));

fprintf('\nFinal PC = %u\n',pc);

if halted
    fprintf('Status = HALTED\n');
else
    fprintf('Status = NOT HALTED\n');
end

% ============================================================
% EXPECTED RESULTS
% ============================================================

pass1 = registers(2) == uint32(hex2dec('FFFFFFF8'));
pass2 = registers(3) == uint32(8);

pass3 = registers(4) == uint32(1);
pass4 = registers(5) == uint32(0);

% x1 = 0xFFFFFFF8 = 4294967288 unsigned.
% Therefore x1 < 0 is FALSE for SLTIU.
pass5 = registers(6) == uint32(0);

pass6 = registers(7) == uint32(1);

% 8 << 2 = 32
pass7 = registers(8) == uint32(32);

% 32 >> 2 = 8
pass8 = registers(9) == uint32(8);

% -8 >>> 2 = -2 = 0xFFFFFFFE
pass9 = registers(10) == uint32(hex2dec('FFFFFFFE'));

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    TEST RESULTS\n');
fprintf('============================================================\n');

if pass1
    fprintf('ADDI -8              : PASS\n');
else
    fprintf('ADDI -8              : FAIL\n');
end

if pass2
    fprintf('ADDI 8               : PASS\n');
else
    fprintf('ADDI 8               : FAIL\n');
end

if pass3
    fprintf('SLTI -8 < 0          : PASS\n');
else
    fprintf('SLTI -8 < 0          : FAIL\n');
end

if pass4
    fprintf('SLTI 8 < 0           : PASS\n');
else
    fprintf('SLTI 8 < 0           : FAIL\n');
end

if pass5
    fprintf('SLTIU -8 < 0         : PASS\n');
else
    fprintf('SLTIU -8 < 0         : FAIL\n');
end

if pass6
    fprintf('SLTIU 8 < 16         : PASS\n');
else
    fprintf('SLTIU 8 < 16         : FAIL\n');
end

if pass7
    fprintf('SLLI 8 << 2          : PASS\n');
else
    fprintf('SLLI 8 << 2          : FAIL\n');
end

if pass8
    fprintf('SRLI 32 >> 2         : PASS\n');
else
    fprintf('SRLI 32 >> 2         : FAIL\n');
end

if pass9
    fprintf('SRAI -8 >> 2         : PASS\n');
else
    fprintf('SRAI -8 >> 2         : FAIL\n');
end

if pass1 && pass2 && pass3 && pass4 && ...
        pass5 && pass6 && pass7 && pass8 && pass9

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('        STAGE 12D PASSED!\n');
    fprintf('     COMPLETE I-TYPE ALU WORKING\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('        STAGE 12D FAILED\n');
    fprintf('********************************************\n');

end

fprintf('\n');

end