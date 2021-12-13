%% Optimise Random Forest
% From https://uk.mathworks.com/help/stats/fitrensemble.html
t = templateTree('Reproducible',true);
hyperOpts = struct('AcquisitionFunctionName', 'expected-improvement-plus');
%mdl = fitrensemble(train_data, y_train,'OptimizeHyperparameters','auto','Learners',t, ...
%    'HyperparameterOptimizationOptions',hyperOpts)

opts = {'NumLearningCycles', 'MinLeafSize'};
mdl = fitrensemble(train_data, y_train,'OptimizeHyperparameters',opts,'Learners',t, ...
    'HyperparameterOptimizationOptions',hyperOpts, 'Method', 'Bag')

%% Check the number of trees
% With help from https://uk.mathworks.com/help/stats/tune-random-forest-using-quantile-error-and-bayesian-optimization.html

NumLearningCycles = optimizableVariable('NumLearningCycles', [1, 500], 'Type', 'real');

results = bayesopt(@(params)getRFError(params), NumLearningCycles, ...
     'AcquisitionFunctionName', 'expected-improvement-plus', 'Verbose', 0);

%% Check number of trees custom
numTrees = [1, 10, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 200, 250, 300, 350, 400, 450, 499, 500];
results = zeros(1, numel(numTrees));

for i = 1: numel(numTrees)
    params.NumLearningCycles = numTrees(i);
    results(i) = getRFError(params);
end
figure
plot(numTrees, results);
xlabel("Number of trees");
ylabel("RMSE");
title("Trees versus RMSE");
%% Optimization function
function rfError = getRFError(params)
    % trick from https://uk.mathworks.com/matlabcentral/answers/51907-how-do-i-get-the-value-of-a-variable-from-the-base-workspace-in-my-gui
    train_data2 = evalin('base', 'train_data2');
    y_train2 = evalin('base', 'y_train2');
    valid_data = evalin('base', 'valid_data');
    y_valid = evalin('base','y_valid');
    
    % Fit the data
    t = templateTree('MinLeafSize', 1);
    mdl = fitrensemble(train_data2, y_train2, 'Method', 'Bag', 'NumLearningCycles', params.NumLearningCycles, 'Learners',t);

    % Work out error and return
    y_pred = predict(mdl, valid_data);
    residuals = y_pred - y_valid;
    
    % Root Mean Squared Error
    rfError = sqrt(sum(residuals .^ 2) / numel(residuals));
    disp(strcat("NumLearningCycles: ", string(params.NumLearningCycles), "RMSE: ", string(rfError)));
end