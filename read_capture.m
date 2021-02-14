fileID = fopen('charging_captured_data.txt', 'r');
size_buf = [Inf 2];
u_size = 4092;

Ucom = fscanf(fileID, '%f %f', [2, 4193]);
% Ucom = transpose(Ucom);


% U1 = Ucom(:, 1);
% U2 = Ucom(:, 2);