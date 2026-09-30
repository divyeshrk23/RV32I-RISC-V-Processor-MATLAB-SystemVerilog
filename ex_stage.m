function result = ex_stage( ...
    opcode,funct3,funct7,rs1Value,rs2Value,immediate)

% =============================================================
% RISC-V PIPELINE
%
% STAGE 18.6
% EXECUTE (EX) STAGE
%
% Performs the ALU operation using values from ID/EX.
%
% Supported:
%   ADD
%   SUB
%   AND
%   OR
%   XOR
%   SLT
%   SLTU
%   ADDI
%   SLTI
%   SLTIU
%   SLLI
%   SRLI
%   SRAI
%
% =============================================================

if nargin < 6
    error('ex_stage requires 6 inputs.');
end

opcode = uint32(opcode);
funct3 = uint32(funct3);
funct7 = uint32(funct7);

rs1Value = uint32(rs1Value);
rs2Value = uint32(rs2Value);

immediate = double(immediate);

result = struct();

result.aluResult = uint32(0);
result.operation = "UNKNOWN";

% =============================================================
% R-TYPE
% =============================================================

if opcode == uint32(51)

    switch funct3

        case 0

            if funct7 == uint32(0)

                result.aluResult = uint32( ...
                    mod(double(rs1Value) + ...
                    double(rs2Value),2^32));

                result.operation = "ADD";

            elseif funct7 == uint32(32)

                result.aluResult = uint32( ...
                    mod(double(rs1Value) - ...
                    double(rs2Value),2^32));

                result.operation = "SUB";

            end


        case 2

            signedA = double(typecast(rs1Value,'int32'));
            signedB = double(typecast(rs2Value,'int32'));

            if signedA < signedB
                result.aluResult = uint32(1);
            else
                result.aluResult = uint32(0);
            end

            result.operation = "SLT";


        case 3

            if rs1Value < rs2Value
                result.aluResult = uint32(1);
            else
                result.aluResult = uint32(0);
            end

            result.operation = "SLTU";


        case 4

            result.aluResult = bitxor(rs1Value,rs2Value);
            result.operation = "XOR";


        case 6

            result.aluResult = bitor(rs1Value,rs2Value);
            result.operation = "OR";


        case 7

            result.aluResult = bitand(rs1Value,rs2Value);
            result.operation = "AND";

    end


% =============================================================
% I-TYPE ALU
% =============================================================

elseif opcode == uint32(19)

    switch funct3

        % ------------------------------------------------------
        % ADDI
        % ------------------------------------------------------

        case 0

            result.aluResult = uint32( ...
                mod(double(rs1Value) + immediate,2^32));

            result.operation = "ADDI";


        % ------------------------------------------------------
        % SLLI
        % ------------------------------------------------------

        case 1

            shamt = mod(immediate,32);

            result.aluResult = ...
                bitshift(rs1Value,shamt);

            result.operation = "SLLI";


        % ------------------------------------------------------
        % SLTI
        % ------------------------------------------------------

        case 2

            signedA = double(typecast(rs1Value,'int32'));

            if signedA < immediate
                result.aluResult = uint32(1);
            else
                result.aluResult = uint32(0);
            end

            result.operation = "SLTI";


        % ------------------------------------------------------
        % SLTIU
        % ------------------------------------------------------

        case 3

            unsignedImmediate = ...
                uint32(mod(immediate,2^32));

            if rs1Value < unsignedImmediate
                result.aluResult = uint32(1);
            else
                result.aluResult = uint32(0);
            end

            result.operation = "SLTIU";


        % ------------------------------------------------------
        % XORI
        % ------------------------------------------------------

        case 4

            unsignedImmediate = ...
                uint32(mod(immediate,2^32));

            result.aluResult = ...
                bitxor(rs1Value,unsignedImmediate);

            result.operation = "XORI";


        % ------------------------------------------------------
        % ORI
        % ------------------------------------------------------

        case 6

            unsignedImmediate = ...
                uint32(mod(immediate,2^32));

            result.aluResult = ...
                bitor(rs1Value,unsignedImmediate);

            result.operation = "ORI";


        % ------------------------------------------------------
        % ANDI
        % ------------------------------------------------------

        case 7

            unsignedImmediate = ...
                uint32(mod(immediate,2^32));

            result.aluResult = ...
                bitand(rs1Value,unsignedImmediate);

            result.operation = "ANDI";


        % ------------------------------------------------------
        % SRLI / SRAI
        % ------------------------------------------------------

        case 5

            shamt = mod(immediate,32);

            if funct7 == uint32(0)

                result.aluResult = ...
                    bitshift(rs1Value,-shamt);

                result.operation = "SRLI";

            elseif funct7 == uint32(32)

                signedValue = typecast(rs1Value,'int32');

                shiftedValue = ...
                    bitshift(signedValue,-shamt);

                result.aluResult = ...
                    typecast(shiftedValue,'uint32');

                result.operation = "SRAI";

            end

    end

end

end