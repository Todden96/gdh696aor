sets
k 'keys' /k1*k30/
n 'nodes' /n1*n8/
;

*This is used to compare the nodes with the other nodes
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
xcontrol(n,s,k) 'constraint controlling if node n and s share key k'
succes(n,s) 'counting direct connections'
;

*I couldn't get the double sum to work so I made a sum within the sum.
*This ensures that we don't match node n with itself.
match .. xi =e= sum(n, sum(s$(ord(s)>ord(n)), z(n,s)));

*This caps the number of keys within each node.
capnode(n) .. sum(k, y(n,k))*kb =l= M;

*This caps the key# given dealt to the nodes.
maxkey(k) .. sum(n, y(n,k)) =l= T;

*This controls the matches between node n and s. Notice that the variable is
*'free' when y(n,k)=y(s,k)=1, but this is a maximizing problem so it's no problem.
xcontrol(n,s,k) .. 2*x(n,s,k)-y(n,k) =l= y(s,k);

*This constraint specifies the z's for for s>n. It will specify whether there is
*a direct connection between node n and s. 
succes(n,s)$(ord(s)>ord(n)) .. sum(k, x(n,s,k)) =g= q*z(n,s)

model MajorKey /all/;
solve MajorKey using MIP maximizing xi;
