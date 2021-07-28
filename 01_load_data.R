# url to cdc site with county-level map:
# https://covid.cdc.gov/covid-data-tracker/#county-view
# 
# direct url to data as json:
# https://covid.cdc.gov/covid-data-tracker/COVIDData/getAjaxData?id=integrated_county_latest_external_data

library(tidyverse)
library(janitor)
library(httr)
library(jsonlite)
library(curl)
library(writexl)
library(tidycensus)
options(scipen = 999)

#set url for direct link to transmission data feeding live map
myurl <- "https://covid.cdc.gov/covid-data-tracker/COVIDData/getAjaxData?id=integrated_county_latest_external_data"

this.content <- fromJSON(myurl)

#returns a list?
class(this.content)
#how long is the list
length(this.content)
this.content[[1]] #the first element - should be states if working
this.content[[2]] #the data itself

#dataframe from the data content element 
content_df <- as.data.frame(this.content[[2]])

glimpse(content_df)

#add timestamp for version tracking 
data <- content_df %>% 
  mutate(
    tstamp = Sys.time()
  ) %>% 
  select(tstamp, everything())


#save results
saveRDS(data, "processed_data/data_current.rds")


# CREATE ARCHIVED VERSION

#save archived copy to use for future comparisons
filestring <- paste0("archived_data/data_archived_", Sys.time())
filestring <- str_replace_all(filestring, "-", "_")
filestring <- str_replace_all(filestring, ":", "_")
filestring <- str_replace(filestring, " ", "t")
#remove seconds for clarity
filestring <- str_sub(filestring, 1, -4L)
#add file extension
filestring <- paste0(filestring, ".rds")
#run the string through and save the file
saveRDS(data, filestring)
