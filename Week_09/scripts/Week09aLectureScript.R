### Week 9a: Functional Programming 
### 10-22-24

#### Load Libraries 
library(tidyverse)
library(here)
library(palmerpenguins)
library(PNWColors)

###
# creating a dataframe
df <- tibble(
  a = rnorm(10), # draws 10 random values from a normal distribution
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)
head(df)

# rescale data
#keeps a column name the same
# below is not a function, just showing something you would do to multiple things
df<-df %>%
  mutate(a = (a-min(a, na.rm = TRUE))/(max(a, na.rm = TRUE)-min(a, na.rm = TRUE)))

df<-df %>%
  mutate(a = (a-min(a, na.rm = TRUE))/(max(a, na.rm = TRUE)-min(a, na.rm = TRUE)),
         b = (b-min(b, na.rm = TRUE))/(max(a, na.rm = TRUE)-min(b, na.rm = TRUE)),
         c = (c-min(c, na.rm = TRUE))/(max(c, na.rm = TRUE)-min(c, na.rm = TRUE)),
         d = (d-min(d, na.rm = TRUE))/(max(d, na.rm = TRUE)-min(d, na.rm = TRUE)))

# we can write a function for this 
rescale01 <- function(x) {
  value<-(x-min(x, na.rm = TRUE))/(max(x, na.rm = TRUE)-min(x, na.rm = TRUE))
  return(value)
}

df %>%
  mutate(a = rescale01(a),
         b = rescale01(b),
         c = rescale01(c),
         d = rescale01(d))

## making an easy function 
temp_C<- (temp_F -32)* 5/9

# naming the function
fahrenheit_to_celsius <- function() {
}

fahrenheit_to_celsius <- function() {
  temp_C<- (temp_F -32)* 5/9
}

# step 3: Decide what the arguments are 
fahrenheit_to_celsius <- function(temp_F) {
  temp_C <- (temp_F - 32) * 5 / 9 
}

# Step 4: Decide what is being returned
fahrenheit_to_celsius <- function(temp_F) { 
  temp_C <- (temp_F - 32) * 5 / 9 
  return(temp_C)
}

# Step 5: Test it 
fahrenheit_to_celsius(32)
fahrenheit_to_celsius(212)

## Think pair share: celcius to kelvin
celsius_kelvin <- function(temp_C) { 
  temp_K <- (temp_C +273.15) 
  return(temp_K)
}
celsius_kelvin(100)

## Making plots into a function 
pal<-pnw_palette("Lake",3, type = "discrete") # this is a function for the color pallete 
# this you can create your own palate
ggplot(penguins, aes(x = body_mass_g, y = bill_length_mm, color = island))+
  geom_point()+
  geom_smooth(method = "lm")+ # add a linear model
  scale_color_manual("Island", values=pal)+   # use pretty colors and another example of how to manually change the legend title for colors
  theme_bw()

# Making the above a function
myplot<-function(){
  pal<-pnw_palette("Lake",3, type = "discrete") # my color palette 
  ggplot(penguins, aes(x = body_mass_g, y = bill_length_mm, color = island))+
    geom_point()+
    geom_smooth(method = "lm")+ # add a linear model
    scale_color_manual("Island", values=pal)+   # use pretty colors and change the legend title
    theme_bw()
}

# making broad 
myplot<-function(data, x, y){
  pal<-pnw_palette("Lake",3, type = "discrete") # my color palette 
  ggplot(data, aes(x = x, y =y , color = island))+
    geom_point()+
    geom_smooth(method = "lm")+ # add a linear model
    scale_color_manual("Island", values=pal)+   # use pretty colors and change the legend title
    theme_bw()
}

myplot(data = penguins, x = body_mass_g, y = bill_length_mm)
## above gives an error

## need to add {{}}
myplot<-function(data, x, y){ 
  pal<-pnw_palette("Lake",3, type = "discrete") # my color palette 
  ggplot(data, aes(x = {{x}}, y = {{y}} , color = island))+
    geom_point()+
    geom_smooth(method = "lm")+ # add a linear model
    scale_color_manual("Island", values=pal)+   # use pretty colors and change the legend title
    theme_bw()
}
myplot(data = penguins, x = body_mass_g, y = bill_length_mm)
# trying another variable
myplot(data = penguins, x = body_mass_g, y = flipper_length_mm)

## Adding defaults
# this would be always using the penguin data
myplot<-function(data = penguins, x, y){
  pal<-pnw_palette("Lake",3, type = "discrete") # my color palette 
  ggplot(data, aes(x = {{x}}, y = {{y}} , color = island))+
    geom_point()+
    geom_smooth(method = "lm")+ # add a linear model
    scale_color_manual("Island", values=pal)+   # use pretty colors and change the legend title
    theme_bw()
}
myplot(x = body_mass_g, y = flipper_length_mm)

## Layering the plot 
myplot(x = body_mass_g, y = flipper_length_mm)+
  labs(x = "Body mass (g)",
       y = "Flipper length (mm)")


### Add an if-else statement for more flexibility
a <- 4
b <- 5

# function for it 
if (a > b) { # my question
  f <- 20 # if it is true give me answer 1
} else { # else give me answer 2
  f <- 10
}

f # confused about this 

# Back to plotting 
myplot<-function(data = penguins, x, y ,lines=TRUE ){ # add new argument for lines
  pal<-pnw_palette("Lake",3, type = "discrete") # my color palette 
  ggplot(data, aes(x = {{x}}, y = {{y}} , color = island))+
    geom_point()+
    geom_smooth(method = "lm")+ # add a linear model
    scale_color_manual("Island", values=pal)+   # use pretty colors and change the legend title
    theme_bw()
}
# making this with if and else
myplot<-function(data = penguins, x, y, lines=TRUE ){ # add new argument for lines
  pal<-pnw_palette("Lake",3, type = "discrete") # my color palette 
  if(lines==TRUE){
    ggplot(data, aes(x = {{x}}, y = {{y}} , color = island))+
      geom_point()+
      geom_smooth(method = "lm")+ # add a linear model
      scale_color_manual("Island", values=pal)+   # use pretty colors and change the legend title
      theme_bw()
  }
  else{
    ggplot(data, aes(x = {{x}}, y = {{y}} , color = island))+
      geom_point()+
      scale_color_manual("Island", values=pal)+   # use pretty colors and change the legend title
      theme_bw()
  }
 
}
# testing it out
myplot(x = body_mass_g, y = flipper_length_mm)
myplot(x = body_mass_g, y = flipper_length_mm, lines = FALSE)


## you can use source to have files with all used functions
devtools::install_github("itsrainingdata/emokid")

