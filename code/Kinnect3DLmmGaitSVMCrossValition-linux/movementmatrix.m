%close all;
%clear all;

%load('EigenKinnectData.mat'); 


MatrixMovement = [];
MatrixMovement =  [labels(:, 1:2) EigenKinnectData];

clear resultMean;
clear resultStd;
%The content of EigenKinnectData is : [velocityUpLeft velocityUpRight velocityDownLeft velocityDownRight amplitudeLeft amplitudeRight];

maxSubjectId = max(MatrixMovement(:,2));
for (i=1:maxSubjectId)
    
    %Subject ID
    resultMean(i,2) = i;
    
    %PD or Control Group        
    %if the subject is normal the mean will be 0 if is parkinson will be 1
    resultMean(i,1) = mean(MatrixMovement(MatrixMovement(:,2) == i,1));
        
    %Mean velocityUpLeft
    resultMean(i,3) = mean(MatrixMovement(MatrixMovement(:,2) == i,3));
    
    
    %Mean velocityUpRight
    resultMean(i,4) = mean(MatrixMovement(MatrixMovement(:,2) == i,4));
    
    %Mean velocityDownLeft
    resultMean(i,5) = mean(MatrixMovement(MatrixMovement(:,2) == i,5));
    
    %Mean velocityDownLeft
    resultMean(i,6) = mean(MatrixMovement(MatrixMovement(:,2) == i,6));
    
    %Mean amplitudeLeft
    resultMean(i,7) = mean(MatrixMovement(MatrixMovement(:,2) == i,7));
    
    %Mean amplitudeRight
    resultMean(i,8) = mean(MatrixMovement(MatrixMovement(:,2) == i,8));
    
    
end

resultMean(:,9) = classificationResult(:,3);




%%%%STD
maxSubjectId = max(MatrixMovement(:,2));
for (i=1:maxSubjectId)
    
    %Subject ID
    resultStd(i,2) = i;
    
    %PD or Control Group        
    %if the subject is normal the mean will be 0 if is parkinson will be 1
    resultStd(i,1) = mean(MatrixMovement(MatrixMovement(:,2) == i,1));
        
    %Mean velocityUpLeft
    resultStd(i,3) = std(MatrixMovement(MatrixMovement(:,2) == i,3));
    
    
    %Mean velocityUpRight
    resultStd(i,4) = std(MatrixMovement(MatrixMovement(:,2) == i,4));
    
    %Mean velocityDownLeft
    resultStd(i,5) = std(MatrixMovement(MatrixMovement(:,2) == i,5));
    
    %Mean velocityDownLeft
    resultStd(i,6) = std(MatrixMovement(MatrixMovement(:,2) == i,6));
    
    %Mean amplitudeLeft
    resultStd(i,7) = std(MatrixMovement(MatrixMovement(:,2) == i,7));
    
    %Mean amplitudeRight
    resultStd(i,8) = std(MatrixMovement(MatrixMovement(:,2) == i,8));   
    
end

resultStd(:,9) = classificationResult(:,3);



%TrainSVM
% svmData = resultMean(:, 3:8);
% svmLabel = resultMean(:,1);
% 
% SVMModel = fitcsvm(svmData,svmLabel, 'Standardize', true, 'KernelFunction','RBF',...
%     'KernelScale', 'auto');
% CVSVMModel = crossval(SVMModel);
% classLoss = kfoldLoss(CVSVMModel)


