### Week 3: Lecture a: plotting more penguin data
### Created by: Megan Smith 
### Created on: 2024-09-17
##################################################

### Load libraries #########
library(palmerpenguins)
library(tidyverse)
library(here)
library(praise)
library(beyonce)
library(devtools) # load the development tools library

library (dadjoke)

### Look at data 
glimpse(penguins)

### intro to dplyr
filter(.data = penguins, sex == "female" )
filter(.data= penguins, year=="2008") #"" mean that it is a character and you want to know the exact number, but this one could have been without quotes
filter(.data=penguins, body_mass_g > 5000) # no " here because it is not a character 

## filtering multipe conditions
filter(.data = penguins, sex == "female", body_mass_g >5000) # just a comma

### Operator meaning
## a & b = and
## a | b = or
## !a = not

## comma and & are the same in filter

filter(.data= penguins, year == 2008 | 2009)
filter(.data = penguins, island  !="Dream")
filter(.data = penguins, species %in% c("Adelie", "Gentoo"))

### mutate the data
data2<-mutate(.data = penguins, 
              body_mass_kg = body_mass_g/1000) #creating a new column that is changing to kg from g

# mutating multiple columns
data2<-mutate(.data = penguins, 
              body_mass_kg = body_mass_g/1000,
              bill_length_depth = bill_length_mm/bill_depth_mm) #this is a ratio

#ifelse ** only two things for ifelse. case_when for 3 ore more things *****
data2<- mutate(.data = penguins,
               after_2008 = ifelse(year>2008, "After 2008", "Before 2008"))
View(data2)

### think pair share
penguinflipmass<-mutate(.data= penguins,
                   flipmass= flipper_length_mm + body_mass_g,
                   greater_4000 = ifelse(body_mass_g, "thicc", "smol"))
view(penguinflipmass)

## adding %>% pipe operator
penguins %>% # use penguin dataframe
  filter(sex == "female") %>% #select females
  mutate(log_mass = log(body_mass_g)) #calculate log biomass     

## this commenting every line is how she wants us to do it on homework 
## adding selecting certain columns 
penguins %>% # use penguin dataframe
  filter(sex == "female") %>% #select females
  mutate(log_mass = log(body_mass_g)) %>% #calculate log biomass
  select(species, island, sex, log_mass) #selecting out the columns we want to keep 

## using select to rename column names 
penguins %>% # use penguin dataframe
  filter(sex == "female") %>% #select females
  mutate(log_mass = log(body_mass_g)) %>% #calculate log biomass
  select(Species = species, island, sex, log_mass) #  selecting columns and changing names 

## summarize
#mean
penguins %>% 
  summarise(mean_flipper = mean(flipper_length_mm, na.rm=TRUE)) # this is going to exclude the NAs which you NEED to do so just always add this 
#mean and min
penguins %>% # 
  summarise(mean_flipper = mean(flipper_length_mm, na.rm=TRUE),# you can do the same as mutate and do if, at, or  all functions
            min_flipper = min(flipper_length_mm, na.rm=TRUE))
## group_by always assoc with summarize
penguins %>%
  group_by(island) %>% # now breaking down island and it gives you each summary of each island
  summarise(mean_bill_length = mean(bill_length_mm, na.rm = TRUE),
            max_bill_length = max(bill_length_mm, na.rm=TRUE))

## group by island and sex
penguins %>%
  group_by(island, sex) %>% # now island and sex
  summarise(mean_bill_length = mean(bill_length_mm, na.rm = TRUE),
            max_bill_length = max(bill_length_mm, na.rm=TRUE))

# dropping NAS
penguins %>%
  drop_na(sex) #gets rid of any NAs in the column you specify. but it will keep the other data in other variables

#merging it all 
penguins %>%
  drop_na(sex) %>%
  group_by(island, sex) %>%
  summarise(mean_bill_length = mean(bill_length_mm, na.rm = TRUE))

# pipe into ggplot this is good if you dont need to save the dataframe*****
penguins %>%
  drop_na(sex) %>%
  ggplot(aes(x = sex, y = flipper_length_mm)) + ## adding plotting directly into data wrangling
  geom_boxplot()

dadjoke()
