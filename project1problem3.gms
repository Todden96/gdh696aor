sets
v 'ships' /v1*v5/
p 'ports' /Singapore, Incheon, Shanghai, Sydney, Gladstone, Dalian, Osaka, Victoria/
h1(p) 'incompt' /Singapore, Osaka/
h2(p) 'incompt' /Incheon, Victoria/
r 'routes' /Asia, ChinaPacific/;

Parameters
f(v) 'costs' /v1 65, v2 60, v3 92, v4 100, v5 110/
g(v) '#sailing days' /v1 300, v2 250, v3 350, v4 330, v5 300/
d(p) '#visits of ports' /Singapore 15, Incheon 18, Shanghai 32, Sydney 32, Gladstone 45, Dalian 32, Osaka 15, Victoria 18/
;

*Days needed for every ship to complete a route
Table A(v,r)
    Asia    ChinaPacific
v1  14.4    21.2
v2  13.0    20.7
v3  14.4    20.6
v4  13.0    19.2
v5  12.0    20.1
;

*Costs for every ship to sail a route
Table B(v,r)
    Asia    ChinaPacific
v1  1.41    1.9
v2  3.0     1.5
v3  0.4     0.8
v4  0.5     0.7
v5  0.7     0.8
;

*Ports of both routes
Table C(p,r)
            Asia    ChinaPacific
Singapore   1       0
Incheon     1       0
Shanghai    1       1
Sydney      0       1
Gladstone   0       1
Dalian      1       1
Osaka       1       0
Victoria    0       1
;

Binary Variables
y(p) 'If we choose to visit port P'
z(v) 'If we choose ship v'
;

Integer Variables
x(v,r)
;

Variables
xi
;

Scalar
k /5/
;

Equations 
cost
useofv(v)
dealreq
incompt1
incompt2
yearlyvisit(p)
yearlymain(v)
;

*Objective function
cost .. xi =e= sum(v, f(v)*z(v)) + sum((r,v), B(v,r)*x(v,r));

*Which ships do we use
useofv(v) .. z(v)*10000 =g= sum(r, x(v,r));

*The minimal ports to serve considering contract
dealreq .. sum(p, y(p)) =g= k;

*The first incompatible port pair
incompt1 .. sum(h1(p), y(p)) =l= 1;

*The second incompatible port pair
incompt2 .. sum(h2(p), y(p)) =l= 1;

*Number of times the ports need to be visited
yearlyvisit(p) .. sum((v,r), C(p,r)*x(v,r)) =g= d(p)*y(p);

*The number of days the ships can be active
yearlymain(v) .. sum(r, A(v,r)*x(v,r)) =l= g(v);

Model ports /all/;
solve ports using MIP minimizing xi;

display xi.l, x.l, y.l, z.l;
