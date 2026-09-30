function result = mem_ex_forwarding( ...
    idExRs1, ...
    idExRs2, ...
    exMemRd, ...
    exMemRegWrite, ...
    exMemResult, ...
    memWbRd, ...
    memWbRegWrite, ...
    memWbResult)

% =============================================================
% RISC-V PIPELINE
%
% STAGE 19.3
% MEM -> EX FORWARDING
%
% Forwarding paths:
%
%       EX/MEM  -> EX
%       MEM/WB  -> EX
%
% EX/MEM has priority because it contains the newer result.
% =============================================================


% =============================================================
% INPUT CONVERSION
% =============================================================

idExRs1 = double(idExRs1);
idExRs2 = double(idExRs2);

exMemRd = double(exMemRd);
memWbRd = double(memWbRd);

exMemRegWrite = logical(exMemRegWrite);
memWbRegWrite = logical(memWbRegWrite);

exMemResult = uint32(exMemResult);
memWbResult = uint32(memWbResult);


% =============================================================
% REGISTER VALIDATION
% =============================================================

if idExRs1 < 0 || idExRs1 > 31 || floor(idExRs1) ~= idExRs1
    error('Invalid ID/EX rs1 register: %d',idExRs1);
end

if idExRs2 < 0 || idExRs2 > 31 || floor(idExRs2) ~= idExRs2
    error('Invalid ID/EX rs2 register: %d',idExRs2);
end

if exMemRd < 0 || exMemRd > 31 || floor(exMemRd) ~= exMemRd
    error('Invalid EX/MEM rd register: %d',exMemRd);
end

if memWbRd < 0 || memWbRd > 31 || floor(memWbRd) ~= memWbRd
    error('Invalid MEM/WB rd register: %d',memWbRd);
end


% =============================================================
% INITIALIZE RESULT
% =============================================================

result = struct();

result.rs1Forward = false;
result.rs2Forward = false;

result.rs1Source = "NONE";
result.rs2Source = "NONE";

result.rs1Value = uint32(0);
result.rs2Value = uint32(0);

result.forwarding = false;


% =============================================================
% RS1 FORWARDING
%
% EX/MEM has priority over MEM/WB.
% =============================================================

if idExRs1 ~= 0

    if exMemRegWrite && ...
            exMemRd ~= 0 && ...
            idExRs1 == exMemRd

        result.rs1Forward = true;
        result.rs1Source = "EX/MEM";
        result.rs1Value = exMemResult;

    elseif memWbRegWrite && ...
            memWbRd ~= 0 && ...
            idExRs1 == memWbRd

        result.rs1Forward = true;
        result.rs1Source = "MEM/WB";
        result.rs1Value = memWbResult;

    end

end


% =============================================================
% RS2 FORWARDING
% =============================================================

if idExRs2 ~= 0

    if exMemRegWrite && ...
            exMemRd ~= 0 && ...
            idExRs2 == exMemRd

        result.rs2Forward = true;
        result.rs2Source = "EX/MEM";
        result.rs2Value = exMemResult;

    elseif memWbRegWrite && ...
            memWbRd ~= 0 && ...
            idExRs2 == memWbRd

        result.rs2Forward = true;
        result.rs2Source = "MEM/WB";
        result.rs2Value = memWbResult;

    end

end


% =============================================================
% OVERALL FORWARDING FLAG
% =============================================================

result.forwarding = ...
    result.rs1Forward || result.rs2Forward;


end