%% Medium 2: 
clc
clear
close all
%Narrow Band Interference Signal : Sine wave with time varying frequency
Fs = 8000; % Sampling frequency 8kHz
SimulationTime = 5; % time in seconds
t  = transpose(0:1/Fs:SimulationTime-1/Fs);
A = 2;
FreqDuration = 0.5; % every 500ms frequency change
FreqCount    = SimulationTime/FreqDuration;
FreqValues   = linspace(50,500,FreqCount); 

for i = 1:length(FreqValues)
    freq(:,i) = repelem(FreqValues(1,i), FreqDuration*Fs);
end

f = reshape(freq, FreqDuration*Fs*FreqCount,1);
i = A*sin(2*pi*f.*t);
figure(2)
subplot(3,1,1)
plot(t,i)
grid on 
xlabel('time in sec');
ylabel('Interference Signal')
ylim([-5 5])

%% White Gaussian Noise
s = wgn(length(t),1,6); 
subplot(3,1,2)
plot(t,s)
grid on 
xlabel('time in sec');
ylabel('Wide Band Signal')
ylim([-15 15])

%% Detected Signal
x = s + i;
subplot(3,1,3)
plot(t,x)
grid on 
xlabel('time in sec');
ylabel('Detected Signal')
ylim([-15 15])

%% Signal To Noise Ratio of Environment
Ps     = (rms(s))^2;
Pn     = (rms(i))^2;
SNR_dB = 10*log10(Ps/Pn);