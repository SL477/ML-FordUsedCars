%% Test Only
% This is for just analysing the two models against each other
clc; close all; clear;

% Load variables
load savedvars.mat

%% Normalise the test data
% Normalise in the same way as the training data
test_data_normed = normalize(test_data, "center", centre, "scale", scale, 'DataVariables', ["year", "mileage", "mpg","engineSize"]);

%% Analyse Linear Regression
% Predict y
y_pred = predict(mdlLR, test_data_normed);

% Analyse the regression
[LRmae, LRrmse] = analyseRegression(y_test, y_pred, test_data, "Linear Regression");

%% Analyse Random Forest Regression
% Predict y
y_pred_rf = predict(mdlRF, test_data);

% Analyse the regression
[RFmae, RFrmse] = analyseRegression(y_test, y_pred_rf, test_data, "Random Forest");