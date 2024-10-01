### Week 5: Joining data sets
### Created by: Megan Smith 
### Created on: 2024-09-24
##################################################

### Load libraries #########
library(tidyverse)
library(here)

### load data
# Environmental data from each site
EnviroData<-read_csv(here("Week_05","Data", "site.characteristics.data.csv"))
#Thermal performance data
TPCData<-read_csv(here("Week_05","Data","Topt_data.csv"))

glimpse(EnviroData)
glimpse(TPCData)

### cleaning data before joining
EnviroData_wide <- EnviroData %>% #making it wider to match the other data set
  pivot_wider(names_from = parameter.measured,
              values_from = values) #this is alphabetical order for name
View(EnviroData_wide)

EnviroData_wide <- EnviroData %>% 
  pivot_wider(names_from = parameter.measured, # pivot the data wider
              values_from = values) %>%
  arrange(site.letter) # arrange the dataframe by site

### left join
FullData_left<- left_join(TPCData, EnviroData_wide) # it automatically joins what needs to be done 
head(FullData_left)

FullData_left<- left_join(TPCData, EnviroData_wide) %>% ## useful when you want to export your data and want to see some things first
  relocate(where(is.numeric), .after = where(is.character)) # relocate all the numeric data after the character data
 # for relocate you can be specific on what order you want

### think pair share
?summarise_at
FullData_summ<-FullData_left %>% 
  group_by(site.letter) %>% 
  summarise_at(vars(E:Topt, light:substrate.cover), 
               funs(mean=mean, var= var),na.rm = TRUE) 
## another way and it looked better
FullData_left %>% 
  pivot_longer(cols=E:substrate.cover,
               names_to="Parameter",
               values_to = "Values") %>% 
  group_by(site.letter, Parameter) %>% 
  summarise(mean_values = mean(Values),
            var_values= var(Values)) %>% 
  view()

## Creating a tibble
T1 <- tibble(Site.ID = c("A", "B", "C", "D"), 
            Temperature = c(14.1, 16.7, 15.3, 12.8))

T2 <-tibble(Site.ID = c("A", "B", "D", "E"), 
           pH = c(7.3, 7.8, 8.1, 7.9))

left_join(T1, T2) ## loses site E beacuse it is in the right data set 

right_join(T1,T2) # lose site E


## inner join only keeps complete data that is in both sets
inner_join(T1,T2)
## full join keeps everything and will just give NAs
full_join(T1,T2)

# Semi join ONLY from the first data frames
semi_join(T1,T2)

## anti-join finds where the first data is missing data across datasets
anti_join(T1,T2)

library(cowsay)
say("hello",by= "shark")
?cowsay

say("hello", by= "signbunny")

say("hello", by= "random")


### Week 5b: Data wrangling: lubridate
### Created by: Megan Smith 
### Created on: 2024-09-26
##################################################

### Load libraries #########
library(tidyverse)
library(here)
library(lubridate)

### load data



####
now() #plugs in the time at the bottom
now(tzone = "EST") # what time is it on the east coast
now(tzone = "GMT") # what time in GMT
today() #just the date
today(tzone = "GMT") #just the date in GMT
am(now()) # is it morning? will give true or false
leap_year(now()) # is it a leap year?


##### ****** very important date MUST be a character!!! so needs "" around it 

ymd("2021-02-24") #now it makes it a true date 

mdy("02/24/2021") #turns it into ISO date
mdy("February 24 2021")
dmy("24/02/2021") # this is very helpful when stuff isnt in ISO format

## Date with time will assume military time if no AM or PM
ymd_hms("2021-02-24 10:22:20 PM") # "2021-02-24 22:22:20 UTC" thats the output

mdy_hms("02/24/2021 22:22:20")

mdy_hm("February 24 2021 10:22 PM") #sometime excel until you bring it into R

## vector of dates 
# make a character string
datetimes<-c("02/24/2021 22:22:20",
             "02/25/2021 11:21:10",
             "02/26/2021 8:01:52") # has to be the same format in the begining 
# convert to datetimes
datetimes <- mdy_hms(datetimes)

## just want to see months
month(datetimes) # you can just mutate a month of this 

month(datetimes, label = TRUE) #plots this in order since its a factor label = TRUE means factor 

month(datetimes, label = TRUE, abbr = FALSE) #Spell it out Not Feb its February helpful when plotting 

day(datetimes) # extract day

wday(datetimes, label = TRUE) # extract day of week

hour(datetimes) #helpful when you want to see average during an hour
minute(datetimes)
second(datetimes)

# adjusting times due to timezone
datetimes + hours(4) # this adds 4 hours has to have the s
datetimes + days(2) # this adds 2 days

## rounding dates- might be helpful when you want them to all be the same to look at data easier 
round_date(datetimes, "minute") # round to nearest minute

round_date(datetimes, "5 mins") # round to nearest 5 minute

### Challenge

CondData<-read_csv(here("Week_05","Data", "CondData.csv"))

glimpse(CondData)
View(CondData)


### todays totally awesome R package
library(devtools)
install_github("Gibbsdavidl/CatterPlots") # install the data

library(CatterPlots)
x <-c(1:10)# make up some data
y<-c(1:10)
catplot(xs=x, ys=y, cat=3, catcolor='blue')


### Week 5b: Homework
### Created by: Megan Smith 
### Created on: 2024-09-26
##################################################

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

### cleaning data

## Dont know where the rest of this code went

