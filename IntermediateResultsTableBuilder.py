import pandas as pd

def main()->str:
    """This is to convert the excel file Intermediate Results.xlsx into a format for LaTex"""
    df = pd.read_excel("Intermediate Results.xlsx", sheet_name="New Results")
    df.drop("Unnamed: 5",axis=1, inplace=True)
    #print(df)
    #print(df.columns)

    # Start the heading of the table
    ret = "\\begin{longtable}{m{4cm}m{6cm}ccm{2cm}}\n\\toprule\n"
    ret += " & ".join(df.columns)
    ret += " \\\\"
    ret += "\n\\midrule"

    for i in df.itertuples():
        ret += "\n" + i.Type + " & " + i._2 + " & " + str(i.RMSE) + " & " + str(i.MAE) + " & " + str(i._5) + " \\\\"
        ret += "\n\\addlinespace"
        #print(i)

    ret += "\n\\bottomrule\n\\end{longtable}"

    return ret

if __name__ == '__main__':
    print(main())