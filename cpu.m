function [registers,pc,halted,dataMemory, ...
          instructionCount,cycleCount, ...
          addCount,subCount,andCount,orCount, ...
          xorCount,sltCount,sltuCount, ...
          aluOperationCount, ...
          loadCount,storeCount,memoryOperationCount, ...
          beqCount,bneCount,bltCount,bgeCount, ...
          bltuCount,bgeuCount, ...
          branchCount,branchTakenCount,branchNotTakenCount, ...
          jalCount,jalrCount,jumpCount, ...
          controlFlowCount, ...
          registerWriteCount,x0WriteAttemptCount, ...
          actualRegisterWriteCount, ...
          memoryReadCount,memoryWriteCount, ...
          totalMemoryAccessCount, ...
          lbCount,lbuCount,lhCount,lhuCount,lwCount, ...
          sbCount,shCount,swCount, ...
          cpi,performanceReport] = cpu( ...
    program,maxCycles,initialMemory)

% =============================================================
% RISC-V CPU
%
% STAGE 17.9
% PERFORMANCE REPORT
% =============================================================

if nargin < 2 || isempty(maxCycles)
    maxCycles = 100;
end


% =============================================================
% LOAD PROGRAM
% =============================================================

memory = program_loader(program);


% =============================================================
% REGISTER FILE
% =============================================================

registers = zeros(32,1,'uint32');


% =============================================================
% DATA MEMORY
% =============================================================

if nargin < 3 || isempty(initialMemory)

    dataMemory = zeros(1024,1,'uint8');

else

    if ~isvector(initialMemory)
        error('Initial memory must be a vector.');
    end

    initialMemory = uint8(initialMemory(:));

    if length(initialMemory) > 1024
        error('Initial memory cannot exceed 1024 bytes.');
    end

    dataMemory = zeros(1024,1,'uint8');

    dataMemory(1:length(initialMemory)) = initialMemory;

end


% =============================================================
% CPU STATE
% =============================================================

pc = uint32(0);

halted = false;


% =============================================================
% STAGE 17.1
% =============================================================

instructionCount = 0;


% =============================================================
% STAGE 17.2
% =============================================================

cycleCount = 0;


% =============================================================
% STAGE 17.3
% ALU STATISTICS
% =============================================================

addCount = 0;
subCount = 0;
andCount = 0;
orCount = 0;
xorCount = 0;
sltCount = 0;
sltuCount = 0;

aluOperationCount = 0;


% =============================================================
% STAGE 17.4
% MEMORY STATISTICS
% =============================================================

loadCount = 0;
storeCount = 0;
memoryOperationCount = 0;


% =============================================================
% STAGE 17.5
% BRANCH STATISTICS
% =============================================================

beqCount = 0;
bneCount = 0;
bltCount = 0;
bgeCount = 0;
bltuCount = 0;
bgeuCount = 0;

branchCount = 0;

branchTakenCount = 0;
branchNotTakenCount = 0;


% =============================================================
% STAGE 17.5
% JUMP STATISTICS
% =============================================================

jalCount = 0;
jalrCount = 0;

jumpCount = 0;

controlFlowCount = 0;


% =============================================================
% STAGE 17.6
% REGISTER WRITE STATISTICS
% =============================================================

registerWriteCount = 0;

x0WriteAttemptCount = 0;

actualRegisterWriteCount = 0;


% =============================================================
% STAGE 17.7
% MEMORY ACCESS STATISTICS
% =============================================================

memoryReadCount = 0;

memoryWriteCount = 0;

totalMemoryAccessCount = 0;


lbCount = 0;
lbuCount = 0;
lhCount = 0;
lhuCount = 0;
lwCount = 0;

sbCount = 0;
shCount = 0;
swCount = 0;


% =============================================================
% STAGE 17.8
% CPI
% =============================================================

cpi = 0;


% =============================================================
% EXECUTION LOOP
% =============================================================

while ~halted && cycleCount < maxCycles


    % =========================================================
    % COUNT CYCLE
    % =========================================================

    cycleCount = cycleCount + 1;


    % =========================================================
    % FETCH
    % =========================================================

    index = double(pc)/4 + 1;

    if index < 1 || index > length(memory)

        instruction = uint32(0);

    else

        instruction = memory(index);

    end


    % =========================================================
    % DECODE
    % =========================================================

    decoded = decoder(instruction);


    fprintf('\n');
    fprintf('------------------------------------------------------------\n');
    fprintf('Cycle       : %d\n',cycleCount);
    fprintf('PC          : %u\n',pc);
    fprintf('Instruction : 0x%08X\n',instruction);
    fprintf('Opcode      : %s\n',decoded.opcode);


    % =========================================================
    % END
    % =========================================================

    if decoded.opcode == "END"

        halted = true;

        break;

    end


    % =========================================================
    % INSTRUCTION COUNT
    % =========================================================

    instructionCount = instructionCount + 1;


    % =========================================================
    % READ REGISTERS
    % =========================================================

    [readData1,readData2,registers] = register_file( ...
        decoded.rs1, ...
        decoded.rs2, ...
        0, ...
        0, ...
        false, ...
        registers);


    fprintf('rs1 value   : %u\n',readData1);
    fprintf('rs2 value   : %u\n',readData2);


    % =========================================================
    % DEFAULT CONTROL SIGNALS
    % =========================================================

    nextPC = pc + uint32(4);

    writeEnable = false;

    writeData = uint32(0);

    memoryReadEnable = false;

    memoryWriteEnable = false;

    memoryOperation = '';


    % =========================================================
    % EXECUTE
    % =========================================================

    switch decoded.opcode


        % =====================================================
        % ADD
        % =====================================================

        case 'ADD'

            writeData = alu( ...
                'ADD',readData1,readData2);

            writeEnable = true;

            addCount = addCount + 1;

            aluOperationCount = ...
                aluOperationCount + 1;


        % =====================================================
        % SUB
        % =====================================================

        case 'SUB'

            writeData = alu( ...
                'SUB',readData1,readData2);

            writeEnable = true;

            subCount = subCount + 1;

            aluOperationCount = ...
                aluOperationCount + 1;


        % =====================================================
        % AND
        % =====================================================

        case 'AND'

            writeData = alu( ...
                'AND',readData1,readData2);

            writeEnable = true;

            andCount = andCount + 1;

            aluOperationCount = ...
                aluOperationCount + 1;


        % =====================================================
        % OR
        % =====================================================

        case 'OR'

            writeData = alu( ...
                'OR',readData1,readData2);

            writeEnable = true;

            orCount = orCount + 1;

            aluOperationCount = ...
                aluOperationCount + 1;


        % =====================================================
        % XOR
        % =====================================================

        case 'XOR'

            writeData = alu( ...
                'XOR',readData1,readData2);

            writeEnable = true;

            xorCount = xorCount + 1;

            aluOperationCount = ...
                aluOperationCount + 1;


        % =====================================================
        % SLT
        % =====================================================

        case 'SLT'

            signedA = typecast( ...
                uint32(readData1),'int32');

            signedB = typecast( ...
                uint32(readData2),'int32');

            if signedA < signedB
                writeData = uint32(1);
            else
                writeData = uint32(0);
            end

            writeEnable = true;

            sltCount = sltCount + 1;

            aluOperationCount = ...
                aluOperationCount + 1;


        % =====================================================
        % SLTU
        % =====================================================

        case 'SLTU'

            unsignedA = uint32(readData1);

            unsignedB = uint32(readData2);

            if unsignedA < unsignedB
                writeData = uint32(1);
            else
                writeData = uint32(0);
            end

            writeEnable = true;

            sltuCount = sltuCount + 1;

            aluOperationCount = ...
                aluOperationCount + 1;


        % =====================================================
        % ADDI
        % =====================================================

        case 'ADDI'

            writeData = uint32(mod( ...
                double(readData1) + ...
                double(decoded.immediate), ...
                2^32));

            writeEnable = true;


        % =====================================================
        % SLTI
        % =====================================================

        case 'SLTI'

            signedRS1 = typecast( ...
                uint32(readData1),'int32');

            signedImmediate = ...
                int32(decoded.immediate);

            if signedRS1 < signedImmediate
                writeData = uint32(1);
            else
                writeData = uint32(0);
            end

            writeEnable = true;


        % =====================================================
        % SLTIU
        % =====================================================

        case 'SLTIU'

            unsignedRS1 = uint32(readData1);

            unsignedImmediate = uint32(mod( ...
                double(decoded.immediate), ...
                2^32));

            if unsignedRS1 < unsignedImmediate
                writeData = uint32(1);
            else
                writeData = uint32(0);
            end

            writeEnable = true;


        % =====================================================
        % SLLI
        % =====================================================

        case 'SLLI'

            shiftAmount = ...
                double(decoded.immediate);

            writeData = bitshift( ...
                uint32(readData1), ...
                shiftAmount);

            writeEnable = true;


        % =====================================================
        % SRLI
        % =====================================================

        case 'SRLI'

            shiftAmount = ...
                double(decoded.immediate);

            writeData = bitshift( ...
                uint32(readData1), ...
                -shiftAmount);

            writeEnable = true;


        % =====================================================
        % SRAI
        % =====================================================

        case 'SRAI'

            shiftAmount = ...
                double(decoded.immediate);

            signedValue = typecast( ...
                uint32(readData1),'int32');

            shiftedValue = bitshift( ...
                signedValue, ...
                -shiftAmount);

            writeData = typecast( ...
                int32(shiftedValue),'uint32');

            writeEnable = true;


        % =====================================================
        % LOADS
        % =====================================================

        case {'LB','LBU','LH','LHU','LW'}

            address = calculateAddress( ...
                readData1, ...
                decoded.immediate);

            memoryReadEnable = true;

            memoryOperation = decoded.opcode;


            [writeData,dataMemory] = data_memory( ...
                address, ...
                0, ...
                memoryReadEnable, ...
                false, ...
                memoryOperation, ...
                dataMemory);


            writeEnable = true;

            loadCount = loadCount + 1;

            memoryOperationCount = ...
                memoryOperationCount + 1;

            memoryReadCount = ...
                memoryReadCount + 1;

            totalMemoryAccessCount = ...
                totalMemoryAccessCount + 1;


            switch decoded.opcode

                case 'LB'
                    lbCount = lbCount + 1;

                case 'LBU'
                    lbuCount = lbuCount + 1;

                case 'LH'
                    lhCount = lhCount + 1;

                case 'LHU'
                    lhuCount = lhuCount + 1;

                case 'LW'
                    lwCount = lwCount + 1;

            end


        % =====================================================
        % STORES
        % =====================================================

        case {'SB','SH','SW'}

            address = calculateAddress( ...
                readData1, ...
                decoded.immediate);

            memoryWriteEnable = true;

            memoryOperation = decoded.opcode;


            [~,dataMemory] = data_memory( ...
                address, ...
                readData2, ...
                false, ...
                memoryWriteEnable, ...
                memoryOperation, ...
                dataMemory);


            storeCount = storeCount + 1;

            memoryOperationCount = ...
                memoryOperationCount + 1;

            memoryWriteCount = ...
                memoryWriteCount + 1;

            totalMemoryAccessCount = ...
                totalMemoryAccessCount + 1;


            switch decoded.opcode

                case 'SB'
                    sbCount = sbCount + 1;

                case 'SH'
                    shCount = shCount + 1;

                case 'SW'
                    swCount = swCount + 1;

            end


        % =====================================================
        % BEQ
        % =====================================================

        case 'BEQ'

            beqCount = beqCount + 1;

            branchCount = branchCount + 1;

            controlFlowCount = ...
                controlFlowCount + 1;

            if uint32(readData1) == ...
                    uint32(readData2)

                branchTakenCount = ...
                    branchTakenCount + 1;

                nextPC = uint32(mod( ...
                    double(pc) + ...
                    double(decoded.immediate), ...
                    2^32));

            else

                branchNotTakenCount = ...
                    branchNotTakenCount + 1;

            end


        % =====================================================
        % BNE
        % =====================================================

        case 'BNE'

            bneCount = bneCount + 1;

            branchCount = branchCount + 1;

            controlFlowCount = ...
                controlFlowCount + 1;

            if uint32(readData1) ~= ...
                    uint32(readData2)

                branchTakenCount = ...
                    branchTakenCount + 1;

                nextPC = uint32(mod( ...
                    double(pc) + ...
                    double(decoded.immediate), ...
                    2^32));

            else

                branchNotTakenCount = ...
                    branchNotTakenCount + 1;

            end


        % =====================================================
        % BLT
        % =====================================================

        case 'BLT'

            bltCount = bltCount + 1;

            branchCount = branchCount + 1;

            controlFlowCount = ...
                controlFlowCount + 1;

            signedA = typecast( ...
                uint32(readData1),'int32');

            signedB = typecast( ...
                uint32(readData2),'int32');

            if signedA < signedB

                branchTakenCount = ...
                    branchTakenCount + 1;

                nextPC = uint32(mod( ...
                    double(pc) + ...
                    double(decoded.immediate), ...
                    2^32));

            else

                branchNotTakenCount = ...
                    branchNotTakenCount + 1;

            end


        % =====================================================
        % BGE
        % =====================================================

        case 'BGE'

            bgeCount = bgeCount + 1;

            branchCount = branchCount + 1;

            controlFlowCount = ...
                controlFlowCount + 1;

            signedA = typecast( ...
                uint32(readData1),'int32');

            signedB = typecast( ...
                uint32(readData2),'int32');

            if signedA >= signedB

                branchTakenCount = ...
                    branchTakenCount + 1;

                nextPC = uint32(mod( ...
                    double(pc) + ...
                    double(decoded.immediate), ...
                    2^32));

            else

                branchNotTakenCount = ...
                    branchNotTakenCount + 1;

            end


        % =====================================================
        % BLTU
        % =====================================================

        case 'BLTU'

            bltuCount = bltuCount + 1;

            branchCount = branchCount + 1;

            controlFlowCount = ...
                controlFlowCount + 1;

            if uint32(readData1) < ...
                    uint32(readData2)

                branchTakenCount = ...
                    branchTakenCount + 1;

                nextPC = uint32(mod( ...
                    double(pc) + ...
                    double(decoded.immediate), ...
                    2^32));

            else

                branchNotTakenCount = ...
                    branchNotTakenCount + 1;

            end


        % =====================================================
        % BGEU
        % =====================================================

        case 'BGEU'

            bgeuCount = bgeuCount + 1;

            branchCount = branchCount + 1;

            controlFlowCount = ...
                controlFlowCount + 1;

            if uint32(readData1) >= ...
                    uint32(readData2)

                branchTakenCount = ...
                    branchTakenCount + 1;

                nextPC = uint32(mod( ...
                    double(pc) + ...
                    double(decoded.immediate), ...
                    2^32));

            else

                branchNotTakenCount = ...
                    branchNotTakenCount + 1;

            end


        % =====================================================
        % JAL
        % =====================================================

        case 'JAL'

            jalCount = jalCount + 1;

            jumpCount = jumpCount + 1;

            controlFlowCount = ...
                controlFlowCount + 1;

            writeData = pc + uint32(4);

            writeEnable = true;

            nextPC = uint32(mod( ...
                double(pc) + ...
                double(decoded.immediate), ...
                2^32));


        % =====================================================
        % JALR
        % =====================================================

        case 'JALR'

            jalrCount = jalrCount + 1;

            jumpCount = jumpCount + 1;

            controlFlowCount = ...
                controlFlowCount + 1;

            writeData = pc + uint32(4);

            writeEnable = true;

            target = uint32(mod( ...
                double(readData1) + ...
                double(decoded.immediate), ...
                2^32));

            target = bitand( ...
                target, ...
                uint32(hex2dec('FFFFFFFE')));

            nextPC = target;

    end


    % =========================================================
    % REGISTER WRITE STATISTICS
    % =========================================================

    if writeEnable

        registerWriteCount = ...
            registerWriteCount + 1;

        if decoded.rd == 0

            x0WriteAttemptCount = ...
                x0WriteAttemptCount + 1;

        else

            actualRegisterWriteCount = ...
                actualRegisterWriteCount + 1;

        end

    end


    % =========================================================
    % WRITE BACK
    % =========================================================

    if writeEnable

        [~,~,registers] = register_file( ...
            decoded.rs1, ...
            decoded.rs2, ...
            decoded.rd, ...
            writeData, ...
            true, ...
            registers);

        fprintf('Write back  : x%d = %u\n', ...
            decoded.rd,writeData);

    else

        fprintf('Write back  : none\n');

    end


    % =========================================================
    % UPDATE PC
    % =========================================================

    pc = nextPC;

    fprintf('Next PC     : %u\n',pc);

end


% =============================================================
% CPI
% =============================================================

if instructionCount > 0

    cpi = double(cycleCount) / ...
           double(instructionCount);

else

    cpi = 0;

end


% =============================================================
% PERFORMANCE REPORT
% =============================================================

performanceReport = struct();


% Basic performance

performanceReport.instructions = ...
    instructionCount;

performanceReport.cycles = ...
    cycleCount;

performanceReport.cpi = ...
    cpi;


% ALU

performanceReport.aluOperations = ...
    aluOperationCount;

if instructionCount > 0

    performanceReport.aluPercentage = ...
        100 * double(aluOperationCount) / ...
        double(instructionCount);

else

    performanceReport.aluPercentage = 0;

end


% Memory

performanceReport.memoryOperations = ...
    memoryOperationCount;

performanceReport.memoryReads = ...
    memoryReadCount;

performanceReport.memoryWrites = ...
    memoryWriteCount;

if instructionCount > 0

    performanceReport.memoryPercentage = ...
        100 * double(memoryOperationCount) / ...
        double(instructionCount);

else

    performanceReport.memoryPercentage = 0;

end


% Branch

performanceReport.branches = ...
    branchCount;

if instructionCount > 0

    performanceReport.branchPercentage = ...
        100 * double(branchCount) / ...
        double(instructionCount);

else

    performanceReport.branchPercentage = 0;

end


% Jumps

performanceReport.jumps = ...
    jumpCount;

if instructionCount > 0

    performanceReport.jumpPercentage = ...
        100 * double(jumpCount) / ...
        double(instructionCount);

else

    performanceReport.jumpPercentage = 0;

end


% Control flow

performanceReport.controlFlow = ...
    controlFlowCount;

if instructionCount > 0

    performanceReport.controlFlowPercentage = ...
        100 * double(controlFlowCount) / ...
        double(instructionCount);

else

    performanceReport.controlFlowPercentage = 0;

end


% Register writes

performanceReport.registerWrites = ...
    registerWriteCount;

performanceReport.actualRegisterWrites = ...
    actualRegisterWriteCount;

performanceReport.x0WriteAttempts = ...
    x0WriteAttemptCount;


% =============================================================
% PRINT FINAL REPORT
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                 CPU EXECUTION COMPLETE\n');
fprintf('============================================================\n');

fprintf('Final PC : %u\n',pc);

if halted
    fprintf('Status   : HALTED - PROGRAM COMPLETE\n');
else
    fprintf('Status   : NOT HALTED\n');
end


fprintf('\n');
fprintf('============================================================\n');
fprintf('                 PERFORMANCE REPORT\n');
fprintf('============================================================\n');

fprintf('\n');

fprintf('Instructions executed : %d\n', ...
    instructionCount);

fprintf('CPU cycles            : %d\n', ...
    cycleCount);

fprintf('CPI                   : %.4f\n', ...
    cpi);


fprintf('\n');
fprintf('------------------------------------------------------------\n');
fprintf('INSTRUCTION MIX\n');
fprintf('------------------------------------------------------------\n');

fprintf('ALU operations        : %d  (%.2f%%)\n', ...
    aluOperationCount, ...
    performanceReport.aluPercentage);

fprintf('Memory operations     : %d  (%.2f%%)\n', ...
    memoryOperationCount, ...
    performanceReport.memoryPercentage);

fprintf('Branches              : %d  (%.2f%%)\n', ...
    branchCount, ...
    performanceReport.branchPercentage);

fprintf('Jumps                 : %d  (%.2f%%)\n', ...
    jumpCount, ...
    performanceReport.jumpPercentage);


fprintf('\n');
fprintf('------------------------------------------------------------\n');
fprintf('MEMORY ACTIVITY\n');
fprintf('------------------------------------------------------------\n');

fprintf('Memory reads          : %d\n', ...
    memoryReadCount);

fprintf('Memory writes         : %d\n', ...
    memoryWriteCount);

fprintf('Total memory accesses : %d\n', ...
    totalMemoryAccessCount);


fprintf('\n');
fprintf('------------------------------------------------------------\n');
fprintf('CONTROL FLOW\n');
fprintf('------------------------------------------------------------\n');

fprintf('Branches              : %d\n', ...
    branchCount);

fprintf('Taken branches        : %d\n', ...
    branchTakenCount);

fprintf('Not taken branches    : %d\n', ...
    branchNotTakenCount);

fprintf('Jumps                 : %d\n', ...
    jumpCount);

fprintf('Control-flow total    : %d\n', ...
    controlFlowCount);

fprintf('Control-flow          : %.2f%%\n', ...
    performanceReport.controlFlowPercentage);


fprintf('\n');
fprintf('------------------------------------------------------------\n');
fprintf('REGISTER ACTIVITY\n');
fprintf('------------------------------------------------------------\n');

fprintf('Register write attempts : %d\n', ...
    registerWriteCount);

fprintf('Actual register writes  : %d\n', ...
    actualRegisterWriteCount);

fprintf('x0 write attempts       : %d\n', ...
    x0WriteAttemptCount);


fprintf('\n');
fprintf('============================================================\n');

end


% =============================================================
% MEMORY ADDRESS CALCULATION
% =============================================================

function address = calculateAddress(base,immediate)

address = uint32(mod( ...
    double(uint32(base)) + ...
    double(immediate), ...
    2^32));

end