function result = jump_control( ...
    opcode, ...
    pc, ...
    rs1Value, ...
    immediate)

% =============================================================
% RISC-V PIPELINE
%
% STAGE 20.6
% JUMP HANDLING
%
% Supported:
%
%   JAL
%   JALR
%
% JAL:
%
%   rd = PC + 4
%   PC = PC + immediate
%
% JALR:
%
%   rd = PC + 4
%   PC = (rs1 + immediate) & ~1
%
% =============================================================


% =============================================================
% INPUT CONVERSION
% =============================================================

opcode = upper(string(opcode));

pc = uint32(pc);
rs1Value = uint32(rs1Value);

immediate = double(immediate);


% =============================================================
% INITIALIZE RESULT
% =============================================================

result = struct();

result.isJump = false;

result.isJAL = false;
result.isJALR = false;

result.rdWrite = false;

result.returnAddress = uint32(0);

result.targetPc = uint32(0);
result.nextPc = uint32(0);

result.redirect = false;


% =============================================================
% JAL
% =============================================================

if opcode == "JAL"

    result.isJump = true;
    result.isJAL = true;

    % Return address
    result.returnAddress = uint32( ...
        mod(double(pc) + 4,2^32));

    % Jump target
    result.targetPc = uint32( ...
        mod(double(pc) + immediate,2^32));

    result.nextPc = result.targetPc;

    result.rdWrite = true;
    result.redirect = true;


% =============================================================
% JALR
% =============================================================

elseif opcode == "JALR"

    result.isJump = true;
    result.isJALR = true;

    % Return address
    result.returnAddress = uint32( ...
        mod(double(pc) + 4,2^32));

    % Calculate target
    rawTarget = mod( ...
        double(rs1Value) + immediate, ...
        2^32);

    % JALR clears bit 0
    rawTarget = bitand( ...
        uint32(rawTarget), ...
        uint32(hex2dec('FFFFFFFE')));

    result.targetPc = uint32(rawTarget);

    result.nextPc = result.targetPc;

    result.rdWrite = true;
    result.redirect = true;


% =============================================================
% NOT A JUMP
% =============================================================

else

    result.isJump = false;

    result.returnAddress = uint32(0);

    result.targetPc = uint32( ...
        mod(double(pc) + 4,2^32));

    result.nextPc = result.targetPc;

    result.rdWrite = false;
    result.redirect = false;

end


end