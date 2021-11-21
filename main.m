clc; clear; close all;
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
f = figure;
f.Position = [50, 50, 960,780];
for i = 1: width(data)
    %figure
    subplot(width(data),1,i);
    histogram(data{:, i});
    title(data.Properties.VariableNames(i));
    ylabel("Count");
end

% Graph against price