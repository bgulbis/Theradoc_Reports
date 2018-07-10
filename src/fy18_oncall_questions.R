library(tidyverse)
library(readxl)
library(lubridate)
library(openxlsx)

data_ext <- "data/raw"

clin_cols <- c(rep("text", 7), "date", "text", "text", "numeric", rep("text", 8), rep("numeric", 5))

data_oncall <- list.files(data_ext, pattern = "resident_clinical", full.names = TRUE) %>%
    map_df(read_excel, col_types = clin_cols) %>%
    mutate_at("Age", str_replace_all, pattern = " Y", replacement = "") %>%
    mutate_at("Age", as.numeric) %>%
    filter(`Clinical Activities` == "Resident On-Call")

write.xlsx(
    data_oncall,
    "data/external/fy18_oncall_questions.xlsx"
)
