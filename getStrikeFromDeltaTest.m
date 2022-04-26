function tests = getStrikeFromDeltaTest
  tests = functiontests(localfunctions);
end

function testDeltaFromStrike(testCase)
  [spot, lag, days, domdfs, fordfs, vols, cps, deltas] = getMarket();
  tau = lag / 365;
  Ts = days / 365;
  domCurve = makeDepoCurve(Ts, domdfs);
  forCurve = makeDepoCurve(Ts, fordfs);
  fwdCurve = makeFwdCurve(domCurve, forCurve, spot, tau);
  T = 0.5;
  fwd = getFwdSpot(fwdCurve, T);
  strike = getStrikeFromDelta(fwd, T, cps(1), vols(1), deltas(1));
  d1 = (log(fwd)-log(strike))/(vols(1)*sqrt(T)) + 0.5*vols(1)*sqrt(T);
  verifyTrue(testCase, abs(1-normcdf(d1) - deltas(1)) < eps(1));
end

function testCall(testCase)
  verifyTrue(testCase, abs(getStrikeFromDelta(100, 2, 1, 0.25, 0.4) - 116.4244) < 0.0001);
end

function testPut(testCase)
  verifyTrue(testCase, abs(getStrikeFromDelta(100, 2, -1, 0.25, 0.4) - 97.3291) < 0.0001);
end
