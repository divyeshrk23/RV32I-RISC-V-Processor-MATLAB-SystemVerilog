function nextRegister = id_ex_register( ...
    valid,pc,opcode,rs1Value,rs2Value,rd,immediate,funct3,funct7)

% =============================================================
% RISC-V PIPELINE
%
% STAGE 18.5
% ID/EX PIPELINE REGISTER
%
% Transfers decoded information:
%
% ID  ->  ID/EX  ->  EX
%
% =============================================================

if nargin < 9
    error('id_ex_register requires 9 inputs.');
end

nextRegister = struct();

% =============================================================
% VALID
% =============================================================

nextRegister.valid = logical(valid);

% =============================================================
% PROGRAM COUNTER
% =============================================================

nextRegister.pc = uint32(pc);

% =============================================================
% INSTRUCTION INFORMATION
% =============================================================

nextRegister.opcode = uint32(opcode);
nextRegister.funct3 = uint32(funct3);
nextRegister.funct7 = uint32(funct7);

% =============================================================
% REGISTER VALUES
% =============================================================

nextRegister.rs1Value = uint32(rs1Value);
nextRegister.rs2Value = uint32(rs2Value);

% =============================================================
% DESTINATION REGISTER
% =============================================================

nextRegister.rd = double(rd);

% =============================================================
% IMMEDIATE
% =============================================================

nextRegister.immediate = double(immediate);

end