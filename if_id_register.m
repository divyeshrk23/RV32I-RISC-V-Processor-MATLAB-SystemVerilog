function nextRegister = if_id_register( ...
    instruction,pc,pcNext,valid)

% =============================================================
% RISC-V PIPELINE
%
% STAGE 18.3
% IF/ID PIPELINE REGISTER
% =============================================================

if nargin < 4
    valid = true;
end

nextRegister = struct();

% =============================================================
% REGISTER VALID
% =============================================================

nextRegister.valid = logical(valid);

% =============================================================
% PROGRAM COUNTER
% =============================================================

nextRegister.pc = uint32(pc);

% =============================================================
% FETCHED INSTRUCTION
% =============================================================

nextRegister.instruction = uint32(instruction);

% =============================================================
% NEXT PROGRAM COUNTER
% =============================================================

nextRegister.pcNext = uint32(pcNext);

end