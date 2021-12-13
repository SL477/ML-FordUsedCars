%% KFold Random Forest
close all;
rng(52);
t = templateTree('MinLeafSize', 1);
cvmdlRF = fitrensemble(train_data, y_train, 'Method', 'Bag', 'NumLearningCycles', 100, 'Learners',t, 'KFold', 5, 'Crossval','on');
mse = kfoldLoss(cvmdlRF);

% using https://uk.mathworks.com/help/stats/regressionlinear.predict.html

% for i = 1:5
%     y_pred = predict(cvmdlRF.Trained{i}, test_data);
%     [mae, rmse] = analyseRegression(y_test, y_pred, test_data, strcat("RF - ", string(i)));
% end

y_pred = predictCombinedMdl(cvmdlRF, test_data);
[mae, rmse] = analyseRegression(y_test, y_pred, test_data, "RF - KFold");