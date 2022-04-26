% Computes the price of a European payoff by integration Input:
%    volSurface : volatility surface data
%    T : time to maturity of the option
%    payoff: payoff function
%    ints: optional , partition of integration domain
%          e.g. [0, 3, +Inf]. Defaults to [0, +Inf]
% Output:
%    u : forward price of the option (undiscounted price)
function u = getEuropean(volSurface , T, payoff , ints)
  if nargin < 4
    ints = [0, +inf];
  elseif any(ints < 0)
    error('getEuropean:NegativeValueError', 'int cannot be negative');
  end

  u =sum(arrayfun(@(i, j)integral(@(x) payoff(x).*getPdf(volSurface, T, x), i, j), ints(1:end-1), ints(2:end)));
end
