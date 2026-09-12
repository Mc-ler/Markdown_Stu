library("tidyverse")

id <- 1:120
memory_raw <- tibble(
  participant_id = sprintf("P%03d", id),
  condition_code = rep(c(1L, 2L), each = 60),
  gender_code = rep(c(1L, 2L, 1L, 1L, 2L), length.out = 120),
  age = 18 + ((id * 7) %% 8),
  sleep_hours = round(5.2 + ((id * 11) %% 32) / 10, 1),
  anxiety_score = round(42 + ((id * 13) %% 17) - 8 + if_else(condition_code == 1L, 2, 0) + sin(id / 4) * 3),
  mem_pre = round(17 + ((id * 5) %% 8) + cos(id / 5) * 1.5),
  mem_post = round(mem_pre + if_else(condition_code == 2L, 3, 1) + (((id * 3) %% 5) - 2) / 2),
  rt_ms = round(560 + if_else(condition_code == 1L, 45, -10) + ((id * 17) %% 81) - 40 + anxiety_score * 0.7 - sleep_hours * 4),
  acc_rate = round(pmin(pmax(0.68 + if_else(condition_code == 2L, 0.07, 0) + (mem_post - 20) * 0.012 - ((id * 7) %% 11) / 100, 0.55), 0.98), 2),
  attention_check = if_else(id %in% c(17, 54, 88, 113), 0L, 1L),
  completed = if_else(id %in% c(29, 63, 97), 0L, 1L)
)

memory_raw$sleep_hours[c(8, 57, 103)] <- NA_real_
memory_raw$anxiety_score[c(14, 61, 89, 110)] <- NA_real_
memory_raw$rt_ms[c(23, 76)] <- NA_real_
memory_raw$acc_rate[45] <- NA_real_

memory_raw$rt_ms[40] <- 890
memory_raw$rt_ms[102] <- 330

duplicate_record <- memory_raw |>
  filter(participant_id == "P032")

raw_data <- bind_rows(memory_raw, duplicate_record)

codebook <- tibble(
  variable = c(
    "participant_id",
    "condition_code",
    "gender_code",
    "age",
    "sleep_hours",
    "anxiety_score",
    "mem_pre",
    "mem_post",
    "rt_ms",
    "acc_rate",
    "attention_check",
    "completed"
  ),
  meaning = c(
    "被试编号",
    "实验条件编码",
    "性别编码",
    "年龄",
    "前一晚睡眠时长",
    "焦虑得分",
    "记忆前测得分",
    "记忆后测得分",
    "平均反应时，单位为毫秒",
    "正确率",
    "是否通过注意检查",
    "是否完成实验"
  ),
  coding = c(
    "P001至P120",
    "1=高负荷，2=低负荷",
    "1=女，2=男",
    "单位：岁",
    "单位：小时",
    "分数越高表示焦虑水平越高",
    "记忆任务前测得分",
    "记忆任务后测得分",
    "单位：毫秒",
    "0至1之间",
    "0=未通过，1=通过",
    "0=未完成，1=完成"
  )
)

write_csv(raw_data, "./data/memory_raw.csv", na = "")

writexl::write_xlsx(
  x = list(
   "原始数据" = raw_data,
   "变量说明" = codebook
  ),
  path = "./data/memory_raw.xlsx"
)

file.exists("./data/memory_raw.csv")
file.exists("./data/memory_raw.xlsx")
