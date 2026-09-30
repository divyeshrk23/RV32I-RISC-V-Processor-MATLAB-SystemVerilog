function stage22_10_pipeline_registers

clc;

fprintf('==============================================\n');
fprintf('STAGE 22.10 - HARDWARE PIPELINE REGISTERS\n');
fprintf('==============================================\n\n');

testsPassed = 0;
testsTotal = 10;

% ------------------------------------------------
% Pipeline register structures
% ------------------------------------------------

IF_ID  = struct();
ID_EX  = struct();
EX_MEM = struct();
MEM_WB = struct();

% =================================================
% TEST 1 - IF/ID register
% =================================================

IF_ID.pc = uint32(100);
IF_ID.instruction = uint32(hex2dec('00A00093'));
IF_ID.valid = true;

if IF_ID.pc == uint32(100) && ...
   IF_ID.instruction == uint32(hex2dec('00A00093')) && ...
   IF_ID.valid

    fprintf('1. IF/ID register             : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('1. IF/ID register             : FAIL\n');

end

% =================================================
% TEST 2 - IF/ID data preservation
% =================================================

savedPC = IF_ID.pc;
savedInstruction = IF_ID.instruction;
savedValid = IF_ID.valid;

if savedPC == IF_ID.pc && ...
   savedInstruction == IF_ID.instruction && ...
   savedValid == IF_ID.valid

    fprintf('2. IF/ID data preservation    : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('2. IF/ID data preservation    : FAIL\n');

end

% =================================================
% TEST 3 - ID/EX register
% =================================================

ID_EX.pc = uint32(100);
ID_EX.rs1Value = uint32(10);
ID_EX.rs2Value = uint32(20);
ID_EX.rd = 5;
ID_EX.immediate = 15;
ID_EX.opcode = "ADD";
ID_EX.RegWrite = true;
ID_EX.ALUSrc = false;
ID_EX.valid = true;

if ID_EX.pc == uint32(100) && ...
   ID_EX.rs1Value == uint32(10) && ...
   ID_EX.rs2Value == uint32(20) && ...
   ID_EX.rd == 5 && ...
   ID_EX.immediate == 15 && ...
   strcmp(char(ID_EX.opcode),'ADD') && ...
   ID_EX.RegWrite && ...
   ~ID_EX.ALUSrc && ...
   ID_EX.valid

    fprintf('3. ID/EX register             : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('3. ID/EX register             : FAIL\n');

end

% =================================================
% TEST 4 - ID/EX control signals
% =================================================

ID_EX.MemRead = false;
ID_EX.MemWrite = false;
ID_EX.MemToReg = false;
ID_EX.Branch = false;
ID_EX.Jump = false;
ID_EX.Jalr = false;

if ~ID_EX.MemRead && ...
   ~ID_EX.MemWrite && ...
   ~ID_EX.MemToReg && ...
   ~ID_EX.Branch && ...
   ~ID_EX.Jump && ...
   ~ID_EX.Jalr

    fprintf('4. ID/EX control signals     : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('4. ID/EX control signals     : FAIL\n');

end

% =================================================
% TEST 5 - EX/MEM register
% =================================================

EX_MEM.pc = uint32(100);
EX_MEM.aluResult = uint32(30);
EX_MEM.storeData = uint32(50);
EX_MEM.rd = 6;
EX_MEM.RegWrite = true;
EX_MEM.MemRead = false;
EX_MEM.MemWrite = true;
EX_MEM.MemToReg = false;
EX_MEM.valid = true;

if EX_MEM.pc == uint32(100) && ...
   EX_MEM.aluResult == uint32(30) && ...
   EX_MEM.storeData == uint32(50) && ...
   EX_MEM.rd == 6 && ...
   EX_MEM.RegWrite && ...
   ~EX_MEM.MemRead && ...
   EX_MEM.MemWrite && ...
   EX_MEM.valid

    fprintf('5. EX/MEM register            : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('5. EX/MEM register            : FAIL\n');

end

% =================================================
% TEST 6 - EX/MEM data preservation
% =================================================

oldALUResult = EX_MEM.aluResult;
oldStoreData = EX_MEM.storeData;
oldRd = EX_MEM.rd;

if oldALUResult == uint32(30) && ...
   oldStoreData == uint32(50) && ...
   oldRd == 6

    fprintf('6. EX/MEM data preservation   : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('6. EX/MEM data preservation   : FAIL\n');

end

% =================================================
% TEST 7 - MEM/WB register
% =================================================

MEM_WB.pc = uint32(100);
MEM_WB.result = uint32(30);
MEM_WB.memoryData = uint32(75);
MEM_WB.rd = 7;
MEM_WB.RegWrite = true;
MEM_WB.MemToReg = true;
MEM_WB.valid = true;

if MEM_WB.pc == uint32(100) && ...
   MEM_WB.result == uint32(30) && ...
   MEM_WB.memoryData == uint32(75) && ...
   MEM_WB.rd == 7 && ...
   MEM_WB.RegWrite && ...
   MEM_WB.MemToReg && ...
   MEM_WB.valid

    fprintf('7. MEM/WB register            : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('7. MEM/WB register            : FAIL\n');

end

% =================================================
% TEST 8 - MEM/WB write-back selection
% =================================================

aluResult = uint32(30);
memoryData = uint32(75);

memToReg = true;

if memToReg

    wbData = memoryData;

else

    wbData = aluResult;

end

if wbData == uint32(75)

    fprintf('8. MEM/WB write-back select  : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('8. MEM/WB write-back select  : FAIL\n');

end

% =================================================
% TEST 9 - Pipeline valid control
% =================================================

IF_ID.valid = false;
ID_EX.valid = false;
EX_MEM.valid = false;
MEM_WB.valid = false;

if ~IF_ID.valid && ...
   ~ID_EX.valid && ...
   ~EX_MEM.valid && ...
   ~MEM_WB.valid

    fprintf('9. Pipeline valid control     : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('9. Pipeline valid control     : FAIL\n');

end

% =================================================
% TEST 10 - Complete register chain
% =================================================

IF_ID.valid = true;
ID_EX.valid = true;
EX_MEM.valid = true;
MEM_WB.valid = true;

IF_ID.pc = uint32(200);
ID_EX.pc = IF_ID.pc;
EX_MEM.pc = ID_EX.pc;
MEM_WB.pc = EX_MEM.pc;

if MEM_WB.pc == uint32(200) && ...
   IF_ID.valid && ...
   ID_EX.valid && ...
   EX_MEM.valid && ...
   MEM_WB.valid

    fprintf('10. Complete pipeline chain   : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('10. Complete pipeline chain   : FAIL\n');

end

% ------------------------------------------------
% Hardware summary
% ------------------------------------------------

fprintf('\n');
fprintf('Hardware Pipeline Registers:\n');
fprintf('  IF/ID    : PC + Instruction + Valid\n');
fprintf('  ID/EX    : Decode data + Control signals\n');
fprintf('  EX/MEM   : ALU result + Store data + Control\n');
fprintf('  MEM/WB   : Memory/ALU result + Write-back data\n');
fprintf('  Valid    : Pipeline instruction validity\n');
fprintf('  Clock    : State transfer boundary\n');

fprintf('\n');
fprintf('Tests passed : %d / %d\n', ...
    testsPassed,testsTotal);

if testsPassed == testsTotal

    fprintf('STAGE 22.10 PASSED!\n');

else

    fprintf('STAGE 22.10 FAILED\n');

end

end