function [pc, instruction, decoded] = cpu_fetch(pc, memory)

% =========================================================
% STAGE 10C - RISC-V PROGRAM COUNTER + INSTRUCTION FETCH
%
% INPUT:
%   pc     - current program counter
%   memory - instruction memory
%
% OUTPUT:
%   pc         - next program counter
%   instruction - fetched 32-bit instruction
%   decoded    - decoded instruction structure
%
% Operation:
%
%   current PC
%       ↓
%   instruction memory
%       ↓
%   instruction
%       ↓
%   decoder
%       ↓
%   PC + 4
%
% =========================================================


% ---------------------------------------------------------
% Validate PC
% ---------------------------------------------------------

if pc < 0

    error('PC cannot be negative.');

end


if mod(pc,4) ~= 0

    error('PC must be aligned to 4 bytes.');

end


% ---------------------------------------------------------
% Convert byte address to memory index
% ---------------------------------------------------------

index = floor(pc / 4) + 1;


% ---------------------------------------------------------
% Check whether PC is inside program
% ---------------------------------------------------------

if index > length(memory)

    instruction = uint32(0);

    decoded.opcode = "END";
    decoded.rd = 0;
    decoded.rs1 = 0;
    decoded.rs2 = 0;
    decoded.immediate = 0;

    return;

end


% ---------------------------------------------------------
% FETCH
% ---------------------------------------------------------

instruction = memory(index);


% ---------------------------------------------------------
% DECODE
% ---------------------------------------------------------

decoded = decoder(instruction);


% ---------------------------------------------------------
% PC UPDATE
%
% RV32I normal sequential execution:
%
% PC = PC + 4
%
% Branches and jumps will modify PC later.
% ---------------------------------------------------------

pc = pc + 4;

end