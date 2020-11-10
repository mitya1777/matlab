
%instrfind;

sObject = serial( 'COM6', 'BaudRate', 19200, 'TimeOut', 10, 'Terminator', 'LF');
set( sObject, 'Parity', 'none' );

fclose ( sObject );
fopen( sObject );

U1(4096);
U2(4096);
U3(4096);

switcher = 0;

while (1)
    rx = fread (sObject, 1, 'uint16');
    U1(switcher) = rx;
    switcher = switcher + 1;
    if switcher == 4096
        switcher = 0;
        break;
    end;
end;

while (1)
    rx = fread (sObject, 1, 'uint16');
    U2(switcher) = rx;
    switcher = switcher + 1;
    if switcher == 4096
        switcher = 0;
        break;
    end;
end;

while (1)
    rx = fread (sObject, 1, 'uint16');
    U3(switcher) = rx;
    switcher = switcher + 1;
    if switcher == 4096
        switcher = 0;
        break;
    end;
end;
