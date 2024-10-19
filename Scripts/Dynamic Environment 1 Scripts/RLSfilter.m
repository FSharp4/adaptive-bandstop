% RLSFILTER: Recursive Least Squares Adaptive Filtering Script
clear
clc
load('DynmEnvLSNR.mat') % Change line to load different scenario

M      = 22;     % FIR filter order
d      = 1e-4;      % regularization parameter
lambda = 0.999;  % Forgetting Factor
nd     = 8;      % delay sample

P = {};
clear w
clear X
w(:,1) = zeros(M,1);
P{1,1}(:,:) = d^-1 * eye(M);

%% Filter input
for n = 1:length(x)
    if n < M
        X(:,n) = [flipud(x(1:n))';zeros(M-n,1)]; %@Jake adj
    else
        if n == M
            X(:,n) = flipud(x(1:M));
        else % n > M
            X(:,n) = flipud(x(n-M+1:n));
        end
    end
end

k = zeros(M, length(x));
y = zeros(length(x),1);
e = y;

%% RLS Algorithm
for n = 1:length(x)
    if n <= nd
        num           = lambda^-1 * P{n,1} * zeros(M,1);
        den           = 1 + lambda^-1 * transpose(zeros(M,1)) * P{n,1} * zeros(M,1);
        k(:,n)        = num/den;
        y(n,1)        = transpose(w(:,n))*zeros(M,1);
        e(n,1)        = x(1,n) - y(n,1);
        w(:,n+1)      = w(:,n) + k(:,n)*e(n,1);
        P{n+1,1}(:,:) = lambda^-1*P{n,1}(:,:) - lambda^-1*k(:,n)*transpose(zeros(M,1))*P{n,1}(:,:);
    else
        num           = lambda^-1 * P{n,1} * X(:,n-nd);
        den           = 1 + lambda^-1 * transpose(X(:,n-nd)) * P{n,1} * X(:,n-nd);
        k(:,n)        = num/den;
        y(n,1)        = transpose(w(:,n))*X(:,n-nd);
        e(n,1)        = x(1,n) - y(n,1);
        w(:,n+1)      = w(:,n) + k(:,n)*e(n,1);
        P{n+1,1}(:,:) = lambda^-1*P{n,1}(:,:) - lambda^-1*k(:,n)*transpose(X(:,n-nd))*P{n,1}(:,:);
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
ylabel('Estimation Error ({V^2})')
title('Mean Square Estimation Error over time')