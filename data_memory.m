function [readData, memory] = data_memory( ...
    address, writeData, readEnable, writeEnable, operation, memory)

% =========================================================
% RISC-V DATA MEMORY
% STAGE 11C
%
% Supported:
%
%   LB
%   LBU
%   LH
%   LHU
%   LW
%   SB
%   SH
%   SW
%
% Memory:
%
%   Byte addressable
%   Little endian
%
% =========================================================


% ---------------------------------------------------------
% Initialize memory
% ---------------------------------------------------------

if nargin < 6 || isempty(memory)

    memory = zeros(1024,1,'uint8');

end


% ---------------------------------------------------------
% Default operation
% ---------------------------------------------------------

if nargin < 5 || isempty(operation)

    operation = 'LW';

end


operation = upper(char(operation));


% ---------------------------------------------------------
% Default read data
% ---------------------------------------------------------

readData = uint32(0);


% ---------------------------------------------------------
% Address validation
% ---------------------------------------------------------

if address < 0

    error('Memory address cannot be negative.');

end


address = uint32(address);


% =========================================================
% STORE OPERATIONS
% =========================================================

if writeEnable

    data = uint32(writeData);


    switch operation


        % -------------------------------------------------
        % SB - STORE BYTE
        % -------------------------------------------------

        case 'SB'

            if double(address) >= length(memory)

                error('SB address is outside data memory.');

            end


            byte0 = uint8( ...
                bitand(data,uint32(255)));


            memory(double(address)+1) = byte0;


        % -------------------------------------------------
        % SH - STORE HALFWORD
        % -------------------------------------------------

        case 'SH'

            if double(address)+1 >= length(memory)

                error('SH address is outside data memory.');

            end


            if mod(double(address),2) ~= 0

                error('SH address must be halfword aligned.');

            end


            byte0 = uint8( ...
                bitand(data,uint32(255)));


            byte1 = uint8( ...
                bitand( ...
                bitshift(data,-8), ...
                uint32(255)));


            memory(double(address)+1) = byte0;
            memory(double(address)+2) = byte1;


        % -------------------------------------------------
        % SW - STORE WORD
        % -------------------------------------------------

        case 'SW'

            if double(address)+3 >= length(memory)

                error('SW address is outside data memory.');

            end


            if mod(double(address),4) ~= 0

                error('SW address must be word aligned.');

            end


            byte0 = uint8( ...
                bitand(data,uint32(255)));


            byte1 = uint8( ...
                bitand( ...
                bitshift(data,-8), ...
                uint32(255)));


            byte2 = uint8( ...
                bitand( ...
                bitshift(data,-16), ...
                uint32(255)));


            byte3 = uint8( ...
                bitand( ...
                bitshift(data,-24), ...
                uint32(255)));


            memory(double(address)+1) = byte0;
            memory(double(address)+2) = byte1;
            memory(double(address)+3) = byte2;
            memory(double(address)+4) = byte3;


        otherwise

            error( ...
                'Unsupported store operation: %s', ...
                operation);

    end

end


% =========================================================
% LOAD OPERATIONS
% =========================================================

if readEnable

    switch operation


        % -------------------------------------------------
        % LB - LOAD BYTE SIGNED
        % -------------------------------------------------

        case 'LB'

            if double(address) >= length(memory)

                error('LB address is outside data memory.');

            end


            byte0 = uint8( ...
                memory(double(address)+1));


            if byte0 >= 128

                signedValue = int32(byte0) - 256;

            else

                signedValue = int32(byte0);

            end


            readData = typecast( ...
                int32(signedValue), ...
                'uint32');


        % -------------------------------------------------
        % LBU - LOAD BYTE UNSIGNED
        % -------------------------------------------------

        case 'LBU'

            if double(address) >= length(memory)

                error('LBU address is outside data memory.');

            end


            readData = uint32( ...
                memory(double(address)+1));


        % -------------------------------------------------
        % LH - LOAD HALFWORD SIGNED
        % -------------------------------------------------

        case 'LH'

            if double(address)+1 >= length(memory)

                error('LH address is outside data memory.');

            end


            if mod(double(address),2) ~= 0

                error('LH address must be halfword aligned.');

            end


            byte0 = uint32( ...
                memory(double(address)+1));


            byte1 = uint32( ...
                memory(double(address)+2));


            halfword = bitor( ...
                byte0, ...
                bitshift(byte1,8));


            if halfword >= uint32(32768)

                signedValue = int32(halfword) - int32(65536);

                readData = typecast( ...
                    signedValue, ...
                    'uint32');

            else

                readData = halfword;

            end


        % -------------------------------------------------
        % LHU - LOAD HALFWORD UNSIGNED
        % -------------------------------------------------

        case 'LHU'

            if double(address)+1 >= length(memory)

                error('LHU address is outside data memory.');

            end


            if mod(double(address),2) ~= 0

                error('LHU address must be halfword aligned.');

            end


            byte0 = uint32( ...
                memory(double(address)+1));


            byte1 = uint32( ...
                memory(double(address)+2));


            readData = bitor( ...
                byte0, ...
                bitshift(byte1,8));


        % -------------------------------------------------
        % LW - LOAD WORD
        % -------------------------------------------------

        case 'LW'

            if double(address)+3 >= length(memory)

                error('LW address is outside data memory.');

            end


            if mod(double(address),4) ~= 0

                error('LW address must be word aligned.');

            end


            byte0 = uint32( ...
                memory(double(address)+1));


            byte1 = uint32( ...
                memory(double(address)+2));


            byte2 = uint32( ...
                memory(double(address)+3));


            byte3 = uint32( ...
                memory(double(address)+4));


            readData = bitor( ...
                byte0, ...
                bitshift(byte1,8));


            readData = bitor( ...
                readData, ...
                bitshift(byte2,16));


            readData = bitor( ...
                readData, ...
                bitshift(byte3,24));


        otherwise

            error( ...
                'Unsupported load operation: %s', ...
                operation);

    end

end


% ---------------------------------------------------------
% Force uint32
% ---------------------------------------------------------

readData = uint32(readData);

end