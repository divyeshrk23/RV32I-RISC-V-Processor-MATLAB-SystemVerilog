clc;
clear;

fprintf('\n');
fprintf('============================================================\n');
fprintf('          STAGE 11A - DATA MEMORY TEST\n');
fprintf('============================================================\n');


% ============================================================
% INITIALIZE MEMORY
% ============================================================

memory = zeros(1024,1,'uint8');


% ============================================================
% TEST 1 - STORE WORD
% ============================================================

address = 100;
writeData = uint32(123456789);


fprintf('\n');
fprintf('TEST 1: SW\n');
fprintf('Address    : %d\n',address);
fprintf('Write data : %u\n',writeData);


[~,memory] = data_memory( ...
    address, ...
    writeData, ...
    false, ...
    true, ...
    memory);


fprintf('Stored bytes:\n');

fprintf('Byte 0 : 0x%02X\n',memory(address+1));
fprintf('Byte 1 : 0x%02X\n',memory(address+2));
fprintf('Byte 2 : 0x%02X\n',memory(address+3));
fprintf('Byte 3 : 0x%02X\n',memory(address+4));


% ============================================================
% TEST 2 - LOAD WORD
% ============================================================

fprintf('\n');
fprintf('TEST 2: LW\n');

[readData,memory] = data_memory( ...
    address, ...
    0, ...
    true, ...
    false, ...
    memory);


fprintf('Address   : %d\n',address);
fprintf('Read data : %u\n',readData);


if readData == writeData

    fprintf('PASS\n');

else

    fprintf('FAIL\n');

end


% ============================================================
% TEST 3 - SECOND ADDRESS
% ============================================================

address2 = 200;
writeData2 = uint32(hex2dec('DEADBEEF'));


fprintf('\n');
fprintf('TEST 3: SW/LW with hexadecimal data\n');
fprintf('Address    : %d\n',address2);
fprintf('Write data : 0x%08X\n',writeData2);


[~,memory] = data_memory( ...
    address2, ...
    writeData2, ...
    false, ...
    true, ...
    memory);


[readData2,memory] = data_memory( ...
    address2, ...
    0, ...
    true, ...
    false, ...
    memory);


fprintf('Read data  : 0x%08X\n',readData2);


if readData2 == writeData2

    fprintf('PASS\n');

else

    fprintf('FAIL\n');

end


% ============================================================
% FINAL RESULT
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('          STAGE 11A - TEST COMPLETE\n');
fprintf('============================================================\n');

if readData == writeData && readData2 == writeData2

    fprintf('\n');
    fprintf('********************************************\n');
    fprintf('          STAGE 11A PASSED!                \n');
    fprintf('        DATA MEMORY WORKING                 \n');
    fprintf('********************************************\n');

else

    fprintf('\n');
    fprintf('STAGE 11A FAILED\n');

end

fprintf('\n');
fprintf('============================================================\n');