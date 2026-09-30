function stage22_7_forwarding_unit

clc;

fprintf('==============================================\n');
fprintf('STAGE 22.7 - HARDWARE FORWARDING UNIT\n');
fprintf('==============================================\n\n');

testsPassed = 0;
testsTotal = 10;

% ------------------------------------------------
% Forwarding encoding
%
% ForwardA / ForwardB:
%
% 0 = Register File
% 1 = EX/MEM
% 2 = MEM/WB
%
% ------------------------------------------------

% =================================================
% TEST 1 - No forwarding
% =================================================

idExRs1 = 1;
idExRs2 = 2;

exMemRd = 5;
exMemRegWrite = false;

memWbRd = 6;
memWbRegWrite = false;

forwardA = 0;
forwardB = 0;

if idExRs1 ~= 0

    if exMemRegWrite && exMemRd ~= 0 && ...
            idExRs1 == exMemRd

        forwardA = 1;

    elseif memWbRegWrite && memWbRd ~= 0 && ...
            idExRs1 == memWbRd

        forwardA = 2;

    end

end

if idExRs2 ~= 0

    if exMemRegWrite && exMemRd ~= 0 && ...
            idExRs2 == exMemRd

        forwardB = 1;

    elseif memWbRegWrite && memWbRd ~= 0 && ...
            idExRs2 == memWbRd

        forwardB = 2;

    end

end

if forwardA == 0 && forwardB == 0

    fprintf('1. No forwarding             : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('1. No forwarding             : FAIL\n');

end

% =================================================
% TEST 2 - EX/MEM -> EX on rs1
% =================================================

idExRs1 = 5;
idExRs2 = 2;

exMemRd = 5;
exMemRegWrite = true;

memWbRd = 8;
memWbRegWrite = true;

forwardA = 0;
forwardB = 0;

if idExRs1 ~= 0

    if exMemRegWrite && exMemRd ~= 0 && ...
            idExRs1 == exMemRd

        forwardA = 1;

    elseif memWbRegWrite && memWbRd ~= 0 && ...
            idExRs1 == memWbRd

        forwardA = 2;

    end

end

if idExRs2 ~= 0

    if exMemRegWrite && exMemRd ~= 0 && ...
            idExRs2 == exMemRd

        forwardB = 1;

    elseif memWbRegWrite && memWbRd ~= 0 && ...
            idExRs2 == memWbRd

        forwardB = 2;

    end

end

if forwardA == 1 && forwardB == 0

    fprintf('2. EX/MEM -> EX rs1          : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('2. EX/MEM -> EX rs1          : FAIL\n');

end

% =================================================
% TEST 3 - EX/MEM -> EX on rs2
% =================================================

idExRs1 = 2;
idExRs2 = 7;

exMemRd = 7;
exMemRegWrite = true;

memWbRd = 9;
memWbRegWrite = true;

forwardA = 0;
forwardB = 0;

if idExRs1 ~= 0

    if exMemRegWrite && exMemRd ~= 0 && ...
            idExRs1 == exMemRd

        forwardA = 1;

    elseif memWbRegWrite && memWbRd ~= 0 && ...
            idExRs1 == memWbRd

        forwardA = 2;

    end

end

if idExRs2 ~= 0

    if exMemRegWrite && exMemRd ~= 0 && ...
            idExRs2 == exMemRd

        forwardB = 1;

    elseif memWbRegWrite && memWbRd ~= 0 && ...
            idExRs2 == memWbRd

        forwardB = 2;

    end

end

if forwardA == 0 && forwardB == 1

    fprintf('3. EX/MEM -> EX rs2          : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('3. EX/MEM -> EX rs2          : FAIL\n');

end

% =================================================
% TEST 4 - MEM/WB -> EX on rs1
% =================================================

idExRs1 = 10;
idExRs2 = 2;

exMemRd = 5;
exMemRegWrite = true;

memWbRd = 10;
memWbRegWrite = true;

forwardA = 0;
forwardB = 0;

if idExRs1 ~= 0

    if exMemRegWrite && exMemRd ~= 0 && ...
            idExRs1 == exMemRd

        forwardA = 1;

    elseif memWbRegWrite && memWbRd ~= 0 && ...
            idExRs1 == memWbRd

        forwardA = 2;

    end

end

if idExRs2 ~= 0

    if exMemRegWrite && exMemRd ~= 0 && ...
            idExRs2 == exMemRd

        forwardB = 1;

    elseif memWbRegWrite && memWbRd ~= 0 && ...
            idExRs2 == memWbRd

        forwardB = 2;

    end

end

if forwardA == 2 && forwardB == 0

    fprintf('4. MEM/WB -> EX rs1          : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('4. MEM/WB -> EX rs1          : FAIL\n');

end

% =================================================
% TEST 5 - MEM/WB -> EX on rs2
% =================================================

idExRs1 = 2;
idExRs2 = 11;

exMemRd = 5;
exMemRegWrite = true;

memWbRd = 11;
memWbRegWrite = true;

forwardA = 0;
forwardB = 0;

if idExRs1 ~= 0

    if exMemRegWrite && exMemRd ~= 0 && ...
            idExRs1 == exMemRd

        forwardA = 1;

    elseif memWbRegWrite && memWbRd ~= 0 && ...
            idExRs1 == memWbRd

        forwardA = 2;

    end

end

if idExRs2 ~= 0

    if exMemRegWrite && exMemRd ~= 0 && ...
            idExRs2 == exMemRd

        forwardB = 1;

    elseif memWbRegWrite && memWbRd ~= 0 && ...
            idExRs2 == memWbRd

        forwardB = 2;

    end

end

if forwardA == 0 && forwardB == 2

    fprintf('5. MEM/WB -> EX rs2          : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('5. MEM/WB -> EX rs2          : FAIL\n');

end

% =================================================
% TEST 6 - Both operands forwarded
% =================================================

idExRs1 = 5;
idExRs2 = 7;

exMemRd = 5;
exMemRegWrite = true;

memWbRd = 7;
memWbRegWrite = true;

forwardA = 0;
forwardB = 0;

if idExRs1 ~= 0

    if exMemRegWrite && exMemRd ~= 0 && ...
            idExRs1 == exMemRd

        forwardA = 1;

    elseif memWbRegWrite && memWbRd ~= 0 && ...
            idExRs1 == memWbRd

        forwardA = 2;

    end

end

if idExRs2 ~= 0

    if exMemRegWrite && exMemRd ~= 0 && ...
            idExRs2 == exMemRd

        forwardB = 1;

    elseif memWbRegWrite && memWbRd ~= 0 && ...
            idExRs2 == memWbRd

        forwardB = 2;

    end

end

if forwardA == 1 && forwardB == 2

    fprintf('6. Both operands forwarded   : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('6. Both operands forwarded   : FAIL\n');

end

% =================================================
% TEST 7 - EX/MEM priority over MEM/WB
% =================================================

idExRs1 = 5;
idExRs2 = 2;

exMemRd = 5;
exMemRegWrite = true;

memWbRd = 5;
memWbRegWrite = true;

forwardA = 0;

if idExRs1 ~= 0

    if exMemRegWrite && exMemRd ~= 0 && ...
            idExRs1 == exMemRd

        forwardA = 1;

    elseif memWbRegWrite && memWbRd ~= 0 && ...
            idExRs1 == memWbRd

        forwardA = 2;

    end

end

if forwardA == 1

    fprintf('7. EX/MEM priority           : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('7. EX/MEM priority           : FAIL\n');

end

% =================================================
% TEST 8 - x0 must not forward
% =================================================

idExRs1 = 0;
idExRs2 = 0;

exMemRd = 0;
exMemRegWrite = true;

memWbRd = 0;
memWbRegWrite = true;

forwardA = 0;
forwardB = 0;

if idExRs1 ~= 0

    if exMemRegWrite && exMemRd ~= 0 && ...
            idExRs1 == exMemRd

        forwardA = 1;

    elseif memWbRegWrite && memWbRd ~= 0 && ...
            idExRs1 == memWbRd

        forwardA = 2;

    end

end

if idExRs2 ~= 0

    if exMemRegWrite && exMemRd ~= 0 && ...
            idExRs2 == exMemRd

        forwardB = 1;

    elseif memWbRegWrite && memWbRd ~= 0 && ...
            idExRs2 == memWbRd

        forwardB = 2;

    end

end

if forwardA == 0 && forwardB == 0

    fprintf('8. x0 not forwarded          : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('8. x0 not forwarded          : FAIL\n');

end

% =================================================
% TEST 9 - RegWrite disabled
% =================================================

idExRs1 = 5;
idExRs2 = 7;

exMemRd = 5;
exMemRegWrite = false;

memWbRd = 7;
memWbRegWrite = false;

forwardA = 0;
forwardB = 0;

if idExRs1 ~= 0

    if exMemRegWrite && exMemRd ~= 0 && ...
            idExRs1 == exMemRd

        forwardA = 1;

    elseif memWbRegWrite && memWbRd ~= 0 && ...
            idExRs1 == memWbRd

        forwardA = 2;

    end

end

if idExRs2 ~= 0

    if exMemRegWrite && exMemRd ~= 0 && ...
            idExRs2 == exMemRd

        forwardB = 1;

    elseif memWbRegWrite && memWbRd ~= 0 && ...
            idExRs2 == memWbRd

        forwardB = 2;

    end

end

if forwardA == 0 && forwardB == 0

    fprintf('9. RegWrite disabled         : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('9. RegWrite disabled         : FAIL\n');

end

% =================================================
% TEST 10 - Independent forwarding paths
% =================================================

idExRs1 = 14;
idExRs2 = 15;

exMemRd = 15;
exMemRegWrite = true;

memWbRd = 14;
memWbRegWrite = true;

forwardA = 0;
forwardB = 0;

if idExRs1 ~= 0

    if exMemRegWrite && exMemRd ~= 0 && ...
            idExRs1 == exMemRd

        forwardA = 1;

    elseif memWbRegWrite && memWbRd ~= 0 && ...
            idExRs1 == memWbRd

        forwardA = 2;

    end

end

if idExRs2 ~= 0

    if exMemRegWrite && exMemRd ~= 0 && ...
            idExRs2 == exMemRd

        forwardB = 1;

    elseif memWbRegWrite && memWbRd ~= 0 && ...
            idExRs2 == memWbRd

        forwardB = 2;

    end

end

if forwardA == 2 && forwardB == 1

    fprintf('10. Independent paths        : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('10. Independent paths        : FAIL\n');

end

% ------------------------------------------------
% Hardware summary
% ------------------------------------------------

fprintf('\n');
fprintf('Hardware Forwarding Unit:\n');
fprintf('  ForwardA = 0 : Register File\n');
fprintf('  ForwardA = 1 : EX/MEM\n');
fprintf('  ForwardA = 2 : MEM/WB\n');
fprintf('  ForwardB = 0 : Register File\n');
fprintf('  ForwardB = 1 : EX/MEM\n');
fprintf('  ForwardB = 2 : MEM/WB\n');
fprintf('  EX/MEM priority over MEM/WB\n');
fprintf('  x0 forwarding disabled\n');

fprintf('\n');
fprintf('Tests passed : %d / %d\n', ...
    testsPassed,testsTotal);

if testsPassed == testsTotal

    fprintf('STAGE 22.7 PASSED!\n');

else

    fprintf('STAGE 22.7 FAILED\n');

end

end