clc;
clear;

fprintf('\n');
fprintf('============================================================\n');
fprintf('       STAGE 10A - INSTRUCTION MEMORY TEST\n');
fprintf('============================================================\n');


% ============================================================
% TEST ADDRESS 0
% ============================================================

address = 0;

instruction = instruction_memory(address);

fprintf('\nAddress      : %d\n',address);
fprintf('Machine code : 0x%08X\n',instruction);

decoded = decoder(instruction);

fprintf('Instruction  : %s\n',decoded.opcode);
fprintf('rd           : x%d\n',decoded.rd);
fprintf('rs1          : x%d\n',decoded.rs1);
fprintf('rs2          : x%d\n',decoded.rs2);


% ============================================================
% TEST ADDRESS 4
% ============================================================

address = 4;

instruction = instruction_memory(address);

fprintf('\nAddress      : %d\n',address);
fprintf('Machine code : 0x%08X\n',instruction);

decoded = decoder(instruction);

fprintf('Instruction  : %s\n',decoded.opcode);
fprintf('rd           : x%d\n',decoded.rd);
fprintf('rs1          : x%d\n',decoded.rs1);
fprintf('rs2          : x%d\n',decoded.rs2);


% ============================================================
% TEST ADDRESS 8
% ============================================================

address = 8;

instruction = instruction_memory(address);

fprintf('\nAddress      : %d\n',address);
fprintf('Machine code : 0x%08X\n',instruction);

decoded = decoder(instruction);

fprintf('Instruction  : %s\n',decoded.opcode);
fprintf('rd           : x%d\n',decoded.rd);
fprintf('rs1          : x%d\n',decoded.rs1);
fprintf('rs2          : x%d\n',decoded.rs2);


% ============================================================
% TEST ADDRESS 12
% ============================================================

address = 12;

instruction = instruction_memory(address);

fprintf('\nAddress      : %d\n',address);
fprintf('Machine code : 0x%08X\n',instruction);

decoded = decoder(instruction);

fprintf('Instruction  : %s\n',decoded.opcode);
fprintf('rd           : x%d\n',decoded.rd);
fprintf('rs1          : x%d\n',decoded.rs1);
fprintf('rs2          : x%d\n',decoded.rs2);


% ============================================================
% OUT-OF-RANGE TEST
% ============================================================

address = 16;

instruction = instruction_memory(address);

fprintf('\nAddress      : %d\n',address);
fprintf('Machine code : 0x%08X\n',instruction);

if instruction == uint32(0)

    fprintf('Result       : OUT OF PROGRAM MEMORY\n');

else

    fprintf('Result       : ERROR\n');

end


fprintf('\n');
fprintf('============================================================\n');
fprintf('        STAGE 10A - TEST COMPLETE\n');
fprintf('============================================================\n');