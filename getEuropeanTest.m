function tests = europeanTest
  tests = functiontests(localfunctions);
end

function setupOnce(testCase)
	[spot, lag, days, domdfs, fordfs, vols, cps, deltas] = getMarket();
	tau = lag / 365;
	Ts = days / 365;
	domCurve = makeDepoCurve(Ts, domdfs);
	forCurve = makeDepoCurve(Ts, fordfs);
	fwdCurve = makeFwdCurve(domCurve, forCurve, spot, tau);
	testCase.TestData.volSurface = makeVolSurface(fwdCurve, Ts, cps, deltas, vols);
	testCase.TestData.fwd = getFwdSpot(fwdCurve, 0.8);
end

function testEuropeanWithThreeParams(testCase)
	volSurface = testCase.TestData.volSurface;
	fwd = testCase.TestData.fwd;
	u = getEuropean(volSurface, 0.8, @(x)max(x-fwd,0));
	verifyTrue(testCase, abs(u-0.13622) < 0.00001);
end

function testEuropeanWithFourParams(testCase)
	volSurface = testCase.TestData.volSurface;
	fwd = testCase.TestData.fwd;
	verifyEqual(testCase, getEuropean(volSurface, 0.8, @(x)max(x-fwd,0)), ...
		getEuropean(volSurface, 0.8, @(x)max(x-fwd,0), [0, +Inf]));
end
