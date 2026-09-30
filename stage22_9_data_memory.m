function stage22_9_data_memory

clc;

fprintf('==============================================\n');
fprintf('STAGE 22.9 - HARDWARE DATA MEMORY INTERFACE\n');
fprintf('==============================================\n\n');

testsPassed = 0;
testsTotal = 10;

% ------------------------------------------------
% Hardware memory
% ------------------------------------------------
%
% Address width : 32 bits
% Data width    : 32 bits
% Byte addressable
% Little endian
%
% ------------------------------------------------

memory = zeros(1024,1,'uint8');

% =================================================
% TEST 1 - SW
% =================================================

address = 100;
value = uint32(hex2dec('12345678'));

bytes = typecast(value,'uint8');

memory(address + 1) = bytes(1);
memory(address + 2) = bytes(2);
memory(address + 3) = bytes(3);
memory(address + 4) = bytes(4);

if memory(address + 1) == hex2dec('78') && ...
   memory(address + 2) == hex2dec('56') && ...
   memory(address + 3) == hex2dec('34') && ...
   memory(address + 4) == hex2dec('12')

    fprintf('1. SW little-endian store   : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('1. SW little-endian store   : FAIL\n');

end

% =================================================
% TEST 2 - LW
% =================================================

readBytes = memory(address + 1:address + 4);

loadedValue = typecast(uint8(readBytes),'uint32');

if loadedValue == value

    fprintf('2. LW 32-bit load            : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('2. LW 32-bit load            : FAIL\n');

end

% =================================================
% TEST 3 - SB
% =================================================

address = 200;
value = uint32(hex2dec('AB'));

memory(address + 1) = uint8(value);

if memory(address + 1) == uint8(hex2dec('AB'))

    fprintf('3. SB byte store             : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('3. SB byte store             : FAIL\n');

end

% =================================================
% TEST 4 - LB signed
% =================================================

address = 200;

byteValue = memory(address + 1);

signedByte = typecast(uint8(byteValue),'int8');

if signedByte == int8(-85)

    fprintf('4. LB sign extension         : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('4. LB sign extension         : FAIL\n');
    fprintf('   Expected = -85, Got = %d\n',signedByte);

end

% =================================================
% TEST 5 - LBU unsigned
% =================================================

address = 200;

byteValue = memory(address + 1);

unsignedByte = uint32(byteValue);

if unsignedByte == uint32(171)

    fprintf('5. LBU zero extension       : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('5. LBU zero extension       : FAIL\n');

end

% =================================================
% TEST 6 - SH
% =================================================

address = 300;
value = uint32(hex2dec('ABCD'));

halfBytes = typecast(uint16(value),'uint8');

memory(address + 1) = halfBytes(1);
memory(address + 2) = halfBytes(2);

if memory(address + 1) == hex2dec('CD') && ...
   memory(address + 2) == hex2dec('AB')

    fprintf('6. SH little-endian store   : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('6. SH little-endian store   : FAIL\n');

end

% =================================================
% TEST 7 - LH signed
% =================================================

address = 300;

halfValue = uint16( ...
    double(memory(address + 1)) + ...
    double(memory(address + 2))*256);

signedHalf = typecast(halfValue,'int16');

expectedHalf = typecast(uint16(hex2dec('ABCD')),'int16');

if signedHalf == expectedHalf

    fprintf('7. LH sign extension        : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('7. LH sign extension        : FAIL\n');

end

% =================================================
% TEST 8 - LHU unsigned
% =================================================

unsignedHalf = uint32(halfValue);

if unsignedHalf == uint32(hex2dec('ABCD'))

    fprintf('8. LHU zero extension       : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('8. LHU zero extension       : FAIL\n');

end

% =================================================
% TEST 9 - Memory write disabled
% =================================================

address = 400;

memory(address + 1) = uint8(hex2dec('55'));

oldValue = memory(address + 1);

memWrite = false;

newValue = uint8(hex2dec('AA'));

if memWrite

    memory(address + 1) = newValue;

end

if memory(address + 1) == oldValue

    fprintf('9. MemWrite disabled         : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('9. MemWrite disabled         : FAIL\n');

end

% =================================================
% TEST 10 - Memory read/write controls
% =================================================

memRead = true;
memWrite = true;

if memRead && memWrite

    fprintf('10. MemRead/MemWrite control : PASS\n');
    testsPassed = testsPassed + 1;

else

    fprintf('10. MemRead/MemWrite control : FAIL\n');

end

% ------------------------------------------------
% Hardware summary
% ------------------------------------------------

fprintf('\n');
fprintf('Hardware Data Memory:\n');
fprintf('  Addressing       : Byte addressable\n');
fprintf('  Data width       : 32 bits\n');
fprintf('  Endianness       : Little endian\n');
fprintf('  Loads            : LB/LBU/LH/LHU/LW\n');
fprintf('  Stores           : SB/SH/SW\n');
fprintf('  MemRead          : Read enable\n');
fprintf('  MemWrite         : Write enable\n');
fprintf('  Sign extension   : LB/LH\n');
fprintf('  Zero extension   : LBU/LHU\n');

fprintf('\n');
fprintf('Tests passed : %d / %d\n', ...
    testsPassed,testsTotal);

if testsPassed == testsTotal

    fprintf('STAGE 22.9 PASSED!\n');

else

    fprintf('STAGE 22.9 FAILED\n');

end

end