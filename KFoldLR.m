%% KFold Linear Regression
rng(45);
cvmdlLR = fitrlinear(train_data_normed, y_train, 'Lambda', 0.000010015, 'Learner', 'leastsquares', 'Regularization', 'ridge', 'Solver', 'bfgs', 'FitBias', true, 'PostFitBias', false, 'OptimizeLearnRate', false, 'KFold', 5)

mse = kfoldLoss(cvmdlLR);

% using https://uk.mathworks.com/help/stats/regressionlinear.predict.html

for i = 1:5
    y_pred = predict(cvmdlLR.Trained{i}, test_data_normed);
    [mae, rmse] = analyseRegression(y_test, y_pred, test_data_normed, strcat("LR - ", string(i)));
end