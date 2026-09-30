function result = alu_execute(decoded, readData1, readData2)

% =========================================================
% STAGE 10E - ALU EXECUTION UNIT
%
% Executes decoded RV32I ALU instructions.
%
% Supported:
%
%   ADD
%   SUB
%   AND
%   OR
%   XOR
%   ADDI
%
% INPUT:
%
%   decoded   - output from decoder.m
%   readData1 - value from rs1
%   readData2 - value from rs2
%
% OUTPUT:
%
%   result    - 32-bit ALU result
%
% =========================================================


% ---------------------------------------------------------
% Convert inputs to uint32
% ---------------------------------------------------------

readData1 = uint32(readData1);
readData2 = uint32(readData2);


% ---------------------------------------------------------
% Select ALU operation
% ---------------------------------------------------------

switch upper(char(decoded.opcode))

    % -----------------------------------------------------
    % R-TYPE
    % -----------------------------------------------------

    case 'ADD'

        result = alu('ADD',readData1,readData2);


    case 'SUB'

        result = alu('SUB',readData1,readData2);


    case 'AND'

        result = alu('AND',readData1,readData2);


    case 'OR'

        result = alu('OR',readData1,readData2);


    case 'XOR'

        result = alu('XOR',readData1,readData2);


    % -----------------------------------------------------
    % I-TYPE
    % -----------------------------------------------------

    case 'ADDI'

        immediate = int32(decoded.immediate);

        result = alu( ...
            'ADD', ...
            readData1, ...
            uint32(immediate));


    % -----------------------------------------------------
    % Unsupported instruction
    % -----------------------------------------------------

    otherwise

        error( ...
            'ALU execution does not support instruction: %s', ...
            decoded.opcode);

end


% ---------------------------------------------------------
% Ensure 32-bit result
% ---------------------------------------------------------

result = uint32(result);

end