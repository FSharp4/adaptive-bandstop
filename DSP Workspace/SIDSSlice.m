% SIDSSlice
% Assume LMS and targetSNR is set
sampleindex = 1;
if ~exist("Name", 'var')
    Name = "Unnamed";
end
f = waitbar(0, "Investigation: " + Name + "Run 1 out of 10");
DynmEnv;
learningcurves = zeros(10, length(x));
LMSfilter;
learningcurves(sampleindex, :) = msee(e,s);
for sampleindex = 2:10
    waitbar((sampleindex-1)/10, f, "Investigation: " + Name + ": Run " + sampleindex + " out of 10")
    DynmEnv
    LMSfilter;
    learningcurves(sampleindex,:) = msee(e,s);
end
waitbar(1, f, "Investigation: " + Name + ": Calculating mean learning curve")
learningcurve = mean(learningcurves);
close(f)