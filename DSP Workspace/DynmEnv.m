% DYNMENV: Script for loading a dynamic environment into the matlab
%   workspace
% 
%   Flags:
%   - sampleindex: [1-10] which sample to load. Samples are present in the
%   'Samples' folder
%   - targetSNR: target SNR value for sample to gaussian noise. If not
%   provided, the SNR is still calculated but not fixed. This value should
%   be in dB.
%% Medium 1: 

%New Code

if ~exist('sampleindex', 'var')
    sampleindex = 1;
end
[rec, Fs] = loadsample(sampleindex);
duration = 10; % in seconds
t = 0:1/Fs:duration - 1/Fs;
nsamples = length(t);
s = unitize(transpose(rec(1:nsamples)));
%Old Code

% Speech Signal
% Fs = 10000; % Sampling frequency
% t  = 0:1/Fs:5-1/Fs; % time span is 1 sec
% rec = audiorecorder(Fs, 8, 1);
% disp('start speaking')
% recordblocking(rec,5);
% disp('end of speech')
% speech = getaudiodata(rec);
% s = 10*transpose(speech); % power of noise is same as power in deterministic sine wave
% subplot(3,1,2)
% plot(t,s)
% grid on 
% xlabel('time in sec');
% ylabel('Wide Band Signal')
% ylim([-10 10])

A = 1;
fi = 150;
i = A*sin(2*pi*fi*t);
% disp("Did it")
[SNRdb, SNR] = mysnr(s,i);
if exist("targetSNR", 'var')
    targetSNRRaw = 10^(targetSNR/10);
    Gain = sqrt(targetSNRRaw / SNR);
    s = s * Gain; % This produces our target SNR
    [SNRdb, SNR] = mysnr(s,i);
end

% Detected Signal
x = s + i;


% figure(1)
% subplot(3,1,1)
% plot(t,i)
% grid on 
% xlabel('time in sec');
% ylabel('Interference Signal')
% ylim([-10 10])
% subplot(3,1,2);
% plot(t,s);
% grid on
% xlabel('time in sec');
% ylabel('Wide Band Signal');
% ylim([-10 10]);
% subplot(3,1,3)
% plot(t,x)
% grid on 
% xlabel('time in sec');
% ylabel('Detected Signal')
% ylim([-10 10])

%% Medium 2: 
% %Narrow Band Interference Signal : Sine wave with time varying frequency
% Fs = 10000; % Sampling frequency
% t  = 0:1/Fs:0.1; % time span is 1 sec
% A = 5;
% fi1 = 350;
% fi2 = 700;
% fi3 = 100;
% t1 = 0:1/Fs:0.04;
% t2 = 0.04+1/Fs:1/Fs:0.07;
% t3 = 0.07+1/Fs:1/Fs:0.1;
% 
% i1 = A*sin(2*pi*fi1*t1);
% i2 = A*sin(2*pi*fi2*t2);
% i3 = A*sin(2*pi*fi3*t3);
% i = [i1 i2 i3]; 
% figure(2)
% subplot(3,1,1)
% plot(t,i)
% grid on 
% xlabel('time in sec');
% ylabel('Interference Signal')
% ylim([-10 10])
% 
% % White Gaussian Noise
% s = transpose(wgn(length(t),1,A^2/4)); 
% subplot(3,1,2)
% plot(t,s)
% grid on 
% xlabel('time in sec');
% ylabel('Wide Band Signal')
% ylim([-10 10])
% 
% % Detected Signal
% x = s + i;
% subplot(3,1,3)
% plot(t,x)
% grid on 
% xlabel('time in sec');
% ylabel('Detected Signal')
% ylim([-10 10])