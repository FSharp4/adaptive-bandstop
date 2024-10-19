clc
clear

load('DynEnvMSNR.mat');

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
E = EnsembleMean(ConvRate);

figure(4)
subplot(2,1,1)
plot(t,i,'r')
grid on 
xlabel('time in sec');
ylabel('Amplitude in volts')
title('Interference Signal')
ylim([-4 4])
xlim([0.40 0.60])
subplot(2,1,2)
plot(t,y,'g')
grid on 
xlabel('time in sec');
ylabel('Amplitude in volts')
title('Filter Output')
ylim([-4 4])
xlim([0.40 0.60])

figure(5)
plot(t,e,'g', t,s,'r')
xlabel('time')
legend('Estimated Signal','Desired Signal')
grid on

% figure(6)
% plot(t,ConvRate)
% xlabel('time')
% title('Absolute Value of Square Estimation Error as a function of time')
% grid on

figure(7)
plot(t,E)
xlabel('time in sec')
ylabel('Amplitude in volts')
title('Mean Square Estimation Error as a function of time')
grid on

