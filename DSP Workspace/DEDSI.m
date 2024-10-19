%DynamicEnvironmentDesignSpaceInvestigation
%% Initialize Investigation
targetSNR = -10; %dB

%% Load LMS1
Name = "Trial One (Mu=1e-2)";
M = 16;
Mu = 1e-2;
nd = 8;
tic
SIDSSlice
toc
meanlearningcurves = zeros(4, length(x));
meanlearningcurves(1,:) = learningcurve;

%% Load LMS2
M = 16;
Mu = 1e-3;
nd = 8;
Name = "Trial Two (Mu=1e-3)";
tic
SIDSSlice
toc
meanlearningcurves(2,:) = learningcurve;

%% Load LMS3
M = 16;
Mu = 1e-4;
nd = 8;
Name = "Trial Three (Mu=1e-4)";
tic
SIDSSlice
toc
meanlearningcurves(3,:) = learningcurve;

%% Load LMS4
M = 16;
Mu = 1e-5;
nd = 8;
Name = "Trial Four (Mu=1e-5)";
tic
SIDSSlice
toc
meanlearningcurves(4,:) = learningcurve;

figure
hold on
for ii=1:4
    plot(t, meanlearningcurves(ii,:))
end
hold off
xlabel("Time (s)")
ylabel("Mean Square Estimation Error")
legend('step size 0.01', 'step size 0.001', 'step size 0.0001', 'step size 0.00001')
