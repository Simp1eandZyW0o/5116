% Compute the probability density function of the price S(T)
% Inputs:
%    volSurf: volatility surface data
%    T: time to expiry of the option
%    Ks: vector of strikes
% Output:
%    pdf: vector of pdf(Ks)
function pdf = getPdf(volSurf, T, Ks)
	n = numel(Ks);
    H = 0.00001;
	pdf = zeros(1, n);
	Ks_positive = Ks(Ks-H>0);
	i = n-numel(Ks_positive)+1;
	Ks_right = Ks_positive + H;
    Ks_left = Ks_positive - H;

	[vols, fwd]= getVol(volSurf, T, Ks_positive);
	[vols_right, fwd_right] = getVol(volSurf, T, Ks_right);
    [vols_left, fwd_left] = getVol(volSurf, T, Ks_left);

	callPrices = getBlackCall(fwd, T, Ks_positive, vols);
    callPrices_right = getBlackCall(fwd_right, T, Ks_right, vols_right);
	callPrices_left = getBlackCall(fwd_left, T, Ks_left, vols_left);
	

	pdf(i:end) = (callPrices_right - 2 * callPrices + callPrices_left  ) / H^2;
end
