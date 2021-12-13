%% KFold Linear Regression
rng(52);
cvmdlLR = fitrlinear(train_data_normed, y_train, 'Lambda', 0.000010015, 'Learner', 'leastsquares', 'Regularization', 'ridge', 'Solver', 'bfgs', 'FitBias', true, 'PostFitBias', false, 'OptimizeLearnRate', false, 'KFold', 5, 'Crossval','on');

mse = kfoldLoss(cvmdlLR);

% using https://uk.mathworks.com/help/stats/regressionlinear.predict.html

% for i = 1:5
%     y_pred = predict(cvmdlLR.Trained{i}, test_data_normed);
%     [mae, rmse] = analyseRegression(y_test, y_pred, test_data_normed, strcat("LR - ", string(i)));
% end

%y_pred = kfoldPredict(cvmdlLR, test_data_normed);
%[mae, rmse] = analyseRegression(y_test, y_pred, test_data_normed, "LR - Kfold");

y_pred = predictCombinedMdl(cvmdlLR, test_data_normed);
[mae, rmse] = analyseRegression(y_test, y_pred, test_data_normed, "LR - Kfold");
