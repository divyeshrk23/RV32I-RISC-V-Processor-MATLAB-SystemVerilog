function program = assembly_reader(filename)

% ============================================================
% RISC-V ASSEMBLY FILE READER
%
% Input:
%   filename - path to .asm file
%
% Output:
%   program  - cell array of clean assembly instructions
%
% Features:
%   - Reads external .asm files
%   - Removes blank lines
%   - Removes # comments
%   - Removes % comments
%   - Removes inline comments
%   - Trims extra spaces
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('             RISC-V ASSEMBLY FILE READER\n');
fprintf('============================================================\n');

%% ============================================================
% CHECK FILE
% ============================================================

if nargin < 1 || isempty(filename)

    error('Assembly filename was not provided.');

end

if ~(ischar(filename) || isstring(filename))

    error('Filename must be a character vector or string.');

end

filename = char(filename);

if ~isfile(filename)

    error('Assembly file not found: %s',filename);

end

%% ============================================================
% OPEN FILE
% ============================================================

fileID = fopen(filename,'r');

if fileID == -1

    error('Unable to open assembly file: %s',filename);

end

%% ============================================================
% READ FILE
% ============================================================

program = {};

lineNumber = 0;

while true

    line = fgetl(fileID);

    if ~ischar(line)

        break;

    end

    lineNumber = lineNumber + 1;

    %% --------------------------------------------------------
    % Remove # comments
    % --------------------------------------------------------

    hashPosition = strfind(line,'#');

    if ~isempty(hashPosition)

        line = line(1:hashPosition(1)-1);

    end

    %% --------------------------------------------------------
    % Remove % comments
    % --------------------------------------------------------

    percentPosition = strfind(line,'%');

    if ~isempty(percentPosition)

        line = line(1:percentPosition(1)-1);

    end

    %% --------------------------------------------------------
    % Remove leading/trailing spaces
    % --------------------------------------------------------

    line = strtrim(line);

    %% --------------------------------------------------------
    % Ignore blank lines
    % --------------------------------------------------------

    if isempty(line)

        continue;

    end

    %% --------------------------------------------------------
    % Store instruction
    % --------------------------------------------------------

    program{end+1} = line;

end

%% ============================================================
% CLOSE FILE
% ============================================================

fclose(fileID);

%% ============================================================
% CHECK RESULT
% ============================================================

if isempty(program)

    error('Assembly file contains no valid instructions.');

end

%% ============================================================
% DISPLAY RESULT
% ============================================================

fprintf('\n');
fprintf('Assembly file : %s\n',filename);
fprintf('Valid instructions : %d\n',length(program));

fprintf('\n');
fprintf('Instructions read:\n');
fprintf('------------------------------------------------------------\n');

for i = 1:length(program)

    fprintf('%d. %s\n',i,program{i});

end

fprintf('============================================================\n');

end