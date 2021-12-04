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
    disp(array2table(["RMSE", string(rmse); "MAE", string(mae); 'Residual Sum', string(sumResiduals)], 'VariableNames', [strcat(ModelName,": Stats"), "Number"]));
    
    % Display graphs of how well some of the features predict the price
    f2 = figure('Name', strcat(ModelName, " Features versus price"));
    f2.Position = [200, 200, 800, 560];
    
    % Year versus price
    subplot(2,2,1);
    scatter(X.year, y_true);
    xlabel("Year");
    ylabel("Price");
    title(strcat(ModelName, ": Year v price"));
    hold on
    scatter(X.year, y_pred, [],'x');
    hold off
    legend("True", "Prediction");
    
    % Mileage versus price
    subplot(2,2,2);
    scatter(X.mileage, y_true);
    xlabel("Mileage");
    ylabel("Price");
    title(strcat(ModelName, ": Mileage v price"));
    hold on
    scatter(X.mileage, y_pred, [],'x');
    hold off
    legend("True", "Prediction");
    
    % MPG versus price
    subplot(2,2,3);
    scatter(X.mpg, y_true);
    xlabel("MPG");
    ylabel("Price");
    title(strcat(ModelName, ": MPG v price"));
    hold on
    scatter(X.mpg, y_pred, [],'x');
    hold off
    legend("True", "Prediction");
    
    % Engine Size versus price
    subplot(2,2,4);
    scatter(X.engineSize, y_true);
    xlabel("Engine Size");
    ylabel("Price");
    title(strcat(ModelName, ": Engine Size v price"));
    hold on
    scatter(X.engineSize, y_pred, [],'x');
    hold off
    legend("True", "Prediction");
end