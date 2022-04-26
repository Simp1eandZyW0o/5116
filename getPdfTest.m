function tests = pdfTest
  tests = functiontests(localfunctions);
end

function testGetPdf(testCase)
  [spot, lag, days, domdfs, fordfs, vols, cps, deltas] = getMarket();
  tau = lag / 365;
  Ts = days / 365;
  domCurve = makeDepoCurve(Ts, domdfs);
  forCurve = makeDepoCurve(Ts, fordfs);
  fwdCurve = makeFwdCurve(domCurve, forCurve, spot, tau);
  volSurface = makeVolSurface(fwdCurve, Ts, cps, deltas, vols);
  fwd = getFwdSpot(fwdCurve, 1);
  pdf = getPdf(volSurface, 1, [fwd, fwd]);
  verifyTrue(testCase, abs(pdf(1) - 1.0901) <= 0.0001);
end
