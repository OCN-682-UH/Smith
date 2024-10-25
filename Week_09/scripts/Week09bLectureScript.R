### Week 9b: Functional Programming 
### 10-25-24

#### Load Libraries 
library(tidyverse)
library(here)

#tuesdata <- tidytuesdayR::tt_load(2021, week = 7)
#income_mean<-tuesdata$income_mean
income_mean <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-02-09/income_mean.csv')

#factors
fruits<-factor(c("Apple", "Grape", "Banana"))
fruits

# factors store everything as integers in background
# cautions with factors 
test<-c("A", "1", "2")
as.numeric(test)

#making above a factor
test<-factor(test) # covert to factor
as.numeric(test) #turns the "A" into a 3

# factors are for categorical data- categories

# read.csv() reads everything in as a factor
# read_csv() reads everthing in as character

#forcats
glimpse(starwars)
starwars %>% 
  filter(!is.na(species)) %>% # remove the NAs
  count(species, sort = TRUE) # gives a tibble with species name on left and how many of that species on right
## *** Use this count function in future

# focusing on dominate species 
star_counts<-starwars %>%
  filter(!is.na(species)) %>%
  mutate(species = fct_lump(species, n = 3)) %>% #fct_lump turns everthing into factor and groups
  count(species)
star_counts # our results are not in ABC order because its a factor

# basic ggplot
star_counts %>%
  ggplot(aes(x = species, y = n))+
  geom_col()
# above is not really in good order
star_counts %>%
  ggplot(aes(x = fct_reorder(species, n), y = n))+ # reorder the factor of species by n
  geom_col() # goes from lowest n to highest n

#making same plot descending 
star_counts %>%
  ggplot(aes(x = fct_reorder(species, n, .desc = TRUE), y = n))+ # reorder the factor of species by n
  geom_col() +
  labs(x = "Species")
# above is just a two dimensional plot 

#Moving into three dimensionsal plots 
# reordering line plots 
glimpse(income_mean)

#cleaning this 
total_income<-income_mean %>%
  group_by(year, income_quintile)%>%
  summarise(income_dollars_sum = sum(income_dollars))%>%
  mutate(income_quintile = factor(income_quintile)) # make it a factor

total_income%>%
  ggplot(aes(x = year, y = income_dollars_sum, color = income_quintile))+
  geom_line() # lengend in ABC order, so doesnt quite make sense

# fct_reorder2 is ordering 2 things so year and income quintile 
total_income%>%
  ggplot(aes(x = year, y = income_dollars_sum, 
             color = fct_reorder2(income_quintile,year,income_dollars_sum)))+
  geom_line()+
  labs(color = "income quantile")

# reordering levels directly just because I said so 
x1 <- factor(c("Jan", "Mar", "Apr", "Dec")) #not making it a "month" on lubritdate
x1

x1 <- factor(c("Jan", "Mar", "Apr", "Dec"), levels = c("Jan", "Mar", "Apr", "Dec"))
x1

#subset data with factors
starwars_clean<-starwars %>% 
  filter(!is.na(species)) %>% # remove the NAs
  count(species, sort = TRUE) %>%
  mutate(species = factor(species)) %>% # make species a factor
  filter(n>3) # only keep species that have more than 3
starwars_clean

# checking different levels
levels(starwars_clean$species)
# above showed that all the other species are still there

# using droplevels will get rid of all the extras 
starwars_clean<-starwars %>% 
  filter(!is.na(species)) %>% # remove the NAs
  count(species, sort = TRUE) %>%
  mutate(species = factor(species)) %>% # make species a factor 
  filter(n>3)  %>% # only keep species that have more than 3 
  droplevels() # drop extra levels

levels(starwars_clean$species)
# good idea to always drop levles after manipulating data 

# recode levels to diff names 
starwars_clean<-starwars %>% 
  filter(!is.na(species)) %>% # remove the NAs
  count(species, sort = TRUE) %>%
  mutate(species = factor(species)) %>% # make species a factor 
  filter(n>3)  %>% # only keep species that have more than 3 
  droplevels() %>% # drop extra levels 
  mutate(species = fct_recode(species, "Humanoid" = "Human"))
starwars_clean
