clc
clear
close all

load('StatEnvLSNR.mat');
%% LMS Algorithm 
M      = 18; % FIR filter order
Mu     = 0.01; % step size
nd     = 1; % delay sample

w(:,1) = zeros(M,1);

for n = 1:length(x)
    if n < M
        X(:,n) = [flipud(x(1:n,1));zeros(M-n,1)];
    else
        if n == M
            X(:,n) = flipud(x(1:M,1));
        else % n > M
            X(:,n) = flipud(x(n-M+1:n,1));
        end
    end
end
for n = 1:length(x)
    if n <= nd
        y(n,1)   = 0;
        e(n,1)   = x(n,1) - y(n,1);
        w(:,n+1) = w(:,n);
    else
        y(n,1)   = transpose(w(:,n))*X(:,n-nd);
        e(n,1)   = x(n,1) - y(n,1);
        w(:,n+1) = w(:,n) + Mu*e(n,1)*X(:,n-nd);
    end
end
Pe      = (rms(e))^2;
Py      = (rms(y))^2;
SNR2_dB = 10*log10(Pe/Py);
ConvRate = abs((e - s).^2);
E1 = EnsembleMean(ConvRate);

%% RLS Algorithm
clc
% clear
load('StatEnvLSNR.mat');

% FIR filter Design
M      = 18; % FIR filter order
d      = 1; % regularization parameter
lambda = 1; % Forgetting Factor
nd     = 1; % delay sample
P = {};
w(:,1) = zeros(M,1);
P{1,1}(:,:) = d^-1 * eye(M);

% Filter input if delay "nd" was zero
for n = 1:length(x)
    if n < M
        X(:,n) = [flipud(x(1:n,1));zeros(M-n,1)];
    else
        if n == M
            X(:,n) = flipud(x(1:M,1));
        else % n > M
            X(:,n) = flipud(x(n-M+1:n,1));
        end
    end
end

% RLS Algorithm
for n = 1:length(x)
    if n <= nd
        num           = lambda^-1 * P{n,1} * zeros(M,1);
        den           = 1 + lambda^-1 * transpose(zeros(M,1)) * P{n,1} * zeros(M,1);
        k(:,n)        = num/den;
        y(n,1)        = transpose(w(:,n))*zeros(M,1);
        e(n,1)        = x(n,1) - y(n,1);
        w(:,n+1)      = w(:,n) + k(:,n)*e(n,1);
        P{n+1,1}(:,:) = lambda^-1*P{n,1}(:,:) - lambda^-1*k(:,n)*transpose(zeros(M,1))*P{n,1}(:,:);
    else
        num           = lambda^-1 * P{n,1} * X(:,n-nd);
        den           = 1 + lambda^-1 * transpose(X(:,n-nd)) * P{n,1} * X(:,n-nd);
        k(:,n)        = num/den;
        y(n,1)        = transpose(w(:,n))*X(:,n-nd);
        e(n,1)        = x(n,1) - y(n,1);
        w(:,n+1)      = w(:,n) + k(:,n)*e(n,1);
        P{n+1,1}(:,:) = lambda^-1*P{n,1}(:,:) - lambda^-1*k(:,n)*transpose(X(:,n-nd))*P{n,1}(:,:);
    end
end
Pe      = (rms(e))^2;
Py      = (rms(y))^2;
SNR2_dB = 10*log10(Pe/Py);
ConvRate = abs((e - s));
E2 = EnsembleMean(ConvRate);

figure(1)
subplot(2,1,1)
plot(t,E1,'g',t,E2,'b')
xlabel('time in sec')
ylabel('Amplitude in volts')
title('Mean Square Estimation Error as a function of time')
grid on
legend('Estimation Error @ M = 18; {\alpha} = 0.01','Estimation Error @ M = 18; {\delta} = 1; {\lambda} =1')
xlim([0 0.1])