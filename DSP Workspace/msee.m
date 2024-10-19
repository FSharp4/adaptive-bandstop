function [ learningcurve, see ] = msee(e, s)
    see = abs((e(:)-s(:)).^2);
    learningcurve = EnsembleMean(see);
end