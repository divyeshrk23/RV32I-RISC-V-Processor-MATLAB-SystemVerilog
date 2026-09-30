function nextRegister = ex_mem_register( ...
    valid,pc,opcode,aluResult,storeData,rd, ...
    memoryRead,memoryWrite,memoryOperation)

% =============================================================
% RISC-V PIPELINE
%
% STAGE 18.7
% EX/MEM PIPELINE REGISTER
%
% Transfers information:
%
% EX -> EX/MEM -> MEM
%
% =============================================================

if nargin < 9
    error('ex_mem_register requires 9 inputs.');
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

% =============================================================
% ALU RESULT
% =============================================================

nextRegister.aluResult = uint32(aluResult);

% =============================================================
% STORE DATA
% =============================================================

nextRegister.storeData = uint32(storeData);

% =============================================================
% DESTINATION REGISTER
% =============================================================

nextRegister.rd = double(rd);

% =============================================================
% MEMORY CONTROL
% =============================================================

nextRegister.memoryRead = logical(memoryRead);

nextRegister.memoryWrite = logical(memoryWrite);

% =============================================================
% MEMORY OPERATION
% =============================================================

nextRegister.memoryOperation = string(memoryOperation);

end