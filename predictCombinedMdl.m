%% Predict using combined parameters
function preds = predictCombinedMdl(mdl, xdata)
    % Get the predictions using all of the models
    % There doesn't seem to be a stock way of doing this as kfoldPredict
    % doesn't do anything helpful
    preds = zeros(height(xdata), numel(mdl.Trained));
    for i = 1: numel(mdl.Trained)
        preds(:,i) = predict(mdl.Trained{i}, xdata);
    end
    preds = mean(preds, 2);
end