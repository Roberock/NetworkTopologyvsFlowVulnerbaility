function PlotClusterNetwork(Clusters,A2Cluster,mpc,K)

Col={'r';'b';'k';'g';'y';'c';'m';[0.1 0.3 1];[1 0.3 0.1]}; % up to 9 cluster colours
if K>9
    for kol=10:K; Col{kol}=rand([1,3]); % add random Colours
    end
end
figure
objGridp=plot(graph(A2Cluster))
for k=1:K
    highlight(objGridp,mpc.bus(Clusters.idx==k,1),'NodeColor',Col{k})
end

end