
% Normalise a vector between 0 and 1.
function out = normalise(in)
out = in./max(abs(in));
end

