clear;

u_size = 4096;

discovery = serialpot ("COM4", 19200);
flush (discovery);

U1 = zeros( 1, u_size );
U1 = read (discovery, u_size, uint16);

% discovery.U1 = struct ("data", []; "count", 1);