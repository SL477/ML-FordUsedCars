function [mae, rmse] = analyseRegression(y_true, y_pred, X, ModelName)
    %% analyseRegression This is to analyse the results of the regression
    % Plot the actual values against the predicted ones
    residuals = y_pred - y_true;
    %figure('Name', strcat(ModelName,": Predictions vs Actual"))
    f = figure('Name', strcat(ModelName, " Analysis"));
    f.Position = [200, 200, 800, 560];
    subplot(1,2,1);
    scatter(y_pred, y_true);
    m = max([y_true y_pred]);
    hold on
    plot([0 m], [0 m], 'r')
    hold off
    ylabel("Predictions");
    xlabel("Actual");
    title(strcat("Predictions versus actual ", ModelName));
    legend('Predictions', 'Ideal Line', "Location", "northwest");

    % Plot residuals as a histogram
    %figure('Name', strcat(ModelName,": Histogram of residuals"))
    subplot(1,2,2);
    histogram(residuals);
    title(strcat("Histogram of residuals ", ModelName));
    xlabel("Residuals");
    ylabel("Count");

    % Root Mean Squared Error
    rmse = sqrt(sum(residuals .^ 2) / numel(residuals));

    % Mean Absolute Error
    mae = sum(abs(residuals)) / numel(residuals);
    
    % Sum residuals, they should add to zero for Linear Regression
    sumResiduals = sum(residuals);
    
    % Format display of RMSE & MAE
    disp(array2table(["RMSE", string(rmse); "MAE", string(mae); 'Residual Sum', string(sumResiduals)], 'VariableNames', [strcat(ModelName,": Stats"), "Number"]))
end