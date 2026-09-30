function result = branch_target(branchPc, immediate, taken)

% =============================================================
% RISC-V PIPELINE
%
% STAGE 20.3
% BRANCH TARGET / PC REDIRECTION
%
% Branch target:
%
%       target = branch PC + branch immediate
%
% If the branch is not taken:
%
%       next PC = branch PC + 4
%
% =============================================================


% =============================================================
% INPUT CONVERSION
% =============================================================

branchPc = uint32(branchPc);
immediate = double(immediate);
taken = logical(taken);


% =============================================================
% INITIALIZE RESULT
% =============================================================

result = struct();

result.branchPc = branchPc;
result.immediate = immediate;
result.taken = taken;

result.targetPc = uint32(0);
result.nextPc = uint32(0);

result.redirect = false;


% =============================================================
% BRANCH TAKEN
% =============================================================

if taken

    target = mod(double(branchPc) + immediate,2^32);

    result.targetPc = uint32(target);
    result.nextPc = uint32(target);

    result.redirect = true;


    % =============================================================
    % BRANCH NOT TAKEN
    % =============================================================

else

    next = mod(double(branchPc) + 4,2^32);

    result.targetPc = uint32(next);
    result.nextPc = uint32(next);

    result.redirect = false;

end


end