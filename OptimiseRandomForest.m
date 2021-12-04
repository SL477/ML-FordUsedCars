%% Optimise Random Forest
% From https://uk.mathworks.com/help/stats/fitrensemble.html
t = templateTree('Reproducible',true);
hyperOpts = struct('AcquisitionFunctionName', 'expected-improvement-plus');
%mdl = fitrensemble(train_data, y_train,'OptimizeHyperparameters','auto','Learners',t, ...
%    'HyperparameterOptimizationOptions',hyperOpts)

opts = {'NumLearningCycles', 'MinLeafSize'};
mdl = fitrensemble(train_data, y_train,'OptimizeHyperparameters',opts,'Learners',t, ...
    'HyperparameterOptimizationOptions',hyperOpts, 'Method', 'Bag')