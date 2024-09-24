### Week 4: Homework b
### Created by: Megan Smith 
### Created on: 2024-09-20
##################################################

### Load libraries #########
library(tidyverse)
library(here)
library(ggcorrplot)


### open data 
ChemData<-read_csv(here("Week_04","data", "chemicaldata_maunalua.csv"))
View(ChemData)
glimpse(ChemData)

### cleaning data
ChemData_clean<-ChemData %>%
  drop_na() %>% #removing nas
  separate(col = Tide_time, # seperating Tide and Time 
           into = c("Tide","Time"), # new column names
           sep = "_" )

View(ChemData_clean)

### analyzing data
ChemData_long<- ChemData_clean %>%
  filter(Time == "Day") %>% # filtering out just Day
  pivot_longer(cols= c(Temp_in, Salinity, pH),# making a long data set with selcted variables
               names_to = "Variables", # naming column for Variables
               values_to = "Values") %>% #namine column for values
 group_by(Site,Zone, Tide, Variables) %>% # how I want them grouped
  summarise(mean_vals = mean(Values, na.rm = TRUE)) %>% #getting the mean of the values
 pivot_wider(names_from = Variables,
            values_from = mean_vals) %>% #making wider to create a table for summary statistics
  write_csv(here("Week_04","Outputs","Week04HWb_summary.csv"))

### New data analysis to do "Correlogram" plot

ChemData_corr<-ChemData_clean %>% #pulling from clean data set
  select(Temperature=Temp_in, #changing names for readability 
         Salinity, Phosphate, Silicate,
         `Nitrate+Nitrite` = NN,# using `` to keep the +
         pH,Alkalinity = TA,
         `%SGD`= percent_sgd) %>% 
  cor() #to create a correlation matrix
ggcorrplot(ChemData_corr,  #using ("kassambara/ggcorrplot") function
           hc.order = TRUE, type = "lower",  # only keeping lower triangle
           lab = FALSE,  # no labels for correlation values 
           method = "circle",  # choosing circles 
           colors = c("#785ef0", "white", "#009e73"),  # colors for correlation strength
           ggtheme = theme_bw(),  # using bw theme
           legend.title = "Correlation Strength") +  # renaming legend
  ggtitle("Correlation of Environmental and Chemical \nVariables Across Site Zones") +  # making title 2 lines
  theme(plot.title = element_text(size = 18, hjust = 0.3)) #changing title size and position
ggsave(here("Week_04","Outputs","Week04HWb_ChemDataPlot.png"), #saving plot
       width = 7, height = 6) 









