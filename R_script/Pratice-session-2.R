#remove pre-exsiting entries
rm(list = ls()) ;cat("\014")

#load the necessary packages
library(cleaningtools)
library(dplyr)

#load the necessary data
my_raw_dataset <- cleaningtools::cleaningtools_raw_data
my_kobo_survey <- cleaningtools::cleaningtools_survey
my_kobo_choice <- cleaningtools::cleaningtools_choices

#load the previous log from exercise 1
previous_exercise_log <- readRDS("Exercises/Pratice2/03 - exercise - previous_log.RDS")

#Export cleaning log for manual review
  create_combined_log() %>%
  create_xlsx_cleaning_log(output_path = "Outputs/03 - correction - cleaning_log.xlsx", 
                           sm_dropdown_type = "logical",
                           use_dropdown = TRUE)

#read the filled cleaning log after manual review
exercise_filled_log <- readxl::read_excel("Exercises/Pratice2/04 - exercise - cleaning_log - filled.xlsx", sheet = "cleaning_log")

#clean the dataset (excluding SM parent data)
semi_clean_data <- create_clean_data(raw_dataset = my_raw_dataset,
  raw_data_uuid_column = "X_uuid",
  cleaning_log = exercise_filled_log, 
  cleaning_log_uuid_column = "uuid",
  cleaning_log_question_column = "question",
  cleaning_log_new_value_column = "new_value",
  cleaning_log_change_type_column = "change_type")

#clean the dataset (including SM parent data)
clean_data <- recreate_parent_column(semi_clean_data,
        uuid_column = "X_uuid", 
        kobo_survey = my_kobo_survey,
        kobo_choices = my_kobo_choice,
        cleaning_log_to_append = exercise_filled_log)

#load the cleand datatset and cleaning log for review
exercise3_clean_dataset <- readxl::read_excel("Exercises/Pratice2/05 - exercise - clean dataset for review.xlsx")
exercise3_cleaning_log <- readxl::read_excel("Exercises/Pratice2/05 - exercise - clean dataset for review.xlsx", sheet = 2)

#fIdentify removed survey
exercise3_deletion_log <- exercise3_cleaning_log %>% 
  filter(change_type == "remove_survey")

#Identify unremoved survey
exercise3_log_no_deletion <- exercise3_cleaning_log %>% 
  filter(change_type != "remove_survey") %>% 
  filter(!uuid %in% exercise3_deletion_log$uuid)

#review the cleaning 
review_of_cleaning <- review_cleaning(raw_dataset = my_raw_dataset,
                                      raw_dataset_uuid_column = "X_uuid", 
                                      clean_dataset = exercise3_clean_dataset,
                                      clean_dataset_uuid_column = "X_uuid",
                                      cleaning_log = exercise3_log_no_deletion, 
                                      cleaning_log_uuid_column = "uuid",
                                      cleaning_log_question_column = "question",
                                      cleaning_log_new_value_column = "new_value",
                                      cleaning_log_change_type_column = "change_type", 
                                      cleaning_log_old_value_column = "old_value", 
                                      deletion_log = exercise3_deletion_log, 
                                      deletion_log_uuid_column = "uuid")

