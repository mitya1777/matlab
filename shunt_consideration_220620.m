R_sh = [0.1: 0.1: 2e3];
i_load = [10e-6: 10e-6: 200e-3];
i_load = i_load';
U_sh = R_sh .* i_load;

surf(U_sh);


