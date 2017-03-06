function L=makeLaplacian(W)
% build the laplacian L of the weighted or unweighted adjacency matrix W
L=-W;
Degree=sum(W,2);
L(logical(eye(size(W))))=Degree;
end
