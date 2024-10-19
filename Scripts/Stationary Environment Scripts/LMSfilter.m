clc
clear

load('StatEnvLSNR.mat');

M      = 26; % FIR filter order
Mu     = 0.001; % step size
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

% figure(3)
% plot(t,x)
% grid on 
% xlabel('time in sec');
% ylabel('Detected Signal')
% ylim([-2 2])

figure(4)
subplot(2,1,1)
plot(t,i,'r')
grid on 
xlabel('time in sec');
title('Interference Signal')
ylim([-2 2])
xlim([0 0.05])
subplot(2,1,2)
plot(t,y,'g')
grid on 
xlabel('time in sec');
title('Filter Output')
ylim([-2 2])
xlim([0 0.05])

figure(5)
plot(t,e,'g', t,s,'r')
xlabel('time')
legend('Estimated Signal','Desired Signal')
grid on
% xlim([0 0.1])
ConvRate = abs((e - s).^2);
% figure(6)
% plot(t,ConvRate)
% xlabel('time')
% title('Absolute Value of Square Estimation Error as a function of time')
% grid on
E = EnsembleMean(ConvRate);
figure(7)
plot(t,E)
xlabel('time')
title('Mean Square Estimation Error as a function of time')
grid on
% xlim([0 0.05])

