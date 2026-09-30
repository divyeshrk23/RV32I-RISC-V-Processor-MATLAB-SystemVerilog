function state = pipeline_state()

% =============================================================
% RISC-V PIPELINE STATE
%
% STAGE 18.1
% PIPELINE ARCHITECTURE
%
% Five stages:
%
% IF -> ID -> EX -> MEM -> WB
%
% This stage only establishes and verifies the
% pipeline-stage structure.
% =============================================================


% =============================================================
% PROGRAM COUNTER
% =============================================================

state.pc = uint32(0);


% =============================================================
% IF STAGE
% =============================================================

state.IF.valid = false;

state.IF.pc = uint32(0);

state.IF.instruction = uint32(0);


% =============================================================
% ID STAGE
% =============================================================

state.ID.valid = false;

state.ID.pc = uint32(0);

state.ID.instruction = uint32(0);

state.ID.opcode = "";

state.ID.rs1 = 0;

state.ID.rs2 = 0;

state.ID.rd = 0;

state.ID.immediate = 0;


% =============================================================
% EX STAGE
% =============================================================

state.EX.valid = false;

state.EX.pc = uint32(0);

state.EX.opcode = "";

state.EX.rs1Value = uint32(0);

state.EX.rs2Value = uint32(0);

state.EX.rd = 0;

state.EX.immediate = 0;

state.EX.aluResult = uint32(0);


% =============================================================
% MEM STAGE
% =============================================================

state.MEM.valid = false;

state.MEM.pc = uint32(0);

state.MEM.opcode = "";

state.MEM.aluResult = uint32(0);

state.MEM.storeData = uint32(0);

state.MEM.rd = 0;

state.MEM.memoryData = uint32(0);


% =============================================================
% WB STAGE
% =============================================================

state.WB.valid = false;

state.WB.pc = uint32(0);

state.WB.opcode = "";

state.WB.result = uint32(0);

state.WB.rd = 0;


% =============================================================
% PIPELINE CONTROL
% =============================================================

state.halted = false;

state.cycle = 0;


% =============================================================
% STAGE VALIDITY
% =============================================================

state.stageValid = false(1,5);


% =============================================================
% STAGE NAMES
% =============================================================

state.stageNames = { ...
    'IF', ...
    'ID', ...
    'EX', ...
    'MEM', ...
    'WB'};


end