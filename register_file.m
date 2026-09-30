function [readData1, readData2, registers] = register_file( ...
    rs1, rs2, rd, writeData, writeEnable, registers)

% =========================================================
% STAGE 10D - RISC-V REGISTER FILE
%
% 32 registers
% Each register = 32 bits
%
% x0 is permanently zero.
%
% INPUTS:
%
%   rs1        - first read register number
%   rs2        - second read register number
%   rd         - destination register number
%   writeData  - data to write
%   writeEnable - 1 = perform write
%   registers  - current register file
%
% OUTPUTS:
%
%   readData1  - value from rs1
%   readData2  - value from rs2
%   registers  - updated register file
%
% =========================================================


% ---------------------------------------------------------
% Initialize register file if not supplied
% ---------------------------------------------------------

if nargin < 6 || isempty(registers)

    registers = zeros(32,1,'uint32');

end


% ---------------------------------------------------------
% Check register numbers
% ---------------------------------------------------------

if rs1 < 0 || rs1 > 31 || floor(rs1) ~= rs1
    error('Invalid rs1 register: %d',rs1);
end

if rs2 < 0 || rs2 > 31 || floor(rs2) ~= rs2
    error('Invalid rs2 register: %d',rs2);
end

if rd < 0 || rd > 31 || floor(rd) ~= rd
    error('Invalid rd register: %d',rd);
end


% ---------------------------------------------------------
% REGISTER READ
%
% MATLAB uses index 1...32
% RISC-V uses x0...x31
%
% Therefore:
%
% x0 → MATLAB index 1
% x1 → MATLAB index 2
% ...
% x31 → MATLAB index 32
% ---------------------------------------------------------

readData1 = registers(rs1 + 1);
readData2 = registers(rs2 + 1);


% ---------------------------------------------------------
% REGISTER WRITE
% ---------------------------------------------------------

if writeEnable

    % x0 cannot be modified

    if rd ~= 0

        registers(rd + 1) = uint32(writeData);

    end

end


% ---------------------------------------------------------
% FORCE x0 = 0
% ---------------------------------------------------------

registers(1) = uint32(0);


% ---------------------------------------------------------
% Re-read values after write
% ---------------------------------------------------------

readData1 = registers(rs1 + 1);
readData2 = registers(rs2 + 1);

end