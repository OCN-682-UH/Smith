
library(tidytuesdayR)
library(tidyverse)
library(ggridges)
library(hrbrthemes)
library(magick)
library(gganimate)
library(here)
library(beepr)
library(grid)



tuesdata <- tidytuesdayR::tt_load('2024-11-19')

episode_metrics <- tuesdata$episode_metrics

glimpse(episode_metrics)

# creating a Bobs Burgers color pallete 
bobs_col<-c(
  "1"= "#f0262a",
  "2"="#f172a9",
  "3"="#95d244",
  "4"= "#fcdd60",
  "5"="#9ac7e8",
  "6"="#9ba54a",
  "7"="#c08653",
  "8"= "#a4b8df",
  "9"= "#324a70",
  "10"="#f2d477",
  "11"= "#f24344",
  "12"="#f2a679",
  "13"= "#c7c5a2",
  "14"= "#4063a6"
  
)
tinagif <- here("tidy_tuesday", "tidytuesday1126", "giphy.gif")
tina <- image_read(tinagif)
ggplot(episode_metrics, aes(x= unique_words, y= factor(season, levels= rev(unique(season))), fill= factor(season)))+
  geom_density_ridges (scale= 3)+
  theme_ridges ()+
  scale_fill_manual(values= bobs_col)+
  theme_minimal()+
    theme(
    legend.position = "none", 
    panel.spacing = unit(0.1, "lines"),
    strip.text.x= element_text(size=8)
  ) + 
  labs( x= "Unique Words",
        y= "Season",
        title= "Number of Unique Words in Bob's Burgers Per Season")


