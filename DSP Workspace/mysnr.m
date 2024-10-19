function [SNRdb, SNR] = mysnr(signal, noise)
    Psignal = rms(signal)^2;
    Pnoise = rms(noise)^2;
    SNR = Psignal/Pnoise;
    SNRdb = 10 * log10(SNR);
end