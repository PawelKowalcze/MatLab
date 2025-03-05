function val = fun_bungee( t )
global z0 m c v0 g
val   = -( z0 + m/c*(v0+(m*g)/c)*(1-exp(-(c/m)*t))-((m*g)/c)*t );