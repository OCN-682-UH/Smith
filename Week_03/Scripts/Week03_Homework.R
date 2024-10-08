### Week 3 Homework Penguin Plotting
### Created by: Megan Smith 
### Created on: 2024-09-15
##################################################

### Load libraries #########
library(palmerpenguins)
library(tidyverse)
library(here)
library(praise)
library(beyonce)


### Look at data 
str(penguins)
unique(penguins$year) # looking at how many years to determine how facet will look


### Plotting
penguins_omitna<- penguins %>%
  na.omit() # removing out all na data

ggplot(data = penguins_omitna, 
       mapping = aes(x = sex,
                     y = body_mass_g,
                     fill = sex)) +
  geom_violin(width = 1) + # changed width so there was no overlapping
  geom_boxplot(width = 0.08, color="grey") + 
  labs(title="Penguin Body Mass by Species and Year",
       x="Sex", y="Body mass (g)",
       fill="Sex",
       caption= " Source: Palmer Station LTER/palmerpenguin package") +
  scale_fill_manual(values = beyonce_palette(11)) +  
  facet_grid(year~species) + 
  theme_bw()
praise() # yay made a cool plot
ggsave(here("Week_03","output","Homework_penguinplot.png"),
       width = 7, height = 5) 
