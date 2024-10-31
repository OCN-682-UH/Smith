### Homework 09b: Factors 
## Created on 10/20/2024
## Factors

## Make a plot where one of the axes is a factor

## Load libraries
library(tidyverse)
library(here)
library(janitor)


## Load in data 
intide_data<- read_csv(here("Week_09", "data", "intertidaldata.csv"))
intide_data_lat<- read_csv(here("Week_09", "data", "intertidaldata_latitude.csv"))


## glimpse data 
head(intide_data)
glimpse(intide_data)
unique(intide_data$Site)

head(intide_data_lat)
glimpse(intide_data_lat)


## cleaning data 
intide_clean<-intide_data %>% 
  clean_names() %>% 
  mutate(quadrat = str_replace(quadrat, "^(Low|Mid|High).*", "\\1")) #trying to use regex more often

## plotting 
glimpse(intide_clean)

selectsites<-intide_clean %>% 
  filter(site %in% c("Starfish Point", "Pyramid Point", "Fogarty Creek", "Cape Meares")) %>% 
  pivot_longer(cols= whelks_counts:stars_counts,
               names_to = "Organisms",
               values_to = "Values") %>% 
  group_by(site, Organisms, quadrat) %>% 
  mutate(quadrat = factor(quadrat, levels= c("Low", "Mid", "High"))) %>% 
  summarise(Total_Organisms = sum(Values, na.rm= TRUE))
glimpse(selectsites)
ggplot(selectsites, aes(x = Total_Organisms, y=quadrat, fill= quadrat)) +
  geom_bar(stat = "identity") +  
  labs(title = "Total Organism Counts by Site and Tide",
       x = "Site",
       y = "Total Organisms") +
  scale_fill_manual(values= c("#48cae4", "#0077B6","#03045E"))+
  theme_minimal() +
  theme(legend.position = "right",  
        axis.text.x = element_blank()) + 
  coord_flip() +
  facet_wrap(~ site, scales= "free")


