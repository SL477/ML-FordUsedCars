%% Optimize Linear Regression
rng(42);

%% Split train into train and validation sets
% numrows2 = height(train_data_normed);
% cvpart2 = cvpartition(numrows2, 'Holdout', 0.3);
% idxTrain2 = training(cvpart2);
% idxTest2 = test(cvpart2);
% 
% % need to move price to a new variable and delete it here, otherwise it
% % will thing it is a feature
% train_data2 = train_data_normed(idxTrain2,:);
% y_train2 = y_train(idxTrain2);
% 
% valid_data = train_data_normed(idxTest2, :);
% y_valid = y_train(idxTest2);
% 
% % Tidy up
% clear numrows2 cvpart2 idxTrain2 idxTest2
%% Optimize parameters
% % With help from https://uk.mathworks.com/help/stats/tune-random-forest-using-quantile-error-and-bayesian-optimization.html
% 
% Learner = optimizableVariable('Learner', {'svm', 'leastsquares'}, 'Type', 'categorical');
% Regularization = optimizableVariable('Regularization', {'lasso', 'ridge'}, 'Type', 'categorical');
% Solver = optimizableVariable('Solver', {'sgd', 'asgd', 'dual', 'bfgs', 'lbfgs', 'sparsa'}, 'Type', 'categorical');
% %FitBias = optimizableVariable('FitBias', [true, false], 'Type', 'logical');
% %PostFitBias = optimizableVariable('PostFitBias', [true, false], 'Type', 'bool');
% LearnRate = optimizableVariable('LearnRate', [0.0001, 0.1], 'Type', 'real');
% %OptimizeLearnRate = optimizableVariable('OptimizeLearnRate', [true, false], 'Type', 'bool');
% 
% %hyperParamsLR = [Learner, Regularization, Solver, FitBias, PostFitBias, LearnRate, OptimizeLearnRate];
% hyperParamsLR = [Learner, Regularization, Solver, LearnRate];
% 
% results = bayesopt(@(params)getLRerror(params), hyperParamsLR, ...
%     'AcquisitionFunctionName', 'expected-improvement-plus', 'Verbose', 0);

% Using https://uk.mathworks.com/help/stats/fitrlinear.html#bvevent-1

hyperOpts = struct('AcquisitionFunctionName', 'expected-improvement-plus');
[mdl, FitInfo, HyperParameterOptimizationResults] = fitrlinear(train_data_normed, ...
    y_train, 'OptimizeHyperparameters', 'auto', 'HyperparameterOptimizationOptions', hyperOpts)

%% Function
% 
% function lrError = getLRerror(params)
% 
%     % trick from https://uk.mathworks.com/matlabcentral/answers/51907-how-do-i-get-the-value-of-a-variable-from-the-base-workspace-in-my-gui
%     train_data2 = evalin('base', 'train_data2');
%     y_train2 = evalin('base', 'y_train2');
%     valid_data = evalin('base', 'valid_data');
%     y_valid = evalin('base','y_valid');
% 
% %     mdl = fitrlinear(X, y, 'Learner', params.Learner, ...
% %         'Regularization', params.Regularization, 'Solver', params.Solver, ...
% %         'FitBias', params.FitBias, 'PostFitBias', params.PostFitBias, ...
% %         'LearnRate', params.LearnRate, 'OptimizeLearnRate', params.OptimizeLearnRate);
%     mdl = fitrlinear(train_data2, y_train2, 'Learner', char(params.Learner), ...
%         'Regularization', char(params.Regularization), 'Solver', char(params.Solver), ...
%         'LearnRate', params.LearnRate);
%     
%     y_pred = predict(mdl, valid_data);
%     residuals = y_pred - y_valid;
%     
%     % Root Mean Squared Error
%     lrError = sqrt(sum(residuals .^ 2) / numel(residuals));
% end