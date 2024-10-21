### Week 7b: Cont maps 
###


#### Load Libraries 
library(ggmap) #for ggmaps
library(tidyverse)
library(here)
library(ggspatial) # adds scale bars and compass arrows

# Entered Maps API and Stadia Api in console
# Both APIs are in Obsidian
# Wont need to load unless there is a enw version of R


### Loading in data 
ChemData<-read_csv(here("Week_07","data","chemicaldata_maunalua.csv"))
glimpse(ChemData)

# Getting base maps 
Oahu<-get_map("Oahu") # just pulling out cordinate system  not plotting 
# had to enable Geocoding 
ggmap(Oahu)

# Get coordinates for Wailupe Oahu
#Make a data frame of lon and lat coordinates
WP<-data.frame(lon = -157.7621, lat = 21.27427) # coordinates for Wailupe
# Get base layer
Map1<-get_map(WP)
# plot it
ggmap(Map1)

## Zoom in on a location 
# goes from 3 to 20: 3 is more zoomed out, 20 is super zoomed
Map1<-get_map(WP,zoom = 17)
ggmap(Map1)

# Changing map type
# this is satellite, but there are a lot of other types
# this is from google maps
Map1<-get_map(WP,zoom = 17, maptype = "satellite")
ggmap(Map1)

# stadia maps
Map1<-get_map(WP,zoom = 17, maptype = "stamen_watercolor", source = "stadia")
ggmap(Map1)

## ** Go play around with different map types ** ##

## Now plotting ChemData on map 
Map1<-get_map(WP,zoom = 17, maptype = "satellite") 
ggmap(Map1)+
  geom_point(data = ChemData,
             aes(x = Long, y = Lat, color = Salinity), # this is from the data set ** I can do this with my data**
             size = 4) +
  scale_color_viridis_c()

# adding scale bar and north arrow 
ggmap(Map1)+
  geom_point(data = ChemData, 
             aes(x = Long, y = Lat, color = Salinity), 
             size = 4) + 
  scale_color_viridis_c()+
  annotation_scale( bar_cols = c("yellow", "white"), # this is from tha ggspactial
                    location = "bl")+ # put the bar on the bottom left and make the colors yellow and white
  annotation_north_arrow(location = "tl")+ # add a north arrow
  coord_sf(crs = 4326) # Has to have this! for the scale bar to work it needs to be in this coordinate system - this is a typical coordinate reference system for a GPS (WGS84)


## Dont know exact lat and long 
# geocode can give exacts 
geocode("the white house") # output is tibble of lat and long 


geocode("University of Hawaii at Manoa")

## totally awesome r package
library(emojifont)
search_emoji('smile')
ggplot() + 
  geom_emoji('smile_cat', 
             x=1:5, y=1:5, 
             size=10)
