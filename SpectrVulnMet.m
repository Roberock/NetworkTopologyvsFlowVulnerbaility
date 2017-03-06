function Out=SpectrVulnMet(W) 
%% INPUT 
%   W=Ajacence (weighted or not weighted) Matrix of the graph G
%% OUTPUT
%  Out.Rho = spectral radius of W
%  Out.Alg_Con = Algebraic Connectivity
%  Out.Rg= Effective Ressitance Netowork
%  Out.Nat_Con = Natural Connectivity of a Network
% make laplacian
L=makeLaplacian(W);
%eigenvalues
[~,EvalorigW]=eig(full(W));%solve eigenvalues/vectors problem for W
EvalorigW=diag(EvalorigW);%sort eigenvalues
[~,EvalorigL]=eig(full(L));%solve eigenvalues/vectors problem for W
EvalorigL=diag(EvalorigL);%sort eigenvalues  
% The Spectral Metrics
Out.SpectralRadius=max(EvalorigW); % spectral radius (W)
Out.NaturalConnectivity=log(mean(exp(EvalorigW)));  % Natural Connectivity (W)
Out.AlgebraicConnectivity=min(EvalorigL(2:end)); % Algebraic Connectivity ( W?)
Out.EffectiveResistance=length(EvalorigL).*sum(1./EvalorigL(2:end)); % Effective Ressitance Netowork ( W?)
end