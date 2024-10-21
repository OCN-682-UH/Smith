


library(tidyverse)
library(here)
library(maps)
library(mapproj)
library(mapdata)
library(lubridate)



bigfootraw<-read.csv(here("Week_07","data","bigfoot.csv"))
states<- map_data("state")

glimpse(bigfootraw)
glimpse(states)

states$region <- str_to_title(states$region) #changing all states region names to uppercase first letter to match bigfoot data
bigfootmainland<- bigfootraw %>% 
  filter(state != "Alaska") %>% 
  mutate(date= ymd(date),
    year = year(date))
glimpse(bigfootmainland)

ggplot()+
  geom_polygon(data =  subset (states,long >-130 ),
               aes(x = long,
                   y = lat,
                   group = group),
               fill= NA,
               color = "darkgrey",
               linewidth=0.5)+
  geom_point(data = subset(bigfootmainland, 
                           longitude >-130 & season !="Unknown" &
                             classification != "Class C" &
                             year >= 2010 & year <= 2020), 
             aes(x = longitude,
                 y = latitude,
                 color= classification)) +
  coord_map()+
  theme_void() +
  labs(title="Class A & B Bigfoot sightings in the US from 2010-2020")+
  facet_wrap(~ season)




