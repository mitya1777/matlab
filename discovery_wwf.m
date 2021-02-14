clear all;
close all;
delete(instrfindall);

u_size = 4092;
reference_voltage = 3.0;

discovery_p = serial('COM4');
set(discovery_p, 'InputBufferSize', 8192);
set(discovery_p, 'BaudRate', 19200);
set(discovery_p, 'Timeout', 10);

fopen(discovery_p);
%flush(discovery_link);
%U1 = zeros(1, 1);

U1 = fread(discovery_p, u_size, 'uint16');
U2 = fread(discovery_p, u_size, 'uint16');

%
%	Bitshifting for 12 bit data resolution
%

U1_adc = zeros(u_size, 1);
U2_adc = zeros(u_size, 1);

 for switcher = 1 : u_size
 	U1_adc(switcher) = bitshift(U1(switcher), - 2);
 	U2_adc(switcher) = bitshift(U2(switcher), - 2);
 end

% delete(U1);
% delete(U2);

%
%	Authentic voltage value calculating
%

U1_r = zeros(u_size, 1);
U2_r = zeros(u_size, 1);

for switcher = 1 : u_size
	U1_r(switcher) = (U1_adc(switcher) ./ 4096) .* reference_voltage;
	U2_r(switcher) = (U2_adc(switcher) ./ 4096) .* reference_voltage;
end

Ucom_r = [U1_r U2_r];
Ucom_c = transpose(Ucom_r);

%
%	Writing tabulated data to a text file
%

fileID = fopen('charging_captured_data.txt', 'w');
% fprintf(fileID,'%7s %12s\n','U1, V','U2, V');
fprintf(fileID,'%7.4f %12.4f\r\n', Ucom_c);
fclose(fileID);

clear switcher U1 U1_adc U1_r U2 U2_adc U2_r;

%
%	Reading tabulated data from a text file
%

fileID = fopen('charging_captured_data.txt', 'r');

Ucom = fscanf(fileID, '%f %f', [2, u_size]);
Ucom = transpose(Ucom);

 U1 = Ucom(:, 1);
 U2 = Ucom(:, 2);