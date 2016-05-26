close all;
clear all;



%Plot Left Hand Amplitude
%figure(1);
%plot(leftWristJoint(:,3));
%title(strcat(files(1).name(1:10),' - RawData LeftWrist Joint in Y Position Point'));
%print -dpng 'figure\1-rawdataLeftWristPoints.png';

%Plot Right Hand Amplitude
%figure(1);
%plot(rightWristJoint(:,3));
%title(strcat(files(1).name(1:10),' - RawData RightWrist Joint in X Position Point'));
%print -dpng 'figure\2-rawdataRightWristPoints.png';

%% Load Data
if exist('EigenKinnectData.mat')
   load('EigenKinnectData.mat');     
else 
    % Prepare data
   [ EigenKinnectData, processedCycles, labels ] = prepareEigenKinnectData('DataBase');
   save('EigenKinnectData.mat', 'EigenKinnectData', 'processedCycles', 'labels');
end % if

%% Plot MeanGait HealthyPerson x Parkinson Disease
% figure(2)
% hold on;
% plot(mean(processedCycles(1:64,1:40)),'red');
% plot(mean(processedCycles(65:end,1:40)),'blue');
% text(7,80,'Bra�o Esquerdo');
% text(27,80,'Bra�o Direito');
% title('Vetor M�dio do Movimento de Abdu��o e Adu��o dos Bra�os','FontWeight','bold')
% %legend('N�o Parkinsonianos', 'Parkinsonianos');
% hold off;
% legend('N�o Parkinsonianos', 'Parkinsonianos','Location','NorthEastOutside');
% 
% EigenKinnectData(isnan(EigenKinnectData))=0;
% 
% %% Surf plot of processedCycles
% cyclesCount = size(labels,1);
% normalCyclesCount = size(labels,1) - sum(labels(:,1));
% hold on;
% figure(3);
% %colormap(gray)
% surf(processedCycles,'DisplayName','processedCycles');figure(gcf);
% %text(39,20,163,'N�o Parkisonianos','FontWeight','bold');
% healthycycles = line([0 0],[0 normalCyclesCount],[160 160],'Marker','.','LineStyle','-');
% parkinsoncycles = line([0 0],[normalCyclesCount+1 cyclesCount],[160 160],'Color','r');
% title('Amplitude do �ngulo Relativo da Abdu��o e Adu��o (Bra�o Esquerdo e Direito)', 'FontWeight','bold');
% legend('Legenda Linhas','Movimentos N�o-Parkinsonianoos','Movimentos Parkinsonianos','Location','NorthEastOutside');
% %TODO: PUT the Cycles LABELS to  see the difference data
% %text(personalGaitT(4,1)+labelGap,personalGaitT(4,2)+labelGap,personalGaitT(4,3)+labelGap,'Parkinson subjects')
% %text(personalGaitT(1,1)+labelGap,personalGaitT(1,2)+labelGap,personalGaitT(1,3)+labelGap,'Healthy subjects')
% hold off


%Grid Searching
%C_VALUES = [2^-5; 2^-3; 2^-1; 2^1; 2^3; 2^5; 2^7; 2^9; 2^11; 2^13; 2^15];
%C_VALUES = [2^-5; 2^-4; 2^-3; 2^-2; 2^-1;2^0;2^1;2^2;2^3;2^4];
C_VALUES = [0.25; 0.5; 0.75; 1; 1.25; 1.5; 1.75; 2; 2.25; 2.5];

SIGMA_VALUES = [1 2 3 4 5 6 7 8 9 10];
%SIGMA_VALUES = [2^-15 2^-13 2^-11 2^-9 2^-7 2^-5 2^-3 2^-1 2^1 2^3];
grid_searching_matrix = zeros(size(C_VALUES,1)+1, size(SIGMA_VALUES,2)+1);
grid_searching_matrix(2:size(C_VALUES,1)+1,1) = C_VALUES;
grid_searching_matrix(1, 2:size(SIGMA_VALUES,2)+1) = SIGMA_VALUES;

grid_error_matrix = zeros(size(C_VALUES,1)+1, size(SIGMA_VALUES,2)+1);
grid_error_matrix(2:size(C_VALUES,1)+1,1) = C_VALUES;
grid_error_matrix(1, 2:size(SIGMA_VALUES,2)+1) = SIGMA_VALUES;


for m = 1:size(C_VALUES,1)
  C = C_VALUES(m)
  for n = 1:size(SIGMA_VALUES,2)
     sigma = SIGMA_VALUES(n);
     
     classificationResult = svmclassificationrbf(labels, EigenKinnectData, C, sigma);
     errorCyclesIdentification = sum(labels(:,1) ~= labels(:,4))/size(labels,1); %mis-classification rate  
     
     [TPRATE, FPRATE, PRECISION, ACCURACY, F_SCORE] = confusionmatrix(classificationResult);
     
     grid_searching_matrix(m+1, n+1) = ACCURACY
     grid_error_matrix(m+1, n+1) = FPRATE;
     
  end
end
save('GridSearch.mat', 'grid_searching_matrix', 'grid_error_matrix');

%Verificar matriz de confus�o
classificationResult = svmclassificationrbf(labels, EigenKinnectData, 2, 3)
%classificationResult = svmclassificationrbf(labels, EigenKinnectData, 0.5, 5)
[TPRATE, FPRATE, PRECISION, ACCURACY, F_SCORE] = confusionmatrix(classificationResult)
[C,order]=confusionmat(classificationResult(:,2),classificationResult(:,3))
ConfMatrix = [C(4)  C(2);C(3) C(1)]    