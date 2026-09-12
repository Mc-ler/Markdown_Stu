library("tidyverse")
# IMPORT DATA
raw_data <- read_csv("data/memory_raw.csv", show_col_types = FALSE)

# CHECK DATA
dim(raw_data)
nrow(raw_data)
ncol(raw_data)
head(raw_data)
head(raw_data, 10)
names(raw_data)
glimpse(raw_data)
View(raw_data)
summary(raw_data)
skimr::skim(raw_data)

