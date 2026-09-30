function result = pipeline_cpu(program, initialMemory, maxCycles)

% =============================================================
% COMPLETE 5-STAGE RV32I PIPELINE CPU
%
% Stage 21.1
%
% Pipeline:
%   IF -> ID -> EX -> MEM -> WB
%
% Includes:
%   - Register file
%   - ALU operations
%   - Loads
%   - Stores
%   - EX/MEM forwarding
%   - MEM/WB forwarding
%   - Load-use stall
%   - Branches
%   - Branch flushing
%   - JAL
%   - JALR
%
% =============================================================


% =============================================================
% INPUTS
% =============================================================

if nargin < 2 || isempty(initialMemory)
    memory = zeros(1024,1,'uint8');
else
    memory = uint8(initialMemory);
end

if nargin < 3 || isempty(maxCycles)
    maxCycles = 100;
end

program = uint32(program);


% =============================================================
% CPU STATE
% =============================================================

registers = zeros(32,1,'uint32');

pc = uint32(0);

cycle = 0;

halted = false;


% =============================================================
% IF/ID PIPELINE REGISTER
% =============================================================

IF_ID.valid = false;
IF_ID.pc = uint32(0);
IF_ID.instruction = uint32(0);


% =============================================================
% ID/EX PIPELINE REGISTER
% =============================================================

ID_EX.valid = false;

ID_EX.pc = uint32(0);

ID_EX.opcode = "";

ID_EX.rs1 = 0;
ID_EX.rs2 = 0;
ID_EX.rd = 0;

ID_EX.rs1Value = uint32(0);
ID_EX.rs2Value = uint32(0);

ID_EX.immediate = 0;

ID_EX.regWrite = false;

ID_EX.memoryRead = false;
ID_EX.memoryWrite = false;

ID_EX.memoryOperation = "NONE";

ID_EX.memoryToReg = false;


% =============================================================
% EX/MEM PIPELINE REGISTER
% =============================================================

EX_MEM.valid = false;

EX_MEM.pc = uint32(0);

EX_MEM.opcode = "";

EX_MEM.rs1 = 0;
EX_MEM.rs2 = 0;

EX_MEM.aluResult = uint32(0);

EX_MEM.storeData = uint32(0);

EX_MEM.rd = 0;

EX_MEM.memoryRead = false;
EX_MEM.memoryWrite = false;

EX_MEM.memoryOperation = "NONE";

EX_MEM.memoryToReg = false;

EX_MEM.regWrite = false;


% =============================================================
% MEM/WB PIPELINE REGISTER
% =============================================================

MEM_WB.valid = false;

MEM_WB.pc = uint32(0);

MEM_WB.opcode = "";

MEM_WB.aluResult = uint32(0);

MEM_WB.memoryData = uint32(0);

MEM_WB.rd = 0;

MEM_WB.memoryToReg = false;

MEM_WB.regWrite = false;


% =============================================================
% MAIN PIPELINE
% =============================================================

while cycle < maxCycles

    cycle = cycle + 1;


    % =========================================================
    % WB STAGE
    % =========================================================

    if MEM_WB.valid

        if MEM_WB.memoryToReg
            writeData = MEM_WB.memoryData;
        else
            writeData = MEM_WB.aluResult;
        end

        if MEM_WB.regWrite && MEM_WB.rd ~= 0

            registers(MEM_WB.rd + 1) = uint32(writeData);

        end

        % x0 is permanently zero
        registers(1) = uint32(0);

    end


    % =========================================================
    % MEM STAGE
    % =========================================================

    next_MEM_WB = MEM_WB;

    next_MEM_WB.valid = EX_MEM.valid;

    next_MEM_WB.pc = EX_MEM.pc;

    next_MEM_WB.opcode = EX_MEM.opcode;

    next_MEM_WB.aluResult = EX_MEM.aluResult;

    next_MEM_WB.memoryData = uint32(0);

    next_MEM_WB.rd = EX_MEM.rd;

    next_MEM_WB.memoryToReg = EX_MEM.memoryToReg;

    next_MEM_WB.regWrite = EX_MEM.regWrite;


    if EX_MEM.valid

        address = double(EX_MEM.aluResult);


        % =====================================================
        % STORE
        % =====================================================

        if EX_MEM.memoryWrite

            if address < 0 || address >= length(memory)

                error( ...
                    'Memory write address out of range: %d', ...
                    address);

            end


            switch EX_MEM.memoryOperation

                case "SB"

                    memory(address + 1) = ...
                        uint8(bitand( ...
                        EX_MEM.storeData, ...
                        uint32(255)));


                case "SH"

                    if mod(address,2) ~= 0
                        error('SH requires 2-byte alignment.');
                    end

                    if address + 2 > length(memory)
                        error('SH address out of range.');
                    end

                    memory(address + 1) = ...
                        uint8(bitand( ...
                        EX_MEM.storeData, ...
                        uint32(255)));

                    memory(address + 2) = ...
                        uint8(bitand( ...
                        bitshift(EX_MEM.storeData,-8), ...
                        uint32(255)));


                case "SW"

                    if mod(address,4) ~= 0
                        error('SW requires 4-byte alignment.');
                    end

                    if address + 4 > length(memory)
                        error('SW address out of range.');
                    end

                    memory(address + 1) = ...
                        uint8(bitand( ...
                        EX_MEM.storeData, ...
                        uint32(255)));

                    memory(address + 2) = ...
                        uint8(bitand( ...
                        bitshift(EX_MEM.storeData,-8), ...
                        uint32(255)));

                    memory(address + 3) = ...
                        uint8(bitand( ...
                        bitshift(EX_MEM.storeData,-16), ...
                        uint32(255)));

                    memory(address + 4) = ...
                        uint8(bitand( ...
                        bitshift(EX_MEM.storeData,-24), ...
                        uint32(255)));

            end

        end


        % =====================================================
        % LOAD
        % =====================================================

        if EX_MEM.memoryRead

            if address < 0 || address >= length(memory)

                error( ...
                    'Memory read address out of range: %d', ...
                    address);

            end


            switch EX_MEM.memoryOperation

                case "LB"

                    value = uint32(memory(address + 1));

                    if value >= 128

                        next_MEM_WB.memoryData = ...
                            typecast( ...
                            int32(double(value) - 256), ...
                            'uint32');

                    else

                        next_MEM_WB.memoryData = value;

                    end


                case "LBU"

                    next_MEM_WB.memoryData = ...
                        uint32(memory(address + 1));


                case "LH"

                    if mod(address,2) ~= 0
                        error('LH requires 2-byte alignment.');
                    end

                    if address + 2 > length(memory)
                        error('LH address out of range.');
                    end

                    b0 = uint32(memory(address + 1));
                    b1 = uint32(memory(address + 2));

                    value = ...
                        b0 + bitshift(b1,8);

                    if value >= 32768

                        next_MEM_WB.memoryData = ...
                            typecast( ...
                            int32(double(value) - 65536), ...
                            'uint32');

                    else

                        next_MEM_WB.memoryData = ...
                            uint32(value);

                    end


                case "LHU"

                    if mod(address,2) ~= 0
                        error('LHU requires 2-byte alignment.');
                    end

                    if address + 2 > length(memory)
                        error('LHU address out of range.');
                    end

                    b0 = uint32(memory(address + 1));
                    b1 = uint32(memory(address + 2));

                    next_MEM_WB.memoryData = ...
                        uint32(b0 + bitshift(b1,8));


                case "LW"

                    if mod(address,4) ~= 0
                        error('LW requires 4-byte alignment.');
                    end

                    if address + 4 > length(memory)
                        error('LW address out of range.');
                    end

                    b0 = uint32(memory(address + 1));
                    b1 = uint32(memory(address + 2));
                    b2 = uint32(memory(address + 3));
                    b3 = uint32(memory(address + 4));

                    next_MEM_WB.memoryData = ...
                        b0 + ...
                        bitshift(b1,8) + ...
                        bitshift(b2,16) + ...
                        bitshift(b3,24);

            end

        end

    end


    % =========================================================
    % FORWARDING
    %
    % Priority:
    %
    %   1. EX/MEM
    %   2. MEM/WB
    %
    % A load cannot be forwarded from EX/MEM because its
    % actual value is not available until MEM/WB.
    % =========================================================

    exRs1Value = ID_EX.rs1Value;
    exRs2Value = ID_EX.rs2Value;


    % ---------------------------------------------------------
    % RS1 forwarding
    % ---------------------------------------------------------

    if ID_EX.rs1 ~= 0

        if EX_MEM.valid && ...
                EX_MEM.regWrite && ...
                ~EX_MEM.memoryToReg && ...
                EX_MEM.rd ~= 0 && ...
                EX_MEM.rd == ID_EX.rs1

            exRs1Value = EX_MEM.aluResult;


        elseif MEM_WB.valid && ...
                MEM_WB.regWrite && ...
                MEM_WB.rd ~= 0 && ...
                MEM_WB.rd == ID_EX.rs1

            if MEM_WB.memoryToReg
                exRs1Value = MEM_WB.memoryData;
            else
                exRs1Value = MEM_WB.aluResult;
            end

        end

    end


    % ---------------------------------------------------------
    % RS2 forwarding
    % ---------------------------------------------------------

    if ID_EX.rs2 ~= 0

        if EX_MEM.valid && ...
                EX_MEM.regWrite && ...
                ~EX_MEM.memoryToReg && ...
                EX_MEM.rd ~= 0 && ...
                EX_MEM.rd == ID_EX.rs2

            exRs2Value = EX_MEM.aluResult;


        elseif MEM_WB.valid && ...
                MEM_WB.regWrite && ...
                MEM_WB.rd ~= 0 && ...
                MEM_WB.rd == ID_EX.rs2

            if MEM_WB.memoryToReg
                exRs2Value = MEM_WB.memoryData;
            else
                exRs2Value = MEM_WB.aluResult;
            end

        end

    end


    % =========================================================
    % LOAD-USE HAZARD
    % =========================================================

    loadUseHazard = false;


    if IF_ID.valid && ID_EX.valid

        decodedHazard = decoder(IF_ID.instruction);

        hazard = load_use_hazard( ...
            decodedHazard.rs1, ...
            decodedHazard.rs2, ...
            ID_EX.rd, ...
            ID_EX.memoryRead, ...
            ID_EX.memoryOperation);

        loadUseHazard = hazard.hazard;

    end


    % =========================================================
    % EX STAGE
    % =========================================================

    next_EX_MEM = EX_MEM;

    next_EX_MEM.valid = ID_EX.valid;

    next_EX_MEM.pc = ID_EX.pc;

    next_EX_MEM.opcode = ID_EX.opcode;

    next_EX_MEM.rs1 = ID_EX.rs1;
    next_EX_MEM.rs2 = ID_EX.rs2;

    next_EX_MEM.aluResult = uint32(0);

    next_EX_MEM.storeData = exRs2Value;

    next_EX_MEM.rd = ID_EX.rd;

    next_EX_MEM.memoryRead = false;
    next_EX_MEM.memoryWrite = false;

    next_EX_MEM.memoryOperation = "NONE";

    next_EX_MEM.memoryToReg = false;

    next_EX_MEM.regWrite = false;


    branchTaken = false;
    branchTarget = uint32(0);

    jumpTaken = false;
    jumpTarget = uint32(0);


    if ID_EX.valid

        opcode = upper(string(ID_EX.opcode));


        switch opcode


            % =================================================
            % R-TYPE
            % =================================================

            case "ADD"

                next_EX_MEM.aluResult = ...
                    uint32(mod( ...
                    double(exRs1Value) + ...
                    double(exRs2Value), ...
                    2^32));

                next_EX_MEM.regWrite = true;


            case "SUB"

                next_EX_MEM.aluResult = ...
                    uint32(mod( ...
                    double(exRs1Value) - ...
                    double(exRs2Value), ...
                    2^32));

                next_EX_MEM.regWrite = true;


            case "AND"

                next_EX_MEM.aluResult = ...
                    bitand(exRs1Value,exRs2Value);

                next_EX_MEM.regWrite = true;


            case "OR"

                next_EX_MEM.aluResult = ...
                    bitor(exRs1Value,exRs2Value);

                next_EX_MEM.regWrite = true;


            case "XOR"

                next_EX_MEM.aluResult = ...
                    bitxor(exRs1Value,exRs2Value);

                next_EX_MEM.regWrite = true;


            case "SLT"

                a = typecast(exRs1Value,'int32');
                b = typecast(exRs2Value,'int32');

                if a < b
                    next_EX_MEM.aluResult = uint32(1);
                else
                    next_EX_MEM.aluResult = uint32(0);
                end

                next_EX_MEM.regWrite = true;


            case "SLTU"

                if exRs1Value < exRs2Value
                    next_EX_MEM.aluResult = uint32(1);
                else
                    next_EX_MEM.aluResult = uint32(0);
                end

                next_EX_MEM.regWrite = true;


            % =================================================
            % I-TYPE ALU
            % =================================================

            case "ADDI"

                next_EX_MEM.aluResult = ...
                    uint32(mod( ...
                    double(exRs1Value) + ...
                    double(ID_EX.immediate), ...
                    2^32));

                next_EX_MEM.regWrite = true;


            case "SLTI"

                a = typecast(exRs1Value,'int32');

                if a < int32(ID_EX.immediate)

                    next_EX_MEM.aluResult = uint32(1);

                else

                    next_EX_MEM.aluResult = uint32(0);

                end

                next_EX_MEM.regWrite = true;


            case "SLTIU"

                imm = uint32(mod( ...
                    double(ID_EX.immediate), ...
                    2^32));

                if exRs1Value < imm
                    next_EX_MEM.aluResult = uint32(1);
                else
                    next_EX_MEM.aluResult = uint32(0);
                end

                next_EX_MEM.regWrite = true;


            case "SLLI"

                shamt = mod(double(ID_EX.immediate),32);

                next_EX_MEM.aluResult = ...
                    bitshift(exRs1Value,shamt);

                next_EX_MEM.regWrite = true;


            case "SRLI"

                shamt = mod(double(ID_EX.immediate),32);

                next_EX_MEM.aluResult = ...
                    bitshift(exRs1Value,-shamt);

                next_EX_MEM.regWrite = true;


            case "SRAI"

                shamt = mod(double(ID_EX.immediate),32);

                signedValue = ...
                    typecast(exRs1Value,'int32');

                shifted = ...
                    bitshift(signedValue,-shamt);

                next_EX_MEM.aluResult = ...
                    typecast(shifted,'uint32');

                next_EX_MEM.regWrite = true;


            % =================================================
            % LOADS
            % =================================================

            case {"LB","LBU","LH","LHU","LW"}

                next_EX_MEM.aluResult = ...
                    uint32(mod( ...
                    double(exRs1Value) + ...
                    double(ID_EX.immediate), ...
                    2^32));

                next_EX_MEM.memoryRead = true;

                next_EX_MEM.memoryOperation = opcode;

                next_EX_MEM.memoryToReg = true;

                next_EX_MEM.regWrite = true;


            % =================================================
            % STORES
            % =================================================

            case {"SB","SH","SW"}

                next_EX_MEM.aluResult = ...
                    uint32(mod( ...
                    double(exRs1Value) + ...
                    double(ID_EX.immediate), ...
                    2^32));

                next_EX_MEM.memoryWrite = true;

                next_EX_MEM.memoryOperation = opcode;

                next_EX_MEM.regWrite = false;


            % =================================================
            % BRANCHES
            % =================================================

            case {"BEQ","BNE","BLT","BGE","BLTU","BGEU"}

                decision = branch_decision( ...
                    opcode, ...
                    exRs1Value, ...
                    exRs2Value);

                if decision.taken

                    branchTaken = true;

                    target = branch_target( ...
                        ID_EX.pc, ...
                        ID_EX.immediate, ...
                        true);

                    branchTarget = target.targetPc;

                end


            % =================================================
            % JAL
            % =================================================

            case "JAL"

                jump = jump_control( ...
                    "JAL", ...
                    ID_EX.pc, ...
                    uint32(0), ...
                    ID_EX.immediate);

                jumpTaken = true;

                jumpTarget = jump.targetPc;

                next_EX_MEM.aluResult = ...
                    jump.returnAddress;

                next_EX_MEM.regWrite = true;


            % =================================================
            % JALR
            % =================================================

            case "JALR"

                jump = jump_control( ...
                    "JALR", ...
                    ID_EX.pc, ...
                    exRs1Value, ...
                    ID_EX.immediate);

                jumpTaken = true;

                jumpTarget = jump.targetPc;

                next_EX_MEM.aluResult = ...
                    jump.returnAddress;

                next_EX_MEM.regWrite = true;

        end

    end


    % =========================================================
    % ID STAGE
    % =========================================================

    next_ID_EX = ID_EX;


    if loadUseHazard

        % -----------------------------------------------------
        % Insert one bubble into EX.
        % Hold IF/ID and PC below.
        % -----------------------------------------------------

        next_ID_EX.valid = false;

        next_ID_EX.pc = uint32(0);

        next_ID_EX.opcode = "";

        next_ID_EX.rs1 = 0;
        next_ID_EX.rs2 = 0;
        next_ID_EX.rd = 0;

        next_ID_EX.rs1Value = uint32(0);
        next_ID_EX.rs2Value = uint32(0);

        next_ID_EX.immediate = 0;

        next_ID_EX.regWrite = false;

        next_ID_EX.memoryRead = false;
        next_ID_EX.memoryWrite = false;

        next_ID_EX.memoryOperation = "NONE";

        next_ID_EX.memoryToReg = false;


    elseif IF_ID.valid

        decoded = decoder(IF_ID.instruction);

        next_ID_EX.valid = true;

        next_ID_EX.pc = IF_ID.pc;

        next_ID_EX.opcode = ...
            upper(string(decoded.opcode));

        next_ID_EX.rs1 = decoded.rs1;
        next_ID_EX.rs2 = decoded.rs2;
        next_ID_EX.rd = decoded.rd;

        next_ID_EX.rs1Value = ...
            registers(decoded.rs1 + 1);

        next_ID_EX.rs2Value = ...
            registers(decoded.rs2 + 1);

        next_ID_EX.immediate = decoded.immediate;

        next_ID_EX.regWrite = false;

        next_ID_EX.memoryRead = false;
        next_ID_EX.memoryWrite = false;

        next_ID_EX.memoryOperation = "NONE";

        next_ID_EX.memoryToReg = false;


        opcode = upper(string(decoded.opcode));


        switch opcode

            case { ...
                    "ADD","SUB","AND","OR","XOR","SLT","SLTU", ...
                    "ADDI","SLTI","SLTIU", ...
                    "SLLI","SRLI","SRAI"}

                next_ID_EX.regWrite = true;


            case {"LB","LBU","LH","LHU","LW"}

                next_ID_EX.regWrite = true;

                next_ID_EX.memoryRead = true;

                next_ID_EX.memoryToReg = true;

                next_ID_EX.memoryOperation = opcode;


            case {"SB","SH","SW"}

                next_ID_EX.memoryWrite = true;

                next_ID_EX.memoryOperation = opcode;


            case {"JAL","JALR"}

                next_ID_EX.regWrite = true;


            case {"BEQ","BNE","BLT","BGE","BLTU","BGEU"}

                % No register write.

        end


    else

        next_ID_EX.valid = false;

        next_ID_EX.pc = uint32(0);

        next_ID_EX.opcode = "";

        next_ID_EX.rs1 = 0;
        next_ID_EX.rs2 = 0;
        next_ID_EX.rd = 0;

        next_ID_EX.rs1Value = uint32(0);
        next_ID_EX.rs2Value = uint32(0);

        next_ID_EX.immediate = 0;

        next_ID_EX.regWrite = false;

        next_ID_EX.memoryRead = false;
        next_ID_EX.memoryWrite = false;

        next_ID_EX.memoryOperation = "NONE";

        next_ID_EX.memoryToReg = false;

    end


    % =========================================================
    % CONTROL FLOW
    % =========================================================

    redirect = false;

    redirectPc = pc;


    if branchTaken

        redirect = true;

        redirectPc = branchTarget;


    elseif jumpTaken

        redirect = true;

        redirectPc = jumpTarget;

    end


    % =========================================================
    % IF STAGE
    % =========================================================

    next_IF_ID = IF_ID;


    if redirect

        % Flush wrong-path instruction.

        next_IF_ID.valid = false;

        next_IF_ID.pc = uint32(0);

        next_IF_ID.instruction = uint32(0);

        pc = redirectPc;


    elseif loadUseHazard

        % Stall:
        % PC does not change.
        % IF/ID does not change.

        next_IF_ID = IF_ID;


    else

        next_IF_ID.valid = false;

        next_IF_ID.pc = pc;

        next_IF_ID.instruction = uint32(0);


        index = double(pc)/4 + 1;


        if index >= 1 && index <= length(program)

            instruction = uint32(program(index));


            if instruction ~= uint32(0)

                next_IF_ID.valid = true;

                next_IF_ID.pc = pc;

                next_IF_ID.instruction = instruction;

            end


            pc = uint32(mod( ...
                double(pc) + 4, ...
                2^32));

        end

    end


    % =========================================================
    % FLUSH ID/EX AFTER TAKEN BRANCH OR JUMP
    % =========================================================

    if redirect

        next_ID_EX.valid = false;

        next_ID_EX.pc = uint32(0);

        next_ID_EX.opcode = "";

        next_ID_EX.rs1 = 0;
        next_ID_EX.rs2 = 0;
        next_ID_EX.rd = 0;

        next_ID_EX.rs1Value = uint32(0);
        next_ID_EX.rs2Value = uint32(0);

        next_ID_EX.immediate = 0;

        next_ID_EX.regWrite = false;

        next_ID_EX.memoryRead = false;
        next_ID_EX.memoryWrite = false;

        next_ID_EX.memoryOperation = "NONE";

        next_ID_EX.memoryToReg = false;

    end


    % =========================================================
    % UPDATE PIPELINE REGISTERS
    % =========================================================

    MEM_WB = next_MEM_WB;

    EX_MEM = next_EX_MEM;

    ID_EX = next_ID_EX;

    IF_ID = next_IF_ID;


    % =========================================================
    % HALT CONDITION
    % =========================================================

    programFinished = ...
        (double(pc)/4 >= length(program));


    if programFinished && ...
            ~IF_ID.valid && ...
            ~ID_EX.valid && ...
            ~EX_MEM.valid && ...
            ~MEM_WB.valid

        halted = true;

        break;

    end

end


% =============================================================
% RESULT
% =============================================================

result = struct();

result.registers = registers;

result.memory = memory;

result.pc = pc;

result.cycles = cycle;

result.halted = halted;


end