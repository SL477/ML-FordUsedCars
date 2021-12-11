%% KFold Random Forest
rng(42);
t = templateTree('MinLeafSize', 1);
cvmdlRF = fitrensemble(train_data, y_train, 'Method', 'Bag', 'NumLearningCycles', 499, 'Learners',t, 'KFold', 5);
mse = kfoldLoss(cvmdlRF);

% using https://uk.mathworks.com/help/stats/regressionlinear.predict.html

for i = 1:5
    y_pred = predict(cvmdlRF.Trained{i}, test_data);
    [mae, rmse] = analyseRegression(y_test, y_pred, test_data, strcat("RF - ", string(i)));
end