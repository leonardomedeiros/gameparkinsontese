

function [ velocityUp velocityDown amplitude selectedCycles] = LMMAngleVelocity( rawdatacolumn, numcycles, scaledLength)
i = 1;
initialCycle = 1;

timestamp = rawdatacolumn(:,1);
angles = rawdatacolumn(:,2);

%Clean Unfinished Cycles
indicesvaley = peakfinder(angles,[],[],-1);
allcycle = angles(indicesvaley(initialCycle):indicesvaley(length(indicesvaley)-1));
%figure(100);
%plot(allcycle);
%title('Identified Cycles of Relative Angle in the Upper Limb Movement');
timestamp = timestamp(indicesvaley(initialCycle):indicesvaley(length(indicesvaley)-1));

%3D Graphic
%figure(4)
%plot(angles) 
%Shift for only positive positions
%miniminumvalue = abs(min(allcycle));
%allcycle = allcycle + miniminumvalue;


indicesvaley = peakfinder(allcycle,[],[],-1);
indicespeaks = peakfinder(allcycle,[],[],+1);
numcycles = min(numcycles, length(indicespeaks));

%% Filter Wrong Data
threeSholdVariance = 0.4;
threeSholdAmplitudeMinValue = mean(allcycle(indicespeaks))*(1-threeSholdVariance);
threeSholdAmplitudeMaxValue = mean(allcycle(indicespeaks))*(1+threeSholdVariance);

%threeSholdLongitudeMinValue = 60;
%threeSholdLongitudeMaxValue = 200;

%figure(1);
%plot(allcycle);

begincycle = indicesvaley(initialCycle);
i = initialCycle;
selectedCycles = [];
identifiedCycles = 0;
endCycle = initialCycle + 1;
while ((identifiedCycles<numcycles) & (length(indicesvaley)>endCycle))
    %index = index+1;
    endCycle = (i + 1);
    cycle = allcycle(indicesvaley(i):indicesvaley(endCycle));

    %Velocidade qubeginyposition= 
    %endypositione levanta o braço
    peak = peakfinder(cycle);
    longitude = indicesvaley(endCycle) - indicesvaley(i);
    
    %Remove Invalid Cycles;
    %if ((cycle(peak) < threeSholdAmplitudeMinValue) | (cycle(peak) > threeSholdAmplitudeMaxValue) | (longitude < threeSholdLongitudeMinValue) | (longitude > threeSholdLongitudeMaxValue))
    if ((cycle(peak) < threeSholdAmplitudeMinValue) | (cycle(peak) > threeSholdAmplitudeMaxValue))
        i = i + 1;
        continue;
    else
        identifiedCycles = identifiedCycles + 1
    end 
    
    timestampcycle = timestamp(indicesvaley(i):indicesvaley(endCycle));
    selectedCycles(identifiedCycles,:) = scalingCycles(cycle, scaledLength);
    %selectedCycles = [selectedCycles scaledCycle];
    
    distanceup = cycle(peak) - cycle(1);
    amplitude(identifiedCycles,1) = cycle(peak);
    
    timestampupsec = (abs(timestampcycle(1) - timestampcycle(peak)))/1000;
    velocityUp(identifiedCycles,1) = distanceup/timestampupsec;
    %plot(gaitcyclefeatures)

    distancedown = abs(cycle(end) - cycle(peak));
    timestampdownsec = (abs(timestampcycle(peak) - timestampcycle(end)))/1000;
    %timestampupsec = (timestamp(indicesvaley(endCycle) - timestamp(indicespeaks(i))))/1000;
    velocityDown(identifiedCycles,1) = distancedown/timestampdownsec;
    
    begincycle = endCycle;
    i = i + 1;
end

%remove  negative values of cycles
minimumCycleValue = min(selectedCycles);
if (minimumCycleValue < 0)
  selectedCycles = selectedCycles + abs(minimumCycleValue);   
end

end

%%Function to Scale The Person Cycles
function [scaledCycle] = scalingCycles(cycle, scaledLength)
     % scaling the cycle
    scaling = scaledLength/length(cycle) .* (1:length(cycle));
    scaledCycle = interp1(scaling, cycle, 1:scaledLength);
end

