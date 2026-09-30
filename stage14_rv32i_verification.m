function stage14_rv32i_verification()

clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('        STAGE 14 - COMPLETE RV32I VERIFICATION\n');
fprintf('============================================================\n');

%% ============================================================
% PROGRAM
% ============================================================

program = {

    'ADDI x1, x0, 20'
    'ADDI x2, x0, 5'
    'ADD x3, x1, x2'
    'SUB x4, x1, x2'

    'AND x5, x1, x2'
    'OR x6, x1, x2'
    'XOR x7, x1, x2'

    'SLT x8, x2, x1'
    'SLTU x9, x2, x1'

    'SLTI x10, x1, 25'
    'SLTIU x11, x1, 25'

    'SLLI x12, x2, 2'
    'SRLI x13, x12, 1'
    'SRAI x14, x12, 1'

    'ADDI x15, x0, -8'
    'SRAI x16, x15, 2'
    'SLTI x17, x15, 0'

    'ADDI x18, x0, 100'

    'SW x3, 0(x18)'
    'LW x19, 0(x18)'

    'SH x12, 4(x18)'
    'LH x20, 4(x18)'
    'LHU x21, 4(x18)'

    'SB x2, 8(x18)'
    'LB x22, 8(x18)'
    'LBU x23, 8(x18)'
};

fprintf('\nProgram:\n');
fprintf('------------------------------------------------------------\n');

for i = 1:length(program)
    fprintf('%d. %s\n',i,program{i});
end

%% ============================================================
% RUN CPU
% ============================================================

[registers,pc,halted,dataMemory] = cpu(program,100);

%% ============================================================
% FINAL RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    FINAL RESULTS\n');
fprintf('============================================================\n');

fprintf('x1  = %d\n',registers(2));
fprintf('x2  = %d\n',registers(3));
fprintf('x3  = %d\n',registers(4));
fprintf('x4  = %d\n',registers(5));
fprintf('x5  = %d\n',registers(6));
fprintf('x6  = %d\n',registers(7));
fprintf('x7  = %d\n',registers(8));
fprintf('x8  = %d\n',registers(9));
fprintf('x9  = %d\n',registers(10));
fprintf('x10 = %d\n',registers(11));
fprintf('x11 = %d\n',registers(12));

fprintf('x12 = 0x%08X\n',registers(13));
fprintf('x13 = 0x%08X\n',registers(14));
fprintf('x14 = 0x%08X\n',registers(15));

fprintf('x15 = 0x%08X\n',registers(16));
fprintf('x16 = 0x%08X\n',registers(17));
fprintf('x17 = %d\n',registers(18));

fprintf('x18 = %d\n',registers(19));

fprintf('x19 = 0x%08X\n',registers(20));
fprintf('x20 = 0x%08X\n',registers(21));
fprintf('x21 = 0x%08X\n',registers(22));
fprintf('x22 = 0x%08X\n',registers(23));
fprintf('x23 = 0x%08X\n',registers(24));

fprintf('\n');

fprintf('Memory[100] = 0x%02X\n',dataMemory(101));
fprintf('Memory[101] = 0x%02X\n',dataMemory(102));
fprintf('Memory[102] = 0x%02X\n',dataMemory(103));
fprintf('Memory[103] = 0x%02X\n',dataMemory(104));

fprintf('Memory[104] = 0x%02X\n',dataMemory(105));
fprintf('Memory[105] = 0x%02X\n',dataMemory(106));

fprintf('Memory[108] = 0x%02X\n',dataMemory(109));

fprintf('\nFinal PC = %d\n',pc);

if halted
    fprintf('Status = HALTED\n');
else
    fprintf('Status = RUNNING\n');
end

%% ============================================================
% EXPECTED VALUES
% ============================================================

expected = zeros(32,1,'uint32');

expected(2)  = uint32(20);
expected(3)  = uint32(5);
expected(4)  = uint32(25);
expected(5)  = uint32(15);
expected(6)  = uint32(4);
expected(7)  = uint32(21);
expected(8)  = uint32(17);

expected(9)  = uint32(1);
expected(10) = uint32(1);

expected(11) = uint32(1);
expected(12) = uint32(1);

expected(13) = uint32(20);
expected(14) = uint32(10);
expected(15) = uint32(10);

expected(16) = uint32(hex2dec('FFFFFFF8'));
expected(17) = uint32(hex2dec('FFFFFFFE'));
expected(18) = uint32(1);

expected(19) = uint32(100);

expected(20) = uint32(25);
expected(21) = uint32(20);
expected(22) = uint32(20);
expected(23) = uint32(5);
expected(24) = uint32(5);

%% ============================================================
% REGISTER TESTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    REGISTER TESTS\n');
fprintf('============================================================\n');

passCount = 0;
totalTests = 23;

for i = 2:24

    registerNumber = i - 1;

    if registers(i) == expected(i)

        fprintf('x%-2d : PASS\n',registerNumber);
        passCount = passCount + 1;

    else

        fprintf('x%-2d : FAIL\n',registerNumber);

        fprintf('       Expected : 0x%08X\n',expected(i));
        fprintf('       Actual   : 0x%08X\n',registers(i));

    end

end

%% ============================================================
% MEMORY TESTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    MEMORY TESTS\n');
fprintf('============================================================\n');

memoryPass = true;

% Word store
if dataMemory(101) == uint8(25) && ...
   dataMemory(102) == uint8(0) && ...
   dataMemory(103) == uint8(0) && ...
   dataMemory(104) == uint8(0)

    fprintf('SW/LW memory test : PASS\n');
    passCount = passCount + 1;

else

    fprintf('SW/LW memory test : FAIL\n');
    memoryPass = false;

end

% Halfword store
if dataMemory(105) == uint8(20) && ...
   dataMemory(106) == uint8(0)

    fprintf('SH/LH memory test : PASS\n');
    passCount = passCount + 1;

else

    fprintf('SH/LH memory test : FAIL\n');
    memoryPass = false;

end

% Byte store
if dataMemory(109) == uint8(5)

    fprintf('SB/LB memory test : PASS\n');
    passCount = passCount + 1;

else

    fprintf('SB/LB memory test : FAIL\n');
    memoryPass = false;

end

%% ============================================================
% FINAL STATUS
% ============================================================

totalTests = totalTests + 3;

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    TEST SUMMARY\n');
fprintf('============================================================\n');

fprintf('Tests passed : %d / %d\n',passCount,totalTests);

fprintf('\n');

if passCount == totalTests

    fprintf('********************************************\n');
    fprintf('          STAGE 14 PASSED!\n');
    fprintf('       COMPLETE RV32I WORKING\n');
    fprintf('********************************************\n');

else

    fprintf('********************************************\n');
    fprintf('          STAGE 14 FAILED\n');
    fprintf('********************************************\n');

end

fprintf('\n');

end