function stage11c_halfword_test()

fprintf('\n');
fprintf('============================================================\n');
fprintf('          STAGE 11C-3 - HALFWORD TEST\n');
fprintf('============================================================\n');

program = {
    'ADDI x1, x0, 100'
    'ADDI x2, x0, 1'
    'SLLI x2, x2, 15'
    'SH x2, 0(x1)'
    'LH x3, 0(x1)'
    'LHU x4, 0(x1)'
};

fprintf('\nProgram:\n');
fprintf('------------------------------------------------------------\n');

for i = 1:length(program)
    fprintf('%d. %s\n',i,program{i});
end

[registers,pc,halted,dataMemory] = cpu(program,20);

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    FINAL RESULTS\n');
fprintf('============================================================\n');

fprintf('x1 = %u\n',registers(2));
fprintf('x2 = 0x%08X\n',registers(3));
fprintf('x3 = 0x%08X\n',registers(4));
fprintf('x4 = 0x%08X\n',registers(5));

fprintf('\n');

fprintf('Memory[100] = 0x%02X\n',dataMemory(101));
fprintf('Memory[101] = 0x%02X\n',dataMemory(102));

fprintf('\n');
fprintf('Final PC = %u\n',pc);

if halted
    fprintf('Status = HALTED\n');
else
    fprintf('Status = NOT HALTED\n');
end

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    TEST RESULTS\n');
fprintf('============================================================\n');

pass1 = registers(2) == uint32(100);
pass2 = registers(3) == uint32(hex2dec('00008000'));

% LH should sign extend 0x8000 to 0xFFFF8000
pass3 = registers(4) == uint32(hex2dec('FFFF8000'));

% LHU should zero extend 0x8000 to 0x00008000
pass4 = registers(5) == uint32(hex2dec('00008000'));

% Little-endian memory:
% 0x8000 -> byte 0 = 00
%            byte 1 = 80
pass5 = dataMemory(101) == uint8(hex2dec('00'));
pass6 = dataMemory(102) == uint8(hex2dec('80'));

if pass1
    fprintf('x1 = 100             : PASS\n');
else
    fprintf('x1 = 100             : FAIL\n');
end

if pass2
    fprintf('x2 = 0x00008000      : PASS\n');
else
    fprintf('x2 = 0x00008000      : FAIL\n');
end

if pass3
    fprintf('LH = 0xFFFF8000      : PASS\n');
else
    fprintf('LH = 0xFFFF8000      : FAIL\n');
end

if pass4
    fprintf('LHU = 0x00008000     : PASS\n');
else
    fprintf('LHU = 0x00008000     : FAIL\n');
end

if pass5
    fprintf('Memory[100] = 0x00   : PASS\n');
else
    fprintf('Memory[100] = 0x00   : FAIL\n');
end

if pass6
    fprintf('Memory[101] = 0x80   : PASS\n');
else
    fprintf('Memory[101] = 0x80   : FAIL\n');
end

if pass1 && pass2 && pass3 && pass4 && pass5 && pass6
    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 11C-3 PASSED!\n');
    fprintf('          HALFWORD WORKING\n');
    fprintf('********************************************\n');
else
    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('       STAGE 11C-3 FAILED\n');
    fprintf('********************************************\n');
end

fprintf('\n');

end