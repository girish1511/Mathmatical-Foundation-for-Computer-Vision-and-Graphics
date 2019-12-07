function q_n = corres(p,q)

[r,c]=size(p);
% p_n=zeros(r,c);
q_n=zeros(r,c);
r_q=r;
q_t=q;
for i=1:r
    d=zeros(1,r_q);
    for j=1:r_q
        d(j)=norm(p(i,:)-q_t(j,:));
%         d(j)=pdist(temp,'euclidean');
    end
    [~,ind]=min(d);
    q_n(i,:)=q_t(ind,:);
    q_t(ind,:)=[];
    [r_q,~]=size(q_t);
end
end