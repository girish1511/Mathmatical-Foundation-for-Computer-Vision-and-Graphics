%%
clear
clc
P=cell(1,10);
Q=cell(1,10);
T=cell(1,10);
Ro=cell(1,10);
Q_al=cell(1,10);
for i=1:10
   P{i}=dlmread("Dataset/P_"+num2str(i)+".txt");
   Q{i}=dlmread("Dataset/Q_"+num2str(i)+".txt");
end
%%
for k=1:10
p=P{k};
% pm=mean(P{k});
q=Q{k};
% qm=mean(Q{k});
[r,c]=size(p);
% q_n=corres(p,q);
% [t,R]=trans(p,q_n);
u=zeros(c,1);
u(1)=1;
t=zeros(c,1);
R=eye(c);
fl=true;
fprintf('Point cloud pair: %d\n',k);
while fl
    q_t=(t+R*p.').';
    q_n=corres(q_t,q);
    [t_n,R_n]=trans(p,q_n);
%     et=sqrt(sum((t_n-t).^2));
    er=norm(acos(dot(R*u,u))-acos(dot(R_n*u,u)))*180/pi;
    et=norm(t_n-t);
    t=t_n;
    R=R_n;
    if ((et<0.3) && (er<0.025))
        fl=false;
    end
    fprintf('Iteration Number: %d',k);
    fprintf(' Error in t: %0.4f Error in R: %0.4f\n',et,er);
end
Q_al{k}=corres((t+R*p.').',q);
T{k}=t;
Ro{k}=R;
end
%%
for i=1:10
    dlmwrite("Q_"+num2str(i)+"aligned.txt",Q_al{i});
    dlmwrite("T_"+num2str(i)+".txt",T{i});
    dlmwrite("R_"+num2str(i)+".txt",Ro{i});
end