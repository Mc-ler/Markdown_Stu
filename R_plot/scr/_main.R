library("tidyverse")
library("ggplot2")
library("dplyr")
library("hrbrthemes")

# pipeline: import data -> depict the data set -> delete invalid data 
# -> general plot and optimize the figure surface 
# -> classify the semester -> sort the different semester -> opt(find the most)
# -> plot basic histograms -> moderate figure feature -> save as .svg or .pdf

# IMPORT DATA
raw_data <- read.csv("./data/Query_Grades.csv")
dim(raw_data)
names(raw_data)
glimpse(raw_data)

# clear the data and give report
delete_reduplicate <- raw_data |> distinct(课程名, .keep_all = FALSE) # no repeat

# score_class <- c("A+","A-","B+","B-","C+","C-")
import_data <- raw_data |> mutate(总成绩 = parse_number(总成绩))
valid_data <- import_data |> mutate(is_valid = case_when(is.na(总成绩) ~ "invalid", TRUE ~ "valid")) |>  filter(is_valid == "valid")
addno_data <- valid_data |> arrange(desc(总成绩)) |> mutate(No. = sprintf("%02d", 1:nrow(valid_data)))

# plot the general figure 
p <- addno_data |>
  ggplot(aes(x = No., y = 总成绩)) +
    geom_col( fill="#69b3a2", color="#e9ecef", alpha=0.9) +
    ggtitle("Plot") +
    theme_ipsum() +
    theme(plot.title = element_text(size = 14))
print(p)
