# World precipitation data cleaning
## Data source
NOAA GHCN version 4 Beta Land Precipitation: https://www.ncei.noaa.gov/access/monitoring/ghcn-gridded-products/data-access

## Description
This data set provides monthly precipitation totals for over 100,000 stations across the globe. Totals are provided in millimeters.
The main files are:
- ghcn-m_v4_prcp_inventory.txt
- ghcn-m_v4_prcp_readme.txt
- and a zip file with over 300,000 csv files, each file for every station

## Data cleaning steps

1. Read in inventory file, which is a txt file that includes a list of all stations along with the start and end years
2. Add a header for each column as the first row to the file (get the columns from the readme file)
3. From the inventory file, get a list of names of files for which there is data for 2023
4. Store the station ids in a list for all stations that have 2023 data
5. Filter the csv files for only those files and copy them to the "2023" folder
6. For all the csv files in the 2023 folder, add a header for each column as the first row to the file (get the columns from the readme file)
7. For each file in 2023, get only the row for 2023-05, and append it to a final csv dataset in the "final" folder named 2023MayData.csv

## Final dataset
A csv file with all stations with 2023 data, showing only the most updated dataset (2023 May, most updated data as of June 30) 

## Note 
For this repo, I kept only 2000 out of 122063 individual stations csv files to serve as an example, you can download the full dataset here and run the same code on this dataset: https://www.ncei.noaa.gov/data/ghcnm/v4beta/archive/



