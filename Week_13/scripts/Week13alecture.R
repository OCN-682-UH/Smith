## Iterative coding 
## 12-3-2024

library(tidyverse)
library(here)

# simple for loop 
print(paste("The year is", 2000))

# loop 
years<- c(2015:2021)

for(i in years) {
  print(paste("The year is", i))
}
# above just prints

# need to allocate space

#Pre-allocate space for the for loop
# empty matrix that is as long as the years vector
year_data<-tibble(year =  rep(NA, length(years)),  # column name for year, seq is years
                  year_name = rep(NA, length(years))) # column name for the year name
year_data

# these are originally in base r and not tidy
for(i in 1:length(years)){# set up the for loop where i is the index
  year_data$year_name[i]<-paste("This year is", years[i])# loop over i
  year_data$year[i]<-years[i] # loop over year
}
year_data

# she makes i=1 then runs each line to make sure the loop works
# ex year_data$year_name[i]<-paste("This year is", years[i])

# reading in csv files 
testdata<-read_csv(here("Week_13", "data", "cond_data","011521_CT316_1pcal.csv"))
glimpse(testdata)

# list files in a directory 
# point to the location on the computer of the folder
CondPath<-here("Week_13", "data", "cond_data")
# list all the files in that path with a specific pattern
# In this case we are looking for everything that has a .csv in the filename
# you can use regex to be more specific if you are looking for certain patterns in filenames
files <- dir(path = CondPath,pattern = ".csv")
files

# pre-allocate space for loop 
# make an empty dataframe that has one row for each file and 3 columns
cond_data<-tibble(filename =  rep(NA, length(files)),  # column name for year
                  mean_temp = rep(NA, length(files)), # column name for the mean temperature
                  mean_sal = rep(NA, length(files)), # column name for the mean salinity
) # column name for the year name
cond_data

#testing first
raw_data<-read_csv(paste0(CondPath,"/",files[1])) # test by reading in the first file and see if it works
head(raw_data)
#testing mean first
mean_temp<-mean(raw_data$Temperature, na.rm = TRUE) # calculate a mean
mean_temp

#turning it into a for loop
for (i in 1:length(files)){ # loop over 1:3 the number of files
  
  raw_data<-read_csv(paste0(CondPath,"/",files[i])) # file only thing be iterated
  glimpse(raw_data)
} #this ran 3 different outputs in console 

# now adding next line of code
for (i in 1:length(files)){ # loop over 1:3 the number of files 
  raw_data<-read_csv(paste0(CondPath,"/",files[i]))
  #glimpse(raw_data) # we know this works, so # it out
  cond_data$filename[i]<-files[i] #seeing if it saves in the right location 
} 
cond_data # checking to see if it works

#adding in next row
for (i in 1:length(files)){ # loop over 1:3 the number of files 
  raw_data<-read_csv(paste0(CondPath,"/",files[i]))
  #glimpse(raw_data)
  cond_data$filename[i]<-files[i]
  cond_data$mean_temp[i]<-mean(raw_data$Temperature, na.rm =TRUE) # only saves the mean of these and throws away the rest so it is not taking up space 
  cond_data$mean_sal[i]<-mean(raw_data$Salinity, na.rm =TRUE)
} 
cond_data

### purrr
# uses tidy so different than for loop 

# map() makes a list.
# map_lgl() makes a logical vector.
# map_int() makes an integer vector.
# map_dbl() makes a double vector.
# map_chr() makes a character vector.
# map_df() makes a dataframe

# 3 ways to do the same thing in a map() function 

# creating a vector of 1-10
1:10 # a vector from 1 to 10 (we are going to do this 10 times)

# mapping and no need to pre- allocate space 
1:10 %>% # a vector from 1 to 10 (we are going to do this 10 times) %>% # the vector to iterate over
  map(rnorm, n = 15)  %>% # calculate 15 random numbers based on a normal distribution in a list 
  map_dbl(mean) # calculate the mean. It is now a vector which is type "double"

# now can make your own function
1:10 %>% # list 1:10
  map(function(x) rnorm(15, x)) %>% # make your own function
  map_dbl(mean)

1:10 %>%
  map(~ rnorm(15, .x)) %>% # changes the arguments inside the function that already exists .x is basically your i 
  map_dbl(mean)

# now doing the exact same thing as for loop but in map 
# point to the location on the computer of the folder
CondPath<-here("Week_13", "data", "cond_data")
files <- dir(path = CondPath,pattern = ".csv")
files

# or one less step 
files <- dir(path = CondPath,pattern = ".csv", full.names = TRUE)
#save the entire path name
files

# this will bring in data and just stack them on top of one another
data<-files %>%
  set_names()%>% # set's the id of each list to the file name
  map_df(read_csv,.id = "filename") # map everything to a dataframe and put the id in a column called filename
data

# now adding in summarise 
data<-files %>%
  set_names()%>% # set's the id of each list to the file name
  map_df(read_csv,.id = "filename") %>% # map everything to a dataframe and put the id in a column called filename
  group_by(filename) %>%
  summarise(mean_temp = mean(Temperature, na.rm = TRUE),
            mean_sal = mean(Salinity,na.rm = TRUE))
data
