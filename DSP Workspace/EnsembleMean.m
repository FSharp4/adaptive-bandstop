function E = EnsembleMean(x)

for n = 1:length(x)
    E(n,1) = sum(x(1:n))/n;
end

end