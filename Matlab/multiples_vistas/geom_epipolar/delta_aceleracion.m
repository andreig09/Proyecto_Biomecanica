


function delta_aceleracion = delta_aceleracion (p1,p2,p3,p4)



a1 = (p3 - p2) - (p2 - p1);

a2 = (p4 - p3) - (p3 - p2);

delta_aceleracion = norm(a2 - a1);

%delta_aceleracion = cross([a1;1],[a2;1]);