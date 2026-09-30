function [instruction,pcNext] = if_stage(pc,instructionMemory)

% =============================================================
% RISC-V PIPELINE
%
% STAGE 18.2
% INSTRUCTION FETCH (IF)
%
% Inputs:
%   pc                 Current program counter
%   instructionMemory  Program memory
%
% Outputs:
%   instruction        Fetched instruction
%   pcNext             Next sequential PC
%
% =============================================================


% =============================================================
% INPUT VALIDATION
% =============================================================

if nargin < 2

    error('if_stage requires PC and instruction memory.');

end


% =============================================================
% DEFAULT INSTRUCTION
% =============================================================

instruction = uint32(0);


% =============================================================
% CALCULATE MEMORY INDEX
% =============================================================

index = double(pc) / 4 + 1;


% =============================================================
% FETCH INSTRUCTION
% =============================================================

if index >= 1 && index <= length(instructionMemory)

    instruction = uint32(instructionMemory(index));

end


% =============================================================
% NEXT PC
% =============================================================

pcNext = uint32(mod( ...
    double(pc) + 4, ...
    2^32));


end