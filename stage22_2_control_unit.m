function stage22_2_control_unit

clc;

fprintf('==============================================\n');
fprintf('STAGE 22.2 - HARDWARE CONTROL UNIT\n');
fprintf('==============================================\n\n');

% =================================================
% Instruction list
% =================================================

instructions = {
    'ADD'
    'SUB'
    'AND'
    'OR'
    'XOR'
    'SLT'
    'SLTU'
    'ADDI'
    'SLLI'
    'SRLI'
    'SRAI'
    'SLTI'
    'SLTIU'
    'LB'
    'LBU'
    'LH'
    'LHU'
    'LW'
    'SB'
    'SH'
    'SW'
    'BEQ'
    'BNE'
    'BLT'
    'BGE'
    'BLTU'
    'BGEU'
    'JAL'
    'JALR'
};

% =================================================
% Generate control signals
% =================================================

control = cell(length(instructions),1);

for i = 1:length(instructions)

    opcode = instructions{i};

    % -------------------------------------------------
    % Default values
    % -------------------------------------------------

    signal = struct();

    signal.RegWrite = false;
    signal.MemRead = false;
    signal.MemWrite = false;
    signal.MemToReg = false;
    signal.ALUSrc = false;
    signal.Branch = false;
    signal.Jump = false;
    signal.Jalr = false;

    signal.ALUControl = "";
    signal.BranchType = "";
    signal.PCSrc = "PC+4";

    % =================================================
    % Instruction decoding
    % =================================================

    switch opcode

        % -------------------------------------------------
        % R-Type
        % -------------------------------------------------

        case 'ADD'

            signal.RegWrite = true;
            signal.ALUControl = "ADD";

        case 'SUB'

            signal.RegWrite = true;
            signal.ALUControl = "SUB";

        case 'AND'

            signal.RegWrite = true;
            signal.ALUControl = "AND";

        case 'OR'

            signal.RegWrite = true;
            signal.ALUControl = "OR";

        case 'XOR'

            signal.RegWrite = true;
            signal.ALUControl = "XOR";

        case 'SLT'

            signal.RegWrite = true;
            signal.ALUControl = "SLT";

        case 'SLTU'

            signal.RegWrite = true;
            signal.ALUControl = "SLTU";

        % -------------------------------------------------
        % I-Type ALU
        % -------------------------------------------------

        case 'ADDI'

            signal.RegWrite = true;
            signal.ALUSrc = true;
            signal.ALUControl = "ADD";

        case 'SLLI'

            signal.RegWrite = true;
            signal.ALUSrc = true;
            signal.ALUControl = "SLL";

        case 'SRLI'

            signal.RegWrite = true;
            signal.ALUSrc = true;
            signal.ALUControl = "SRL";

        case 'SRAI'

            signal.RegWrite = true;
            signal.ALUSrc = true;
            signal.ALUControl = "SRA";

        case 'SLTI'

            signal.RegWrite = true;
            signal.ALUSrc = true;
            signal.ALUControl = "SLT";

        case 'SLTIU'

            signal.RegWrite = true;
            signal.ALUSrc = true;
            signal.ALUControl = "SLTU";

        % -------------------------------------------------
        % Loads
        % -------------------------------------------------

        case {'LB','LBU','LH','LHU','LW'}

            signal.RegWrite = true;
            signal.MemRead = true;
            signal.MemToReg = true;
            signal.ALUSrc = true;
            signal.ALUControl = "ADD";

        % -------------------------------------------------
        % Stores
        % -------------------------------------------------

        case {'SB','SH','SW'}

            signal.MemWrite = true;
            signal.ALUSrc = true;
            signal.ALUControl = "ADD";

        % -------------------------------------------------
        % Branches
        % -------------------------------------------------

        case {'BEQ','BNE','BLT','BGE','BLTU','BGEU'}

            signal.Branch = true;
            signal.ALUControl = "SUB";
            signal.BranchType = string(opcode);
            signal.PCSrc = "BRANCH";

        % -------------------------------------------------
        % JAL
        % -------------------------------------------------

        case 'JAL'

            signal.RegWrite = true;
            signal.Jump = true;
            signal.Jalr = false;
            signal.PCSrc = "JAL";

        % -------------------------------------------------
        % JALR
        % -------------------------------------------------

        case 'JALR'

            signal.RegWrite = true;
            signal.MemRead = false;
            signal.MemWrite = false;
            signal.MemToReg = false;

            signal.ALUSrc = true;

            signal.Branch = false;

            signal.Jump = true;
            signal.Jalr = true;

            signal.ALUControl = "ADD";
            signal.PCSrc = "JALR";

        otherwise

            error('Unsupported instruction: %s',opcode);

    end

    control{i} = signal;

end

% =================================================
% Display control table
% =================================================

fprintf('%-6s %-9s %-9s %-9s %-9s %-8s %-8s %-8s %-8s %-8s\n', ...
    'Instr', ...
    'RegWrite', ...
    'MemRead', ...
    'MemWrite', ...
    'MemToReg', ...
    'ALUSrc', ...
    'Branch', ...
    'Jump', ...
    'Jalr', ...
    'PCSrc');

fprintf('%s\n',repmat('-',1,105));

for i = 1:length(instructions)

    s = control{i};

    fprintf('%-6s %-9d %-9d %-9d %-9d %-8d %-8d %-8d %-8d %-8s\n', ...
        instructions{i}, ...
        s.RegWrite, ...
        s.MemRead, ...
        s.MemWrite, ...
        s.MemToReg, ...
        s.ALUSrc, ...
        s.Branch, ...
        s.Jump, ...
        s.Jalr, ...
        char(s.PCSrc));

end

% =================================================
% Verification
% =================================================

fprintf('\n');
fprintf('Control signal verification:\n\n');

testsPassed = 0;
testsTotal = length(instructions);

for i = 1:length(instructions)

    opcode = instructions{i};
    s = control{i};

    valid = true;

    % -------------------------------------------------
    % R-Type verification
    % -------------------------------------------------

    if any(strcmp(opcode, ...
            {'ADD','SUB','AND','OR','XOR','SLT','SLTU'}))

        valid = ...
            s.RegWrite == true && ...
            s.MemRead == false && ...
            s.MemWrite == false && ...
            s.MemToReg == false && ...
            s.ALUSrc == false && ...
            s.Branch == false && ...
            s.Jump == false && ...
            s.Jalr == false && ...
            strcmp(char(s.PCSrc),'PC+4');

    end

    % -------------------------------------------------
    % I-Type ALU verification
    % -------------------------------------------------

    if any(strcmp(opcode, ...
            {'ADDI','SLLI','SRLI','SRAI','SLTI','SLTIU'}))

        valid = ...
            s.RegWrite == true && ...
            s.MemRead == false && ...
            s.MemWrite == false && ...
            s.MemToReg == false && ...
            s.ALUSrc == true && ...
            s.Branch == false && ...
            s.Jump == false && ...
            s.Jalr == false && ...
            strcmp(char(s.PCSrc),'PC+4');

    end

    % -------------------------------------------------
    % Load verification
    % -------------------------------------------------

    if any(strcmp(opcode, ...
            {'LB','LBU','LH','LHU','LW'}))

        valid = ...
            s.RegWrite == true && ...
            s.MemRead == true && ...
            s.MemWrite == false && ...
            s.MemToReg == true && ...
            s.ALUSrc == true && ...
            s.Branch == false && ...
            s.Jump == false && ...
            s.Jalr == false && ...
            strcmp(char(s.PCSrc),'PC+4');

    end

    % -------------------------------------------------
    % Store verification
    % -------------------------------------------------

    if any(strcmp(opcode, ...
            {'SB','SH','SW'}))

        valid = ...
            s.RegWrite == false && ...
            s.MemRead == false && ...
            s.MemWrite == true && ...
            s.MemToReg == false && ...
            s.ALUSrc == true && ...
            s.Branch == false && ...
            s.Jump == false && ...
            s.Jalr == false && ...
            strcmp(char(s.PCSrc),'PC+4');

    end

    % -------------------------------------------------
    % Branch verification
    % -------------------------------------------------

    if any(strcmp(opcode, ...
            {'BEQ','BNE','BLT','BGE','BLTU','BGEU'}))

        valid = ...
            s.RegWrite == false && ...
            s.MemRead == false && ...
            s.MemWrite == false && ...
            s.MemToReg == false && ...
            s.ALUSrc == false && ...
            s.Branch == true && ...
            s.Jump == false && ...
            s.Jalr == false && ...
            strcmp(char(s.PCSrc),'BRANCH');

    end

    % -------------------------------------------------
    % JAL verification
    % -------------------------------------------------

    if strcmp(opcode,'JAL')

        valid = ...
            s.RegWrite == true && ...
            s.MemRead == false && ...
            s.MemWrite == false && ...
            s.MemToReg == false && ...
            s.ALUSrc == false && ...
            s.Branch == false && ...
            s.Jump == true && ...
            s.Jalr == false && ...
            strcmp(char(s.PCSrc),'JAL');

    end

    % -------------------------------------------------
    % JALR verification
    % -------------------------------------------------

    if strcmp(opcode,'JALR')

        % Explicit JALR verification

        test1 = (s.RegWrite == true);
        test2 = (s.MemRead == false);
        test3 = (s.MemWrite == false);
        test4 = (s.MemToReg == false);
        test5 = (s.ALUSrc == true);
        test6 = (s.Branch == false);
        test7 = (s.Jump == true);
        test8 = (s.Jalr == true);
        test9 = strcmp(char(s.ALUControl),'ADD');
        test10 = strcmp(char(s.PCSrc),'JALR');

        valid = ...
            test1 && ...
            test2 && ...
            test3 && ...
            test4 && ...
            test5 && ...
            test6 && ...
            test7 && ...
            test8 && ...
            test9 && ...
            test10;

        % If something fails, show exactly what failed

        if ~valid

            fprintf('\nJALR diagnostic:\n');
            fprintf('RegWrite  = %d\n',test1);
            fprintf('MemRead   = %d\n',test2);
            fprintf('MemWrite  = %d\n',test3);
            fprintf('MemToReg  = %d\n',test4);
            fprintf('ALUSrc    = %d\n',test5);
            fprintf('Branch    = %d\n',test6);
            fprintf('Jump      = %d\n',test7);
            fprintf('Jalr      = %d\n',test8);
            fprintf('ALUControl= %d\n',test9);
            fprintf('PCSrc     = %d\n',test10);

        end

    end

    % -------------------------------------------------
    % Result
    % -------------------------------------------------

    if valid

        fprintf('%-6s : PASS\n',opcode);

        testsPassed = testsPassed + 1;

    else

        fprintf('%-6s : FAIL\n',opcode);

    end

end

% =================================================
% Final result
% =================================================

fprintf('\n');

fprintf('Tests passed : %d / %d\n', ...
    testsPassed,testsTotal);

if testsPassed == testsTotal

    fprintf('STAGE 22.2 PASSED!\n');

else

    fprintf('STAGE 22.2 FAILED\n');

end

end