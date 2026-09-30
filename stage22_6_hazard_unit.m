function stage22_6_hazard_unit

clc;

fprintf('==============================================\n');
fprintf('STAGE 22.6 - HARDWARE HAZARD UNIT\n');
fprintf('==============================================\n\n');

testsPassed = 0;
testsTotal = 10;

% ------------------------------------------------
% Hardware hazard unit
% ------------------------------------------------
%
% Inputs:
%   ID/EX.Rd
%   ID/EX.MemRead
%   IF/ID.Rs1
%   IF/ID.Rs2
%
% Outputs:
%   PCWrite
%   IFIDWrite
%   IDEXFlush
%   Stall
%
% ------------------------------------------------

% =================================================
% TEST 1 - Load-use hazard on rs1
% =================================================

exRd = 5;
exMemRead = true;

idRs1 = 5;
idRs2 = 0;

hazard = ...
    exMemRead && ...
    exRd ~= 0 && ...
    (idRs1 == exRd || idRs2 == exRd);

pcWrite = ~hazard;
ifIdWrite = ~hazard;
idExFlush = hazard;
stall = hazard;

if hazard && ~pcWrite && ~ifIdWrite && idExFlush && stall

    fprintf('1. Load-use hazard rs1       : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('1. Load-use hazard rs1       : FAIL\n');

end

% =================================================
% TEST 2 - Load-use hazard on rs2
% =================================================

exRd = 8;
exMemRead = true;

idRs1 = 2;
idRs2 = 8;

hazard = ...
    exMemRead && ...
    exRd ~= 0 && ...
    (idRs1 == exRd || idRs2 == exRd);

pcWrite = ~hazard;
ifIdWrite = ~hazard;
idExFlush = hazard;
stall = hazard;

if hazard && ~pcWrite && ~ifIdWrite && idExFlush && stall

    fprintf('2. Load-use hazard rs2       : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('2. Load-use hazard rs2       : FAIL\n');

end

% =================================================
% TEST 3 - No hazard
% =================================================

exRd = 5;
exMemRead = true;

idRs1 = 1;
idRs2 = 2;

hazard = ...
    exMemRead && ...
    exRd ~= 0 && ...
    (idRs1 == exRd || idRs2 == exRd);

pcWrite = ~hazard;
ifIdWrite = ~hazard;
idExFlush = hazard;
stall = hazard;

if ~hazard && pcWrite && ifIdWrite && ~idExFlush && ~stall

    fprintf('3. No hazard                 : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('3. No hazard                 : FAIL\n');

end

% =================================================
% TEST 4 - EX instruction is not a load
% =================================================

exRd = 5;
exMemRead = false;

idRs1 = 5;
idRs2 = 2;

hazard = ...
    exMemRead && ...
    exRd ~= 0 && ...
    (idRs1 == exRd || idRs2 == exRd);

pcWrite = ~hazard;
ifIdWrite = ~hazard;
idExFlush = hazard;
stall = hazard;

if ~hazard && pcWrite && ifIdWrite && ~idExFlush && ~stall

    fprintf('4. Non-load dependency       : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('4. Non-load dependency       : FAIL\n');

end

% =================================================
% TEST 5 - x0 must never cause a stall
% =================================================

exRd = 0;
exMemRead = true;

idRs1 = 0;
idRs2 = 0;

hazard = ...
    exMemRead && ...
    exRd ~= 0 && ...
    (idRs1 == exRd || idRs2 == exRd);

pcWrite = ~hazard;
ifIdWrite = ~hazard;
idExFlush = hazard;
stall = hazard;

if ~hazard && pcWrite && ifIdWrite && ~idExFlush && ~stall

    fprintf('5. x0 dependency ignored     : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('5. x0 dependency ignored     : FAIL\n');

end

% =================================================
% TEST 6 - Both source registers hazardous
% =================================================

exRd = 10;
exMemRead = true;

idRs1 = 10;
idRs2 = 10;

hazard = ...
    exMemRead && ...
    exRd ~= 0 && ...
    (idRs1 == exRd || idRs2 == exRd);

pcWrite = ~hazard;
ifIdWrite = ~hazard;
idExFlush = hazard;
stall = hazard;

if hazard && ~pcWrite && ~ifIdWrite && idExFlush && stall

    fprintf('6. Both-source hazard        : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('6. Both-source hazard        : FAIL\n');

end

% =================================================
% TEST 7 - Hazard on rs1 only
% =================================================

exRd = 12;
exMemRead = true;

idRs1 = 12;
idRs2 = 7;

hazard = ...
    exMemRead && ...
    exRd ~= 0 && ...
    (idRs1 == exRd || idRs2 == exRd);

pcWrite = ~hazard;
ifIdWrite = ~hazard;
idExFlush = hazard;
stall = hazard;

if hazard && ~pcWrite && ~ifIdWrite && idExFlush && stall

    fprintf('7. rs1-only hazard           : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('7. rs1-only hazard           : FAIL\n');

end

% =================================================
% TEST 8 - Hazard on rs2 only
% =================================================

exRd = 13;
exMemRead = true;

idRs1 = 7;
idRs2 = 13;

hazard = ...
    exMemRead && ...
    exRd ~= 0 && ...
    (idRs1 == exRd || idRs2 == exRd);

pcWrite = ~hazard;
ifIdWrite = ~hazard;
idExFlush = hazard;
stall = hazard;

if hazard && ~pcWrite && ~ifIdWrite && idExFlush && stall

    fprintf('8. rs2-only hazard           : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('8. rs2-only hazard           : FAIL\n');

end

% =================================================
% TEST 9 - Different destination register
% =================================================

exRd = 20;
exMemRead = true;

idRs1 = 19;
idRs2 = 21;

hazard = ...
    exMemRead && ...
    exRd ~= 0 && ...
    (idRs1 == exRd || idRs2 == exRd);

pcWrite = ~hazard;
ifIdWrite = ~hazard;
idExFlush = hazard;
stall = hazard;

if ~hazard && pcWrite && ifIdWrite && ~idExFlush && ~stall

    fprintf('9. Different destination     : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('9. Different destination     : FAIL\n');

end

% =================================================
% TEST 10 - Load-use stall releases
% =================================================

% First cycle: hazard exists
exRd = 6;
exMemRead = true;

idRs1 = 6;
idRs2 = 3;

hazard1 = ...
    exMemRead && ...
    exRd ~= 0 && ...
    (idRs1 == exRd || idRs2 == exRd);

% Next cycle: load has moved forward
exRd = 6;
exMemRead = false;

hazard2 = ...
    exMemRead && ...
    exRd ~= 0 && ...
    (idRs1 == exRd || idRs2 == exRd);

if hazard1 && ~hazard2

    fprintf('10. Stall release             : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('10. Stall release             : FAIL\n');

end

% ------------------------------------------------
% Hardware summary
% ------------------------------------------------

fprintf('\n');
fprintf('Hardware Hazard Unit:\n');
fprintf('  Detection source : ID/EX + IF/ID\n');
fprintf('  Hazard type      : Load-use RAW\n');
fprintf('  PCWrite          : 0 during stall\n');
fprintf('  IF/IDWrite       : 0 during stall\n');
fprintf('  ID/EXFlush       : 1 during stall\n');
fprintf('  Bubble insertion : Enabled\n');
fprintf('  x0 dependency    : Ignored\n');

fprintf('\n');
fprintf('Tests passed : %d / %d\n', ...
    testsPassed,testsTotal);

if testsPassed == testsTotal

    fprintf('STAGE 22.6 PASSED!\n');

else

    fprintf('STAGE 22.6 FAILED\n');

end

end