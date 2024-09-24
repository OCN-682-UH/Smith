### Week 4: Homework a
### Created by: Megan Smith 
### Created on: 2024-09-17
##################################################

### Load libraries #########
library(palmerpenguins)
library(tidyverse)
library(here)
library(beyonce)

### look at data
glimpse(penguins)

#### Data analysis

## Question 1
penguin_summ<-penguins %>%
  na.omit() %>% # removing na
  group_by(species,island, sex) %>% #grouping out what I want
  summarise(mean_body_mass = mean(body_mass_g, na.rm = TRUE), #getting the mean of body mass
            var_body_mass= var(body_mass_g, na.rm=TRUE))#getting variance of body mass 

## Question 2
penguins %>% 
  filter(sex != "male") %>% #filtering out males
  mutate(log_mass = log(body_mass_g)) %>% # logging body mass 
  select(species, island, sex, log_mass) %>% # selecting columns I want
  ggplot(aes(x = island, y = log_mass, fill= island)) + # adding plotting directly into data wrangling
  geom_violin() + #choosing violin
  labs(title="Female Penguin Body Mass (log) by Species and Island", # naming title
       x="Island", y="Log Body mass (g)", #renaming axes
       fill="Islands", #renaming legend
       caption= " Source: Palmer Station LTER/palmerpenguin package") + #adding caption
  scale_fill_manual(values = beyonce_palette(18)) + #changing fill color
  facet_grid(~species) + #faceting for species
  theme_light()
ggsave(here("Week_04","Outputs","Week04HWa_Penguinplot.png"), #saving plot
       width = 7, height = 6) 


