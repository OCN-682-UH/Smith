

install.packages("gganimate")



Ye# Not working in markdown because I cant get gganimate to work 
penguins %>%
  ggplot(aes(x = body_mass_g, 
             y = bill_depth_mm, 
             color = species)) +
  geom_point() +
  transition_states(
    year, # what are we animating by
    transition_length = 2, #The relative length of the transition.
    state_length = 1 # The length of the pause between transitions
  )
penguins %>%
  ggplot(aes(x = body_mass_g, 
             y = bill_depth_mm, 
             color = species)) +
  geom_point() +
  transition_states(
    year, # what are we animating by
    transition_length = 2, #The relative length of the transition.
    state_length = 1 # The length of the pause between transitions
  )+
  ease_aes("bounce-in-out")
penguins %>%
  ggplot(aes(x = body_mass_g, 
             y = bill_depth_mm, 
             color = species)) +
  geom_point() +
  transition_states(
    year, # what are we animating by
    transition_length = 2, #The relative length of the transition.
    state_length = 1 # The length of the pause between transitions
  )+
  ease_aes("sine-in-out") +
  labs(title = 'Year: {closest_state}') #adding the title, bracet is what you are telling it to label, so the state will be the year

penguins %>%
  ggplot(aes(x = body_mass_g, 
             y = bill_depth_mm, 
             color = species)) +
  geom_point() +
  transition_states(
    year, # what are we animating by
    transition_length = 2, #The relative length of the transition.
    state_length = 1 # The length of the pause between transitions
  )+
  ease_aes("sine-in-out") +
  labs(title = 'Year: {closest_state}') +
  anim_save(here("Week_08","output","mypengiungif.gif"))


### Penguin Plot 
penguin<-image_read("https://pngimg.com/uploads/penguin/pinguin_PNG9.png")
penguin

penguins %>%
  ggplot(aes(x = body_mass_g, 
             y = bill_depth_mm, 
             color = species)) +
  geom_point()

ggsave(here("Week_08","output","penguinplot.png"))

penplot<-image_read(here("Week_08","output","penguinplot.png"))
out <- image_composite(penplot, penguin, offset = "+70+30") #offset is where you want the penguin to be
out

# Adding animation to plot 
# Read in a penguin gif
pengif<-image_read("https://media3.giphy.com/media/H4uE6w9G1uK4M/giphy.gif")
outgif <- image_composite(penplot, pengif, gravity = "center") # another way to change where the image is
animation <- image_animate(outgif, fps = 10, optimize = TRUE) #fps is frames per second and optimized so it doesnt take up lot of space in computer
animation

# Totally awesome r package
remotes::install_github("andrewheiss/sourrr")

library(sourrr)
build_recipe(final_weight = 900, hydration = 0.75)

