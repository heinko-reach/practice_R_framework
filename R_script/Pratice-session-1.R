library(cleaningtools)
library(dplyr)

my_raw_dataset <- cleaningtools::cleaningtools_raw_data
my_kobo_survey <- cleaningtools::cleaningtools_survey
my_kobo_choice <- cleaningtools::cleaningtools_choices

#pratice1
check_pii_list <- my_raw_dataset |> check_pii(uuid_column = "X_uuid")

#pratice2
check_percentage_missing_list <- my_raw_dataset |> 
   add_percentage_missing(
    kobo_survey = my_kobo_survey) |> 
  check_percentage_missing(uuid_column = "X_uuid")

exercise_check_list <- readxl::read_excel("exercise1_check_list.xlsx")

#pratice_3
pratice_3 <- my_raw_dataset |> 
    check_logical_with_list(uuid_column = "X_uuid",
                          list_of_check = exercise_check_list,
                          check_id_column = "check_id",
                          check_to_perform_column = "check_to_perform",
                          columns_to_clean_column = "columns_to_clean",
                          description_column = "description")

#need to download audit file from the server
add_audit_list <-  my_raw_dataset |>  create_audit_list(uuid_column = "X_uuid") |>  
  add_duration_from_audit()

