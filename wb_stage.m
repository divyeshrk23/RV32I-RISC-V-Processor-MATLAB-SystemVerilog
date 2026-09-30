function result = wb_stage( ...
    valid, ...
    opcode, ...
    aluResult, ...
    memoryData, ...
    rd, ...
    memoryToReg, ...
    regWrite, ...
    registers)

% =============================================================
% RISC-V PIPELINE
%
% STAGE 18.10
% WRITE-BACK (WB) STAGE
%
% MEM/WB
%    |
%    |-- ALU result
%    |
%    |-- Memory data
%    |
%    v
% Write-back MUX
%    |
%    v
% Register File
%
% =============================================================

if nargin < 8
    error('wb_stage requires 8 inputs.');
end


% =============================================================
% INPUT CONVERSION
% =============================================================

valid = logical(valid);

opcode = string(opcode);

aluResult = uint32(aluResult);

memoryData = uint32(memoryData);

memoryToReg = logical(memoryToReg);

regWrite = logical(regWrite);


% =============================================================
% REGISTER FILE INITIALIZATION
% =============================================================

if nargin < 9 || isempty(registers)

    registers = zeros(32,1,'uint32');

end


if length(registers) ~= 32

    error('Register file must contain exactly 32 registers.');

end


if ~isa(registers,'uint32')

    registers = uint32(registers);

end


% =============================================================
% RD VALIDATION
% =============================================================

if rd < 0 || rd > 31 || floor(rd) ~= rd

    error('Invalid destination register: %d',rd);

end


% =============================================================
% OUTPUT STRUCTURE
% =============================================================

result = struct();

result.valid = valid;

result.opcode = opcode;

result.aluResult = aluResult;

result.memoryData = memoryData;

result.rd = rd;

result.memoryToReg = memoryToReg;

result.regWrite = regWrite;

result.writeData = uint32(0);

result.writePerformed = false;

result.registers = registers;


% =============================================================
% INVALID PIPELINE ENTRY
% =============================================================

if ~valid

    result.writeData = uint32(0);

    result.writePerformed = false;

    result.registers(1) = uint32(0);

    return;

end


% =============================================================
% WRITE-BACK MUX
%
% memoryToReg = 0
%       ALU result
%
% memoryToReg = 1
%       Memory data
% =============================================================

if memoryToReg

    writeData = memoryData;

else

    writeData = aluResult;

end


result.writeData = uint32(writeData);


% =============================================================
% REGISTER WRITE
% =============================================================

if regWrite

    % ---------------------------------------------------------
    % x0 MUST ALWAYS REMAIN ZERO
    % ---------------------------------------------------------

    if rd ~= 0

        result.registers(rd + 1) = uint32(writeData);

        result.writePerformed = true;

    else

        % Write attempt to x0 is ignored

        result.writePerformed = false;

    end

end


% =============================================================
% FORCE x0 TO ZERO
% =============================================================

result.registers(1) = uint32(0);


end