%% Load Data
if exist('EigenKinnectData.mat')
   load('EigenKinnectData.mat');     
else 
    % Prepare data
   [ EigenKinnectData, processedCycles, labels ] = prepareEigenKinnectData('DataBase');
   save('EigenKinnectData.mat', 'EigenKinnectData', 'processedCycles', 'labels');
end % if

numberOfSubjects = max(labels(:,2));

%Grid Searching
%C_VALUES = [2^-5; 2^-3; 2^-1; 2^1; 2^3; 2^5; 2^7; 2^9; 2^11; 2^13; 2^15];
C_VALUES = [2^-5; 2^-4; 2^-3; 2^-2; 2^-1;2^0;2^1;2^2;2^4; 2^5];
SIGMA_VALUES = [1 2 3 4 5 6 7 8 9 10];
%SIGMA_VALUES = [2^-15 2^-13 2^-11 2^-9 2^-7 2^-5 2^-3 2^-1 2^1 2^3];
grid_searching_matrix = zeros(size(C_VALUES,1)+1, size(SIGMA_VALUES,2)+1);
grid_searching_matrix(2:size(C_VALUES,1)+1,1) = C_VALUES;
grid_searching_matrix(1, 2:size(SIGMA_VALUES,2)+1) = SIGMA_VALUES;


for m = 1:size(C_VALUES,1)
  C = C_VALUES(m)
  for n = 1:size(SIGMA_VALUES,2)
     sigma = SIGMA_VALUES(n);
     
     classificationResult = svmclassificationfitsvm(labels, EigenKinnectData, C, sigma);
     errorCyclesIdentification = sum(labels(:,1) ~= labels(:,4))/size(labels,1); %mis-classification rate  
     
     [TPRATE, FPRATE, PRECISION, ACCURACY, F_SCORE] = confusionmatrix(classificationResult);
     
     grid_searching_matrix(m+1, n+1) = ACCURACY
  end
end




classificationResult = personClassification(labels);
[TPRATE, FPRATE, PRECISION, ACCURACY, F_SCORE] = confusionmatrix(classificationResult)
[C,order]=confusionmat(classificationResult(:,2),classificationResult(:,3))
ConfMatrix = [C(4)  C(2);C(3) C(1)]    

