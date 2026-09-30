clc;
clear;

fprintf('\n');
fprintf('============================================================\n');
fprintf('       STAGE 10C - CPU FETCH TEST\n');
fprintf('============================================================\n');


% ============================================================
% PROGRAM
% ============================================================

program = {

    'ADDI x1, x0, 10'
    'ADDI x2, x0, 20'
    'ADD x3, x1, x2'
    'SUB x4, x3, x1'
    'AND x5, x3, x4'
    'OR x6, x3, x4'

};


% ============================================================
% LOAD PROGRAM
% ============================================================

memory = program_loader(program);


% ============================================================
% INITIAL PC
% ============================================================

pc = 0;


% ============================================================
% FETCH LOOP
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                 FETCH SEQUENCE\n');
fprintf('============================================================\n');

for cycle = 1:length(memory)

    currentPC = pc;

    [pc, instruction, decoded] = cpu_fetch(pc,memory);

    fprintf('\n');
    fprintf('Cycle       : %d\n',cycle);
    fprintf('PC          : %d\n',currentPC);
    fprintf('Machine code: 0x%08X\n',instruction);
    fprintf('Opcode      : %s\n',decoded.opcode);

    if decoded.rd ~= 0
        fprintf('rd          : x%d\n',decoded.rd);
    end

    if decoded.rs1 ~= 0
        fprintf('rs1         : x%d\n',decoded.rs1);
    end

    if decoded.rs2 ~= 0
        fprintf('rs2         : x%d\n',decoded.rs2);
    end

    fprintf('Immediate   : %d\n',decoded.immediate);

    fprintf('Next PC     : %d\n',pc);

end


% ============================================================
% FINAL RESULT
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('             STAGE 10C - TEST COMPLETE\n');
fprintf('============================================================\n');

expectedFinalPC = length(memory) * 4;

fprintf('Final PC     : %d\n',pc);
fprintf('Expected PC  : %d\n',expectedFinalPC);


if pc == expectedFinalPC

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('          STAGE 10C PASSED!                \n');
    fprintf('   PC + FETCH + DECODE WORKING             \n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('STAGE 10C FAILED\n');

end

fprintf('\n');
fprintf('============================================================\n');