clc;
clear all;
%%
I = imread('Dataset/slic_in1.jpg');
im = imresize(I,[100,100]);
[row, col, ch] = size(im);
N = row*col;
V = reshape(im, [N,3]);
%%
r = 3;
sig_i = 10;
sig_x = 10;
ncut_threshold = 0.1;
%%
W = sparse(N,N); % Weight matrix
D = sparse(N,N); %Degree matrix
x = zeros(row, col, 2);
for i = 1:row
    for j = 1:col
        x(i,j,:) = [i, j];
    end
end
X = reshape(x, [N,2]); % Spatial matrix
F = reshape(im, [N,3]); % Feature matrix
%%

for i = 1:N
    for j = i:N
        dist_xij = norm(double(X(i,:))-double(X(j,:)));
        if dist_xij <=r
            feat_sim = exp(-(norm(double(F(i,:))-double(F(j,:)))/sig_i)^2);
            spat_sim = exp(-(norm(double(X(i,:))-double(X(j,:)))/sig_x)^2);
            W(i,j) = feat_sim*spat_sim;
            W(j,i) = W(i,j);
        end
    end
    D(i,i) = sum(W(i,:));
    if mod(i,500) == 0
            fprintf('Number of Pixels done: %d\n',i);
    end
end
%%
% [Y,lam] = eigs(D-W,D,2,'sm');
% eig_vec = Y(:,1);
% part_point = median(eig_vec);
% 
% part_1 = find(eig_vec>part_point);
% part_2 = find(eig_vec<=part_point);
% 
% ncut_val = min_ncut(part_point,D,W, eig_vec);
% 
% if ncut_val < Ncut_threshold
%     fprintf('sucessful')
% end
%%
node = 1:N;
[node_data, ncut] = part(node, W, ncut_threshold);
s=cell(length(node_data));
for i=1:length(node_data)
    s_t = zeros(N, ch);
    s_t(node_data{i},:) = V(node_data{i},:);
    s{i} = reshape(s_t,[row,col,ch]);
end

for i=1:length(s)
figure; 
imshow(s{i});
imwrite(s{i}, char("NCut\Segment"+ num2str(i) +".jpg"));
fprintf('Ncut(%d) = %f\n', i, ncut{i});
end