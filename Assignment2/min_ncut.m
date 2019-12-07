function ncut_val = min_ncut(part_point,D,W, eig_vec)


x = eig_vec>part_point;
x = 2*x -1;
d = sum(W,2);
k = sum(d(x>0))/sum(d);
b = k/(1-k);
y = (1+x)-b*(1-x);

ncut_val = (y.'*(D-W)*y)/(y.'*D*y);

end