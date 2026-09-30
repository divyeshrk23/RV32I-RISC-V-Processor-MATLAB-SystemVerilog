function result = hazard_detection( ...
    idRs1, ...
    idRs2, ...
    exRd, ...
    exRegWrite, ...
    memRd, ...
    memRegWrite)

% =============================================================
% RISC-V PIPELINE
%
% STAGE 19.1
% RAW HAZARD DETECTION
%
% Detects:
%
%       ID instruction reads a register
%       while an earlier instruction will write that register.
%
% RAW = Read After Write
%
% No forwarding is performed here.
% No stall is performed here.
%
% This stage ONLY detects the hazard.
% =============================================================


% =============================================================
% INPUT CONVERSION
% =============================================================

idRs1 = double(idRs1);
idRs2 = double(idRs2);

exRd = double(exRd);
memRd = double(memRd);

exRegWrite = logical(exRegWrite);
memRegWrite = logical(memRegWrite);


% =============================================================
% REGISTER VALIDATION
% =============================================================

if idRs1 < 0 || idRs1 > 31 || floor(idRs1) ~= idRs1
    error('Invalid ID rs1 register: %d',idRs1);
end

if idRs2 < 0 || idRs2 > 31 || floor(idRs2) ~= idRs2
    error('Invalid ID rs2 register: %d',idRs2);
end

if exRd < 0 || exRd > 31 || floor(exRd) ~= exRd
    error('Invalid EX rd register: %d',exRd);
end

if memRd < 0 || memRd > 31 || floor(memRd) ~= memRd
    error('Invalid MEM rd register: %d',memRd);
end


% =============================================================
% INITIALIZE RESULT
% =============================================================

result = struct();

result.hazard = false;

result.rs1Hazard = false;
result.rs2Hazard = false;

result.exHazard = false;
result.memHazard = false;

result.idRs1 = idRs1;
result.idRs2 = idRs2;

result.exRd = exRd;
result.memRd = memRd;


% =============================================================
% EX → ID RAW HAZARD
% =============================================================

if exRegWrite && exRd ~= 0

    if idRs1 ~= 0 && idRs1 == exRd

        result.rs1Hazard = true;
        result.exHazard = true;

    end

    if idRs2 ~= 0 && idRs2 == exRd

        result.rs2Hazard = true;
        result.exHazard = true;

    end

end


% =============================================================
% MEM → ID RAW HAZARD
% =============================================================

if memRegWrite && memRd ~= 0

    if idRs1 ~= 0 && idRs1 == memRd

        result.rs1Hazard = true;
        result.memHazard = true;

    end

    if idRs2 ~= 0 && idRs2 == memRd

        result.rs2Hazard = true;
        result.memHazard = true;

    end

end


% =============================================================
% FINAL HAZARD FLAG
% =============================================================

result.hazard = ...
    result.rs1Hazard || result.rs2Hazard;


% =============================================================
% CONTROL INFORMATION
% =============================================================

result.stall = result.hazard;

result.forwardRequired = result.hazard;


end