function result = mem_stage( ...
    opcode, ...
    aluResult, ...
    storeData, ...
    memoryRead, ...
    memoryWrite, ...
    memoryOperation, ...
    memory)

% =============================================================
% RISC-V PIPELINE
%
% STAGE 18.8
% MEMORY (MEM) STAGE
%
% Supported:
%   LB
%   LBU
%   LH
%   LHU
%   LW
%   SB
%   SH
%   SW
%
% Memory format:
%   Byte-addressable
%   Little-endian
%
% This stage is intentionally independent of data_memory.m.
% =============================================================

if nargin < 7
    error('mem_stage requires 7 inputs.');
end

% =============================================================
% INPUT CONVERSION
% =============================================================

opcode = uint32(opcode);
aluResult = uint32(aluResult);
storeData = uint32(storeData);

memoryRead = logical(memoryRead);
memoryWrite = logical(memoryWrite);

memoryOperation = upper(string(memoryOperation));

% =============================================================
% CHECK MEMORY
% =============================================================

if isempty(memory)
    memory = zeros(1024,1,'uint8');
end

if ~isa(memory,'uint8')
    memory = uint8(memory);
end

% =============================================================
% OUTPUT STRUCTURE
% =============================================================

result = struct();

result.aluResult = aluResult;
result.memoryData = uint32(0);
result.storeData = storeData;

result.memoryRead = memoryRead;
result.memoryWrite = memoryWrite;

result.memoryOperation = memoryOperation;

result.memory = memory;


% =============================================================
% MEMORY READ
% =============================================================

if memoryRead

    address = double(aluResult);

    % ---------------------------------------------------------
    % ADDRESS CHECK
    % ---------------------------------------------------------

    if address < 0 || address >= length(memory)

        error('Memory read address out of range: %d',address);

    end


    switch memoryOperation

        % =====================================================
        % LB
        % =====================================================

        case "LB"

            if address + 1 > length(memory)
                error('LB address out of range.');
            end

            value = uint32(memory(address + 1));

            if value >= 128

                result.memoryData = ...
                    typecast(int32(double(value) - 256),'uint32');

            else

                result.memoryData = value;

            end


        % =====================================================
        % LBU
        % =====================================================

        case "LBU"

            result.memoryData = ...
                uint32(memory(address + 1));


        % =====================================================
        % LH
        % =====================================================

        case "LH"

            if mod(address,2) ~= 0
                error('LH requires a 2-byte aligned address.');
            end

            if address + 2 > length(memory)
                error('LH address out of range.');
            end

            b0 = uint32(memory(address + 1));
            b1 = uint32(memory(address + 2));

            value = b0 + bitshift(b1,8);

            if value >= 32768

                result.memoryData = ...
                    typecast(int32(double(value) - 65536),'uint32');

            else

                result.memoryData = uint32(value);

            end


        % =====================================================
        % LHU
        % =====================================================

        case "LHU"

            if mod(address,2) ~= 0
                error('LHU requires a 2-byte aligned address.');
            end

            if address + 2 > length(memory)
                error('LHU address out of range.');
            end

            b0 = uint32(memory(address + 1));
            b1 = uint32(memory(address + 2));

            result.memoryData = ...
                uint32(b0 + bitshift(b1,8));


        % =====================================================
        % LW
        % =====================================================

        case "LW"

            if mod(address,4) ~= 0
                error('LW requires a 4-byte aligned address.');
            end

            if address + 4 > length(memory)
                error('LW address out of range.');
            end

            b0 = uint32(memory(address + 1));
            b1 = uint32(memory(address + 2));
            b2 = uint32(memory(address + 3));
            b3 = uint32(memory(address + 4));

            result.memoryData = ...
                b0 + ...
                bitshift(b1,8) + ...
                bitshift(b2,16) + ...
                bitshift(b3,24);


        % =====================================================
        % UNKNOWN READ
        % =====================================================

        otherwise

            error('Unknown memory read operation: %s', ...
                memoryOperation);

    end

end


% =============================================================
% MEMORY WRITE
% =============================================================

if memoryWrite

    address = double(aluResult);

    % ---------------------------------------------------------
    % ADDRESS CHECK
    % ---------------------------------------------------------

    if address < 0 || address >= length(memory)

        error('Memory write address out of range: %d',address);

    end


    switch memoryOperation

        % =====================================================
        % SB
        % =====================================================

        case "SB"

            if address + 1 > length(memory)
                error('SB address out of range.');
            end

            memory(address + 1) = ...
                uint8(bitand(storeData,uint32(255)));


        % =====================================================
        % SH
        % =====================================================

        case "SH"

            if mod(address,2) ~= 0
                error('SH requires a 2-byte aligned address.');
            end

            if address + 2 > length(memory)
                error('SH address out of range.');
            end

            memory(address + 1) = ...
                uint8(bitand(storeData,uint32(255)));

            memory(address + 2) = ...
                uint8(bitand( ...
                    bitshift(storeData,-8), ...
                    uint32(255)));


        % =====================================================
        % SW
        % =====================================================

        case "SW"

            if mod(address,4) ~= 0
                error('SW requires a 4-byte aligned address.');
            end

            if address + 4 > length(memory)
                error('SW address out of range.');
            end

            memory(address + 1) = ...
                uint8(bitand(storeData,uint32(255)));

            memory(address + 2) = ...
                uint8(bitand( ...
                    bitshift(storeData,-8), ...
                    uint32(255)));

            memory(address + 3) = ...
                uint8(bitand( ...
                    bitshift(storeData,-16), ...
                    uint32(255)));

            memory(address + 4) = ...
                uint8(bitand( ...
                    bitshift(storeData,-24), ...
                    uint32(255)));


        % =====================================================
        % UNKNOWN WRITE
        % =====================================================

        otherwise

            error('Unknown memory write operation: %s', ...
                memoryOperation);

    end

end


% =============================================================
% RETURN UPDATED MEMORY
% =============================================================

result.memory = memory;

end