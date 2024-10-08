### My first plot
### BY Megan Smith 
### created on 2024-09-10

## load libraries
library(palmerpenguins)
library(tidyverse)


### look at data 
glimpse(penguins)
View(penguins)
head(penguins)
tail(penguins)


#make a plot 
ggplot(data=penguins) # this will be empty

ggplot(data=penguins,
       mapping= aes(x=bill_depth_mm)) #still nothing on the plot and no geom

ggplot(data=penguins,
       mapping= aes(x=bill_depth_mm,
                    y= bill_length_mm))# we have x adn y but no points

ggplot(data=penguins,
       mapping= aes(x=bill_depth_mm,
                    y= bill_length_mm)) + # the plus is adding another layer and is outside of the function 
  geom_point()
  
ggplot(data=penguins,
       mapping= aes(x=bill_depth_mm,
                    y= bill_length_mm,
                    color= species)) + # the plus is adding another layer and is outside of the function 
  geom_point()
ggplot(data=penguins,
       mapping= aes(x=bill_depth_mm,
                    y= bill_length_mm,
                    color= island)) + # the plus is adding another layer and is outside of the function 
  geom_point() 
 
ggplot(data=penguins,
       mapping= aes(x=bill_depth_mm,
                    y= bill_length_mm,
                    color= species)) + # the plus is adding another layer and is outside of the function 
  geom_point()+
  labs(title="Bill depth and length") # this is going to add your title 

ggplot(data=penguins,
       mapping= aes(x=bill_depth_mm,
                    y= bill_length_mm,
                    color= species)) + # the plus is adding another layer and is outside of the function 
# changing x and y names
geom_point()+
  labs(title="Bill depth and length",
       subtitle= "Dimensions of penguin",
       x="Bill depth(mm)", y="Bill length (mm)",
       color="Species") # this is to change the title of the legend 


# adding a caption to the bottom
ggplot(data=penguins,
       mapping= aes(x=bill_depth_mm,
                    y= bill_length_mm,
                    color= species)) + 
  geom_point()+
  labs(title="Bill depth and length",
       subtitle= "Dimensions of penguin",
       x="Bill depth(mm)", y="Bill length (mm)",
       color="Species",
       caption="Source: Palmer Station LTER")

## adding a layer for people who are color blind
ggplot(data=penguins,
       mapping= aes(x=bill_depth_mm,
                    y= bill_length_mm,
                    color= species)) + 
  geom_point()+
  labs(title="Bill depth and length",
       subtitle= "Dimensions of penguin",
       x="Bill depth(mm)", y="Bill length (mm)",
       color="Species",
       caption="Source: Palmer Station LTER") +
  scale_color_viridis_d()

# adding more aes (always related to the data)
# adding shape for different islands

ggplot(data=penguins,
       mapping= aes(x=bill_depth_mm,
                    y= bill_length_mm,
                    color= species,
                    shape= species)) + 
  geom_point()+
  labs(title="Bill depth and length",
       subtitle= "Dimensions of penguin",
       x="Bill depth(mm)", y="Bill length (mm)",
       color="Species",
       caption="Source: Palmer Station LTER") +
  scale_color_viridis_d()

#changing the size
ggplot(data=penguins,
       mapping= aes(x=bill_depth_mm, # aes always assoc with data 
                    y= bill_length_mm,
                    color= species,
                    size = body_mass_g,# makes each body size different size circle aka bigger penguins is bigger circle
                    alpha= flipper_length_mm)) + # big flippers are darker than small flippers
  geom_point()+
  labs(title="Bill depth and length",
       subtitle= "Dimensions of penguin",
       x="Bill depth(mm)", y="Bill length (mm)",
       color="Species",
       caption="Source: Palmer Station LTER") +
  scale_color_viridis_d()


# mapping vs setting

#mapping
ggplot(data=penguins, 
       mapping = aes(x = bill_depth_mm,
                     y = bill_length_mm,
                     size = body_mass_g,
                     alpha = flipper_length_mm
       )) +
  geom_point()

#setting
ggplot(data=penguins, 
       mapping = aes(x = bill_depth_mm,
                     y = bill_length_mm)) +
  geom_point(size = 2, alpha = 0.5) # just adding the alpha to all the points

# Faceting

#below doesnt have proper labeling but it is just to show us how to facet
#facet_grid rows by columns
ggplot(penguins, 
       aes(x = bill_depth_mm,
           y = bill_length_mm))+
  geom_point()+
  facet_grid(species~sex)# makes everything a grid- rows as a function of columns

#this is reversing what is above
ggplot(penguins, 
       aes(x = bill_depth_mm,
           y = bill_length_mm))+
  geom_point()+
  facet_grid(sex~species)# swapped these

#facet_wrap a ribbon and you can determin the dimensions
ggplot(penguins, aes(x = bill_depth_mm, y = bill_length_mm)) + 
  geom_point() +
  facet_wrap(~ species) # just by species, you can switch this to species ~

#saying how many columns
ggplot(penguins, aes(x = bill_depth_mm, y = bill_length_mm)) + 
  geom_point() +
  facet_wrap(~ species, ncol=2) # make it two columns

# facet and color
ggplot(data=penguins, 
       mapping = aes(x = bill_depth_mm,
                     y = bill_length_mm,
                     color = species,
       )) +
  geom_point()+
  scale_color_viridis_d()+
  facet_grid(species~sex)

#removing lengend
ggplot(data=penguins, 
       mapping = aes(x = bill_depth_mm,
                     y = bill_length_mm,
                     color = species,
       )) +
  geom_point()+
  scale_color_viridis_d()+
  facet_grid(species~sex)+
  guides(color = FALSE)
