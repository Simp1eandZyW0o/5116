function tests = getFwdSpotTest
  tests = functiontests(localfunctions);
end

function testGetFwdSpot(testCase)
  curve = makeFwdCurve(struct('ts', [3; 7; 11],'rates', [1.2; 2.5; 4.6]), struct('ts', [3; 7; 11], 'rates', [1.4; 2.2; 3.5]), 0.6, 2.5);
  verifyTrue(testCase, abs(getFwdSpot(curve, 2) - 0.8514) < 0.0001);
end

function testNegative(testCase)
  verifyError(testCase, @()getFwdSpot([], -1), 'getFwdSpot:NegativeError');
end
