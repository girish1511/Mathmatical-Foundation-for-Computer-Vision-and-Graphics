function [node_data, ncut] = part(node, W, ncut_threshold)

N = length(W);
D = sparse(N,N);
for i= 1:N
    D(i,i) = sum(W(i,:));
end
[Y,lam] = eigs(D-W,D,2,'sm');
eig_vec = Y(:,1);
part_point = median(eig_vec);

part_1 = find(eig_vec>part_point);
part_2 = find(eig_vec<=part_point);

ncut_val = min_ncut(part_point,D,W, eig_vec);


if ncut_val<ncut_threshold
    node_data{1} = node;
    ncut{1} = ncut_val;
    return
end

[node1, ncut1] = part(node(part_1), W(part_1,part_1), ncut_threshold);
[node2, ncut2] = part(node(part_2), W(part_2,part_2), ncut_threshold);

node_data   = cat(2, node1, node2);
ncut = cat(2, ncut1, ncut2);
end