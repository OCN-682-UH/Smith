### Week 8a
### Created by: Megan Smith 
### Created on: 2024-10-15
##################################################

### Load libraries #########
library(here)
library(tidyverse)
library(tidytext)
library(wordcloud2)
library(janeaustenr)

#####

### manipulation
paste("High temp", "Low pH")

paste("High temp", "Low pH", sep = "-")

## no space between the two
paste0("High temp", "Low pH")

# working with vectors- helpful for plots 
shapes <- c("Square", "Circle", "Triangle")
paste("My favorite shape is a", shapes)

two_cities <- c("best", "worst")
paste("It was the", two_cities, "of times.")

## individual characters **** good for molecular work
shapes # vector of shapes
str_length(shapes) # how many letters are in each word?

#molecular example
seq_data<-c("ATCCCGTC")
str_sub(seq_data, start = 2, end = 4) # extract the 2nd to 4th AA

#modifiy string
str_sub(seq_data, start = 3, end = 3) <- "A" # add an A in the 3rd position
seq_data

#duplicate
str_dup(seq_data, times = c(2, 3)) # times is the number of times to duplicate each string

# whitespace
badtreatments<-c("High", " High", "High ", "Low", "Low")
badtreatments

# triming white space
str_trim(badtreatments) # this removes both

# just removing left side
str_trim(badtreatments, side = "left") # this removes left

# adding padding of white space, if you want it 
str_pad(badtreatments, 5, side = "right") # add a white space to the right side after the 5th character

## this make everything 5 letter *** helpful for image analysis
str_pad(badtreatments, 5, side = "right", pad = "1") # add a 1 to the right side after the 5th character

### Locale sensitive
x<-"I love R!"
str_to_upper(x) # uppercase

str_to_lower(x) # lowercase

str_to_title(x) # first letter upper case

### Pattern matching
data<-c("AAA", "TATA", "CTAG", "GCTT")

# find all the strings with an A
str_view(data, pattern = "A")

## detect a specific pattern
str_detect(data, pattern = "A") # this gives true or false 

str_detect(data, pattern = "AT")

# locate the pattern
str_locate(data, pattern = "AT")

##### Regular expressions ***** use cheatsheet 

# metacharacters:  . \ | ( ) [ { $ * + ?  //= really looking for it 
vals<-c("a.b", "b.c","c.d")
#string, pattern, replace
str_replace(vals, "\\.", " ")

vals<-c("a.b.c", "b.c.d","c.d.e")
#string, pattern, replace
str_replace(vals, "\\.", " ")
#string, pattern, replace
str_replace_all(vals, "\\.", " ")

# sequences: seq of characters we can match
val2<-c("test 123", "test 456", "test")
str_subset(val2, "\\d") # find all the ones that have numbers



# Character classes: inside brackets
str_count(val2, "[aeiou]") # count the # of lowercase vowels
# count any digit
str_count(val2, "[0-9]")

# Quantifiers: outside brackets

# example find the phone number
strings<-c("550-153-7578",
           "banana",
           "435.114.7586",
           "home: 672-442-6739")
# this is what we know about phone numbers
phone <- "([2-9][0-9]{2})[- .]([0-9]{3})[- .]([0-9]{4})"

# Which strings contain phone numbers?
str_detect(strings, phone) # this will give true or false

# subset only the strings with phone numbers
test<-str_subset(strings, phone)
test

### think pair share
# replace all . with -
# extract only numbers
# remove white space
test %>%
  str_replace_all(pattern = "\\.", replacement = "-") %>% # replace periods with -
  str_replace_all(pattern = "[a-zA-Z]|\\:", replacement = "") %>% # remove all the things we don't want
  str_trim() # trim the white space


###### tidytext ***** can look up keywords in abstracts 
## analyze books by jane austen ** dont run austen_books it will crash computer
# explore it
head(austen_books())
tail(austen_books())

## cleaning up data * adding column for a line and chapter
original_books <- austen_books() %>% # get all of Jane Austen's books
  group_by(book) %>%
  mutate(line = row_number(), # find every line
         chapter = cumsum(str_detect(text, regex("^chapter [\\divxlc]", # count the chapters (starts with the word chapter followed by a digit or roman numeral)
                                                 ignore_case = TRUE)))) %>% #ignore lower or uppercase
  ungroup() # ungroup it so we have a dataframe again
# don't try to view the entire thing... its >73000 lines...
head(original_books)

tidy_books <- original_books %>%
  unnest_tokens(output = word, input = text) # add a column named word, with the input as the text column
head(tidy_books) # there are now >725,000 rows. Don't view the entire thing!

## stop words
#see an example of all the stopwords
head(get_stopwords())

# removing stopwords
cleaned_books <- tidy_books %>%
  anti_join(get_stopwords()) # dataframe without the stopwords
head(cleaned_books)

# counting most common books
cleaned_books %>%
  group_by(book) %>% 
  count(word, sort = TRUE)

# sentiment analysis positive or negative meanings
sent_word_counts <- tidy_books %>%
  inner_join(get_sentiments()) %>% # only keep pos or negative words
  count(word, sentiment, sort = TRUE) # count them
head(sent_word_counts)[1:3,]

sent_word_counts %>%
  filter(n > 150) %>% # take only if there are over 150 instances of it
  mutate(n = ifelse(sentiment == "negative", -n, n)) %>% # add a column where if the word is negative make the count negative
  mutate(word = reorder(word, n)) %>% # sort it so it gows from largest to smallest
  ggplot(aes(word, n, fill = sentiment)) +
  geom_col() +
  coord_flip() +
  labs(y = "Contribution to sentiment")

## making word cloud
words<-cleaned_books %>%
  count(word) %>% # count all the words
  arrange(desc(n))%>% # sort the words
  slice(1:100) #take the top 100
wordcloud2(words, shape = 'triangle', size=0.3) # make a wordcloud out of the top 100 words
