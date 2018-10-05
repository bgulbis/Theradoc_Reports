library(tidyverse)
library(readxl)
library(lubridate)
library(openxlsx)

data_month <- mdy("9/1/2018", tz = "UTC")

data_ext <- "data/raw"

clin_cols <- c(
    rep("text", 7), 
    "date", 
    "text", 
    "text", 
    "numeric", 
    rep("text", 8), 
    rep("numeric", 5)
)

data_oncall <- data_ext %>%
    list.files(pattern = "resident_clinical", full.names = TRUE) %>%
    map_df(read_excel, col_types = clin_cols) %>%
    mutate_at("Age", str_replace_all, pattern = " Y", replacement = "") %>%
    mutate_at("Age", as.numeric) %>%
    filter(
        `Clinical Activities` == "Resident On-Call",
        floor_date(`Date Entered`, "month") == data_month
    ) 

write.xlsx(
    data_oncall,
    paste0(
        "/home/brian/Public/W_Pharmacy/Residency Programs/On-Call Questions/",
        format(data_month, "%Y-%m-%d"),
        "_oncall_questions.xlsx"
    )
)
