function result = forwarding_unit( ...
    idExRs1, ...
    idExRs2, ...
    exMemRd, ...
    exMemRegWrite, ...
    exMemResult)

% =============================================================
% RISC-V PIPELINE
%
% STAGE 19.2
% EX -> EX FORWARDING
%
% Forward an ALU result from EX/MEM to the instruction
% currently entering EX.
% =============================================================

idExRs1 = double(idExRs1);
idExRs2 = double(idExRs2);
exMemRd = double(exMemRd);

exMemRegWrite = logical(exMemRegWrite);
exMemResult = uint32(exMemResult);

% -------------------------------------------------------------
% Validate registers
% -------------------------------------------------------------

if idExRs1 < 0 || idExRs1 > 31 || floor(idExRs1) ~= idExRs1
    error('Invalid ID/EX rs1 register: %d',idExRs1);
end

if idExRs2 < 0 || idExRs2 > 31 || floor(idExRs2) ~= idExRs2
    error('Invalid ID/EX rs2 register: %d',idExRs2);
end

if exMemRd < 0 || exMemRd > 31 || floor(exMemRd) ~= exMemRd
    error('Invalid EX/MEM rd register: %d',exMemRd);
end

% -------------------------------------------------------------
% Initialize
% -------------------------------------------------------------

result = struct();

result.rs1Forward = false;
result.rs2Forward = false;

result.rs1Value = uint32(0);
result.rs2Value = uint32(0);

result.forwardValue = exMemResult;

% -------------------------------------------------------------
% EX -> EX forwarding
% -------------------------------------------------------------

if exMemRegWrite && exMemRd ~= 0

    if idExRs1 ~= 0 && idExRs1 == exMemRd
        result.rs1Forward = true;
    end

    if idExRs2 ~= 0 && idExRs2 == exMemRd
        result.rs2Forward = true;
    end

end

% -------------------------------------------------------------
% Forwarded values
% -------------------------------------------------------------

if result.rs1Forward
    result.rs1Value = exMemResult;
end

if result.rs2Forward
    result.rs2Value = exMemResult;
end

result.forwarding = ...
    result.rs1Forward || result.rs2Forward;

end