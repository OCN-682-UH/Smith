### Week 5b: Homework
### Created by: Megan Smith 
### Created on: 2024-09-26
##################################################

#### Homework Directions
## Read in both the conductivity and depth data.
## Convert date columns appropriately
## Round the conductivity data to the nearest 10 seconds so that it matches with the depth data
## Join the two dataframes together (in a way where there will be no NAs... i.e. join in a way where only exact matches between the two dataframes are kept)
## take averages of date, depth, temperature, and salinity by minute
## Make any plot using the averaged data
## Do the entire thing using mostly pipes (i.e. you should not have a bunch of different dataframes). Keep it clean.
## Don't forget to comment!
## Save the output, data, and scripts appropriately


### Load libraries #########
library(tidyverse)
library(here)
library(lubridate)

### load data
CondData<-read_csv(here("Week_05","Data", "CondData.csv"))
DepthData<-read.csv(here("Week_05","Data","DepthData.csv"))

###
glimpse(CondData)
glimpse(DepthData)

### cleaning CondData to match DepthData
CondData$date<- mdy_hms(CondData$date) %>% #making this a date
  round_date("10 seconds") #rounding to 10 seconds to match Depth Data
DepthData$date<-ymd_hms(DepthData$date)#making this a date 


CondDepth_join<- inner_join(CondData, DepthData) #using inner joing to merge the data 

###  Data analysis

CondDepth<- CondDepth_join %>% 
  select(date, Temperature, Salinity, Depth) %>% #selecting just what I need
  mutate(date=floor_date(date, unit= "minute")) %>% #rounding the dates to the nearest minute so we can account for the hours 
  pivot_longer(cols= c(Temperature:Depth), #changing to long
               names_to = "Parameters",# all parameters
               values_to = "Values") %>% #all values
  group_by(date,Parameters) %>% #grouping by to summarise
  summarise(mean_values = mean(Values, na.rm=TRUE))  %>% #summarizing the mean of all values
  ggplot(aes(x=date, y=mean_values, color= Parameters))+ #adding in the plot
  geom_point(size=.5, alpha=0.7)+ #making the points smaller so it is easier to see the changes
  geom_line()+## adding a line 
  facet_wrap(~Parameters, scales= "free_y", ncol=1)+ #facet wrapping with stacking them 
  labs(x="Time", y="Mean Values", #changing the labels 
       title= "Depth, Salinity, and Temperature Over Time") + #adding a title 
  theme_bw()+ #bw theme
  theme(axis.text.x = element_text(angle = 45, hjust = 1),# making the time at an angel
        legend.position = "none")+ #removing the legend
  ggsave(here("Week_05","Outputs","Week05HWb.png"), #saving plot
         width = 7, height = 6) 



