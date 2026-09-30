function result = hazard_control( ...
    idRs1, ...
    idRs2, ...
    exRd, ...
    exRegWrite, ...
    exMemoryRead, ...
    exMemoryOperation, ...
    exMemRd, ...
    exMemRegWrite, ...
    exMemResult, ...
    memWbRd, ...
    memWbRegWrite, ...
    memWbResult)

% =============================================================
% RISC-V PIPELINE
%
% STAGE 19.6
% FORWARDING + STALL INTEGRATION
%
% Combines:
%
%   19.1 RAW hazard detection
%   19.2 EX -> EX forwarding
%   19.3 MEM -> EX forwarding
%   19.4 Load-use hazard detection
%   19.5 Pipeline stall control
%
% =============================================================


% =============================================================
% INPUT CONVERSION
% =============================================================

idRs1 = double(idRs1);
idRs2 = double(idRs2);

exRd = double(exRd);

exRegWrite = logical(exRegWrite);
exMemoryRead = logical(exMemoryRead);

exMemoryOperation = upper(string(exMemoryOperation));


% =============================================================
% INITIALIZE RESULT
% =============================================================

result = struct();

result.forwarding = false;

result.rs1Forward = false;
result.rs2Forward = false;

result.rs1Source = "NONE";
result.rs2Source = "NONE";

result.rs1Value = uint32(0);
result.rs2Value = uint32(0);

result.loadUseHazard = false;
result.rs1LoadHazard = false;
result.rs2LoadHazard = false;

result.stall = false;

result.pcWrite = true;
result.ifIdWrite = true;
result.idExFlush = false;
result.insertBubble = false;


% =============================================================
% LOAD-USE HAZARD DETECTION
% =============================================================

loadHazard = load_use_hazard( ...
    idRs1, ...
    idRs2, ...
    exRd, ...
    exMemoryRead, ...
    exMemoryOperation);


result.loadUseHazard = loadHazard.hazard;
result.rs1LoadHazard = loadHazard.rs1Hazard;
result.rs2LoadHazard = loadHazard.rs2Hazard;


% =============================================================
% EX -> EX / MEM -> EX FORWARDING
% =============================================================

forward = mem_ex_forwarding( ...
    idRs1, ...
    idRs2, ...
    exMemRd, ...
    exMemRegWrite, ...
    exMemResult, ...
    memWbRd, ...
    memWbRegWrite, ...
    memWbResult);


result.forwarding = forward.forwarding;

result.rs1Forward = forward.rs1Forward;
result.rs2Forward = forward.rs2Forward;

result.rs1Source = forward.rs1Source;
result.rs2Source = forward.rs2Source;

result.rs1Value = forward.rs1Value;
result.rs2Value = forward.rs2Value;


% =============================================================
% STALL CONTROL
%
% A load-use hazard requires one bubble.
%
% Forwarding alone is not enough for this case.
% =============================================================

stallControl = pipeline_stall(loadHazard.hazard);


result.stall = stallControl.stall;

result.pcWrite = stallControl.pcWrite;
result.ifIdWrite = stallControl.ifIdWrite;

result.idExFlush = stallControl.idExFlush;

result.insertBubble = stallControl.insertBubble;


end