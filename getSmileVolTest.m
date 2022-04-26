function tests = getSmileVolTest
  tests = functiontests(localfunctions);
end

function testGetSmileVol(testCase)
  [spot, lag, days, domdfs, fordfs, vols, cps, deltas] = getMarket();
  % calcualte tau and days
  tau = lag / 365;
  Ts = days / 365;
  % get curve
  domCurve = makeDepoCurve(Ts, domdfs);
  forCurve = makeDepoCurve(Ts, fordfs);
  fwdCurve = makeFwdCurve(domCurve, forCurve, spot, tau);
  % construct smile curve
  smileCurve = makeSmile(fwdCurve, Ts(end), cps, deltas, vols(end,:));
  fwdSpots = [getFwdSpot(fwdCurve, Ts(2)), getFwdSpot(fwdCurve, Ts(end))];
  ATMfvol = getSmileVol(smileCurve, fwdSpots);
  verifyTrue(testCase, abs(ATMfvol(1) - 0.29987) < 0.00001);
  verifyTrue(testCase, abs(ATMfvol(2) - 0.29994) < 0.00001);
end

function testNegativeStrikeError(testCase)
  verifyError(testCase, @()getSmileVol([], -100),'getSmileVol:NegativeStrikeError');
end
