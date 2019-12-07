function [t,R] = trans(p,q)

pm=mean(p);
qm=mean(q);
X=(p-pm).';
Y=(q-qm).';
[U,~,V]=svd(X*Y.');
R=V*U.';
t=qm.'-R*pm.';

end