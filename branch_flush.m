function result = branch_flush(branchTaken)

% =============================================================
% RISC-V PIPELINE
%
% STAGE 20.4
% PIPELINE FLUSH
%
% When a branch is taken:
%
%   IF/ID -> FLUSH
%   ID/EX -> FLUSH
%
% When branch is not taken:
%
%   No flush
%
% =============================================================


% =============================================================
% INPUT
% =============================================================

branchTaken = logical(branchTaken);


% =============================================================
% INITIALIZE
% =============================================================

result = struct();

result.flush = false;

result.flushIF = false;
result.flushID = false;

result.pcRedirect = false;


% =============================================================
% TAKEN BRANCH
% =============================================================

if branchTaken

    result.flush = true;

    result.flushIF = true;
    result.flushID = true;

    result.pcRedirect = true;

end


end