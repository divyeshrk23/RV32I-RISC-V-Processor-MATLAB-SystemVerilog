clc;
clear;

fprintf('\n');
fprintf('============================================================\n');
fprintf('          STAGE 9 - FINAL ENCODER/DECODER TEST\n');
fprintf('============================================================\n');


% ============================================================
% TEST PROGRAM
% ============================================================

instructions = {
    'ADD x3, x1, x2'
    'SUB x3, x1, x2'
    'AND x3, x1, x2'
    'OR x3, x1, x2'
    'XOR x3, x1, x2'

    'ADDI x5, x1, 100'
    'ADDI x5, x1, -10'

    'LB x5, 4(x1)'
    'LBU x5, 4(x1)'
    'LH x5, 4(x1)'
    'LHU x5, 4(x1)'
    'LW x5, 4(x1)'

    'SB x5, 8(x1)'
    'SH x5, 8(x1)'
    'SW x5, 8(x1)'

    'BEQ x1, x2, 16'
    'BNE x1, x2, 16'
    'BLT x1, x2, 16'
    'BGE x1, x2, 16'
    'BLTU x1, x2, 16'
    'BGEU x1, x2, 16'

    'BNE x1, x2, -8'

    'JAL x1, 32'
    'JAL x1, -32'

    'JALR x1, 4(x2)'
};


% ============================================================
% COUNTERS
% ============================================================

totalTests = length(instructions);

passed = 0;
failed = 0;


% ============================================================
% RUN TESTS
% ============================================================

for i = 1:totalTests

    asm = instructions{i};

    fprintf('\n');
    fprintf('------------------------------------------------------------\n');
    fprintf('Test %d/%d\n',i,totalTests);
    fprintf('Assembly : %s\n',asm);


    try

        % ====================================================
        % ENCODE
        % ====================================================

        machineCode = encoder(asm);

        fprintf('Machine  : 0x%08X\n',machineCode);


        % ====================================================
        % DECODE
        % ====================================================

        decoded = decoder(machineCode);

        fprintf('Opcode   : %s\n',decoded.opcode);


        % ====================================================
        % DISPLAY REGISTERS
        % ====================================================

        if decoded.rd ~= 0
            fprintf('rd       : x%d\n',decoded.rd);
        end

        if decoded.rs1 ~= 0
            fprintf('rs1      : x%d\n',decoded.rs1);
        end

        if decoded.rs2 ~= 0
            fprintf('rs2      : x%d\n',decoded.rs2);
        end

        fprintf('Immediate: %d\n',decoded.immediate);


        % ====================================================
        % GET EXPECTED OPCODE
        % ====================================================

        firstSpace = strfind(strtrim(asm),' ');

        if isempty(firstSpace)

            expectedOpcode = string(strtrim(asm));

        else

            expectedOpcode = string( ...
                strtrim(asm(1:firstSpace(1)-1)) );

        end


        % ====================================================
        % CHECK OPCODE
        % ====================================================

        if decoded.opcode == expectedOpcode

            fprintf('RESULT   : PASS\n');

            passed = passed + 1;

        else

            fprintf('RESULT   : FAIL\n');

            fprintf('Expected : %s\n',expectedOpcode);
            fprintf('Decoded  : %s\n',decoded.opcode);

            failed = failed + 1;

        end


    catch ME

        fprintf('ERROR    : %s\n',ME.message);
        fprintf('RESULT   : FAIL\n');

        failed = failed + 1;

    end

end


% ============================================================
% FINAL RESULT
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                 STAGE 9 FINAL RESULT\n');
fprintf('============================================================\n');

fprintf('Total tests : %d\n',totalTests);
fprintf('Passed      : %d\n',passed);
fprintf('Failed      : %d\n',failed);


if failed == 0

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('          ALL TESTS PASSED!                \n');
    fprintf('     STAGE 9 COMPLETED SUCCESSFULLY        \n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('Some tests failed.\n');

end


fprintf('\n');
fprintf('============================================================\n');