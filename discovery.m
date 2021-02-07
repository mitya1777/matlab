clear all;
close all;
delete(instrfindall);

u_size = 4096;

discovery_p = serial('COM4');
set(discovery_p, 'InputBufferSize', 8192);
set(discovery_p, 'BaudRate', 19200);
set(discovery_p, 'Timeout', 10);

fopen(discovery_p);
%flush(discovery_link);
%U1 = zeros(1, 1);

U1 = fread(discovery_p, u_size, 'uint16');
U2 = fread(discovery_p, u_size, 'uint16');


% switcher = 1;
% 
% while (1)
%     rx = fread(discovery_p, 1, 'uint16');
%     U1(1, switcher) = rx;
%     switcher = switcher + 1;
%     if switcher == u_size
%         switcher = 0;
%         break;
%     end;
% end;
% 
% while (1)
%     rx = fread(discovery_p, 1, 'uint16');
%     U2(1, switcher) = rx;
%     switcher = switcher + 1;
%     if switcher == u_size
%         switcher = 0;
%         break;
%     end;
% end;