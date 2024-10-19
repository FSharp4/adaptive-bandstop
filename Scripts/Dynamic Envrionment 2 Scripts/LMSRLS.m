clc
clear
close all

load('DynEnvMSNR.mat');

%% LMS Algorithm
M      = 22; % FIR filter order
Mu     = 1e-4; % step size
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
        y1(n,1)   = 0;
        e(n,1)   = x(n,1) - y1(n,1);
        w(:,n+1) = w(:,n);
    else
        y1(n,1)   = transpose(w(:,n))*X(:,n-nd);
        e(n,1)   = x(n,1) - y1(n,1);
        w(:,n+1) = w(:,n) + Mu*e(n,1)*X(:,n-nd);
    end
end
Pe      = (rms(e))^2;
Py1      = (rms(y1))^2;
SNR2_dB = 10*log10(Pe/Py1);
ConvRate = abs((e - s).^2);
E1 = EnsembleMean(ConvRate);

%% RLS Algorithm
clc
load('DynEnvMSNR.mat');

% FIR filter Design
M      = 22; % FIR filter order
d      = 1000; % regularization parameter
lambda = [ 0.990 0.992 0.994 0.996 0.998 1 ]'; 

nd     = 1; % delay sample
P = {};
w = {};
X = {};
k = {};

for q = 1:length(lambda)
    w{q}(:,1) = zeros(M,1);
    P{1,q}(:,:) = d^-1 * eye(M);
    for n = 1:length(x)
        if n < M
            X{q}(:,n) = [flipud(x(1:n,1));zeros(M-n,1)];
        else
            if n == M
                X{q}(:,n) = flipud(x(1:M,1));
            else % n > M
                X{q}(:,n) = flipud(x(n-M+1:n,1));
            end
        end
    end

    % RLS Algorithm
    for n = 1:length(x)
        if n <= nd
            num           = lambda(q,1)^-1 * P{n,q} * zeros(M,1);
            den           = 1 + lambda(q,1)^-1 * transpose(zeros(M,1)) * P{n,q} * zeros(M,1);
            k{q}(:,n)     = num/den;
            y(n,q)        = transpose(w{q}(:,n))*zeros(M,1);
            e(n,q)        = x(n,1) - y(n,q);
            w{q}(:,n+1)   = w{q}(:,n) + k{q}(:,n)*e(n,q);
            P{n+1,q}(:,:) = lambda(q,1)^-1*P{n,q}(:,:) - lambda(q,1)^-1*k{q}(:,n)*transpose(zeros(M,1))*P{n,q}(:,:);
        else
            num           = lambda(q,1)^-1 * P{n,q} * X{q}(:,n-nd);
            den           = 1 + lambda(q,1)^-1 * transpose(X{q}(:,n-nd)) * P{n,q} * X{q}(:,n-nd);
            k{q}(:,n)     = num/den;
            y(n,q)        = transpose(w{q}(:,n))*X{q}(:,n-nd);
            e(n,q)        = x(n,1) - y(n,q);
            w{q}(:,n+1)   = w{q}(:,n) + k{q}(:,n)*e(n,q);
            P{n+1,q}(:,:) = lambda(q,1)^-1*P{n,q}(:,:) - lambda(q,1)^-1*k{q}(:,n)*transpose(X{q}(:,n-nd))*P{n,q}(:,:);
        end
    end
    Pe(q)      = (rms(e(:,q)))^2;
    Py(q)      = (rms(y(:,q)))^2;
    SNR2_dB(q) = 10*log10(Pe(q)/Py(q));
end

for L = 1:length(lambda)
    ConvRate(:,L) = abs((e(:,L) - s).^2);
    E2(:,L)        = EnsembleMean(ConvRate(:,L));
end

figure(1)
subplot(2,1,1)
plot(t,E1,'r',t,E2(:,1),'b',t,E2(:,2),'g',t,E2(:,3),'y',t,E2(:,4),'c',t,E2(:,5),'m',t,E2(:,6),'k','LineWidth',1.5)
xlabel('time in sec')
ylabel('Amplitude in volts')
title('Mean Square Estimation Error as a function of time')
grid on
legend('Estimation Error @ M = 22; {\alpha} = 0.0001','Estimation Error @ M = 22; {\delta} = 10000; {\lambda} = 0.990',...
    'Estimation Error @ M = 22; {\delta} = 10000; {\lambda} = 0.992', 'Estimation Error @ M = 22; {\delta} = 10000; {\lambda} = 0.994',...
    'Estimation Error @ M = 22; {\delta} = 10000; {\lambda} = 0.996', 'Estimation Error @ M = 22; {\delta} = 10000; {\lambda} = 0.998',...
    'Estimation Error @ M = 22; {\delta} = 10000; {\lambda} = 1.000')