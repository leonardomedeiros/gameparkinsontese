function [cycleIndex]=cycleperiodic(v, delta, maxAmplitude, minAmplitude)
[peaks, valey] = peakdet(v, delta);
j = 1;
for (i=1:(size(valey,1)-1))    
    initialIndex = valey(i,1);
    endIndex = valey(i+1,1);
    amplitude = endIndex - initialIndex;
    if ((maxAmplitude >= amplitude) & (minAmplitude <= amplitude))
        cycleIndex(j) = valey(i);
        j = j +1;
    end
end

end

