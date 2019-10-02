sets
s 'players' /s1*s25/
p 'positions' /p1*p10/
f 'formations' /f1*f6/
subq(s) 'quality' /s13, s20, s21, s22/
subs(s) 'strength' /s10, s12, s23/
;


Table A(f,p)
        p1      p2      p3      p4      p5      p6      p7      p8      p9      p10
f1      1       2       1       1       2       1       1       0       2       0
f2      1       3       0       0       3       1       1       0       1       1
f3      1       2       1       1       3       0       0       1       2       0
f4      1       2       1       1       3       0       0       0       1       2
f5      1       3       0       0       2       1       1       0       1       2
f6      1       2       1       1       3       0       0       2       1       0
;

Table B(s,p)
    p1  p2  p3  p4  p5  p6  p7  p8  p9  p10
s1  10  0   0   0   0   0   0   0   0   0
s2  9   0   0   0   0   0   0   0   0   0
s3  8.5 0   0   0   0   0   0   0   0   0
s4  0   8   6   5   4   2   2   0   0   0
s5  0   9   7   3   2   0   2   0   0   0
s6  0   8   7   7   3   2   2   0   0   0
s7  0   6   8   8   0   6   6   0   0   0
s8  0   4   5   9   0   6   6   0   0   0
s9  0   5   9   4   0   7   2   0   0   0
s10 0   4   2   2   9   2   2   0   0   0
s11 0   3   1   1   8   1   1   4   0   0
s12 0   3   0   2   10  1   1   0   0   0
s13 0   0   0   0   7   0   0   10  6   0
s14 0   0   0   0   4   8   6   5   0   0
s15 0   0   0   0   4   6   9   6   0   0
s16 0   0   0   0   0   7   3   0   0   0
s17 0   0   0   0   3   0   9   0   0   0
s18 0   0   0   0   0   0   0   6   9   6
s19 0   0   0   0   0   0   0   5   8   7
s20 0   0   0   0   0   0   0   4   4   10
s21 0   0   0   0   0   0   0   3   9   9
s22 0   0   0   0   0   0   0   0   8   8
s23 0   3   1   1   8   4   3   5   0   0
s24 0   3   2   4   7   6   5   6   4   0
s25 0   4   2   2   6   7   5   2   2   0
;
Binary variables
x(s,p,f) 'is 1 if player s is chosen for position p in formation f'
y(f) 'chooses which formation to play' 
;

Variables
xi;

Equations
opti 'what we need to maximize'
formation 'only 1 formation can be chosen'
spiller(s,f) 'every player can at max take one position for each formation'
hold(p,f) 'we need all positions filled for a formation'
quality(f) 'we need at least 1 quality player'
strength(f) 'all quality players => 1 strength'
;

*objective function
opti .. xi =e= sum((s,p,f), B(s,p)*x(s,p,f));

*one formation
formation .. sum(f, y(f)) =e= 1;

*a player can at max play one poosition
spiller(s,f) .. sum(p, x(s,p,f)) =l= 1;

*We need to fill out every position in every formation
hold(p,f) .. sum(s, x(s,p,f)) =l= y(f)*A(f,p);

*we need at least one quality player
quality(f) .. sum((subq(s),p), x(s,p,f)) =g= 1*y(f);

*One strength player if all quality players
strength(f) .. sum((subq(s),p), x(s,p,f)) =l= sum((subs(s),p), x(s,p,f)) + card(subq)-1;

model fodbold /all/;
solve fodbold using mip maximizing xi;
display xi.l, x.l, y.l;


