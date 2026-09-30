clc;
clear;

fprintf('\n');
fprintf('============================================================\n');
fprintf('          STAGE 10B - PROGRAM LOADER TEST\n');
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
% DISPLAY MEMORY
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('              LOADED INSTRUCTION MEMORY\n');
fprintf('============================================================\n');

for i = 1:length(memory)

    address = (i-1) * 4;

    fprintf('\n');
    fprintf('Address      : %d\n',address);
    fprintf('Machine code : 0x%08X\n',memory(i));

    decoded = decoder(memory(i));

    fprintf('Opcode       : %s\n',decoded.opcode);

    if decoded.rd ~= 0
        fprintf('rd           : x%d\n',decoded.rd);
    end

    if decoded.rs1 ~= 0
        fprintf('rs1          : x%d\n',decoded.rs1);
    end

    if decoded.rs2 ~= 0
        fprintf('rs2          : x%d\n',decoded.rs2);
    end

    fprintf('Immediate    : %d\n',decoded.immediate);

end


% ============================================================
% FINAL RESULT
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('         STAGE 10B - TEST COMPLETE\n');
fprintf('============================================================\n');