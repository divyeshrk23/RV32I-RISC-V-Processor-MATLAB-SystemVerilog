clc;
clear;

fprintf('\n');
fprintf('============================================================\n');
fprintf('             STAGE 12A - SLLI TEST\n');
fprintf('============================================================\n');

program = {
    'ADDI x1, x0, 1'
    'SLLI x2, x1, 15'
    };

fprintf('\n');
fprintf('Program:\n');
fprintf('------------------------------------------------------------\n');

for i = 1:length(program)
    fprintf('%d. %s\n',i,program{i});
end

[registers,pc,halted,~] = cpu(program,10);

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    FINAL RESULTS\n');
fprintf('============================================================\n');

fprintf('\n');
fprintf('x1 = %u\n',registers(2));
fprintf('x2 = 0x%08X\n',registers(3));

expectedX1 = uint32(1);
expectedX2 = uint32(hex2dec('00008000'));

test1 = registers(2) == expectedX1;
test2 = registers(3) == expectedX2;

fprintf('\n');
fprintf('============================================================\n');
fprintf('                    TEST RESULTS\n');
fprintf('============================================================\n');

fprintf('\n');

fprintf('x1 = 1          : ');

if test1
    fprintf('PASS\n');
else
    fprintf('FAIL\n');
end

fprintf('x2 = 0x00008000 : ');

if test2
    fprintf('PASS\n');
else
    fprintf('FAIL\n');
end

fprintf('\n');

if test1 && test2 && halted

    fprintf('********************************************\n');
    fprintf('          STAGE 12A PASSED!                \n');
    fprintf('             SLLI WORKING                  \n');
    fprintf('********************************************\n');

else

    fprintf('********************************************\n');
    fprintf('          STAGE 12A FAILED                 \n');
    fprintf('********************************************\n');

end

fprintf('\n');
fprintf('============================================================\n');