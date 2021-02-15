W = 1;
R = 40;
C = 1;

%//i = (-U + sqrt(U.^2 + 4 * R * W)) / 2 * R;

% //plot(U, i, "+");
% //t = ((-U * log((sqrt(4 * R * W + U^2) - U)) - U + sqrt( 4 * R * W + U^2) * log((sqrt( 4 * R * W + U^2) - U))) / (-1*(sqrt(4 * R * W + U^2) - U)) + (log(4 * R * W)) / 2) * ( R * C);

% //------------------------------------------------------------------------------
Umax = 5;
Esuper = 5;

for U = 1 : 0.5 : Umax
    
    k = sqrt(4 * R * W + U^2);                                                                      %//вспомогательная
    f = k - U;                                                                                      %//(sqrt(4*R*W+U^2)-U)%//вспомогательная
    
    t = ((-U * log(f) - U + k * log(f)) / (-1 * f) + (log( 4 * R * W)) / 2) * (R * C);
    subplot(3, 1, 1), plot(t, U, "+");  
    title("Capacitor voltage, V", "fontsize", 4);                                                   %// как быстро нарастает Uc при заданной мощности
    xlabel("time, s", "fontsize" ,3);
    ylabel("Voltage, V", "fontsize", 3);
    
    Wc = U * ((-U + sqrt(U^2 + 4 * R * W)) / (2 * R));
    subplot(3, 1, 2);
    plot(U, Wc, "+");                                                                               %// зависимость мощности заряда от Uc
    title("Charge capacitor power", "fontsize", 4);                                                 %// как быстро нарастает Uc при заданной мощности
    xlabel("Voltage, V", "fontsize", 3);
    ylabel("Power, W", "fontsize", 3);
    
    E = U + sqrt((W - Wc) * R);
    subplot(3, 1, 3);
    plot(U, E, "+");                                                                                %// напряжение на "преобразователе" от напряжения Uc
    title("Source output voltage, V", "fontsize", 4);                                               %// как быстро нарастает Uc при заданной мощности
    xlabel("Capacitor output voltage", "fontsize" ,3);
    ylabel("Source voltage, V", "fontsize", 3);
    
    t = -log(1 - U / Esuper) * R * C;
    subplot(3, 1, 1);
    plot(t, U, ".")                                                                                 %// как быстро нарастает Uc при фиксированном ЭДС
end

%//------------------------------------------------------------------------------

W = 0.1;

for U1 = 1: 0.5: Umax
    
    k = sqrt(4 * R * W + U^2)                                                                       %//вспомогательная
    f=k-U%//(sqrt(4*R*W+U^2)-U)%//вспомогательная
    
    t1 = ((-U * log(f) - U + k * log(f)) / (-1 * f) + log( 4 * R * W) / 2) * (R * C);
    subplot(3, 1, 1);
    plot(t1, U, "o")                                                                                %// как быстро нарастает Uc при заданной мощности
    hl = legend(['cos(t)', "+"; 'cos(2 * t)', "."; 'cos(3 * t)', "o"], 3);
    
    Wc = U * ((-U + sqrt(U^2 + 4 * R * W)) / (2 * R));
    subplot(3, 1, 2);
    plot(U, Wc, "o")                                                                                %// зависимость мощности заряда от Uc 
    
    E = U + sqrt((W - Wc) * R);
    subplot(3, 1, 3);
    plot(U, E, "o")                                                                                 %// напряжение на "преобразователе" от напряжения Uc

end

%//------------------------------------------------------------------------------