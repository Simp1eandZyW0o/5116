% Inputs:
%    domCurve: domestic IR curve data
%    forCurve: domestic IR curve data
%    spot: spot exchange rate
%    tau: lag between spot and settlement
% Output:
%    curve: a struct containing data needed by getFwdSpot
function curve = makeFwdCurve(domCurve, forCurve, spot, tau)
  if numel(domCurve.ts)~=numel(forCurve.ts) || numel(domCurve.rates)~=numel(forCurve.rates)
    error('domCurve and forCurve does not have equal size');
  end
  spread = domCurve.rates - forCurve.rates;
  spreadCurve = struct('ts', domCurve.ts, 'rates', spread);
  cashRate = spot/exp(getRateIntegral(spreadCurve, tau));
  curve = struct('spreadCurve', spreadCurve, 'cashRate', cashRate, 'tau', tau);
end