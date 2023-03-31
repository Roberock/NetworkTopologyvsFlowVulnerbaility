function [CEIi,Pij]=CEI_PCEI_INDEX(X_C,X_nC)

    %%----- Computes cascading indcators according to: 
% Rocchetta and Patelli (2018), "Assessment of power grid vulnerabilities accounting for stochastic loads and model imprecision" Electrical Power and Energy Systems 

%% --------------INPUTS: ----------------------------
% X_C MATPPOWER resutls of the contingnecy case (C) 
% X_C MATPPOWER resutls for the undisturbed gird no-contingnecy (nC)

%% see user manual Matpower Ray D. Zimmerman
% for instane % name column description of X_nC.branch

%   Branch Data Format branch(:,index)
%       1   f, from bus number
%       2   t, to bus number 
%       3   r, resistance (p.u.)
%       4   x, reactance (p.u.)
%       5   b, total line charging susceptance (p.u.)
%       6   rateA, MVA rating A (long term rating)
%       7   rateB, MVA rating B (short term rating)
%       8   rateC, MVA rating C (emergency rating)
%          ....
%       11 initial branch status, 1 = in-service, 0 = out-of-service
%       14 real power injected at “from” bus end (MW)
%       15 reactive power injected at “from” bus end (MVAr)
%       16 real power injected at “to” bus end (MW)
%       17 reactive power injected at “to” bus end (MVAr)
 
%% --------------OUTPUTS:----------------------------
% CEIi: Cascading indices
% Pij: Probability  of failure for the line i after contingnecy
%% -------------------------------------------------- 


% parameters
Safe_PR = 0.9 % safe percentage of rating
Max_PR = 1.25 % safe percentage of rating
D = 10
C = -9
  
%% Compute pre-contingency flow rate
Af = sqrt(X_nC.branch(:,14).^2 + X_nC.branch(:,15).^2); % Real power from
At = sqrt(X_nC.branch(:,16).^2 + X_nC.branch(:,17).^2); % Real power to 
flow = (Af + At)/2; % Avarage flow
Branch_flow_rating_nC  = flow ./ X_nC.branch(:,7); % load rating (no-contingency)

%% Compute post-contingency flow rate
Af = sqrt(X_C.branch(:,14).^2 + X_C.branch(:,15).^2); % Complex from
At = sqrt(X_C.branch(:,16).^2 + X_C.branch(:,17).^2); % Comple to
flow = (Af + At)/2; % Avarage
Branch_flow_rating_C  = flow ./ X_C.branch(:,7); % load rating (contingency).... X_nC.branch(:,7)=X_C.branch(:,7)

%% Compute severity scores.....
Sev_flown = D*Branch_flow_rating_nC+C; % compute severity contingency case
Sev_flown(Branch_flow_rating_nC<Safe_PR)=0; % compute severity contingency case

%% compute Probability
Pij=(Branch_flow_rating_C.*X_C.branch(:,11)-Branch_flow_rating_nC.*X_C.branch(:,11))./(Max_PR-Branch_flow_rating_nC.*X_C.branch(:,11));

Pij(Branch_flow_rating_C<Safe_PR)=0; % probability of follow up line failure event equal zero if flow is low
Pij(Branch_flow_rating_C>Max_PR)=1; 
Pij(Pij<0)=0;
Pij(Pij>1)=1;

%% Cascading Index
CEIi=sum(Pij.*Sev_flown); 
end