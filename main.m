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
stats = zeros(5, 6);
curCol = 1;
for i = 1:9
    if numberCols(i) == 1
       stats(1, curCol) = mean(data{:, i});
       stats(2, curCol) = median(data{:, i});
       stats(3, curCol) = min(data{:, i});
       stats(4, curCol) = max(data{:, i});
       stats(5, curCol) = std(data{:, i});
       curCol = curCol + 1;
    end
end
stats = array2table(stats, 'VariableNames', data.Properties.VariableNames(logical(numberCols)), "RowNames",{'Mean', 'Median', 'Min','Max','Std'});

% update year 2060 to 2020 and redo stats
% Get the mode for non number columns

% Histograms

% Graph against price