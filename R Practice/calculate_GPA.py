# Calculation My GPA of first and second year of my university.
# Data Visualization and return GPA score approximately 
# Edit README.md, adding .gitignore file in my project(PUll from Github?)

# Import module needed:
import math as mh
import csv
import pandas as pd

# Read data from my score file and convent it to list format.
def data_extract(address) -> list | None:
    # "./Markdown_Stu/R Practice/Query_Grades.csv"
    with open (address, 'r', encoding='utf-8') as file:
        score_li = csv.reader(file)
        head_line = next(score_li)
        data_list = [row for row in score_li]
    return  data_list

# clear and re-factor the data which not with right format.
def data_clear(database, column_index) -> list | None:
    data_copy = []
    count_invalid = 0
    for row in database:
        data_copy.append(row[column_index])

    for i in range(len(data_copy)):
        try:
            data_copy[i] = float(data_copy[i])
        except ValueError:
            data_copy[i] = None
            count_invalid += 1
            print(f"The value {database[i][1]} is invalid\n")
            continue
    valid_course = len(data_copy) - count_invalid
    print(f'the valid course num is {valid_course}')
    return data_copy
    
# merge the clear data to database
def merge_data(new_data_column, address, column_name) -> list |None:
    data_df = pd.read_csv(address)
    data_df[column_name] = new_data_column
    
    data_list = data_df.to_numpy().tolist()
    return data_list

# calculation of GPA grade and Average score
def calculate(database) -> dict |None:
    score_analysis = {}
    total_credit = 0
    total_gpa_credit = 0
    total_score_credit = 0
    
    for row in database:
        if mh.isfinite(row[10]) == True:
            total_credit += row[6]
            total_gpa_credit += row[6]*row[12]
            total_score_credit += row[6]*row[10]
        else:
            continue
            
    score_analysis['GPA_Grade'] = total_gpa_credit / total_credit
    score_analysis['Score_Grade'] = total_score_credit / total_credit
    return score_analysis
    
if __name__ == "__main__":
    data = data_extract("./Markdown_Stu/R Practice/Query_Grades.csv")
    column_new = data_clear(data, 10)
    data_new = merge_data(column_new, "./Markdown_Stu/R Practice/Query_Grades.csv", '总成绩')
    score_analysis = calculate(data_new)
    
    for key, value in score_analysis.items():
        print(f"{key} : {value}")
        
        

    
    