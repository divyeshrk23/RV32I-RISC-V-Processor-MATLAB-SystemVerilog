function memory = program_loader(program)

% ============================================================
% ROBUST RISC-V PROGRAM LOADER
%
% Input:
%   program - cell array containing assembly instructions
%
% Output:
%   memory  - uint32 machine-code instruction memory
%
% Supported:
%   - Blank lines
%   - MATLAB comments using %
%   - Extra spaces
%   - Empty entries
%   - Normal assembly instructions
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('              RISC-V PROGRAM LOADER\n');
fprintf('============================================================\n');

%% ============================================================
% INPUT CHECK
% ============================================================

if ~iscell(program)

    error('Program must be a cell array of assembly instructions.');

end

%% ============================================================
% PREPARE PROGRAM
% ============================================================

cleanProgram = {};

for i = 1:length(program)

    % Make sure entry is text
    if isstring(program{i})

        asm = char(program{i});

    elseif ischar(program{i})

        asm = program{i};

    else

        error('Program entry %d is not text.',i);

    end

    % Remove MATLAB comments
    commentPosition = strfind(asm,'%');

    if ~isempty(commentPosition)

        asm = asm(1:commentPosition(1)-1);

    end

    % Remove leading/trailing spaces
    asm = strtrim(asm);

    % Skip blank lines
    if isempty(asm)

        continue;

    end

    % Store cleaned instruction
    cleanProgram{end+1} = asm;

end

%% ============================================================
% CHECK PROGRAM
% ============================================================

numberOfInstructions = length(cleanProgram);

if numberOfInstructions == 0

    error('Program contains no valid instructions.');

end

%% ============================================================
% CREATE INSTRUCTION MEMORY
% ============================================================

memory = zeros(numberOfInstructions,1,'uint32');

%% ============================================================
% ASSEMBLE PROGRAM
% ============================================================

fprintf('\n');
fprintf('Loading program...\n');
fprintf('------------------------------------------------------------\n');

for i = 1:numberOfInstructions

    asm = cleanProgram{i};

    fprintf('\n');
    fprintf('Instruction %d\n',i);
    fprintf('  Assembly   : %s\n',asm);

    try

        machineCode = encoder(asm);

    catch ME

        fprintf('\n');
        fprintf('ERROR while assembling instruction %d:\n',i);
        fprintf('  %s\n',asm);
        fprintf('  %s\n',ME.message);

        rethrow(ME);

    end

    memory(i) = uint32(machineCode);

    fprintf('  Machine code : 0x%08X\n',memory(i));

end

%% ============================================================
% SUMMARY
% ============================================================

fprintf('\n');
fprintf('------------------------------------------------------------\n');
fprintf('Program loaded successfully.\n');
fprintf('Number of instructions : %d\n',numberOfInstructions);
fprintf('Instruction memory size: %d words\n',numberOfInstructions);
fprintf('Instruction memory size: %d bytes\n', ...
    numberOfInstructions * 4);

fprintf('============================================================\n');

end