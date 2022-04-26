% Inputs :
% fwdCurve : forward curve data
% T: time to expiry of the option
% cps: vetor if 1 for call , -1 for put
% deltas : vector of delta in absolute value (e.g. 0.25)
% vols : vector of volatilities
% Output :
% curve : a struct containing data needed in getSmileK
function [ curve ]= makeSmile ( fwdCurve , T, cps , deltas , vols )
  % Hints:
  % 1. assert vector dimension match
  if ~isequal(numel(deltas), numel(vols))
    error('size of deltas and vols must be equal! Please check the inputs!');
  end

  % 2. resolve strikes using deltaToStrikes
  fwdSpot = getFwdSpot(fwdCurve, T);
  n = numel(deltas);
  Ks = zeros(1, n);
  for i=1:n
    Ks(i) = getStrikeFromDelta(fwdSpot, T, cps(i), vols(i), deltas(i));
  end
  dKs = [0 Ks];
  dvols = [0 vols];
  calls = getBlackCall(fwdSpot, T, dKs, dvols);
  
  % 3. check arbitrages
  t = (calls(2:end) - calls(1:end-1)) ./ (dKs(2:end) - dKs(1:end-1));
  if any(calls < 0)
    error('Call Price cannot be negative!');
  elseif any(t(1:end-1) >= t(2:end))
    error('Arbitrage 1','The price of call must be convex in strike!');
  elseif any(t <= -1 | t >= 0)
    error('Arbitrage 2','The price of a call option decreases with strike too fast!');
  end
  
  % 4. compute spline coefficients
  % https://itectec.com/matlab/matlab-plot-natural-cubic-spline/
  splineFuc = csape(Ks, vols, 'variational');
  
  splineFucDeriv = fnder(splineFuc);

  % 5. compute parameters aL , bL , aR and bR
  x = atanh(sqrt(0.5));
  KL = Ks(1)^2 / Ks(2);
  KR = Ks(end)^2 / Ks(end-1);
  bR = x / (KR - Ks(end));
  bL = x / (Ks(1) - KL);
  aR = fnval(splineFucDeriv, Ks(end)) / bR;
  aL = fnval(splineFucDeriv, Ks(1)) / -bL;
  curve = struct('spline', splineFuc, 'aR', aR, 'aL', aL, 'bR', bR, 'bL', bL, 'K1', Ks(1), 'KN', Ks(end));
end

