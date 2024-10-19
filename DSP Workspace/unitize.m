function [out] = unitize(in)
    maxin = max(abs(in(:)));
    out = in / maxin;
end