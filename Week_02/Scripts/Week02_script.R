### This is my first script. I am learning how to import data
### Created by: Megan Smith 
### Created on: 2024-09-05
##################################################

### Load libraries #########
library (tidyverse)
library (here)

### Read in data ###
WeightData<- read.csv(here("Week_02","Data", "weightdata.csv"))


### Data Analysis ###
head(WeightData) # looks at the top 6 lines of dataframe

tail(WeightData) # looks at the bottom 6 lines

View(WeightData) # opens a new window to look at the data 