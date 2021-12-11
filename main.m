%% Setup
% Wipe command window, delete variables, close all figures
clc; clear; close all;

% Set the seed
rng(52);
%% Load the data
data = readtable('data/ford.csv');

% Make model, transmission and fueltype categorical
% From https://uk.mathworks.com/help/matlab/matlab_prog/convert-table-variables-containing-strings-to-categorical.html
data.model = categorical(data.model);
data.transmission = categorical(data.transmission);
data.fuelType = categorical(data.fuelType);

%% Data exploration
% Summary statistics
numberCols = [false true true false true false true true true];
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
    if numberCols(i)
        %figure('Name', strcat("Boxplot: ", data.Properties.VariableNames(i)));
        subplot(3, 2, curpos);
        boxplot(data{:,i});
        title(data.Properties.VariableNames(i));
        curpos = curpos + 1;
    end
end

% Should the hybrid fords have their MPG amount changed from 202 to
% something more resonable? Are they plug in hybrids? If not calculate
% based on MPG of the engine plus/averaged with their range on battery. If
% they are recreate the calculation done for the electric cars
%kugaMPG = 50.3; % 50.05
%data(data.mpg == 201.8,:).mpg = (data(data.mpg == 201.8,:).mpg * 0) + 50.05; % number from Ford for the normal hybrid(https://www.ford.co.uk/cars/new-kuga?searchid=ppc:Search_GB(eng)%7C%5BAO%5D_Retail_SD_Nameplate_Kuga_CPPI_GBP%7CShp-T2%7CDSA:UK-Kuga-DSA::b:c:g:GOOGLE&gclid=Cj0KCQiA15yNBhDTARIsAGnwe0UybuOFe8ITn9pw4UQNd2Pt_dyafdzFlQVahDrjyhejV38GCxw8LMsaAkspEALw_wcB&gclsrc=aw.ds)

% Tidy up the work space
clear curpos i f f2 f3

%% Split into train and test data
% Need to dummy encode the categories
categoryCols = ~numberCols;

% Decide which columns to use
% Columns: model, year, price, transmission, mileage, fuelType, tax, mpg,
% engineSize
useCols = [true, true, true, false, true, true, false, true, true];

% work out new width and column names
colNames = [];
for i = 1: numel(categoryCols)
    if useCols(i)
        if categoryCols(i)
            dummyNames = categories(data{:, i});
            colNames = [colNames strcat(data.Properties.VariableNames(i), "_", dummyNames)'];
        else
            colNames = [colNames data.Properties.VariableNames(i)];
        end
    end
end

% Empty array, so that MatLab didn't complain about appending every loop
data2 = zeros(height(data), numel(colNames));

% Loop through and dummy var the relevant ones, else append
curcol = 1;
for i = 1: numel(categoryCols)
    if useCols(i)
        if categoryCols(i)
            dummyEnc = dummyvar(data{:, i});
            data2(:, curcol:curcol + width(dummyEnc) - 1) = dummyEnc;
            curcol = curcol + width(dummyEnc);
        else
            data2(:, curcol) = data{:, i};
            curcol = curcol + 1;
        end
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

% Normalise train/test data
% Exclude the categorical columns from the normalization to avoid issues
% Used https://uk.mathworks.com/help/matlab/ref/double.normalize.html to
% figure out how to do it
[train_data_normed, centre, scale] = normalize(train_data, 'DataVariables', ["year", "mileage", "mpg","engineSize"]);
% fixed so that the test set is normalised the same way as the training set
test_data_normed = normalize(test_data, "center", centre, "scale", scale, 'DataVariables', ["year", "mileage", "mpg","engineSize"]);

% tidy up variables in the workspace
clear data2 colNames curcol dummyEnc dummyNames i idxTest idxTrain categoryCols numberCols numrows useCols centre scale

%% Linear Regression
% Use https://uk.mathworks.com/help/stats/fitrlinear.html?searchHighlight=fitrlinear&s_tid=srchtitle_fitrlinear_1
%mdlLR = fitrlinear(train_data_normed{:,:}, y_train);

% Split train into train and validation sets
numrows2 = height(train_data_normed);
cvpart2 = cvpartition(numrows2, 'Holdout', 0.3);
idxTrain2 = training(cvpart2);
idxTest2 = test(cvpart2);

% need to move price to a new variable and delete it here, otherwise it
% will thing it is a feature
train_data2 = train_data_normed(idxTrain2,:);
y_train2 = y_train(idxTrain2);

valid_data = train_data_normed(idxTest2, :);
y_valid = y_train(idxTest2);

% Tidy up
clear numrows2 cvpart2 idxTrain2 idxTest2

% Optimised model
mdlLR = fitrlinear(train_data_normed, y_train, 'Lambda', 0.000010015, 'Learner', 'leastsquares', 'Regularization', 'ridge', 'Solver', 'bfgs', 'FitBias', true, 'PostFitBias', false, 'OptimizeLearnRate', false);% 'ValidationData', {valid_data, y_valid}

%mdlLR = fitrlinear(train_data_normed, y_train, 'Lambda', 0.00017074,...
%    'Learner', 'leastsquares', 'Regularization', 'ridge', 'Solver', 'bfgs');

% predict y
y_pred = predict(mdlLR, test_data_normed);

% Analyse the regression
[LRmae, LRrmse] = analyseRegression(y_test, y_pred, test_data, "Linear Regression");
% currently the residuals sum to -13k,

%% Random Forest Regression
% https://uk.mathworks.com/help/stats/fitrensemble.html

% Fit model
t = templateTree('MinLeafSize', 1);
% update method to Bag so that it uses random forest
mdlRF = fitrensemble(train_data, y_train, 'Method', 'Bag', 'NumLearningCycles', 499, 'Learners',t);

% Predict y
y_pred_rf = predict(mdlRF, test_data);

% Analyse the regression
[RFmae, RFrmse] = analyseRegression(y_test, y_pred_rf, test_data, "Random Forest");

%% Feature importance
% Linear Regression
