clc
clear
close all
%% Narrow Band Interference Signal : Deterministic Sine wave
Fs = 8000; % Sampling frequency 8kHz
t  = transpose(0:1/Fs:5-1/Fs);
A = 1;
fi = 200;
i = A*sin(2*pi*fi*t);
figure(1)
subplot(3,1,1)
plot(t,i)
grid on 
xlabel('time in sec');
ylabel('Interference Signal')
ylim([-2 2])

%% Wide Band Desired White Gaussian Noise Signal
s = wgn(length(t),1,-14);
subplot(3,1,2)
plot(t,s)
grid on 
xlabel('time in sec');
ylabel('Wide Band Signal')
ylim([-1 1])

%% Detected Signal
x = s + i;
subplot(3,1,3)
plot(t,x)
grid on 
xlabel('time in sec');
ylabel('Detected Signal')
ylim([-2 2])

%% Signal To Noise Ratio of Environment
Ps     = (rms(s))^2;
Pn     = (rms(i))^2;
SNR_dB = 10*log10(Ps/Pn);