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

# CLEAR DATA
delete_reduplicate <- raw_data |> distinct(participant_id, .keep_all = TRUE)
delete_uncomplete <- delete_reduplicate |>
  mutate(
    exclusion = case_when(
      completed == 0 ~ "Unfinished",
      attention_check == 0 ~ "fail pass the checkpoint",
      TRUE ~ NA_character_
    )
  )
wrong_data <- delete_uncomplete |> filter(!is.na(exclusion)) |> select(participant_id, exclusion)
clear_data <- delete_reduplicate |>  filter(completed == 1, attention_check == 1)
rename_date <- clear_data |> 
  mutate(
    condition = case_when(
      condition_code == 1 ~ "High load",
      condition_code == 2 ~ "Low load",
      TRUE ~ NA_character_
    ),
    gender = case_when(
      gender_code == 1 ~ "Famale",
      gender_code == 2 ~ "Male",
      TRUE ~ NA_character_
    )
    )
sleep_data <- rename_date |>
  mutate(
    sleep_group = case_when(
      is.na(sleep_hours) ~ NA_character_,
      sleep_hours < 6 ~ "Less",
      sleep_hours < 8 ~ "Moderate",
      sleep_hours >= 8 ~ "Adequate"
    )
  )
sleep_data <- sleep_data |>
  mutate(
    sleep_group = factor(
      sleep_group,
      levels = c("Less","Moderate", "Adequate")
    )
  )
