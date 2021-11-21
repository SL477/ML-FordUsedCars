function stats = GetSummaryStats(data, numberColumns)
    %% GetSummaryStats
    % Similar to Pandas describe function
    cols = numel(numberColumns);
    stats = zeros(5, sum(numberColumns));
    curCol = 1;
    for i = 1:cols
        if numberColumns(i) == 1
           stats(1, curCol) = mean(data{:, i});
           stats(2, curCol) = median(data{:, i});
           stats(3, curCol) = min(data{:, i});
           stats(4, curCol) = max(data{:, i});
           stats(5, curCol) = std(data{:, i});
           curCol = curCol + 1;
        end
    end
    stats = array2table(stats, 'VariableNames', data.Properties.VariableNames(logical(numberColumns)), "RowNames",{'Mean', 'Median', 'Min','Max','Std'});
end