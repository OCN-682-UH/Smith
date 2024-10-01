### Week 5b
### Created by: Megan Smith 
### Created on: 2024-09-24
##################################################

### Load libraries #########
library(tidyverse)
library(here)

### load data
### load data
CondData<-read_csv(here("Week_05","Data", "CondData.csv"))
DepthData<-read.csv(here("Week_05","Data","DepthData.csv"))

###
glimpse(CondData)
glimpse(DepthData)

### cleaning data
