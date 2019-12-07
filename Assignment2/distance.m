function D = distance(ck, p, S, m) 

dc = norm(double(ck(1:3))-double(p(1:3)));
ds = norm(double(ck(4:5))-double(p(4:5)));


D = sqrt(dc^2+(((ds/S)^2)*m^2));

end