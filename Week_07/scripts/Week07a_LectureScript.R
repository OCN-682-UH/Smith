### Week 7a: Mapping
### Created by: Megan Smith 
### Created on: 2024-10-01
##################################################

### Load libraries #########
library(tidyverse)
library(here)
library(maps)
library(mapproj)
library(mapdata)

### load data
# Read in data on population in California by county
popdata<-read.csv(here("Week_07","data","CApopdata.csv"))
#read in data on number of seastars at different field sites
stars<-read.csv(here("Week_07","data","stars.csv"))

head(popdata)
head(stars)

# get data for the entire world
world<-map_data("world")
head(world)

# get data for the USA
usa<-map_data("usa")
head(usa)

# get data for states
states<-map_data("state")
head(states)

# get data for counties
counties<-map_data("county")
head(counties)

### Making maps
ggplot()+
  geom_polygon(data = world, aes(x = long, y = lat, group = group)) ## dont forget group or it will be crazy!!

## making a line
ggplot()+
  geom_polygon(data = world, 
               aes(x = long, y = lat, group = group),
               color = "black")
## changing colors of countries
ggplot()+
  geom_polygon(data = world, 
               aes(x = long, 
                   y = lat, 
                   group = group, 
                   fill = region),
               color = "black") +
  guides(fill = FALSE)  # adding false makes it so you dont have a legend

## changing theme and background
ggplot()+
  geom_polygon(data = world, 
               aes(x = long, 
                   y = lat, 
                   group = group,
                   fill = region),
               color = "black")+
  theme_minimal()+
  guides(fill = FALSE)+
  theme(panel.background = element_rect(fill = "lightblue"))

#changing map projection
ggplot()+
  geom_polygon(data = world, 
               aes(x = long, 
                   y = lat, 
                   group = group,
                   fill = region),
               color = "black")+
  theme_minimal()+
  guides(fill = FALSE)+
  theme(panel.background = element_rect(fill = "lightblue"))+
  coord_map(projection = "mercator", #default prjection
            xlim = c(-180,180))

## sinusoidal projection
ggplot()+
  geom_polygon(data = world, 
               aes(x = long,
                   y = lat,
                   group = group, 
                   fill = region),
               color = "black")+
  theme_minimal()+
  guides(fill = FALSE)+
  theme(panel.background = element_rect(fill = "lightblue"))+
  coord_map(projection = "sinusoidal",
            xlim = c(-180,180))

## making a map of just california 
# Use the states dataset
head(states) # keep reminding self that this is just a data set 

CA_data<-states %>%
  filter(region == "california") ## just pulling in state data

ggplot()+
  geom_polygon(data = CA_data, 
               aes(x = long,
                   y = lat,
                   group = group, 
                   fill = region),
               color = "black")+
  coord_map()+
  theme_minimal()

ggplot()+
  geom_polygon(data = CA_data, 
               aes(x = long, 
                   y = lat, 
                   group = group), 
               color = "black")+
  coord_map()+
  theme_void() # this removes the long and lat lines

# Look at the county data
head(counties)[1:3,] # only showing the first 3 rows for space

# Look at the county data
head(popdata)

## Joinging the two data sets
CApop_county<-popdata %>%
  select("subregion" = County, Population)  %>% # rename the county col
  inner_join(counties) %>% #used inner join for no NAs
  filter(region == "california") # some counties have same names in other states
## Joining with by = join_by(subregion)
head(CApop_county)

## plotting the map of CA by county
ggplot()+
  geom_polygon(data = CApop_county, 
               aes(x = long, 
                   y = lat, 
                   group = group,
                   fill = Population), #this bases the color on population
               color = "black")+
  coord_map()+
  theme_void()

# log the pop density so colors tell a better story
ggplot()+
  geom_polygon(data = CApop_county, 
               aes(x = long, 
                   y = lat, 
                   group = group,
                   fill = Population),  
               color = "black")+
  coord_map()+
  theme_void() +
  scale_fill_gradient(trans = "log10") # this is what makes the scaling look better

#now adding layer of sea star data 
head(stars)

### ***** adding sampling location to map 
## adding the stars fow stars locations
ggplot()+
  geom_polygon(data = CApop_county, 
               aes(x = long, 
                   y = lat, 
                   group = group,
                   fill = Population),  
               color = "black")+
  geom_point(data = stars, # add a point at all my sites
             aes(x = long,
                 y = lat))+
  coord_map()+
  theme_void() +
  scale_fill_gradient(trans = "log10")

## this changes the size of the dots based on adundance
ggplot()+
  geom_polygon(data = CApop_county, 
               aes(x = long, 
                   y = lat, 
                   group = group,
                   fill = Population),  
               color = "black")+
  geom_point(data = stars, # add a point at all my sites 
             aes(x = long, 
                 y = lat,
                 size = star_no))+
  coord_map()+
  theme_void() +
  scale_fill_gradient(trans = "log10")

### making a better legend
ggplot()+
  geom_polygon(data = CApop_county, 
               aes(x = long, 
                   y = lat, 
                   group = group,
                   fill = Population),  
               color = "black")+
  geom_point(data = stars, # add a point at all my sites 
             aes(x = long, 
                 y = lat,
                 size = star_no))+ #this is what changes the size of the star 
  coord_map()+
  theme_void() +
  scale_fill_gradient(trans = "log10")+
  labs(size = "# stars/m2") #changing titles
ggsave(here("Week_07","output","CApop.pdf"))

# Awesome R package
library(ggdogs)
ggplot(mtcars) +
  geom_dog(aes(mpg, wt), dog = "pug", size = 5)


