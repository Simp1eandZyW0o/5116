% Inputs:
%    curve: pre-computed fwd curve data
%    T: forward spot date
% Output:
%    fwdSpot: E[S(t) | S(0)]
function fwdSpot = getFwdSpot(curve, T)
	if T < 0
		error('T cannot be negative');
	end
  fwdSpot = curve.cashRate * exp(getRateIntegral(curve.spreadCurve, T+curve.tau));
end
