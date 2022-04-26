% Inputs :
% curve : pre - computed smile data
% Ks: vetor of strikes
% Output :
% vols : implied volatility at stri
function vols = getSmileVol (curve , Ks)
% check inputs  
  if any(Ks < 0)
    error('getSmileVol:NegativeStrikeError','Strike cannot be negative! Please check the input!');
  end
  
  spline = curve.spline;
  aL = curve.aL;
  aR = curve.aR;
  bL = curve.bL;
  bR = curve.bR;
  K1 = curve.K1;
  KN = curve.KN;
  size = numel(Ks);
  splineK1 = fnval(spline, K1);
  splineKN = fnval(spline, KN);
  vols = zeros(1,size);
  
  for i=1:size
    k = Ks(i);
    if k <= KN
      vols(i) = fnval(spline, k);
    elseif K < K1
      vols(i) = splineK1 + aL * tanh(bL * (K1 - k));
    else
      vols(i) = splineKN + aR * tanh(bR * (k - KN));
    end
  end
end
