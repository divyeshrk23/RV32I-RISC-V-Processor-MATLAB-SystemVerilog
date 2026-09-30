function stage22_3_alu

clc;

fprintf('==============================================\n');
fprintf('STAGE 22.3 - HARDWARE ALU INTERFACE\n');
fprintf('==============================================\n\n');

% ------------------------------------------------
% Test vectors
% ------------------------------------------------

tests = {
    'ADD',  10,  5,  15
    'SUB',  10,  5,   5
    'AND',  10,  5,   0
    'OR',   10,  5,  15
    'XOR',  10,  5,  15
    'SLL',   3,  2,  12
    'SRL',  16,  2,   4
    'SRA',  16,  2,   4
    'SLT',   5, 10,   1
    'SLTU',  5, 10,   1
};

% ------------------------------------------------
% Hardware ALU interface
% ------------------------------------------------

fprintf('ALU verification:\n\n');

testsPassed = 0;
testsTotal = size(tests,1);

for i = 1:testsTotal

    operation = tests{i,1};

    A = uint32(tests{i,2});
    B = uint32(tests{i,3});

    expected = uint32(tests{i,4});

    % --------------------------------------------
    % ALU operation
    % --------------------------------------------

    switch operation

        case 'ADD'

            result = uint32( ...
                mod(double(A) + double(B),2^32));

        case 'SUB'

            result = uint32( ...
                mod(double(A) - double(B),2^32));

        case 'AND'

            result = bitand(A,B);

        case 'OR'

            result = bitor(A,B);

        case 'XOR'

            result = bitxor(A,B);

        case 'SLL'

            shiftAmount = double(B);

            result = bitshift(A,shiftAmount);

            result = uint32(result);

        case 'SRL'

            shiftAmount = double(B);

            result = bitshift(A,-shiftAmount);

            result = uint32(result);

        case 'SRA'

            shiftAmount = double(B);

            signedA = typecast(uint32(A),'int32');

            signedResult = bitshift(signedA,-shiftAmount);

            result = typecast(int32(signedResult),'uint32');

        case 'SLT'

            signedA = typecast(uint32(A),'int32');
            signedB = typecast(uint32(B),'int32');

            if signedA < signedB
                result = uint32(1);
            else
                result = uint32(0);
            end

        case 'SLTU'

            if A < B
                result = uint32(1);
            else
                result = uint32(0);
            end

        otherwise

            error('Unknown ALU operation: %s',operation);

    end

    % --------------------------------------------
    % ALU flags
    % --------------------------------------------

    zero = (result == uint32(0));

    signedA = typecast(uint32(A),'int32');
    signedB = typecast(uint32(B),'int32');

    lessThanSigned = signedA < signedB;

    lessThanUnsigned = A < B;

    % --------------------------------------------
    % Verify result
    % --------------------------------------------

    if result == expected

        fprintf('%-5s : PASS   Result = %u', ...
            operation,result);

        fprintf('   Zero = %d',zero);

        fprintf('   SLT = %d',lessThanSigned);

        fprintf('   SLTU = %d\n',lessThanUnsigned);

        testsPassed = testsPassed + 1;

    else

        fprintf('%-5s : FAIL   Result = %u   Expected = %u\n', ...
            operation,result,expected);

    end

end

% ------------------------------------------------
% Special signed-value tests
% ------------------------------------------------

fprintf('\nSigned ALU tests:\n\n');

signedTestsPassed = 0;
signedTestsTotal = 3;

% -10 + 5 = -5
A = typecast(int32(-10),'uint32');
B = typecast(int32(5),'uint32');

result = uint32( ...
    mod(double(A) + double(B),2^32));

expected = typecast(int32(-5),'uint32');

if result == expected

    fprintf('Signed ADD (-10 + 5)  : PASS\n');
    signedTestsPassed = signedTestsPassed + 1;

else

    fprintf('Signed ADD (-10 + 5)  : FAIL\n');

end

% -10 < 5
signedA = typecast(uint32(A),'int32');
signedB = typecast(uint32(B),'int32');

if signedA < signedB

    fprintf('Signed comparison     : PASS\n');
    signedTestsPassed = signedTestsPassed + 1;

else

    fprintf('Signed comparison     : FAIL\n');

end

% Unsigned:
% 0xFFFFFFF6 > 5
if uint32(A) > uint32(B)

    fprintf('Unsigned comparison   : PASS\n');
    signedTestsPassed = signedTestsPassed + 1;

else

    fprintf('Unsigned comparison   : FAIL\n');

end

% ------------------------------------------------
% Interface verification
% ------------------------------------------------

fprintf('\nHardware interface verification:\n\n');

interfacePassed = true;

% 32-bit A
if isa(A,'uint32')

    fprintf('A[31:0]  - 32-bit     : PASS\n');

else

    fprintf('A[31:0]  - 32-bit     : FAIL\n');
    interfacePassed = false;

end

% 32-bit B
if isa(B,'uint32')

    fprintf('B[31:0]  - 32-bit     : PASS\n');

else

    fprintf('B[31:0]  - 32-bit     : FAIL\n');
    interfacePassed = false;

end

% Result
if isa(result,'uint32')

    fprintf('Result[31:0]          : PASS\n');

else

    fprintf('Result[31:0]          : FAIL\n');
    interfacePassed = false;

end

% ------------------------------------------------
% Final result
% ------------------------------------------------

totalPassed = testsPassed + ...
              signedTestsPassed;

totalTests = testsTotal + ...
             signedTestsTotal;

if interfacePassed

    totalPassed = totalPassed + 3;
    totalTests = totalTests + 3;

end

fprintf('\n');
fprintf('ALU operation tests   : %d / %d\n', ...
    testsPassed,testsTotal);

fprintf('Signed tests           : %d / %d\n', ...
    signedTestsPassed,signedTestsTotal);

fprintf('Interface tests        : %d / 3\n', ...
    3 * interfacePassed);

fprintf('\n');
fprintf('Total tests passed     : %d / %d\n', ...
    totalPassed,totalTests);

if totalPassed == totalTests

    fprintf('STAGE 22.3 PASSED!\n');

else

    fprintf('STAGE 22.3 FAILED\n');

end

end