function result = branch_decision(opcode, rs1Value, rs2Value)

% =============================================================
% RISC-V PIPELINE
%
% STAGE 20.2
% BRANCH DECISION
%
% Determines whether a conditional branch is taken.
%
% Supported:
%
%   BEQ
%   BNE
%   BLT
%   BGE
%   BLTU
%   BGEU
%
% Signed comparisons:
%   BLT
%   BGE
%
% Unsigned comparisons:
%   BLTU
%   BGEU
% =============================================================


% =============================================================
% INPUT CONVERSION
% =============================================================

opcode = upper(string(opcode));

rs1Value = uint32(rs1Value);
rs2Value = uint32(rs2Value);


% =============================================================
% INITIALIZE RESULT
% =============================================================

result = struct();

result.isBranch = false;
result.taken = false;
result.branchType = "NONE";


% =============================================================
% BRANCH DECISION
% =============================================================

switch opcode

    case "BEQ"

        result.isBranch = true;
        result.branchType = "BEQ";

        result.taken = (rs1Value == rs2Value);


    case "BNE"

        result.isBranch = true;
        result.branchType = "BNE";

        result.taken = (rs1Value ~= rs2Value);


    case "BLT"

        result.isBranch = true;
        result.branchType = "BLT";

        signedRs1 = typecast(rs1Value,'int32');
        signedRs2 = typecast(rs2Value,'int32');

        result.taken = (signedRs1 < signedRs2);


    case "BGE"

        result.isBranch = true;
        result.branchType = "BGE";

        signedRs1 = typecast(rs1Value,'int32');
        signedRs2 = typecast(rs2Value,'int32');

        result.taken = (signedRs1 >= signedRs2);


    case "BLTU"

        result.isBranch = true;
        result.branchType = "BLTU";

        result.taken = (rs1Value < rs2Value);


    case "BGEU"

        result.isBranch = true;
        result.branchType = "BGEU";

        result.taken = (rs1Value >= rs2Value);


    otherwise

        result.isBranch = false;
        result.taken = false;
        result.branchType = "NONE";

end


% =============================================================
% BRANCH NOT TAKEN FLAG
% =============================================================

result.notTaken = ...
    result.isBranch && ~result.taken;


end