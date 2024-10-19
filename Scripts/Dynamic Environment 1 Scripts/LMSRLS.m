clear
clc
%% LMS1
load('DynmEnvLSNR.mat')

M      = 22; % FIR filter order
Mu     = 0.01; % step size
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
E1 = EnsembleMean(ConvRate(:));

%% RLS
x = x(:);
% FIR filter Design
M      = 22; % FIR filter order
d      = 1; % regularization parameter
lambda = linspace(0.8,1,6)';

nd     = 1; % delay sample
P = {};
w = {};
X = cell(1, length(lambda));
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
    SNR2_dB(q) = snr(e(:,q),y(:,q));
end

for L = 1:length(lambda)
    ConvRate(:,L) = abs((e(:,L)' - s).^2);
    E2(:,L)        = EnsembleMean(ConvRate(:,L));
end

%% PLot
figure(1)
subplot(2,1,1)
plot(t,E1,'r',t,E2(:,1),'b',t,E2(:,2),'g',t,E2(:,3),'y',t,E2(:,4),'c',t,E2(:,5),'m',t,E2(:,6),'k','LineWidth',1.5)
xlabel('time in sec', 'FontSize', 12)
ylabel('Amplitude in volts', 'FontSize', 12)
title('Mean Square Estimation Error as a function of time', 'FontSize', 14)
grid on
legend('Estimation Error @ M = 22; {\alpha} = 0.01','Estimation Error @ M = 22; {\delta} = 1; {\lambda} = 0.8',...
    'Estimation Error @ M = 22; {\delta} = 1; {\lambda} = 0.84', 'Estimation Error @ M = 22; {\delta} = 1; {\lambda} = 0.88',...
    'Estimation Error @ M = 22; {\delta} = 1; {\lambda} = 0.92', 'Estimation Error @ M = 22; {\delta} = 1; {\lambda} = 0.96',...
    'Estimation Error @ M = 22; {\delta} = 1; {\lambda} = 1', 'FontSize', 12)
