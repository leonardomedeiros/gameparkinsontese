%function [ EigenKinnectData, AllVelocityUp, AllVelocityDown, AllAmplitude, labels] = prepareEigenKinnectData( )
function [ EigenKinnectData, processedCycles, labels] = prepareEigenKinnectData( directoryDatabase)

numCycles = 6;
scaledLength = 30;
directories = dir(directoryDatabase);
sep = '/';

filesH = countFilesType('0',directories);
filesParkinson = countFilesType('1',directories);


% TLabel(*,1) = 0 means healthy, = 1 stroke, = 2 parkinson
% TLabel(*,2) = subject id
% TLabel(*,3) = 0 train data, = 1 means test data
% TLabel(*,4) = Classification Result


numberOfSubjects = size(directories,1) - 2;
labels = zeros(numberOfSubjects*numCycles,4);
%Labels of Parkinson
labels((filesH)*numCycles+1:end,1) = 1;
%Labels of Stroke
%labels(filesH*numCycles+1:end,1) = 2;

%This variable storage the collums of velocity and amplitude of each cycle
othersFeaturesLength = 6;

T = zeros(numberOfSubjects*numCycles,2*scaledLength);
otherFeatures = zeros(numberOfSubjects*numCycles,othersFeaturesLength);
cycleCounter = 1;

subjectId = 1;
for (i=3:size(directories))
    
    files = dir(strcat(directoryDatabase,sep,directories(i).name,strcat(sep,'*.dat')));
    directories(i).name;
    torsoJoint = load(endFileName(strcat(directoryDatabase,sep,directories(i).name), sep, files, 'Torso.dat'));  

    leftShoulderJoint = load(endFileName(strcat(directoryDatabase,sep,directories(i).name), sep, files,'LeftShoulder.dat'));  
    leftWristJoint = load(endFileName(strcat(directoryDatabase,sep,directories(i).name), sep, files,'LeftWrist.dat'));  
    leftHipJoint = load(endFileName(strcat(directoryDatabase,sep,directories(i).name), sep, files,'LeftHip.dat'));  

    rightShoulderJoint = load(endFileName(strcat(directoryDatabase,sep,directories(i).name), sep, files,'RightShoulder.dat'));  
    rightWristJoint = load(endFileName(strcat(directoryDatabase,sep,directories(i).name), sep,files,'RightWrist.dat'));  
    rightHipJoint = load(endFileName(strcat(directoryDatabase,sep,directories(i).name), sep,files,'RightHip.dat'));  
    
    [WindowBeginLeft, WindowLengthLeft, WindowBeginRight, WindowLengthRight] = identifyCycles(leftWristJoint, rightWristJoint);    
    
    %Window Length Of the Moviment
    leftShoulderJoint = leftShoulderJoint(WindowBeginLeft:WindowLengthLeft,:);
    leftWristJoint = leftWristJoint(WindowBeginLeft:WindowLengthLeft,:);  
    leftHipJoint = leftHipJoint(WindowBeginLeft:WindowLengthLeft,:);  

    rightShoulderJoint = rightShoulderJoint(WindowBeginRight:WindowLengthRight,:);  
    rightWristJoint = rightWristJoint(WindowBeginRight:WindowLengthRight,:);  
    rightHipJoint = rightHipJoint(WindowBeginRight:WindowLengthRight,:);
    
    %Calculate The LeftArm Angle
    for (j=1:size(leftHipJoint,1))
    %Timestamp
    leftArmAngle(j,1) = leftHipJoint(j,1);
        
    %Arms Elbow Angles
    leftArmAngle(j,2) = ArmRelativeAngleTorso(leftHipJoint,leftShoulderJoint,leftWristJoint, j);    
    end
    
    %Calculate The RightArm Angle
    for (j=1:size(rightHipJoint,1))
    %Timestamp
    rightArmAngle(j,1) = rightHipJoint(j,1);
    
    %Arms Elbow Angles
    rightArmAngle(j,2) = ArmRelativeAngleTorso(rightHipJoint,rightShoulderJoint,rightWristJoint, j);    
    end
    
    [velocityUpLeft velocityDownLeft amplitudeLeft selectedCyclesLeft] = LMMAngleVelocity(leftArmAngle, numCycles, scaledLength);
    [velocityUpRight velocityDownRight amplitudeRight selectedCyclesRight] = LMMAngleVelocity(rightArmAngle, numCycles, scaledLength);
    
    T(cycleCounter:(cycleCounter+numCycles-1),:) = [selectedCyclesLeft selectedCyclesRight];
    
    %Other Features: ;
    otherFeatures(cycleCounter:(cycleCounter+numCycles-1),:) = [velocityUpLeft velocityUpRight velocityDownLeft velocityDownRight amplitudeLeft amplitudeRight];
    %AllVelocityUp(cycleCounter:(cycleCounter+numCycles-1),:) = [velocityUpLeft velocityUpRight];
    %AllVelocityDown(cycleCounter:(cycleCounter+numCycles-1),:) = [velocityDownLeft velocityDownRight];
    %AllAmplitude(cycleCounter:(cycleCounter+numCycles-1),:) = [amplitudeLeft amplitudeRight];
    
    
    %%Filter Out Defect Data
    T(isnan(T))=0;   
    
    %Atribute the subjectID for the label
    labels(cycleCounter:(cycleCounter+numCycles-1),2) = subjectId;
    subjectId = subjectId + 1;    
    
    cycleCounter = cycleCounter + (numCycles);  
end
    [EigenKinnectData, processedCycles, labels] = filterCyclesAndLabels(T, labels, otherFeatures, scaledLength);
    
    
end

function [WindowBeginLeft, WindowLengthLeft, WindowBeginRight, WindowLengthRight] = identifyCycles(leftWristJoint, rightWristJoint)
    signalLeft = leftWristJoint(:,3);
    signalRight = rightWristJoint(:,3);

    cycleIndexLeft = cycleperiodic(signalLeft, 500, 200, 40);
    cycleIndexRight = cycleperiodic(signalRight, 500, 200, 40);
    
    %cycleIndexLeft = cycleperiodic(signalLeft, 500, 200, 40);
    %cycleIndexRight = cycleperiodic(signalRight, 500, 200, 40);

    WindowBeginLeft = cycleIndexLeft(1);
    WindowLengthLeft = cycleIndexLeft(size(cycleIndexLeft,2));
    WindowBeginRight = cycleIndexRight(1);
    WindowLengthRight = cycleIndexRight(size(cycleIndexRight,2));
end

%This function it is necessary to data filter the defected data
function [ KinnectData, processedCycles, labels ] = filterCyclesAndLabels (T, labels, otherFeatures, scaledLength)
    % Normalization of angle vs time graphs for comparison to amplitude max
    % = 1
    normalization = T;
    for i=1:size(T,1)
       normalization(i,1:scaledLength) = T(i,1:scaledLength)./max(T(i,1:scaledLength));
       normalization(i,scaledLength+1:scaledLength*2) = T(i,scaledLength+1:scaledLength*2)./max(T(i,scaledLength+1:scaledLength*2));
       normalization(isnan(normalization(i,1:scaledLength*2))) = min(normalization(i,1:scaledLength*2));
    end
    
    normalization(isnan(normalization)) = 0;
    
    % normalize processed data per column
    if(size(T,2) > scaledLength*2) % other, namely proceessed data in T than just the raw cycle data
       normalization(:,scaledLength*2 + 1:end) =  T(:,scaledLength*2+1 : end)./max(T(:,scaledLength*2 + 1:end));
    end
    
    % define here threshold for filtering
    threshold = 1;
    meanOfNormalization = mean(normalization);
    u = ones(size(normalization,1),1);
    filterTestVector = sum((normalization - (u*meanOfNormalization)).^2,2);
    filterVector = filterTestVector<threshold;
    
       
    KinnectData = [T(filterVector,:) otherFeatures(filterVector,:)];
    %KinnectData = [T(filterVector,:)];
    
    processedCycles = T(filterVector,:);
    otherFeatures = otherFeatures(filterVector,:);
    KinnectData = otherFeatures;
    %KinnectData = processedCycles;
    labels = labels(filterVector,:);    
end

function [ fileName ] = endFileName(directory, sep, files, pattern)
fileName = '';
  for i = 1:length(files)
    endOriginal = files(i).name((length(files(i).name)-length(pattern)+1):end);
    if (strcmp(endOriginal,pattern))
        fileName = strcat(directory, sep, files(i).name);  
        break;
    end;
  end
end

function [ countFiles ] = countFilesType(initalCase, files)
    countFiles = 0;
    for i = 1:length(files)
        if (strcmp(initalCase,files(i).name(1)))
            countFiles = countFiles + 1;
        end;
    end
end
