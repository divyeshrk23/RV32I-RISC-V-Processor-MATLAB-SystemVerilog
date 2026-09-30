clc;
clear;

fprintf('\n');
fprintf('============================================================\n');
fprintf('        STAGE 10E - REGISTER FILE + ALU TEST\n');
fprintf('============================================================\n');


% ============================================================
% INITIALIZE REGISTER FILE
% ============================================================

registers = zeros(32,1,'uint32');


% ============================================================
% TEST PROGRAM
% ============================================================

program = {

    'ADDI x1, x0, 10'
    'ADDI x2, x0, 20'
    'ADD x3, x1, x2'
    'SUB x4, x3, x1'
    'AND x5, x3, x4'
    'OR x6, x3, x4'

};


% ============================================================
% LOAD PROGRAM
% ============================================================

memory = program_loader(program);


% ============================================================
% EXECUTE EACH INSTRUCTION
% ============================================================

for i = 1:length(memory)

    fprintf('\n');
    fprintf('------------------------------------------------------------\n');
    fprintf('Instruction %d\n',i);

    % --------------------------------------------------------
    % FETCH
    % --------------------------------------------------------

    address = (i-1) * 4;

    instruction = memory(i);

    fprintf('PC          : %d\n',address);
    fprintf('Machine code: 0x%08X\n',instruction);


    % --------------------------------------------------------
    % DECODE
    % --------------------------------------------------------

    decoded = decoder(instruction);

    fprintf('Opcode      : %s\n',decoded.opcode);


    % --------------------------------------------------------
    % READ REGISTERS
    % --------------------------------------------------------

    [readData1,readData2,registers] = register_file( ...
        decoded.rs1, ...
        decoded.rs2, ...
        0, ...
        0, ...
        false, ...
        registers);


    fprintf('Read rs1    : %d\n',readData1);
    fprintf('Read rs2    : %d\n',readData2);


    % --------------------------------------------------------
    % ALU EXECUTION
    % --------------------------------------------------------

    result = alu_execute( ...
        decoded, ...
        readData1, ...
        readData2);


    fprintf('ALU result  : %u\n',result);


    % --------------------------------------------------------
    % WRITE RESULT
    % --------------------------------------------------------

    if decoded.rd ~= 0

        [~,~,registers] = register_file( ...
            0, ...
            0, ...
            decoded.rd, ...
            result, ...
            true, ...
            registers);

        fprintf('Write        : x%d = %u\n', ...
            decoded.rd,result);

    else

        fprintf('Write        : none\n');

    end

end


% ============================================================
% DISPLAY FINAL REGISTERS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('             FINAL REGISTER VALUES\n');
fprintf('============================================================\n');

fprintf('x0 = %u\n',registers(1));
fprintf('x1 = %u\n',registers(2));
fprintf('x2 = %u\n',registers(3));
fprintf('x3 = %u\n',registers(4));
fprintf('x4 = %u\n',registers(5));
fprintf('x5 = %u\n',registers(6));
fprintf('x6 = %u\n',registers(7));


% ============================================================
% VERIFY RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                  RESULT CHECK\n');
fprintf('============================================================\n');


% IMPORTANT:
% registers is a column vector, so expected is also
% deliberately created as a column vector.

expected = [ ...
    0;
    10;
    20;
    30;
    20;
    20;
    30];


actual = registers(1:7);


% ============================================================
% DISPLAY EXPECTED AND ACTUAL
% ============================================================

fprintf('\nExpected:\n');
fprintf('     ');

for i = 1:length(expected)

    fprintf('%6d',expected(i));

end

fprintf('\n');

fprintf('Actual:\n');
fprintf('     ');

for i = 1:length(actual)

    fprintf('%6d',actual(i));

end

fprintf('\n');


% ============================================================
% CHECK
% ============================================================

if isequal(actual,expected)

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('          STAGE 10E PASSED!                \n');
    fprintf('    REGISTER FILE + ALU WORKING            \n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('STAGE 10E FAILED\n');

    fprintf('\nExpected vector:\n');
    disp(expected);

    fprintf('Actual vector:\n');
    disp(actual);

end


fprintf('\n');
fprintf('============================================================\n');