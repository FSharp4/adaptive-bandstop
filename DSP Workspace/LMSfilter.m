% LMSFILTER: Least Mean Squares Adaptive Filtering Script
% Flags:
% - x: Input signal array
% - M: Filter Order (Optional, Default is 16)
% - Mu: Step Size (Optional, Default is 1e-3)
% - nd: Sample delay parameter (Optional, Default is 8)

% clc
% clear

%@Jake: Disabled for testing deterministic dynamic environment 
%    (sound samples + sine noise)

% load('StatEnvLSNR.mat');
% load('DynEnv1LSNR.mat');
% load('DynEnv2LSNR.mat');
% load('DynEnv2MSNR.mat');


% M      = 20; % FIR filter order
% Mu     = 1e-3; % step size
% nd     = 1; % delay sample

if ~exist("M", 'var')
    M = 16;
end
if ~exist("nd", 'var')
    nd = 8; % 8 is calculated from checkcorrelation over samples present in Samples
end
if ~exist('Mu', 'var')
    Mu = 1e-3;
end

w(:,1) = zeros(M,1);
%@Jake: prealloc
e = zeros(length(x), 1);
y = zeros(length(x),1);
X = zeros(M, length(x));
for n = 1:length(x)
    if n < M
%         X(:,n) = [flipud(x(1:n,1));zeros(M-n,1)]; %@Jake: remove ',1' from x declarations that would break
        X(:,n) = [flipud(x(1:n))';zeros(M-n,1)];
    else
        if n == M
            X(:,n) = flipud(x(1:M)); %@Jake: adjusted see above
        else % n > M
            X(:,n) = flipud(x(n-M+1:n)); %@Jake: adjusted see above
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

% Pe      = (rms(e))^2;
% Py      = (rms(y))^2;
% SNR2_dB = 10*log10(Pe/Py);
% 
% % figure(3)
% % plot(t,x)
% % grid on 
% % xlabel('time in sec');
% % ylabel('Detected Signal')
% % ylim([-30 30])
% 
% figure(4)
% subplot(2,1,1)
% plot(t,i,'r') %#ok<*IJCL> @Jake suppress err msg
% grid on 
% xlabel('time in sec');
% title('Interference Signal')
% % ylim([-10 10])
% % xlim([0 0.3])
% subplot(2,1,2)
% plot(t,y,'g')
% grid on 
% xlabel('time in sec');
% title('Filter Output')
% % ylim([-10 10])
% % xlim([0 0.3])
% 
% figure(5)
% plot(t,e,'g', t,s,'r')
% xlabel('time')
% legend('Estimated Signal','Desired Signal')
% grid on
% 
% ConvRate = abs((e' - s).^2); % @Jake: transposed e
% % figure(6)
% % plot(t,ConvRate)
% % xlabel('time')
% % title('Absolute Value of Square Estimation Error as a function of time')
% % grid on
% E = EnsembleMean(ConvRate);
% figure(7)
% plot(t,E)
% xlabel('time')
% title('Mean Square Estimation Error as a function of time')
% grid on

% xf = fftshift(fft(x));
% freq = (-length(xf)/2 : length(xf)/2-1)*Fs/length(xf);
% xf_mag = abs(xf);
% 
% sf = fftshift(fft(s));
% freq = (-length(sf)/2 : length(sf)/2-1)*Fs/length(sf);
% sf_mag = abs(sf);
% 
% yf = fftshift(fft(y));
% freq = (-length(yf)/2 : length(yf)/2-1)*Fs/length(yf);
% yf_mag = abs(yf);
% 
% ef = fftshift(fft(e));
% freq = (-length(ef)/2 : length(ef)/2-1)*Fs/length(ef);
% ef_mag = abs(ef);
% 
% figure(6)
% subplot(2,2,1)
% plot(freq,xf_mag)
% xlabel('frequency')
% title('Detected Signal frequency spectrum')
% grid on
% 
% subplot(2,2,2)
% plot(freq,sf_mag)
% xlabel('frequency')
% title('Original Desired Signal frequency spectrum')
% grid on
% 
% 
% subplot(2,2,3)
% plot(freq,yf_mag)
% xlabel('frequency')
% title('Filtered Signal frequency spectrum')
% grid on
% 
% subplot(2,2,4)
% plot(freq,ef_mag)
% xlabel('frequency')
% title('Error Signal frequency spectrum')
% grid on
