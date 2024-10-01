### Week 4: Lecture b: Data wrangling with tidry
### Created by: Megan Smith 
### Created on: 2024-09-20
##################################################

### Load libraries #########
library(palmerpenguins)
library(tidyverse)
library(here)


### open data 
ChemData<-read_csv(here("Week_04","data", "chemicaldata_maunalua.csv"))
View(ChemData)
glimpse(ChemData)

### cleaning data
ChemData_clean<-ChemData %>%
  filter(complete.cases(.)) #filters out everything that is not a complete row and gets rid of NAs
View(ChemData_clean)

ChemData_clean<-ChemData %>%
  drop_na() %>% #filters out everything that is not a complete row
  separate(col = Tide_time, # choose the tide time col (it will get rid of this column)
           into = c("Tide","Time"), # separate it into two columns Tide and time
           sep = "_" ) # separate by _
head(ChemData_clean)

# But if you want to keep that column 
ChemData_clean<-ChemData %>%
  drop_na() %>% #filters out everything that is not a complete row
  separate(col = Tide_time, # choose the tide time col NO " needed
           into = c("Tide","Time"), # separate it into two columns Tide and time NEEDS "
           sep = "_", # separate by _
           remove = FALSE) # keep the original tide_time column
head(ChemData_clean)

## uniting 2 columns 
ChemData_clean<-ChemData %>%
  drop_na() %>% #filters out everything that is not a complete row
  separate(col = Tide_time, # choose the tide time col
           into = c("Tide","Time"), # separate it into two columns Tide and time
           sep = "_", # separate by _
           remove = FALSE) %>% # keep the original tide_time column
  unite(col = "Site_Zone", # the name of the NEW col NEEDS "
        c(Site,Zone), # the columns to unite no " 
        sep = ".", # lets put a . in the middle joining by period
        remove = FALSE) # keep the original
head(ChemData_clean)

## pivot long
## **** below code will be helful for me!!!
ChemData_long <-ChemData_clean %>% #renaming it 
  pivot_longer(cols = Temp_in:percent_sgd, # the cols you want to pivot. This says select the temp to percent SGD cols thats what the : does
               names_to = "Variables", # the names of the new cols with all the column names
               values_to = "Values") # names of the new column with all the values
View(ChemData_long)

# summarising with this long it makes it so much easier
ChemData_long %>%
  group_by(Variables, Site) %>% # group by everything we want
  summarise(Param_means = mean(Values, na.rm = TRUE), # get mean
            Param_vars = var(Values, na.rm = TRUE)) # get variance

#thingpairshar
ChemData_long %>%
  group_by(Variables, Site,Zone, Tide) %>% # group by everything we want
  summarise(Param_means = mean(Values, na.rm = TRUE), # get mean
            Param_vars = var(Values, na.rm = TRUE), #get variance
            Param_StDev = sd(Values, na.rm=TRUE)) # get standard deviation

# facet wrao with long data is so much easier
ChemData_long %>%
  ggplot(aes(x = Site, y = Values))+
  geom_boxplot()+
  facet_wrap(~Variables) # but this way gives the smae y-axis which isnt helpful

# making y-axis different **** this would be helpful in enviro data 
ChemData_long %>%
  ggplot(aes(x = Site, y = Values))+ 
  geom_boxplot()+ 
  facet_wrap(~Variables, scales = "free") #scales "free" releases both x and y axes 
# if you just want to free the x or y you just do free_y or free_x

## making data wide
ChemData_wide<-ChemData_long %>% ## this is basically the same data set 
  pivot_wider(names_from = Variables, # column with the names for the new columns
              values_from = Values) # column with the values

### starting from the beginging to have a clean work flow and saving 

ChemData_clean<-ChemData %>%
  drop_na() %>% #filters out everything that is not a complete row
  separate(col = Tide_time, # choose the tide time col
           into = c("Tide","Time"), # separate it into two columns Tide and time
           sep = "_", # separate by _
           remove = FALSE) %>%
  pivot_longer(cols = Temp_in:percent_sgd, # the cols you want to pivot. This says select the temp to percent SGD cols  
               names_to = "Variables", # the names of the new cols with all the column names 
               values_to = "Values") %>% # names of the new column with all the values 
  group_by(Variables, Site, Time) %>%
  summarise(mean_vals = mean(Values, na.rm = TRUE)) %>% 
  pivot_wider(names_from = Variables,
              values_from = mean_vals) %>% 
  write_csv(here("Week_04","Outputs","summary.csv"))  # export as a csv to the right folder# notice it is now mean_vals as the col name

## above is entire data analysis that looks so pretty!

## Bernie data set
library(ggbernie)
ggplot(ChemData) +
  geom_bernie(aes(x = Salinity, y = NN), bernie = "sitting")



