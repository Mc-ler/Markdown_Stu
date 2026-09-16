library("tidyverse")
library("ggplot2")

# pipeline: import data -> depict the data set -> delete invalid data 
# -> classify the semester -> sort the different semester -> opt(find the mostone)
# -> plot basic histograms -> moderate fijure feature -> save as .svg or .pdf

# IMPORT DATA
raw_data <- read.csv("./data/Query_Grades.csv")
dim(raw_data)
names(raw_data)
glimpse(raw_data)

# clear the data and give report
delete_reduplicate <- raw_data |> distinct(课程名, .keep_all = FALSE) # no repeat

score_class <- c("A+","A-","B+","B-","C+","C-")
valid_date <- raw_data |> filter_out(raw_data, 总成绩==score_class)

