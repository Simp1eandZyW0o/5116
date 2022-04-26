function tests = getMakeFwdCurveTest
  tests = functiontests(localfunctions);
end

function testMakeFwdCurve(testCase)
  curve = makeFwdCurve(struct('ts', [3; 7; 11],'rates', [1.2; 2.5; 4.6]), ...
    struct('ts', [3; 7; 11], 'rates', [1.4; 2.2; 3.5]), 0.6, 2.5);
  verifyTrue(testCase, abs(curve.cashRate - 0.8514) < 0.0001);
  verifyTrue(testCase, all(abs(curve.spreadCurve.rates - [-0.2; -0.3; 1.1]) < 0.0001));
end

function testequalSize(testCase)
  verifyError(testCase, @()makeFwdCurve(struct('ts', [1.5],'rates', [1.5]),struct('ts', [1.5, 2.5],'rates', [1.5, 2.5]), 1.5, 1.5), 'makeFwdCurve:UnequalSize');
end
