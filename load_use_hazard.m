function result = load_use_hazard( ...
    idRs1, ...
    idRs2, ...
    exRd, ...
    exMemoryRead, ...
    exMemoryOperation)

% =============================================================
% RISC-V PIPELINE
%
% STAGE 19.4
% LOAD-USE HAZARD DETECTION
%
% Detects:
%
%       LW  x1, 0(x2)
%       ADD x3, x1, x4
%
% The instruction in ID needs a value that is currently
% being loaded by the instruction in EX.
%
% This hazard requires a pipeline stall.
% =============================================================


% =============================================================
% INPUT CONVERSION
% =============================================================

idRs1 = double(idRs1);
idRs2 = double(idRs2);
exRd = double(exRd);

exMemoryRead = logical(exMemoryRead);
exMemoryOperation = upper(string(exMemoryOperation));


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


% =============================================================
% INITIALIZE RESULT
% =============================================================

result = struct();

result.hazard = false;
result.rs1Hazard = false;
result.rs2Hazard = false;

result.stall = false;

result.idRs1 = idRs1;
result.idRs2 = idRs2;

result.exRd = exRd;
result.exMemoryRead = exMemoryRead;
result.exMemoryOperation = exMemoryOperation;


% =============================================================
% LOAD-USE HAZARD
%
% Only a memory read creates this specific hazard.
%
% x0 is excluded because x0 always contains zero.
% =============================================================

if exMemoryRead && exRd ~= 0

    % ---------------------------------------------------------
    % RS1 dependency
    % ---------------------------------------------------------

    if idRs1 ~= 0 && idRs1 == exRd

        result.rs1Hazard = true;

    end


    % ---------------------------------------------------------
    % RS2 dependency
    % ---------------------------------------------------------

    if idRs2 ~= 0 && idRs2 == exRd

        result.rs2Hazard = true;

    end

end


% =============================================================
% FINAL HAZARD FLAG
% =============================================================

result.hazard = ...
    result.rs1Hazard || result.rs2Hazard;


% =============================================================
% LOAD-USE HAZARD REQUIRES STALL
% =============================================================

result.stall = result.hazard;


end