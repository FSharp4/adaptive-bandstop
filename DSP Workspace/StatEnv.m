clc
clear
close all
%% Narrow Band Interference Signal : Deterministic Sine wave
Fs = 100; % Sampling frequency      % Dim
t  = transpose(0:1/Fs:10-1/Fs);     % DIm
A = 5;                              % Dim
fi = 1;                             % Dim
i = A*sin(2*pi*fi*t);               
figure(1)
subplot(3,1,1)
plot(t,i)
grid on 
xlabel('time in sec');
ylabel('Interference Signal')
ylim([-10 10])

%% Wide Band Desired White Gaussian Noise Signal
s = wgn(length(t),1,10);
subplot(3,1,2)
plot(t,s)
grid on 
xlabel('time in sec');
ylabel('Wide Band Signal')
ylim([-10 10])
% Rs = corrmtx(s,0);
%% Detected Signal
x = s + i;
subplot(3,1,3)
plot(t,x)
grid on 
xlabel('time in sec');
ylabel('Detected Signal')
ylim([-25 25])

%% Frequency Spectrums
% I = fftshift(fft(i));
% freq = (-length(I)/2 : length(I)/2-1)*Fs/length(I);
% I_mag = abs(I);
% figure(2)
% subplot(3,1,1)
% plot(freq,I_mag)
% xlabel('frequency')
% title('Interference Signal frequency spectrum')
% grid on
% 
% sf = fftshift(fft(s));
% freq = (-length(sf)/2 : length(sf)/2-1)*Fs/length(sf);
% sf_mag = abs(sf);
% subplot(3,1,2)
% plot(freq,sf_mag)
% xlabel('frequency')
% title('Original Desired Signal frequency spectrum')
% grid on
% 
% xf = fftshift(fft(x));
% freq = (-length(xf)/2 : length(xf)/2-1)*Fs/length(xf);
% xf_mag = abs(xf);
% subplot(3,1,3)
% plot(freq,xf_mag)
% xlabel('frequency')
% title('Detected Signal frequency spectrum')
% grid on