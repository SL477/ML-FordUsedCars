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
| Appendix.docx | Extra Data for the poster |
| GetData.sh | Bash command to download the dataset |
| GetSummaryStats.m | Function similar to pandas summary stats |
| main.m | Main MatLab program |
| Makefie | File for bash commands to live in |
| OptimizeLinearRegression.m | The script used to get the optimum hyperparameters for Linear Regression |
| Output of OptimizeLinearRegression.txt | The output of the run of OptimizeLinearRegression.m |
| Poster.pptx | The raw file for the poster |
| README.md | This readme file |
| readme.txt | A reduced version of this file |
| SummaryStats.xlsx | Used to format the summary statistics output from MatLab prior to use in the Poster |

## To work out required files use:

```MATLAB
[fileList, packageList] = matlab.codetools.requiredFilesAndProducts("main.m")
```

From https://uk.mathworks.com/help/matlab/ref/matlab.codetools.requiredfilesandproducts.html
