function [E, div] = EnsembleMean(x)
    csum = cumsum(x);
    indexing = 1:length(x);
    E = csum(:) ./ indexing(:);
    div = E(end) > 10 || isnan(E(end));
end
