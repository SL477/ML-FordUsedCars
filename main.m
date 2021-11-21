%% Load the data
data = readtable('data/ford.csv');

% Make model, transmission and fueltype categorical
% From https://uk.mathworks.com/help/matlab/matlab_prog/convert-table-variables-containing-strings-to-categorical.html
data.model = categorical(data.model);
data.transmission = categorical(data.transmission);
data.fuelType = categorical(data.fuelType);

%% Data exploration
