%checkcorrelation

DynmEnv

bounds = zeros(2,10);
ii = 1;
[acf,lags,bounds(:,ii)] = autocorr(s);
figure
subplot(2,1,1);
plot(lags, acf);
hold on
xlabel("Sample Delay");
ylabel("Autocorrelation Function value");
decorrelateddelayindex = zeros(1,10);
decorrelateddelayindex(1) = find(abs(acf) == min(abs(acf))) - 1;
while ii < 10
    ii = ii + 1;
    sampleindex = ii;
    DynmEnv
    [acf,lags,bounds(:,ii)] = autocorr(s);
    decorrelateddelayindex(ii) = find(abs(acf) == min(abs(acf))) - 1;
    plot(lags, acf);
end
hold off
subplot(2,1,2)
plot(1:10, bounds(1,:), 1:10, bounds(2,:));
xlabel("Recording #")
ylabel("Upper/Lower Confidence Bounds") % these are symmetrical
suggesteddelay = round(mean(decorrelateddelayindex));
fprintf('Suggested sample delay (nd): %f', suggesteddelay);
