%
%   Calculation the time overheads that spend within the whole transmit
%   process in a Linear Wireless Sensor Network (LSN)
%   for ARQ protocols with infinite repeat sending
%

% operation zone data
z_i = 15e3;                       %   the full operation distance, m
x_i = 5 : 1 : 65;                 %   sensor node quantity

% comunication parameters
f_b = 433e6;                      %   carier frequency, Hz
V_em = 3e8;                       %   speed of light in vacuum, m/s
P_tr = 100e-3;                    %   transmitter power, W
SNR = -121;                       %   declared sensitivity, dBm
Strn = 45;                        %   noise srength coefficient
R_uart = 19.2e3;                  %   RS-485 interface bit rate (symbol speed), kbit/s
R_rfm  = 19.2e3;                  %   radio-frequency module bit rate (symbol speed), kbit/s
G_rc = 1.0;                       %   the gain of the receiving antenna
G_tr = 1.0;                       %   the gain of the transmitting antenna
fading = [5 10 20 40 100]';

% message values
V_pra  = 4 .* 8;                 %   preamble size
V_sync = 4 .* 8;                 %   synchronization word size
V_start = 1 .* 8;                %   start comdition
V_len  = 1 .* 8;                 %   data packet length
V_data = 25 .* 8;                %   data packet size
V_crc  = 4 .* 8;                 %   CRC size
V_stop = 1 .* 8;                 %   stop comdition
V_ack_d  = 2 .* 8;               %   acknowledgement data size

V_tx = V_pra + V_sync + V_start + V_len + V_data + V_crc + V_stop;
V_rx = round(0.6 .* V_pra + V_sync + V_start + V_len + V_data + V_crc + V_stop);
V_ack = V_pra + V_sync + V_start + V_len + V_ack_d + V_crc + V_stop;

% MCU parameters
f_clk = 48e6;
T_clk = 1 ./ f_clk;
N_rx_sys = 15913;
N_tx_sys = 16737;
t_intr = 0.33e-6;                %   interrupt time

% additive time expenses part
t_data = 1.75e-3;                %   data sensors gathering
t_mcu_tx = T_clk .* N_tx_sys;    %   MCU processing time

t_add = t_data + t_mcu_tx;

%! multiplicative time expenses part
% recieve radio communication time expenses
t_rf_rx = V_rx ./ R_rfm;
t_mcu_rx = T_clk .* N_rx_sys;    %   MCU processing time
t_uart_rx = V_rx ./ R_uart;

t_rx = t_intr + t_rf_rx + t_mcu_rx + t_uart_rx;

% acknowledgement transmit radio communication time expenses
t_uart_ack = V_ack ./ R_uart;
t_rf_ack = V_ack ./ R_rfm;

t_ack = t_mcu_tx + t_uart_ack + t_rf_ack;

% data transmit radio communication time expenses
t_rf_tx = V_tx ./ R_rfm;
t_uart_tx = V_tx ./ R_uart;
t_tx = t_rf_tx + t_uart_tx;

t_mlt = t_rx + t_tx + t_ack;

% the resultative time expenses

d_i = z_i ./ (x_i + 1);
P_rc = (P_tr .* G_tr .* G_rc .* V_em.^2) ./ (4 .* pi .* d_i .* f_b).^2;

P_rx_max = 10.^(SNR ./ 10 - 3);
P_n = P_rx_max .* 10.^(Strn/10);

h2 = P_rc ./ P_n;

for i = fading(1 : 1 : 5)

p_ber_i = ((fading + 1) ./ (h2 + 2 .* fading + 2)) .* exp(-((fading .*  h2) ./ (h2 + 2 .* fading + 2)));
t_del_i = t_add + x_i .* t_mlt .* (1 ./ ((1 - p_ber_i).^(V_tx + V_ack)));

p = plot(x_i, t_del_i);
p(1).LineWidth = 2;
hold on;
grid on;

end

%syms t_del_i x_i t_add t_mlt p_ber_i V_tx V_ack;
%t_del_i = t_add + x_i .* t_mlt .* (1 ./ ((1 - p_ber_i).^(V_tx + V_ack)));
%pretty(t_del_i);