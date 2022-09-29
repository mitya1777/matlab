%
%   Calculation the time overheads that spend within the whole transmit
%   process in a Linear Wireless Sensor Network (LSN)
%

% operation zone data
Z = 64e3;                         %   the full operation distance, m
k = 30 : 1 : 100;                 %   sensor node quantity

% comunication parameters
f_b = 433e6;                      %   carier frequency, Hz
V_em = 3e8;                       %   speed of light in vacuum, m/s
P_tr = 100e-3;                    %   transmitter power, W
SNR = -121;                       %   declared sensitivity, dBm
Strn = 200;                       %   noise srength coefficient
R_uart = 115200;                  %   RS-485 interface bit rate (symbol speed), kbit/s
R_rfm   = 9.6e3;                  %   radio-frequency module bit rate (symbol speed), kbit/s
G_rc = 1.0;                       %   the gain of the receiving antenna
G_tr = 1.0;                       %   the gain of the transmitting antenna
ef = 5;

% message values
V_pra  = 4 .* 8;                 %   preamble size
V_sync = 4 .* 8;                 %   synchronization word size
V_len  = 1 .* 8;                 %   data packet length
V_data = 25 .* 8;                %   data packet size
V_crc  = 4 .* 8;                 %   CRC size
V_ack  = 2 .* 8;                 %   acknowledgement size

V_tx = V_pra + V_sync + V_len + V_data + V_crc;
V_rx = 0.6 .* V_pra + V_sync + V_len + V_data + V_crc;

% MCU parameters
f_clk = 48e6;
T_clk = 1 ./ f_clk;

N_rx_sys = 15913;
N_tx_sys = 16737;

% recieve radio communication time expenses
T_intr = 0.33e-6;                %   interrupt time
T_mcu_rx = T_clk .* N_rx_sys;    %   MCU processing time
T_rf_rx = V_rx ./ R_rfm;
T_rx = T_intr + T_rf_rx + T_mcu_rx;

% transmit radio communication time expenses
T_mcu_tx = T_clk .* N_tx_sys;    %   MCU processing time
T_rf_tx = V_tx ./ R_rfm;
T_tx = T_rf_tx + T_mcu_tx;

% UART communication time expenses
T_uart_tx = V_tx ./ R_uart;
T_uart_rx = V_rx ./ R_uart;
T_uart = T_uart_rx + T_uart_tx;

% transmit radio communication time expenses
T_rf_tx = V_tx ./ R_rfm;

% the resultative time expenses
T_rep = T_rx + T_tx + T_uart;

l_ij = Z ./ (k + 1);
P_rc = (P_tr .* G_tr .* G_rc .* V_em.^2) ./ (4 .* pi .* l_ij .* f_b).^2;

P_rx_max = P_tr .* 10.^(SNR ./ 10);
P_n = Strn .* P_rx_max;

h2 = P_rc ./ P_n;
p_ber_ij = 0.5 .* exp(-h2);

T_rep = k .* T_rep .* (1 ./ ((1 - p_ber_ij).^(V_tx)));

p = plot(k, T_rep, 'r');
p(1).LineWidth = 2;
hold on;
grid on;

%syms T_ij k T_rep p_ber_ij V_tx V_rx;
%T_f = k .* T_rep .* (1 ./ (((1 - p_ber_ij).^V_tx) .* ((1 - p_ber_ij).^V_rx)));
%pretty(T_f);
