function Clusters=SpectralClustering(A,K)
% This algorithm clusterise network based on its spectral proprieties 
L=makeLaplacian(A);
%% Build Laplacian matrix  + Spectral Proprieties (Eigenvalues Eigenvectors EigenGaps Relative Eigengaps)
Degrees=diag(L);
D=Degrees.^-0.5;
%% Step 1 (Normalized Laplacian)): Ln=D^-1/2*L*D^-1/2
Ln= repmat(D,1,size(L,2)).*repmat(D',size(L,2),1).*L;
%% Spectral proprieties: Eigenvectors and Eigenvalues
[Evec,Eval]=eig(full(Ln));Eval=diag(Eval);
%% Step 0 (Spectral Dimension): Find best number of partitions
%% Spectral proprieties Eigengaps of Ln
% K=1 correspond to the first eigenvalue of the laplacian (is it always zero for the adjacency matrix?)
% Eigengaps \vu_{k+1}-\vu_{k}
EigenGaps=(Eval(3:end)-Eval(2:end-1));
% the relative eigengap indicates if the partition it referes to is a good
% partition (the higher the better) \gamma=\frac{\vu_{k+1}-\vu_{k}}{\vu_{k}}
RelativeEigenGaps=EigenGaps./Eval(2:end-1);
BestK_A=max(RelativeEigenGaps); % chose best partition for the Graph
% Nromalize The k selectein a way that

%K=find(RelativeEigenGaps==BestK_A)+1;%best partition

%% Step 1 (Normalized Laplacian)): Ln=D^-1/2*L*D^-1/2
%% Step 2 (Spectral Embedding): normalize eigenvectors on the rows, normalize Eigenvectors to a
% K-1-Sphere norm(u)=1  with u= xi/norm(xi) and xi= row of the
% eigenvectors matrix (spectral coordinates of the i-th vertex of the graph)
u=normr(Evec(:,1:K));
%% Step 3.1: dist(i,j)=||ui-uj|| which is the minimum distances of path conecting the nodes in the graph (shortest path between i and j)
%Dist is orgainzed as {(2,1)(3,1)...(m,1)(3,2)(4,2)...(m,2)......(m,m-1)}
%Dist =   pdist(u);  %'chebychev' is the maximum difference between cooridinate points
idx = kmeans(u,K);
%% Step 4: Hierarchical clustering
%  Z = linkage(u);
%  figure
%  dendrogram(Z);
%% Step 5: Quality of the partitions . Islands Expansions, Boundaries and Volumes
[Bound,Vol]=deal(zeros(1,K));
for k=1:K
    Vol(k)=sum(Degrees(idx==k));
    Bound(k)=sum(sum(A(idx==k,idx~=k)));
end
%  Bound=
Clusters.Expansion=Bound./Vol; % Expansion is a criteria for the cluster evaluation is the number of nodes on the bounds devided by the number of n
Clusters.Vol=Vol;
Clusters.Bound=Bound;
Clusters.idx =idx;
end
