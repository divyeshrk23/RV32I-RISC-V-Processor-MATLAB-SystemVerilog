function instruction = instruction_memory(address)

% =========================================================
% STAGE 10A - RISC-V INSTRUCTION MEMORY
%
% Input:
%   address - byte address
%
% Output:
%   instruction - 32-bit machine-code instruction
%
% Instructions are stored at:
%
%   Address 0  -> Instruction 1
%   Address 4  -> Instruction 2
%   Address 8  -> Instruction 3
%   Address 12 -> Instruction 4
%
% =========================================================

% ---------------------------------------------------------
% Check address
% ---------------------------------------------------------

if address < 0
    error('Instruction memory address cannot be negative.');
end

if mod(address,4) ~= 0
    error('Instruction address must be aligned to 4 bytes.');
end


% ---------------------------------------------------------
% Convert byte address to instruction index
% ---------------------------------------------------------

index = floor(address / 4) + 1;


% ---------------------------------------------------------
% Instruction memory
%
% Program:
%
% ADD  x3,x1,x2
% SUB  x4,x3,x1
% AND  x5,x3,x4
% OR   x6,x3,x4
%
% ---------------------------------------------------------

memory = uint32([

encoder('ADD x3, x1, x2')
encoder('SUB x4, x3, x1')
encoder('AND x5, x3, x4')
encoder('OR x6, x3, x4')

]);


% ---------------------------------------------------------
% Check address range
% ---------------------------------------------------------

if index > length(memory)

    instruction = uint32(0);

else

    instruction = memory(index);

end

end