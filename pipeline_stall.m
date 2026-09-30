function result = pipeline_stall(hazard)

% =============================================================
% RISC-V PIPELINE
%
% STAGE 19.5
% PIPELINE STALL CONTROL
%
% When a hazard is detected:
%
%       PC       = HOLD
%       IF/ID    = HOLD
%       ID/EX    = NOP
%
% This inserts one pipeline bubble.
% =============================================================

hazard = logical(hazard);

result = struct();

% -------------------------------------------------------------
% Default control signals
% -------------------------------------------------------------

result.stall = false;

result.pcWrite = true;
result.ifIdWrite = true;
result.idExFlush = false;

result.insertBubble = false;


% -------------------------------------------------------------
% Hazard detected
% -------------------------------------------------------------

if hazard

    % Hold program counter
    result.pcWrite = false;

    % Hold IF/ID pipeline register
    result.ifIdWrite = false;

    % Flush ID/EX control
    result.idExFlush = true;

    % Insert bubble
    result.insertBubble = true;

    result.stall = true;

end


end