a=fi( 1.625,0,8,7),
a.bin,
b=fi( 0.375,0,8,7),
b.bin,
c=fi( 0.375,1,8,7),
c.bin,
d=fi(-0.375,1,8,7),
d.bin,


format long 
fractional_part = pi - floor(pi),
e = fi(fractional_part,0,8,6)
tmp = e,
pi,
pi - tmp,
e.bin,



f = fi(fractional_part,1,8,6) 
f.bin,
pi - f,
g = fi(fractional_part,0,16,14)
g.bin,
pi - g,
h = fi(fractional_part,1,16,14)
h.bin,
pi - h,

