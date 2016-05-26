%http://www.mathworks.com/matlabcentral/answers/96276-how-does-svmtrain-determine-polynomial-and-rbf-kernel-parameters-gamma-c-in-the-bioinformatics-too
function [ classificationResult ] = svmclassificationrbf( labels ,EigenKinnectData, C_box_constraint, rbf_sigma)
%% Select test data vs training data
%The Traiining Data Approach is Leave One Out. Then we will put each
%subject as test data and the others will be traiining data
numberOfSubjects = max(labels(:,2));

for(i=1:numberOfSubjects)
    trainCases = [1:numberOfSubjects];
    trainCases(i) = [];
    
    labels(:,3) = 0; % initialialize all as Trainning data

    %inform the testdat
    labels(labels(:,2) == i,3) = 1;         
    
    %Select TrainingData
    trainingData = EigenKinnectData(labels(:,3)==0,:);
    trainningClassification = labels(labels(:,3) == 0,1);
    
    testData = EigenKinnectData(labels(:,3)==1,:);    
    testSolutionClassification = labels(labels(:,3) == 1,1);
    
    %Trainning on SVM
    %SVMStruct = svmtrain(trainingData,trainningClassification,'Kernel_Function', 'linear', 'BoxConstraint', 0.3);
    
    %SVMStruct = svmtrain(trainingData,trainningClassification);
    %Best result
    %SVMStruct = svmtrain(trainingData,trainningClassification,'Kernel_Function', 'linear', 'BoxConstraint', 0.1);
    
    %SVMStruct = svmtrain(trainingData,trainningClassification,'showplot',true,'Kernel_Function', 'linear', 'BoxConstraint', 0.10);
        
    %svmtrain(data3,theclass,'Kernel_Function','rbf','boxconstraint',Inf,'showplot',true);
    
    %SVMStruct = svmtrain(trainingData,trainningClassification,'showplot',true);
        
    %SVM Polynomial
    %SVMStruct = svmtrain(trainingData,trainningClassification, 'Kernel_Function', 'polynomial', 'Polyorder', 1)   
    
    %SVM RBF
    SVMStruct = svmtrain(trainingData,trainningClassification, 'Kernel_Function', 'rbf', 'RBF_Sigma', rbf_sigma, 'BoxConstraint', C_box_constraint);
    
    %SVMStruct = svmtrain(trainingData,trainningClassification,'Kernel_Function', 'polinomial', 'BoxConstraint', 0.2);
    class = svmclassify(SVMStruct, testData);
    labels(labels(:,3) == 1,4) = class';
end

classificationResult = personClassification(labels);
end

