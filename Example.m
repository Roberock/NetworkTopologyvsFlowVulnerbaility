clc
close all
clear variables
addpath('D:\WORK FOLDER\MATLAB SOURCE CODES\FREE_SOURCECODES\matpower5.1\matpower5.1') % add matpower path
%addpath('D:\WORK FOLDER\MATLAB SOURCE CODES\MATPOWER CASES\UK Matpower CASEs POWER GRID') % additional case study (UK grids)
%% number of contingencies
N=10;% number og contingencies accounted
%% LOAD MATPOWER CASE FORMAT
% MatPower Cases Tested and Working:
% case9;case14;case24_ieee_rts;case39; case57; case118
% Polish Power Grid works for A not for B? case2736sp
% mpc = case24_ieee_noloops; % IEEE 24 nodes power reliability test system no parallel lines
mpc=case57;
mpc = ext2int(mpc); % convert to internal indexing
%% get rid of loops
mpc=Mmpcloops2mpcnoloops(mpc); % Eliminate Loops
From_Node=mpc.branch(:,1); %starting nodes for the links
To_Node=mpc.branch(:,2); %arrival nodes for the links
Link_weigth=mpc.branch(:,11); %link weights (ones in this case)
Nnodes=length(mpc.bus(:,1)); %number of nodes
Nlinks=length(mpc.branch(:,1)); %number of nodes
%% Make Adjacency and Laplacian
Ybus=makeYbus(mpc,'full');                     % ADMITTANCE MATRIX SPARCE
Bdc=makeBdc(mpc.baseMVA, mpc.bus, mpc.branch); % SUSCEPTANCE MATRIX SPARCE DC APPROXIMATION
B=imag(Ybus);                                  % SUSCEPTANCE MATRIX SPARCE
B(logical(eye(size(B))))=0;                    % Get Rid of Self SUSCEPTANCEs
Bdc(logical(eye(size(Bdc))))=0;                % Get Rid of Self SUSCEPTANCEs
Bdc=abs(Bdc);
%make adjacency and laplacians
A=makeAdjacency(From_Node,To_Node,Link_weigth,Nnodes);
La=makeLaplacian(A); %laplacian of unweighted adjacency
Lw=makeLaplacian(B); %laplacian of weighted adjacency
%% Spectal Clustering
K=3; % number of clusters
A2Cluster=Bdc;
Clusters=SpectralClustering(A2Cluster,K);
%% plotting
PlotClusterNetwork(Clusters,A2Cluster,mpc,K)
%% Compute Spectral Metrics
OutSpecVul_nodamag=SpectrVulnMet(B);
%% Compute Non Spectral pure tolological metrics
[ L, EGlob, CClosed, ELocClosed, ~, ~ ] = graphProperties( A );
%% N-1 Pure Topolgical Spectral Vulnerability  (A)
Vuln_N1_pure=CN1Vulnerability(A,Nlinks,From_Node,To_Node);
%% N-1 Extended Spectral Topological Vulnerability  (W)
Vuln_N1=CN1Vulnerability(B,Nlinks,From_Node,To_Node);
 %% Extended Betweenness
 T_line=ExtendedBetweennes(mpc);
 %% N-k Contingency
 k=10; %k>1and <Nlines
 for k=1:50
 MCrun=1500;
 for j=1:MCrun
    % random N-k Contiengency (lines)
    [B_dam]=Random_k_outof_N(B,From_Node,To_Node,k);
    %compute spectral proprieties of the graph
    OutSpecVul_CNk=SpectrVulnMet(B_dam);%obtain spectral propriety
    % relative vulnerability and save
    Vul=RelSpectrVuln(OutSpecVul_nodamag,OutSpecVul_CNk);
    AlgConCnk(j)=Vul.AlgebraicConnectivity; 
    RgCNk(j)=Vul.EffectiveResistance;
    NatConCNk(j)=Vul.NaturalConnectivity;
    RhoCNk(j)=Vul.SpectralRadius;
 end
 
    Kalg(k)=mean(AlgConCnk);
    KRg(k)= mean(RgCNk);
    KNatCon(k)= mean(NatConCNk);
    KNRho(k)= mean(RhoCNk);
 end
plot([KNRho;KNatCon;KRg;Kalg]')
