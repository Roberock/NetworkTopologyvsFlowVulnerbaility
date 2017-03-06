function Vul=RelSpectrVuln(OutSpecVul_nodamag,OutSpecVul_C)
%OutSpecVul_C = network spectral metrics for the damaged condition C
%Vul= relatvive difference betweenundamaged network metrics and damaged network metrics
AlgebraicConnectivity=abs(OutSpecVul_nodamag.AlgebraicConnectivity-OutSpecVul_C.AlgebraicConnectivity)/OutSpecVul_nodamag.AlgebraicConnectivity;
EffectiveResistance=abs(OutSpecVul_nodamag.EffectiveResistance-OutSpecVul_C.EffectiveResistance)/OutSpecVul_nodamag.EffectiveResistance;
NaturalConnectivity=abs(OutSpecVul_nodamag.NaturalConnectivity-OutSpecVul_C.NaturalConnectivity)/OutSpecVul_nodamag.NaturalConnectivity;
SpectralRadius=abs(OutSpecVul_nodamag.SpectralRadius-OutSpecVul_C.SpectralRadius)/OutSpecVul_nodamag.NaturalConnectivity;
 %% if failed 
 AlgebraicConnectivity(abs(AlgebraicConnectivity)>10e8)=0;
  EffectiveResistance(abs(EffectiveResistance)>10e8)=0;
 NaturalConnectivity(abs(SpectralRadius)>10e8)=0;
 SpectralRadius(abs(SpectralRadius)>10e8)=0;

 
Vul.AlgebraicConnectivity=AlgebraicConnectivity;%save 
Vul.EffectiveResistance=EffectiveResistance; 
Vul.NaturalConnectivity=NaturalConnectivity; 
Vul.SpectralRadius= SpectralRadius;
 
end