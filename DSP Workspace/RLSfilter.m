% RLSFILTER: Recursive Least Squares Adaptive Filtering Script
% FIR filter Design Parameters + Defaults (all are optional except for x)
% x                % input signal array, MUST BE PROVIDED
% M      = 20;     % FIR filter order
% d      = 1e-4;   % regularization parameter
% lambda = 1;      % Forgetting Factor
% nd     = 1;      % delay sample
if ~exist('M', 'var')
    M = 16;
end
if ~exist('d', 'var')
    d = 1e-4;
end
if ~exist('lambda', 'var')
    lambda = 1;
end
if ~exist('nd', 'var')
    nd = 8;
end

P = {};
w(:,1) = zeros(M,1);
P{1,1}(:,:) = d^-1 * eye(M);

%% Filter input if delay "nd" was zero
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
        e(n,1)        = x(1,n) - y(n,1); %@Jake adj
        w(:,n+1)      = w(:,n) + k(:,n)*e(n,1);
        P{n+1,1}(:,:) = lambda^-1*P{n,1}(:,:) - lambda^-1*k(:,n)*transpose(zeros(M,1))*P{n,1}(:,:);
    else
        num           = lambda^-1 * P{n,1} * X(:,n-nd);
        den           = 1 + lambda^-1 * transpose(X(:,n-nd)) * P{n,1} * X(:,n-nd);
        k(:,n)        = num/den;
        y(n,1)        = transpose(w(:,n))*X(:,n-nd);
        e(n,1)        = x(1,n) - y(n,1); %@Jake adj
        w(:,n+1)      = w(:,n) + k(:,n)*e(n,1);
        P{n+1,1}(:,:) = lambda^-1*P{n,1}(:,:) - lambda^-1*k(:,n)*transpose(X(:,n-nd))*P{n,1}(:,:);
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
% plot(t,i,'r')
% grid on
% % ylim([-10 10])
% % xlim([0 0.3])
% xlabel('time in sec');
% title('Interference Signal')
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
% legend('Error Signal','Desired Signal')
% grid on
% 
% ConvRate = abs((e' - s).^2);
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