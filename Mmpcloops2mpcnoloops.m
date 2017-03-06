function mpc=Mmpcloops2mpcnoloops(mpc)
Nbus=size(mpc.bus(:,1),1);                          % Number of busses in the network
From_Bus=mpc.branch(:,1); 
To_Bus=mpc.branch(:,2);
Branch_Status=mpc.branch(:,11);
A = sparse([From_Bus;To_Bus],[To_Bus;From_Bus],[Branch_Status;Branch_Status],Nbus,Nbus); % Adjacency
[Col,Row,~]=find(triu(A)>1);
Lines2clear=[];Lines2Keep=[];
B_eq=zeros(1,length(Col));
Rate_eq=zeros(length(Col),3);
for i=1:length(Col) % get rid of double or triple parallel lines
    % LOOPS=find(mpc.branch(:,1)==Col(i) & mpc.branch(:,2)==Row(i));
    LOOPS=find((mpc.branch(:,1)==Row(i) & mpc.branch(:,2)==Col(i))|(mpc.branch(:,1)==Col(i) & mpc.branch(:,2)==Row(i)));
    Lines2clear=[Lines2clear,LOOPS(1:end-1)'];
    Lines2Keep=[Lines2Keep;LOOPS(end)];
    %equivalent parameters
    Z_eq(i,1:2)=(1./(sum(mpc.branch(LOOPS(1:end-1),3:4))+ mpc.branch(LOOPS(end),3:4))).^-1;
    B_eq(i)=(sum(mpc.branch(LOOPS(1:end-1),5))+ mpc.branch(LOOPS(end),5));
    Rate_eq(i,1:3)=sum(mpc.branch(LOOPS(1:end-1),6:8))+ mpc.branch(LOOPS(end),6:8);
    % How the termal rating changes?
end
if ~isempty(Col)
mpc.branch(Lines2Keep,3:4)=Z_eq;
mpc.branch(Lines2Keep,5)=B_eq;
mpc.branch(Lines2Keep,6:8)=Rate_eq;
end
mpc.branch(Lines2clear,:)=[]; 
end