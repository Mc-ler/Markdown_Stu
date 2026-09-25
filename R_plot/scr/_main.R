library("tidyverse")
library("ggplot2")
library("dplyr")
library("hrbrthemes")
windowsFonts("Times New Roman" = windowsFont("Times New Roman"))

# pipeline: import data -> depict the data set -> delete invalid data 
# -> general plot and optimize the figure surface 
# -> classify the semester -> sort the different semester 
# -> plot basic histograms -> mask the top and bottom one course -> the average red line
# adjust the start score form 60(%Average line) -> bold and stress the first and latest couorse
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
valid_data <- import_data |> mutate(is_valid = case_when(is.na(总成绩) ~ "invalid", TRUE ~ "valid"),
                                    percentae_by_60 = (总成绩 - 60) / 60) |>  filter(is_valid == "valid")
addno_data <- valid_data |> arrange(desc(总成绩)) |> mutate(No. = sprintf("%02d", 1:nrow(valid_data)),
                                                         extreme_value = case_when(No. == "01" ~ "Highest", No. == "40" ~ "Lowest",
                                                                                   TRUE ~ "Between"))
mean_data <- mean(addno_data$总成绩)


# plot the general figure 
p <- addno_data |>
  ggplot(aes(x = No., y = 总成绩)) +
    geom_col( aes(fill = extreme_value), color = "#FFECC3", alpha=0.8) +
    scale_fill_manual( name = "Grade" ,values = c("Highest" = "#6A9A66" ,"Lowest" = "#6A9A66" ,"Between" = "#B4D6A1" ), guide = "none")+
    labs(x = "No.", y = "Total Score",
         title = "Score Tendency (2024 To 2026)",
         subtitle = "Plot with Rstudio and Source From ./jwxt.xjtu/") +
    scale_y_continuous(breaks = c(60, 80, 100)) +
    geom_hline(yintercept = mean_data, color = "#BF616A", linewidth = 1) +
    geom_hline(yintercept = 60, color = "#6A9A66", linewidth = 1, alpha = 0.5) +
    
    theme_ipsum(base_family = "Arial", plot_title_family = "Times New Roman", subtitle_family = "Times New Roman",
                grid = "X", axis = "X", ticks = TRUE) +
    theme(plot.background = element_rect(fill = "#FFECC3", color = "#031E42"), 
          axis.text.y = element_blank(), axis.ticks.y = element_blank(),
          axis.text.x = element_text(face = "bold"),
          plot.title = element_text(family = "Times New Roman"),
          plot.subtitle = element_text(family = "Times New Roman")) +
    coord_flip(ylim = c(60, 100))

print(p)

