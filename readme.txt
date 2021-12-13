# ML-FordUsedCars
My original source code is in the repository: https://github.com/SL477/ML-FordUsedCars. The data I got from https://www.kaggle.com/adityadesai13/used-car-dataset-ford-and-mercedes?select=ford.csv.

## Required software
- MATLAB 9.10
- Statistics and Machine Learning Toolbox, version 12.1
- GetSummaryStats.m (in folder)
- analyseRegression.m (in folder)
- main.m (in folder)

## Running the models (main)
Keep the data in the folder data, then run main.m to run both models off against each other and generate the majority of the graphs.

## Supplementary code
### Feature Importance
This is used to see which features the models use (needs main to have run first).

### KFoldLR/KFoldRF
These were used to experiment with using K-Fold validation on the models (needs main to have run first). These require the function in predictCombinedMdl to run.

### OptimiseRandomForest/OptimiseLinearRegression
These were used to find the best hyperparameters for the relevant models (needs main to have run first).