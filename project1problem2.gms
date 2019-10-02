sets
k 'keys' /k1*k30/
n 'nodes' /n1*n8/
;
alias(n, s)

Binary variables
y(n,k) '1 if node n has key k'
x(n,s,k) '1 if node n AND node s have key k'
z(n,s) '1 if node n and s have at least q of the same keys and are therefore directly connected'
;

Variables
xi;

Scalar
M /1000/
kb /186/
T /2/
q /3/
;


Equations
match 'objective function'
capnode(n) 'memory capacity'
maxkey(k) 'amount of keys available'
xcontrol1(n,s,k) 'two constraints controlling match variable x'
succes(n,s) 'counting direct connections'
;

match .. xi =e= sum(n, sum(s$(ord(s)>ord(n)), z(n,s)));
capnode(n) .. sum(k, y(n,k))*kb =l= M;
maxkey(k) .. sum(n, y(n,k)) =l= T;
xcontrol1(n,s,k) .. 2*x(n,s,k)-y(n,k) =l= y(s,k);
succes(n,s)$(ord(s)>ord(n)) .. sum(k, x(n,s,k)) =g= q*z(n,s)

model skrr /all/;
solve skrr using MIP maximizing xi;
