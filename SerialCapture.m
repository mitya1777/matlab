u_size = 4096;

if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
end

sObject = serial( 'COM6', 'BaudRate', 19200, 'TimeOut', 10, 'Terminator', 'LF');
set( sObject, 'Parity', 'none' );

fopen( sObject );

U1 = zeros( 1, u_size );
U2 = zeros( 1, u_size );
U3 = zeros( 1, u_size );

switcher = 0;

while (1)
    rx = fread (sObject, u_size, 'uint16');
    U1(1, switcher) = rx;
    switcher = switcher + 1;
    if switcher == u_size
        switcher = 0;
    break;
    end;
end;

while (1)
    rx = fread (sObject, 1, 'uint16');
    U2(1, switcher) = rx;
    switcher = switcher + 1;
    if switcher == u_size
        switcher = 0;
        break;
    end;
end;

while (1)
    rx = fread (sObject, 1, 'uint16');
    U3(1, switcher) = rx;
    switcher = switcher + 1;
    if switcher == u_size
        switcher = 0;
        break;
    end;
end;
