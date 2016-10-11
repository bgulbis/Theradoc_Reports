# preprocess

library(tidyverse)
library(readxl)
library(stringr)
library(lubridate)

data_ext <- "data/external"

cols <- c(rep("text", 7), "date", "text", "text", "numeric", rep("text", 8), rep("numeric", 5))

data_clin <- read_excel("data/external/test_clinical_activity_2016-10-11.xlsx",
                        col_types = cols) %>%
    dmap_at("Age", str_replace_all, pattern = " Y", replacement = "") %>%
    dmap_at("Age", as.numeric) %>%
    select(clinician = User,
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
           other_savings = `Other Savings`)
