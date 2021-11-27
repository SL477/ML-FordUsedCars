%% Setup
% Wipe command window, delete variables, close all figures
clc; clear; close all;

% Set the seed
rng(42);
%% Load the data
data = readtable('data/ford.csv');

% Make model, transmission and fueltype categorical
% From https://uk.mathworks.com/help/matlab/matlab_prog/convert-table-variables-containing-strings-to-categorical.html
data.model = categorical(data.model);
data.transmission = categorical(data.transmission);
data.fuelType = categorical(data.fuelType);

%% Data exploration
% Summary statistics
numberCols = [0 1 1 0 1 0 1 1 1];
stats = GetSummaryStats(data, numberCols);
disp("Pre-Changes:");
disp(stats);

% Get the mean of the non-zero engine sizes for imputing into the zero
% sizes
meanNZEngine = mean(data{data.engineSize > 0, 'engineSize'});

% Impute the zeros
data{data.engineSize == 0, 'engineSize'} = meanNZEngine;

% update year 2060 to 2020 and redo stats
data(data.year == 2060,:).year = 2020;
stats2 = GetSummaryStats(data, numberCols);
disp("Post-Changes:");
disp(stats2);

% Get the mode for non number columns
disp(array2table(["Model", char(mode(data.model));
    "Transmission", char(mode(data.transmission));
    "Fuel Type", char(mode(data.fuelType))], 'VariableNames', ["Column", "Mode"])); 
% https://stackoverflow.com/questions/32341083/extract-string-from-categorical-variable-in-matlab
% for how to get the string value of a categorical

% Histograms
f = figure('Name', 'Histograms'); % from https://uk.mathworks.com/matlabcentral/answers/471816-change-name-of-figures-in-figures-tab
f.Position = [50, 50, 960,780];
for i = 1: width(data)
    %figure
    subplot(width(data),1,i);
    histogram(data{:, i});
    title(data.Properties.VariableNames(i));
    ylabel("Count");
end

% Move the Fuel Type Other to be electric, as it is mis-classified
%data(data.fuelType == 'Other',:).fuelType = 'Electric';
% Uses https://uk.mathworks.com/help/matlab/ref/categorical.mergecats.html
% to merge the Other category into Electric
data.fuelType = mergecats(data.fuelType, {'Electric', 'Other'});

% Graph against price
f2 = figure('Name', 'Scatter Plots');
f2.Position = [100, 100, 960, 780];
curpos = 1;
for i = 1: width(data)
    if i ~= 3 %numberCols(i) == 1 && i ~= 3
        %figure('Name', strcat(data.Properties.VariableNames(i), " v price"));
        subplot(4, 2, curpos);
        scatter(data{:,i}, data{:, 'price'});
        title(strcat(data.Properties.VariableNames(i), " v price"));
        ylabel("Price")
        xlabel(data.Properties.VariableNames(i));
        curpos = curpos + 1;
    end
end

% Tidy up the work space
clear curpos i meanNZEngine

% Box plots
curpos = 1;
f3 = figure('Name', 'Box Plots');
f3.Position = [150, 150, 960, 780];
for i = 1: width(data)
    if numberCols(i) == 1
        %figure('Name', strcat("Boxplot: ", data.Properties.VariableNames(i)));
        subplot(3, 2, curpos);
        boxplot(data{:,i});
        title(data.Properties.VariableNames(i));
        curpos = curpos + 1;
    end
end

% Tidy up the work space
clear curpos i f f2 f3

%% Split into train and test data
% Need to dummy encode the categories
categoryCols = [1 0 0 1 0 1 0 0 0];

% work out new width and column names
colNames = [];
for i = 1: numel(categoryCols)
    if categoryCols(i) == 1
        dummyNames = categories(data{:, i});
        colNames = [colNames strcat(data.Properties.VariableNames(i), "_", dummyNames)'];
    else
        colNames = [colNames data.Properties.VariableNames(i)];
    end
end

% Empty array, so that MatLab didn't complain about appending every loop
data2 = zeros(height(data), numel(colNames));

% Loop through and dummy var the relevant ones, else append
curcol = 1;
for i = 1: numel(categoryCols)
    if categoryCols(i) == 1
        dummyEnc = dummyvar(data{:, i});
        data2(:, curcol:curcol + width(dummyEnc) - 1) = dummyEnc;
        curcol = curcol + width(dummyEnc);
    else
        data2(:, curcol) = data{:, i};
        curcol = curcol + 1;
    end
end
data = array2table(data2, 'VariableNames', colNames);

% a lot of inspiration from https://uk.mathworks.com/help/stats/cvpartition.html
numrows = height(data);
cvpart = cvpartition(numrows, 'Holdout', 0.3);
idxTrain = training(cvpart);
idxTest = test(cvpart);

% need to move price to a new variable and delete it here, otherwise it
% will thing it is a feature
train_data = data(idxTrain,:);
y_train = train_data.price;
train_data.price = [];

test_data = data(idxTest, :);
y_test = test_data.price;
test_data.price = [];

% tidy up variables in the workspace
clear data2 colNames curcol dummyEnc dummyNames i idxTest idxTrain categoryCols numberCols numrows

%% Linear Regression
% Use https://uk.mathworks.com/help/stats/fitrlinear.html?searchHighlight=fitrlinear&s_tid=srchtitle_fitrlinear_1
mdlLR = fitrlinear(train_data{:,:}, y_train);

% predict y
y_pred = predict(mdlLR, test_data{:,:});

% Plot the actual values against the predicted ones
residuals = y_pred - y_test;
figure
scatter(y_pred, y_test);
hold on
plot([0 12000], [0 12000], 'r')
hold off
ylabel("Predictions");
xlabel("Actual");
title("Predictions versus actual");
legend('Predictions', 'Ideal Line', "Location", "northwest");

% Plot residuals as a histogram
figure
histogram(residuals);
title("Histogram of residuals");
xlabel("Residuals");
ylabel("Count");

% Root Mean Squared Error
rmse = sqrt(sum(residuals .^ 2) / numel(residuals));

% Mean Absolute Error
mae = sum(abs(residuals)) / numel(residuals);

% Format display of RMSE & MAE
disp(array2table(["RMSE", string(rmse); "MAE", string(mae)], 'VariableNames', ["Stat", "Number"]))