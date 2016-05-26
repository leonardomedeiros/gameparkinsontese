load fisheriris;
inds = ~strcmp(species,'setosa');
X = meas(inds,3:4);
y=species(inds);

SVMModel = fitcsvm(X,y, 'Standardize', true, 'KernelFunction','RBF',...
    'KernelScale', 'auto');
CVSVMModel = crossval(SVMModel);
classLoss = kfoldLoss(CVSVMModel)


yFit = kfoldPredict(CVSVMModel)

