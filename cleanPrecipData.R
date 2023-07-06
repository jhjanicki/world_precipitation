library(tidyverse)

# 1.read in inventory file
data <-read_lines("ghcn-m_v4_prcp_inventory.txt", skip = 0) 

# 2. add a header for the file
data_tibble <- tibble(
       GHCN_ID = str_sub(data, 1, 11),
       Latitude = str_sub(data, 13, 20),
       Longitude = str_sub(data, 22, 30),
       Elevation = str_sub(data, 32, 37),
       State = str_sub(data, 39, 40),
       Station = str_sub(data, 42, 79),
       WMO_ID = str_sub(data, 81, 85),
       First_Year = str_sub(data, 87, 90),
       Last_Year = str_sub(data, 91, 95)
   )

# get rid of leading / trailing spaces using str_squish
# use across() from dplyr to apply str_squish() from stringr to the specified columns of the data frame.  
data_tibble <- data_tibble %>%mutate(across(c(2,3,4,7,8,9), str_squish))

# 3. from inventory file, get a list of names of files for which there is data for 2023
data_tibble_selected <- data_tibble_cleaned %>% filter(Last_Year == 2023)

# 4. store the ids in a list for those files
ids_array <- data_tibble_selected %>%pull(GHCN_ID)

# 5. filter the csv files for only those files and copy them to the "2023" folder
csv_files <- list.files(path = "./stations_data", pattern = ".csv")
for (file_name in csv_files) {
      file_stem <- gsub("\\.csv", "", file_name)
       if (file_stem %in% ids_array) {
             cat("Matched file:", file_name, "\n")
             file_path <- file.path("./stations_data", file_name)
             new_file_path <- file.path("./stations_data/2023", file_name)
             file.copy(file_path, new_file_path)
         }
}

# 6. for all the csv files in the 2023 folder, add a header
csv_files2023 <- list.files(path = "./stations_data/2023", pattern = ".csv", full.names = TRUE)
header_row <- c("GHCN identifier", "Station_name", "Latitude", "Longitude", "Elevation", "yearmonth", "Precipitation_value", "Measurement_flag", "Quality_control_flag", "Source_flag", "Source_index")

for (file_name in csv_files2023) {
       lines <- readLines(file_name)
       lines <- c(paste(header_row, collapse = ","), lines)
       writeLines(lines, file_name, sep = "\n")
}

# 7.for each file in 2023, get only the row for 2023-05, and append it to a final csv dataset 2023MayData.csv

# output file name
output_file <- "./final/2023MayData.csv"

# create a data frame of headers using tibble(), for some reason it doesn't work in the below code when stored as a list
header_df <- tibble(
  GHCN_identifier = "GHCN identifier",
  Station_name = "Station_name",
  Latitude = "Latitude",
  Longitude = "Longitude",
  Elevation = "Elevation",
  yearmonth = "yearmonth",
  Precipitation_value = "Precipitation_value",
  Measurement_flag = "Measurement_flag",
  Quality_control_flag = "Quality_control_flag",
  Source_flag = "Source_flag",
  Source_index = "Source_index"
)

for (csv_file in csv_files2023) {
  # Read the CSV file
  csv_data <- read_csv(csv_file)
  # Filter for rows where yearmonth is "202305"
  filtered_data <- csv_data %>% filter(yearmonth == "202305")
  #filtered_data <- as.data.frame(filtered_data)
  
  # If there are any matching rows, write them to the output file
  if (nrow(filtered_data) > 0) {
    
    # Write the header row and the matching rows to the output file
    if (!file.exists(output_file)) {
      write_csv(header_df, output_file, col_names = FALSE)
    }
    write_csv(filtered_data, output_file, append = TRUE, col_names = FALSE)
  }
}
