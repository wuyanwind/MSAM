%%
D_nc = D_SC115_NC';
D_sz = D_SC115_SZ';
data = D_nc;
data = D_sz;

K=6; 
distance_func = 'correlation'; % distance function, e.g., 'sqeuclidean' | 'cityblock' | 'cosine' | 'correlation' | 'hamming'
ReplicateNum = 10; % replicate number
MaxIter = 500;
clust_subj_sz = zeros(500,225);
s_subj_sz = zeros(500,225);

for i = 1:500
    fprintf('Kmeans: %d clusters... \n',i);
    data_sub = data(i*225-224:i*225,:);
    [clust_subj_sz(i,:), C_subj_sz{i}, sumD_subj_sz{i}, D_subj_sz{i}] = kmeans(data_sub,K,'Distance',distance_func,'replicate',ReplicateNum,'MaxIter',MaxIter);
%     clust(:,i) = kmeans(data,k_range(i),'Distance',distance_func,'replicate',replicate_num);
    s_subj_sz(i,:) = silhouette(data_sub,clust_subj_sz(i,:),distance_func);
end
save('SZ_SUBJ_CAP_SC115.mat','clust_subj_sz','C_subj_sz', 'sumD_subj_sz','D_subj_sz','s_subj_sz')
% eva = evalclusters(data,clust,'silhouette','Distance',distance_func);


%% NC
data = D_SC115_NC';
K=6; 
distance_func = 'correlation'; % distance function, e.g., 'sqeuclidean' | 'cityblock' | 'cosine' | 'correlation' | 'hamming'
ReplicateNum = 10; % replicate number
MaxIter = 500;
clust_subj_nc = zeros(500,225);
s_subj_nc = zeros(500,225);

for i = 1:500
    fprintf('Kmeans: %d clusters... \n',i);
    data_sub = data(i*225-224:i*225,:);
    [clust_subj_nc(i,:), C_subj_nc{i}, sumD_subj_nc{i}, D_subj_nc{i}] = kmeans(data_sub,K,'Distance',distance_func,'replicate',ReplicateNum,'MaxIter',MaxIter);
%     clust(:,i) = kmeans(data,k_range(i),'Distance',distance_func,'replicate',replicate_num);
    s_subj_nc(i,:) = silhouette(data_sub,clust_subj_nc(i,:),distance_func);
end
save('NC_SUBJ_CAP_SC115.mat', 'clust_subj_nc', 'C_subj_nc', 'sumD_subj_nc','D_subj_nc','s_subj_nc')

%% match
sch_8net_label = [2*ones(9,1);ones(6,1);3*ones(8,1);4*ones(7,1);5*ones(3,1);6*ones(4,1);7*ones(13,1);
    2*ones(8,1);ones(8,1);3*ones(7,1);4*ones(5,1);5*ones(2,1);6*ones(9,1);7*ones(11,1);8*ones(15,1)];
figure(51)
clf
vs = violinplot(C_nc{5}(5,:), sch_8net_label, 'ViolinColor', lines,'MarkerSize',10);

% NC [6,1,4,3,2,5]
nc_index = [6,1,4,3,2,5];
for i=1:500
    for j =1:6
        [corr_subj_sz(j,i),corr_subj_sz_index(j,i)]=max(corr(C_nc{5}(nc_index(j),:)',C_subj_sz{i}(:,:)'));
    end
end

clust_subj_sz = clust_subj_sz';
clust_subj_sz_alignment = zeros(225*500,1);
for i=1:500
    for j =1:6
        for k =1:6
            if corr_subj_sz_index(k,i) == j
                temp_index = find(clust_subj_sz(:,i) ==k);
                clust_subj_sz_alignment(temp_index+i*225-225,1)=j;
            end
        end
    end
end