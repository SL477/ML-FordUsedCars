# ML-FordUsedCars
 Ford Used Cars Data Linear Regression versus Decision Tree Regression

## Required Software
| Name | Version |
| ---- | ------- |
| MATLAB | 9.10 |
| Statistics and Machine Learning Toolbox | 12.1 |

## Setup
1. Create folder data
2. Download Ford.csv from: https://www.kaggle.com/adityadesai13/used-car-dataset-ford-and-mercedes?select=ford.csv and save into the folder data
3. Open MatLab and run main.m

Alternative for steps 1 & 2, on Linux and maybe Macs:
1. Setup Kaggle API using the instructions [here](https://github.com/Kaggle/kaggle-api)
2. Run the command:

```bash
bash getData/getData.sh
```

or

```bash
make getdata1
```

Then run step 3

## Files
| File Name | Description |
| --------- | ----------- |
| analyseRegression.m | Holds the function analyseRegression so that both models are analysed the same |
| Appendix.pdf | Extra Data for the poster |
| Appendix.tex | Tex file to create the latest version of the appendix |
| FeatureImportance.m | Get the feature importances |
| GetData.sh | Bash command to download the dataset |
| GetSummaryStats.m | Function similar to pandas summary stats |
| Intermediate Results.xlsx| Spreadsheet of all of the intermediate results |
| IntermediateResultsTableBuilder.py | To create tex code for the Implementation results |
| KFoldLR.m | Experiment with KFold for Linear Regression|
| KFoldRF.m | Experiment with KFold for Random Forest|
| Kuga Hybrid MPG adjustments.xlsx | A file I used to work out whether the hybrid Kuga MPG amount was reasonable |
| main.m | Main MatLab program |
| Makefie | File for bash commands to live in |
| MyLibrary.bib | My bibliography for use by the tex file |
| OptimiseRandomForest.m | The script used to get the optimum hyperparameters for Random Forest |
| OptimizeLinearRegression.m | The script used to get the optimum hyperparameters for Linear Regression |
| Output of OptimizeLinearRegression.txt | The output of the run of OptimizeLinearRegression.m |
| Output of OptimizeRandomForest.txt | The output of OptimizeRandomForest.m with all of the auto parameters |
| Output of OptimizeRandomForest2.txt | The output of OptimizeRandomForest.m with it being forced to use the Bag method |
| Poster.pdf | The final file for the poster |
| Poster.pptx | The raw file for the poster |
| predictCombinedMdl.m | Average out the predictions of a cross-validated model |
| README.md | This readme file |
| readme.txt | A reduced version of this file |
| SummaryStats.xlsx | Used to format the summary statistics output from MatLab prior to use in the Poster |

## To work out required files use:

```MATLAB
[fileList, packageList] = matlab.codetools.requiredFilesAndProducts("main.m")
```

From https://uk.mathworks.com/help/matlab/ref/matlab.codetools.requiredfilesandproducts.html


## TODO:
- Translate code to Python

## LaTex
https://miktex.org/download

## Running the models (main)
Keep the data in the folder data, then run main.m to run both models off against each other and generate the majority of the graphs.


## Supplementary code
### Feature Importance
This is used to see which features the models use (needs main to have run first).

### KFoldLR/KFoldRF
These were used to experiment with using K-Fold validation on the models (needs main to have run first). These require the function in predictCombinedMdl to run.

### OptimiseRandomForest/OptimiseLinearRegression
These were used to find the best hyperparameters for the relevant models (needs main to have run first).