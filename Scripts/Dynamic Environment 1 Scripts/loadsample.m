function [sample, fs] = loadsample(n)

[~, samples] = system('ls samples');
samples = split(samples);
samples = samples(1:end-1);
if (n > 0 && n <= length(samples))
    [sample, fs] = audioread("Samples/" + samples(n));
else
    warning("Invalid sample index %f, max is %f. Ordering is determined by ls output:", n, length(samples));
    samples
    error("Invalid Sample")
end