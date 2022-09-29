%
%   Calculation the time overheads that spend within the whole transmit
%   process in a Linear Wireless Sensor Network (LSN)
%

% operation zone data
Z = 64e3;                         %   the full operation distance, m
k = 40 : 1 : 100;                 %   sensor node quantity

% comunication parameters
f_b = 868e6;                      %   carier frequency, Hz
V_em = 3e8;                       %   speed of light in vacuum, m/s
P_tr = 100e-3;                    %   transmitter power, W
SNR = -121;                       %   declared sensitivity, dBm
Strn = 100;                       %   noise srength coefficient
R_rs485 = 115200;                  %   RS-485 interface bit rate (symbol speed), kbit/s
R_rfm   = 9.6e3;                  %   radio-frequency module bit rate (symbol speed), kbit/s
G_rc = 1.0;                       %   the gain of the receiving antenna
G_tr = 1.0;                       %   the gain of the transmitting antenna 

% message values
V_pra  = 4 .* 8;                 %   preamble size
V_sync = 4 .* 8;                 %   synchronization word size
V_len  = 1 .* 8;                 %   data packet length
V_data = 25 .* 8;                %   data packet size
V_crc  = 4 .* 8;                 %   CRC size
V_ack  = 2 .* 8;                 %   acknowledgement size

V_tx = V_pra + V_sync + V_len + V_data + V_crc;
V_rx = 0.6 .* V_pra + V_sync + V_len + V_data + V_crc;
V_ack_f = V_pra + V_sync + V_len + V_ack + V_crc;

% transmit radio communication time expenses
T_intr = 0.75e-6;                %   interrupt time
T_crc_rx = 0.197e-3;             %   CRC calculation time
T_rf_rx = V_rx ./ R_rfm;
T_rf_rx = T_intr + T_crc_rx + T_rf_rx;

% acknowledgement transmit time expenses
T_ack_tx = V_ack_f ./ R_rfm;

% MCU time expenses
T_dg  = 20e-3;                   %   sensors data gathering
T_af  = 32.1e-6;                 %   array forming time
T_crc_tx = 0.183e-3;             %   CRC calculation time
T_mcu = T_dg + T_af + T_crc_tx;

% RS-485 communication time expenses
T_rs485_tx = V_tx ./ R_rs485;
T_rs485_rx = V_rx ./ R_rs485;
T_rs485_ack = V_ack_f ./ R_rs485;
T_rs485 = T_rs485_tx + T_rs485_rx + T_rs485_ack;

% transmit radio communication time expenses
T_rf_tx = V_tx ./ R_rfm;

% the resultative time expenses
T_rep = T_rf_rx + T_ack_tx + T_mcu + T_rs485 + T_rf_tx;

l_ij = Z ./ (k + 1);
P_rc = (P_tr .* G_tr .* G_rc .* V_em.^2) ./ (4 .* pi .* l_ij .* f_b).^2;

P_rx_max = P_tr .* 10.^(SNR ./ 10);
P_n = Strn .* P_rx_max;

h2 = P_rc ./ P_n;
p_ber_ij = 0.5 .* exp(-h2);

T_rep = k .* T_rep .* (1 ./ ((1 - p_ber_ij).^(V_tx + V_ack_f)));

p = plot(k, T_rep, 'r');
p(1).LineWidth = 2;
hold on;
grid on;

%syms T_ij k T_rep p_ber_ij V_tx V_rx;
%T_f = k .* T_rep .* (1 ./ (((1 - p_ber_ij).^V_tx) .* ((1 - p_ber_ij).^V_rx)));
%pretty(T_f);
