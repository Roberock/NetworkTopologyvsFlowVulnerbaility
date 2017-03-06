function A=makeAdjacency(From_Node,To_Node,Link_weigth,Nnodes)
% build the Adjacency A given starting nodes and arrival nodes indices (From_Node To_Node) 
% and accordingly to the Link_weigth and network number of nodes
A = sparse([From_Node;To_Node],[To_Node;From_Node],[Link_weigth;Link_weigth],Nnodes,Nnodes);
end
