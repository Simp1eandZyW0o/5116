% Inputs:
%    fwd: forward spot for time T, i.e. E[S(T)]
%    T: time to expiry of the option
%    cp: 1 for call, -1 for put
%    sigma: implied Black volatility of the option
%    delta: delta in absolute value (e.g. 0.25)
% Output:
%    K: strike of the option
function K = getStrikeFromDelta(fwd, T, cp, sigma, delta)
  if cp == 1
    d1 = norminv(delta);
  else
    d1 = norminv(1-delta);
  end
  K = exp(log(fwd) + sigma * sqrt(T) * (0.5 * sigma * sqrt(T) - d1));
end
