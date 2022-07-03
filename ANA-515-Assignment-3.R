
library(readr)#loading the tidyverse package
library(tidyverse)

#Reading and storing the dataset (in .csv format) into 'storms_95': 
storms_95 <- read_csv("https://www1.ncdc.noaa.gov/pub/data/swdi/stormevents/csvfiles/StormEvents_details-ftp_v1.0_d1995_c20220425.csv.gz")
storms_95 %% write_csv("file.csv")
glimpse(storms_95)

#Creating Dataframe 
storms_95_df <- data.frame(storms_95)

#Selecting the Columns that are required, dropping the rest from the Dataframe:
StormEvents95_df = subset(storms_95_df, select = c(BEGIN_DATE_TIME, END_DATE_TIME, EPISODE_ID, EVENT_ID, STATE, STATE_FIPS, CZ_NAME, CZ_FIPS, CZ_TYPE, EVENT_TYPE, SOURCE, BEGIN_LAT, BEGIN_LON, END_LAT, END_LON))

#Arranging the Data by the State Name: 
StormEvents95_df  <- arrange(StormEvents95_df, (STATE))
StormEvents95_df 

#Changing state and county names to title case: 
StormEvents95_df$STATE <- str_to_title(StormEvents95_df$STATE)
StormEvents95_df$CZ_NAME <- str_to_title(StormEvents95_df$CZ_NAME)

#Limiting the events listed by county FIPS (CZ_TYPE of "C"): 
StormEvents95_df <- StormEvents95_df[StormEvents95_df$CZ_TYPE == 'C',]
#And dropping the column CZ_TYPE from the DataFrame: 
StormEvents95_df = subset(StormEvents95_df, select = -c(CZ_TYPE))

#pad STATE_FIPS and CZ_FIPS with 0
StormEvents95_df$STATE_FIPS <- str_pad(StormEvents95_df$STATE_FIPS, width = 3, side = "left", pad = "0")

#rename all the column to lower: 
StormEvents95_df <- rename_all(StormEvents95_df, tolower)
StormEvents95_df

#pulling the data that comes with base R on U.S. states:
data("state")
US_State_Info<-data.frame(state=state.name, region=state.region, area=state.area)

#Creating a dataframe with the number of events per state (Frequency): 
table(StormEvents95_df$state)
Storm_StateFreq <- data.frame(table(StormEvents95_df$state))
Storm_StateFreq <- rename(Storm_StateFreq, c("state" = "Var1"))

#Merge two dataframe: 
Merged_StateData <- data.frame(merge(Storm_StateFreq, US_State_Info, by="state"))
Merged_StateData
glimpse(Merged_StateData)
#It can be noticed in the Merged_StateData that two Data rows for state = District of Columbia and Alaska were dropped as the data was not available in the R base state data. 

#GG Plot
library(ggplot2)
storm_plot <-
  ggplot(Merged_StateData, aes(x = area, y = Freq)) +
  geom_point(aes (color = region)) +
  labs(x = "Land area (in square miles)",
       y= "# of storm events in 1995")
storm_plot