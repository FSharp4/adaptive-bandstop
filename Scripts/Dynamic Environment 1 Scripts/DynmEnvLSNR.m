% DYNMENVLSNR: Script for loading a speech clip environment into the
% MATLAB workspace.
% 
%   Flags:
%   - sampleindex: [1-10] which sample to load. Samples are present in the
%   'Samples' folder
%   - targetSNR: target SNR value for sample to gaussian noise. If not
%   provided, the SNR is still calculated but not fixed. This value should
%   be in dB.
%% Medium 1: 

%Optional Flags. You can set these outside of this script if you want to
%change which soundclip loads/how much SNR the soundclip has

if ~exist('sampleindex', 'var')
    sampleindex = 3; % default sample from charts
end

if ~exist("targetSNR", 'var')
    targetSNR = -10; %dB
end

%information signal
[rec, Fs] = loadsample(sampleindex);
duration = 10; % in seconds
t = 0:1/Fs:duration - 1/Fs;
nsamples = length(t);
s = transpose(rec(1:nsamples));

%inteference signal
A = 1;
fi = 300;
i = A*sin(2*pi*fi*t);

%scale information to specified SNR
SNRdb = snr(s, i);
SNR = 10^(SNRdb / 10);
targetSNRRaw = 10^(targetSNR/10);
Gain = sqrt(targetSNRRaw / SNR);
s = s * Gain;

% Detected Signal
x = s + i;
