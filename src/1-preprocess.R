# preprocess

library(tidyverse)
library(readxl)
library(stringr)
library(lubridate)

data_ext <- "data/raw"

clin_cols <- c(rep("text", 7), "date", "text", "text", "numeric", rep("text", 8), rep("numeric", 5))

data_clin <- list.files(data_ext, pattern = "resident_clinical", full.names = TRUE) %>%
    map_df(read_excel, col_types = clin_cols) %>%
    mutate_at("Age", str_replace_all, pattern = " Y", replacement = "") %>%
    mutate_at("Age", as.numeric) %>%
    select(resident = User,
           fin = `Account Number`,
           age = Age,
           provider = `Receiving Clinician`,
           rec_datetime = `Date Entered`,
           rec_type = `Intervention Type`,
           rec_location = `Intervention Location`,
           time_spent = `Time Spent (in minutes)`,
           alert_num = `Related Alert`,
           alert_name = `Alert Title`,
           activity = `Clinical Activities`,
           follow_up = `Follow-up Status`,
           status = `Intervention Status`,
           rec_savings = `Intervention Savings`,
           total_costs = `Total Cost`,
           total_savings = `Total Savings`,
           other_costs = `Other Costs`,
           other_savings = `Other Savings`) %>%
    mutate_at("activity", str_replace_all, pattern = " \\(prevent order, discontinue, change\\)", replacement = "") %>%
    separate(activity, c("act1", "act2", "act3", "act4", "act5", "act6"), sep = ",", remove = FALSE)

gen_cols <- c(rep("text", 7), "date", "text", "text", "numeric", rep("text", 10), rep("numeric", 5))

data_gen <- list.files(data_ext, pattern = "resident_general", full.names = TRUE) %>%
    map_df(read_excel, col_types = gen_cols) %>%
    mutate_at("Age", str_replace_all, pattern = " Y", replacement = "") %>%
    mutate_at("Age", as.numeric) %>%
    select(resident = User,
           fin = `Account Number`,
           age = Age,
           provider = `Receiving Clinician`,
           rec_datetime = `Date Entered`,
           rec_type = `Intervention Type`,
           rec_location = `Intervention Location`,
           time_spent = `Time Spent (in minutes)`,
           alert_num = `Related Alert`,
           alert_name = `Alert Title`,
           reason = Reasons,
           comment = `Team Comments`,
           follow_up = `Follow-up Status`,
           status = `Intervention Status`,
           rec_savings = `Intervention Savings`,
           total_costs = `Total Cost`,
           total_savings = `Total Savings`,
           other_costs = `Other Costs`,
           other_savings = `Other Savings`) %>%
    mutate_at("reason", str_replace_all, pattern = " \\(renal/hepatic, etc.\\)", replacement = "") %>%
    separate(reason, c("reason1", "reason2", "reason3", "reason4", "reason5", "reason6"), sep = ",", remove = FALSE)

saveRDS(data_clin, "data/tidy/resident_clinical.Rds")
saveRDS(data_gen, "data/tidy/resident_general.Rds")
