%% Feature importance
%% Linear Regression
figure('Name', 'LR Feature Importance');
bar(abs(mdlLR.Beta));
xticks(1:numel(colNames));
xtickangle(90);
xticklabels(colNames);
ylabel("W");
title("Linear Regression Feature Importance");

%% Random Forest feature importance
% Using https://uk.mathworks.com/help/stats/select-predictors-for-random-forests.html
impOOB = oobPermutedPredictorImportance(mdlRF);
figure('Name', 'RF Feature Importance');
bar(impOOB);
xticks(1:numel(colNames));
xtickangle(90);
xticklabels(colNames);
ylabel("Importance");
title("Random Forest Feature Importance");