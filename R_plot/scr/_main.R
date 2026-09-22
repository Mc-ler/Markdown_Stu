library("tidyverse")
library("ggplot2")
library("dplyr")
library("hrbrthemes")

# pipeline: import data -> depict the data set -> delete invalid data 
# -> general plot and optimize the figure surface 
# -> classify the semester -> sort the different semester 
# -> plot basic histograms -> mask the top and bottom one course -> the average red line
# -> moderate figure feature -> save as .svg or .pdf

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
    geom_col( fill="#6A9A66", color="#FFECC3", alpha=0.9) +
    labs(x = "No.", y = "Total Score",
         title = "Plot for Score(2024 To 2026)",
         subtitle = "Full Score is 100 And Source from School Center") +
    theme_ipsum(base_family = "Arial", plot_title_family = "Arial", subtitle_family = "Arial",
                grid = "X", axis = "X", ticks = TRUE) +
    theme(axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
    coord_flip()
print(p)
