#### tidy tuesday 10/29/24

## load libraries 

library(tidyverse)
library(here)
library(naniar)


## Load in data 
tt_10_29 <- tidytuesdayR::tt_load('2024-10-29')

tt_genres<- tt_10_29$monster_movie_genres
tt_movies<-tt_10_29$monster_movies

## Exploring data 
glimpse(tt_genres)
glimpse(tt_movies)

## learning something new with the naniar package
# this helps you look for missing data and where it is 
# https://cran.r-project.org/web/packages/naniar/vignettes/getting-started-w-naniar.html

gg_miss_var(tt_genres)


gg_miss_var(tt_movies)



movies_clean <- tt_movies %>%
  filter(!is.na(genres)) %>%
  mutate(main_genre = sub(",.*", "", genres)) 


true_horror<-c("Horror", "Crime", "Documentary","Thriller","Sci-fi","Mystery","Drama","Biography","Adventure","Action")


genre_year<-movies_clean %>% 
  filter(year >=2000) %>% 
  select(year,main_genre) %>%
  filter(main_genre %in% true_horror) %>% 
  mutate(main_genre = case_when(
    main_genre %in% c("Action","Adventure") ~ "Action-Adventure",
    main_genre %in% c("Crime", "Drama") ~ "Crime-Drama",
    main_genre %in% c("Biography", "Documentary") ~"Biography-Documentary",
    main_genre %in% c("Mystery","Thriller") ~"Mystery-Thriller",
    main_genre == "Horror" ~ "Horror")) %>% 
  group_by(year)
genre_peryear<-genre_year %>% 
  add_count(year,main_genre) %>% 
  add_count(year, name = "year_n") %>% 
  group_by(year,main_genre) 
summary(genre_peryear)

ggplot(genre_peryear, aes(fill=main_genre,y=year_n, x=year))+
  geom_bar(position="fill", stat="identity") +
  labs(title= "Genre Composition of True Horror films from 2000-2024",
       x="Year",
       y="Proportion of Genre",
       fill="Genre")+
  scale_y_continuous(expand = c(0,0),
                     labels= scales::percent)+
  scale_x_continuous(expand = c(0,0), 
                     limits =c(2000,2024))+
  scale_fill_manual(values=c("#34073d","#8179dd","#923e4d","#fb8654","#aec5a8"))+
  theme_classic()


