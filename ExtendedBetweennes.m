function T_line=ExtendedBetweennes(mpc)
%% Compute EE-based extended betweeness for lines
PTDF=makePTDF(mpc.baseMVA, mpc.bus, mpc.branch);
PTDFD=PTDF(:,mpc.bus(:,2)==1);
PTDFG=PTDF(:,mpc.bus(:,2)==2 | mpc.bus(:,2)==3);
Plinemax=mpc.branch(:,6); % This is often set to zero for mpc cases!!!!!! Check this and fix a threshold if ratio not available
[Fgd,Ratio]=deal(zeros(size(PTDFD,2),size(PTDFG,2),size(mpc.branch(:,11),1)));
for l=1:size(mpc.branch(:,11),1) % for each line do
    Fgd(:,:,l)=repmat(PTDFG(l,:),[size(PTDFD,2),1])-repmat(PTDFD(l,:),[size(PTDFG,2),1])';
    Ratio(:,:,l)=Plinemax(l)./abs(Fgd(:,:,l));
end
T_line=zeros(1,size(mpc.branch(:,11),1));
[Cgd,I]=min(Ratio, [], 3);
for l=1:size(mpc.branch(:,11),1)
    T_line(l)=sum(sum(Cgd.*abs(Fgd(:,:,l)))); % linee betweeness extended, is a direct indicator of the vulnerability to signle line loss
end
end