% LMSFILTER: Least Mean Squares Adaptive Filtering Script
clear
clc
load('DynmEnvLSNR.mat') % Change line to load different scenario

M      = 22; % FIR filter order
Mu     = 1e-2; % step size
nd     = 8; % delay sample

clear w
w(:,1) = zeros(M,1);
e = zeros(length(x), 1);
y = zeros(length(x),1);
X = zeros(M, length(x));
for n = 1:length(x)
    if n < M
        X(:,n) = [flipud(x(1:n))';zeros(M-n,1)];
    else
        if n == M
            X(:,n) = flipud(x(1:M));
        else % n > M
            X(:,n) = flipud(x(n-M+1:n));
        end
    end
end

for n = 1:length(x)
    if n <= nd
        y(n,1)   = 0;
        e(n,1)   = x(1,n) - y(n,1);
        w(:,n+1) = w(:,n);
    else
        y(n,1)   = transpose(w(:,n))*X(:,n-nd);
        e(n,1)   = x(1,n) - y(n,1);
        w(:,n+1) = w(:,n) + Mu*e(n,1)*X(:,n-nd);
    end
end

SNR2_dB = snr(e,y);
ConvRate = abs(e(:) - s(:).^2);
E = EnsembleMean(ConvRate(:));

%% Plot Information Signal
figure(1)
plot(t,e,'g',t,s,'r');
grid on
xlabel('Time (seconds)')
ylabel('Amplitude (Volts)')
title('Information Signals')
legend('Estimated Signal', 'Desired Signal')

%% Plot MSEE
figure(2)
plot(t,E)
xlabel('Time (seconds)')
ylabel('Amplitude (Volts)')
title('Mean Square Estimation Error over time')
