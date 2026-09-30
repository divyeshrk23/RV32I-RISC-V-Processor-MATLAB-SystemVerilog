function result = branch_control( ...
    opcode, ...
    branchPc, ...
    rs1Value, ...
    rs2Value, ...
    immediate, ...
    loadUseHazard)

% =============================================================
% RISC-V PIPELINE
%
% STAGE 20.5
% BRANCH STALL / FLUSH INTEGRATION
%
% Combines:
%
%   Branch detection
%   Branch decision
%   Branch target calculation
%   Pipeline flush
%   Load-use stall interaction
%
% =============================================================


% =============================================================
% INPUT CONVERSION
% =============================================================

opcode = upper(string(opcode));

branchPc = uint32(branchPc);

rs1Value = uint32(rs1Value);
rs2Value = uint32(rs2Value);

immediate = double(immediate);

loadUseHazard = logical(loadUseHazard);


% =============================================================
% INITIALIZE RESULT
% =============================================================

result = struct();

result.isBranch = false;
result.branchType = "NONE";

result.taken = false;

result.targetPc = uint32(0);
result.nextPc = uint32(0);

result.redirect = false;

result.flush = false;
result.flushIF = false;
result.flushID = false;

result.stall = false;

result.pcWrite = true;
result.ifIdWrite = true;
result.idExFlush = false;


% =============================================================
% BRANCH DETECTION
% =============================================================

branch = branch_detection(opcode);

result.isBranch = branch.isBranch;
result.branchType = branch.branchType;


% =============================================================
% BRANCH DECISION
% =============================================================

if branch.isBranch

    decision = branch_decision( ...
        opcode, ...
        rs1Value, ...
        rs2Value);

    result.taken = decision.taken;

end


% =============================================================
% BRANCH TARGET
% =============================================================

if result.isBranch

    target = branch_target( ...
        branchPc, ...
        immediate, ...
        result.taken);

    result.targetPc = target.targetPc;
    result.nextPc = target.nextPc;
    result.redirect = target.redirect;

else

    result.nextPc = uint32( ...
        mod(double(branchPc) + 4,2^32));

end


% =============================================================
% PIPELINE FLUSH
% =============================================================

flush = branch_flush(result.taken);

result.flush = flush.flush;
result.flushIF = flush.flushIF;
result.flushID = flush.flushID;


% =============================================================
% LOAD-USE STALL
%
% A stall is required if the dependent instruction cannot
% proceed because of a load-use hazard.
% =============================================================

if loadUseHazard

    result.stall = true;

    result.pcWrite = false;
    result.ifIdWrite = false;
    result.idExFlush = true;

end


% =============================================================
% TAKEN BRANCH
%
% Taken branch redirects PC and flushes wrong-path instructions.
% =============================================================

if result.taken

    result.flush = true;
    result.flushIF = true;
    result.flushID = true;

    result.redirect = true;

    result.pcWrite = true;
    result.ifIdWrite = true;

    result.idExFlush = true;

end


end