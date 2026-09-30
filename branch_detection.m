function result = branch_detection(opcode)

% =============================================================
% RISC-V PIPELINE
%
% STAGE 20.1
% BRANCH DETECTION
%
% Detects conditional branch instructions:
%
%   BEQ
%   BNE
%   BLT
%   BGE
%   BLTU
%   BGEU
%
% This stage ONLY identifies the branch.
%
% No branch decision is made here.
% No PC update is performed here.
% No pipeline flush is performed here.
% =============================================================


% =============================================================
% INPUT
% =============================================================

opcode = upper(string(opcode));


% =============================================================
% INITIALIZE RESULT
% =============================================================

result = struct();

result.isBranch = false;

result.branchType = "NONE";

result.isBEQ  = false;
result.isBNE  = false;
result.isBLT  = false;
result.isBGE  = false;
result.isBLTU = false;
result.isBGEU = false;


% =============================================================
% BRANCH DETECTION
% =============================================================

switch opcode

    case "BEQ"

        result.isBranch = true;
        result.branchType = "BEQ";
        result.isBEQ = true;


    case "BNE"

        result.isBranch = true;
        result.branchType = "BNE";
        result.isBNE = true;


    case "BLT"

        result.isBranch = true;
        result.branchType = "BLT";
        result.isBLT = true;


    case "BGE"

        result.isBranch = true;
        result.branchType = "BGE";
        result.isBGE = true;


    case "BLTU"

        result.isBranch = true;
        result.branchType = "BLTU";
        result.isBLTU = true;


    case "BGEU"

        result.isBranch = true;
        result.branchType = "BGEU";
        result.isBGEU = true;


    otherwise

        result.isBranch = false;
        result.branchType = "NONE";

end


end