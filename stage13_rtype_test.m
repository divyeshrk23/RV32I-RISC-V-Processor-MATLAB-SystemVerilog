function stage13_rtype_test()

fprintf('\n');
fprintf('============================================================\n');
fprintf('             STAGE 13 - COMPLETE R-TYPE ALU TEST\n');
fprintf('============================================================\n');

program = {

    'ADDI x1, x0, -8'
    'ADDI x2, x0, 8'

    'ADD x3, x1, x2'
    'SUB x4, x2, x1'

    'AND x5, x1, x2'
    'OR x6, x1, x2'
    'XOR x7, x1, x2'

    'SLT x8, x1, x2'
    'SLT x9, x2, x1'

    'SLTU x10, x1, x2'
    'SLTU x11, x2, x1'
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

fprintf('x1  = 0x%08X\n',registers(2));
fprintf('x2  = 0x%08X\n',registers(3));

fprintf('x3  = 0x%08X\n',registers(4));
fprintf('x4  = 0x%08X\n',registers(5));
fprintf('x5  = 0x%08X\n',registers(6));
fprintf('x6  = 0x%08X\n',registers(7));
fprintf('x7  = 0x%08X\n',registers(8));

fprintf('x8  = %u\n',registers(9));
fprintf('x9  = %u\n',registers(10));

fprintf('x10 = %u\n',registers(11));
fprintf('x11 = %u\n',registers(12));

fprintf('\nFinal PC = %u\n',pc);

if halted
    fprintf('Status = HALTED\n');
else
    fprintf('Status = NOT HALTED\n');
end


% ============================================================
% EXPECTED RESULTS
% ============================================================

% x1 = -8
% x2 = +8

expected_x1 = uint32(hex2dec('FFFFFFF8'));
expected_x2 = uint32(8);

% ADD
% -8 + 8 = 0

expected_x3 = uint32(0);

% SUB
% 8 - (-8) = 16

expected_x4 = uint32(16);

% AND
expected_x5 = bitand( ...
    expected_x1,expected_x2);

% OR
expected_x6 = bitor( ...
    expected_x1,expected_x2);

% XOR
expected_x7 = bitxor( ...
    expected_x1,expected_x2);

% Signed comparison
%
% -8 < +8 = true
% +8 < -8 = false

expected_x8 = uint32(1);
expected_x9 = uint32(0);

% Unsigned comparison
%
% 0xFFFFFFF8 = 4294967288
% 8 = 8
%
% 4294967288 < 8 = false
% 8 < 4294967288 = true

expected_x10 = uint32(0);
expected_x11 = uint32(1);


% ============================================================
% CHECK RESULTS
% ============================================================

pass1 = registers(2)  == expected_x1;
pass2 = registers(3)  == expected_x2;
pass3 = registers(4)  == expected_x3;
pass4 = registers(5)  == expected_x4;
pass5 = registers(6)  == expected_x5;
pass6 = registers(7)  == expected_x6;
pass7 = registers(8)  == expected_x7;
pass8 = registers(9)  == expected_x8;
pass9 = registers(10) == expected_x9;
pass10 = registers(11) == expected_x10;
pass11 = registers(12) == expected_x11;


% ============================================================
% TEST REPORT
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    TEST RESULTS\n');
fprintf('============================================================\n');

if pass1
    fprintf('x1 = -8              : PASS\n');
else
    fprintf('x1 = -8              : FAIL\n');
end

if pass2
    fprintf('x2 = +8              : PASS\n');
else
    fprintf('x2 = +8              : FAIL\n');
end

if pass3
    fprintf('ADD                   : PASS\n');
else
    fprintf('ADD                   : FAIL\n');
end

if pass4
    fprintf('SUB                   : PASS\n');
else
    fprintf('SUB                   : FAIL\n');
end

if pass5
    fprintf('AND                   : PASS\n');
else
    fprintf('AND                   : FAIL\n');
end

if pass6
    fprintf('OR                    : PASS\n');
else
    fprintf('OR                    : FAIL\n');
end

if pass7
    fprintf('XOR                   : PASS\n');
else
    fprintf('XOR                   : FAIL\n');
end

if pass8
    fprintf('SLT  (-8 < +8)        : PASS\n');
else
    fprintf('SLT  (-8 < +8)        : FAIL\n');
end

if pass9
    fprintf('SLT  (+8 < -8)        : PASS\n');
else
    fprintf('SLT  (+8 < -8)        : FAIL\n');
end

if pass10
    fprintf('SLTU (-8 < +8)        : PASS\n');
else
    fprintf('SLTU (-8 < +8)        : FAIL\n');
end

if pass11
    fprintf('SLTU (+8 < -8)        : PASS\n');
else
    fprintf('SLTU (+8 < -8)        : FAIL\n');
end


% ============================================================
% FINAL STATUS
% ============================================================

if pass1 && pass2 && pass3 && pass4 && ...
        pass5 && pass6 && pass7 && pass8 && ...
        pass9 && pass10 && pass11

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('          STAGE 13 PASSED!\n');
    fprintf('       COMPLETE R-TYPE ALU WORKING\n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('          STAGE 13 FAILED\n');
    fprintf('********************************************\n');

end

fprintf('\n');

end