clc;
clear all;
%%
im = double(imread('Dataset/36046.jpg'));
N = numel(im(:,:,1)); % # of pixels
[r, c, ch] = size(im);
%%
no_cl = 64; % # of clusters
S = double(int16(sqrt(N/no_cl)));
r_S = int16(r/S);
c_S = int16(c/S);
%%
label = -ones(r,c);
dist = inf*ones(r,c);
clust_cent = cell(no_cl,1);
i=1;
for x = round(S/2):S:r
    for y = round(S/2):S:c
        clust_cent{i} = [squeeze(im(x,y,:)); x; y];
        i=i+1;
    end
end
%%
clc
% L = zeros(10,1);
for iter = 1:10
    fprintf('Iteration: %d\n',iter)
    for k = 1:no_cl
        ck=clust_cent{k};
        center=ck(end-1:end).';
        x = round(center(1));
        y = round(center(2));
        if x-S<S
            x_iter = 1:x+S;
        elseif x+S>r
            x_iter = x-S:r;
        else
            x_iter = x-S:x+S;
        end
        if y-S<S
            y_iter = 1:y+S;
        elseif y+S>c
            y_iter = y-S:c;
        else
            y_iter = y-S:y+S;
        end
        for i = x_iter
            for j = y_iter
                p = [squeeze(im(i,j,:)); i; j];
                D = distance(ck,p,S,20);
                if D < dist(i,j)
                    dist(i,j) = D;
                    label(i,j) = k;
                end
            end
        end
    end
    err = zeros(no_cl,1);
    for k = 1:no_cl
        old_ck = clust_cent{k};
        [ind_r,ind_c] = find(label==k);
        l = length(ind_r);
        sum_vec = zeros(5,1);
        for in = 1:l
            sum_vec = sum_vec+[squeeze(im(ind_r(in),ind_c(in),:)); ind_r(in); ind_c(in)];
        end
        new_ck = sum_vec/l;
        err(k) = norm(old_ck-new_ck);
        clust_cent{k} = new_ck;
    end
    L(iter) = norm(err/no_cl);
    
    fprintf('Residual error: %f\n',L(iter));
    if L(iter)<0.01
        break;
    end
end
%%
bw =cell(no_cl,1);
for k = 1:no_cl
    bw{k} = label==k;
end
imshow(uint8(im))
hold on
for k = 1:no_cl
[B,L] = bwboundaries(bw{k},'noholes');

hold on;
for b = 1:length(B)
    boundary = B{b};
    plot(boundary(:,2), boundary(:,1), 'k', 'LineWidth', 0.01)
end
end