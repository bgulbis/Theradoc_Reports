# preprocess

library(tidyverse)
library(readxl)
library(stringr)
library(lubridate)

data_ext <- "data/raw"

cols <- c(rep("text", 7), "date", "text", "text", "numeric", rep("text", 8), rep("numeric", 5))

activities <- c("Adverse Event Prevented: Major|Adverse Event Prevented: Minor|Anticoagulation consult/management|Anticoagulation intervention|Avoidance of high cost medication|Change Antimicrobial Dose or Route|CPR/Code attended|Discharge medication counseling|Discontinue inappropriate antimicrobials|Drug Information Consult|Drug therapy change|Initiate antibiotics for untreated infection|Initiate Antimicrobials|IV to PO conversion - antimicrobial|IV to PO conversion - non-antimicrobial|Lab ordered|Medication Reconciliation|Non-formulary to formulary conversion|Pain consults|Pharmacokinetic drug consult/management|Post-discharge micro intervention|Renal Dosing - antimicrobial|Streamline/De-escalate gram negative therapy|Surgical Antibiotic prophylaxis compliance|Therapeutic drug monitoring intervention|Weekend Sign-Out")

data_clin <- list.files(data_ext, pattern = "clinical_activity", full.names = TRUE) %>%
    map_df(read_excel, col_types = cols) %>%
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
           other_savings = `Other Savings`) %>%
    dmap_at("activity", str_replace_all, pattern = " \\(prevent order, discontinue, change\\)", replacement = "") %>%
    separate(activity, c("act1", "act2", "act3", "act4", "act5", "act6"), sep = ",", remove = FALSE)
    # mutate(activity_group = activity) %>%
    # dmap_at("activity_group", str_extract_all, pattern = ".*[,]?")

saveRDS(data_clin, "data/tidy/clinical_activity.Rds")
