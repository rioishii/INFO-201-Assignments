# a3-using-data

################################### Set up (2 Points) ###################################

# Before you get started, make sure to set your working directory using the tilde (~)
setwd("~/Desktop/INFO 201/Assignments/a3-data-rioishii")

################################### DataFrame Manipulation (20 Points) ###################################

# Create a vector `first_names` with 5 names in it
first_names <- c("Rio", "Anthony", "Koko", "Rosie", "Quitina")

# Create a vector `math_grades` with 5 hypothetical grades (0 - 100) in a math course (that correspond to the 5 names above)
math_grades <- c(100, 64, 88, 77, 83)

# Create a vector `spanish_grades` with 5 hypothetical grades (0 - 100) in a Spanish course (that correspond to the 5 names above)
spanish_grades <- c(75, 85, 100, 60, 95)

# Create a data.frame variable `students` by combining your vectors `first_names`, `math_grades`, and `spanish_grades`
students <- data.frame(first_names, math_grades, spanish_grades)

# Create a variable `num_students` that contains the number of rows in your data.frame `students`
num_students <- nrow(students)

# Create a variable `num_courses` that contains the number of columns in your data.frame `students` minus one (b/c of their names)
num_courses <- ncol(students) - 1

# Add a new column `grade_diff` to your dataframe, which is equal to `students$math_grades` minus `students$spanish_grades`
students$grade_diff <- students$math_grades - students$spanish_grades

# Add another column `better_at_math` as a boolean (TRUE/FALSE) variable that indicates that a student got a better grade in math
students$better_at_math <- students$grade_diff > 0

# Create a variable `num_better_at_math` that is the number (i.e., one numeric value) of students better at math
num_better_at_math <- sum(students$better_at_math, na.rm=TRUE)

# Write your `students` data.frame to a new .csv file inside your data/ directory with the filename `grades.csv`. Make sure not to write row names.
write.csv(students, file = "data/grades.csv", row.names = FALSE)

################################### Loading R Data (28 points) ###################################

## In this section, you'll work with some data that comes built into the R environment.
## Load the `Titanic` data set. You may also want to use RStudio to `View()` it to inspect its rows and columns,
## or just print (selected lines of) it.
data(Titanic)

# This data set actually loads in a format called a *table*
# This is not a data frame. Use the `is.data.frame()` function to confirm this.
titanic_frame <- is.data.frame(Titanic)

# You should convert the `Titanic` variable into a data frame; you can use the `data.frame()` function or `as.data.frame()`
# Be sure to **not** treat strings as factors!
convert_titanic <- data.frame(Titanic, stringsAsFactors = FALSE)

# Create a variable `children` that are the rows of the data frame with information about children on the Titanic.
children <- convert_titanic[convert_titanic$Age=="Child",]

# Create a variable `num_children` that is the total number of children on the Titanic.
# Hint: remember the `sum()` function!
num_children <- nrow(children)

# Create a variable `most_lost` which has row with the largest absolute number of losses (people who did not survive).
# Tip: you can use multiple statements (lines of code), such as to make "intermediate" sub-frames
#  (similar to what you did with the `children` variables)
did_not_survive <- convert_titanic[convert_titanic$Survived=="No",]
most_lost <- did_not_survive[did_not_survive$Freq==max(did_not_survive$Freq),]

# Define a function called `SurvivalRate` that takes in a ticket class (e.g., "1st", "2nd") as an argument.
# This function should return a sentence describing the total survival rate of men vs. "women and children" in that ticketing class.
# For example: `"Of Crew class, 87% of women and children survived and 22% of men survived."`
# The approach you take to generating the sentence to return is up to you. A good solution will likely utilize 
# intermediate variables (subsets of data frames) and filtering to produce the required data.
# Avoid using a "loop" in R!
SurvivalRate <- function(class) {
  filter_class <- convert_titanic[convert_titanic$Class==class,]
  filter_male <- filter_class[filter_class$Sex=="Male" & filter_class$Age=="Adult",]
  sum_male <- sum(filter_male$Freq)
  male_survive <- filter_male[filter_male$Survived=="Yes",]
  sum_male_survive <- sum(male_survive$Freq)
  male_rate <- round(sum_male_survive / sum_male * 100, 0)
  
  filter_female <- filter_class[filter_class$Sex=="Female" | filter_class$Age=="Children",]
  sum_female <- sum(filter_female$Freq)
  female_survive <- filter_female[filter_female$Survived=="Yes",]
  sum_female_survive <- sum(female_survive$Freq)
  female_rate <- round(sum_female_survive / sum_female * 100, 0)
  
  output <- paste("Of ", class, " class, ", female_rate, "% of women and children survived and ", 
                  male_rate, "% of men survived.", sep = "")
  return(output)
}

# Call your `SurvivalRate()` function on each of the ticketing classes (`Crew`, `1st`, `2nd`, and `3rd`)
print(SurvivalRate("Crew"))
print(SurvivalRate("1st"))
print(SurvivalRate("2nd"))
print(SurvivalRate("3rd"))

################################### Reading in Data (40 points) ###################################
# In this section, we'll read in a .csv file, which is essentially a tabular row/column layout 
# This is like Microsoft Excel or Google Docs, but without the formatting. 
# The .csv file we'll be working with has the life expectancy for each country in 1960 and 2013. 
# We'll ask real-world questions about the data by writing the code that answers our question. Here are the steps you should walk through:

# Using the `read.csv` function, read the life_expectancy.csv file into a variable called `life_expectancy`
# Makes sure not to read strings as factors
life_expectancy <- read.csv("data/life_expectancy.csv", stringsAsFactors = FALSE)

## Determine if life_expectancy is a data.frame by using the is.data.frame function.
## You may also want to inspect it's content it by View() or by just printing.
life_expectancy_frame <- is.data.frame(life_expectancy)

# Create a column `life_expectancy$change` that is the change in life expectancy from 1960 to 2013
life_expectancy$change <- life_expectancy$le_2013 - life_expectancy$le_1960

# Create a variable `most_improved` that is the name of the country with the largest gain in life expectancy
order_life_expectancy <- life_expectancy[order(-life_expectancy$change),]
most_improved <- order_life_expectancy[1, "country"]

# Create a variable `num_small_gain` that has the number of countries whose life expectance has improved fewer than 5 years between 1960 and 2013
num_small_gain <- sum(life_expectancy$change < 5)

# Write a function `CountryChange` that takes in a country's name as a parameter, and returns it's change in life expectancy from 1960 to 2013
CountryChange <- function(country_name) {
  num <- life_expectancy$change[life_expectancy$country==country_name]
  return(num)
}

# Using your `CountryChange` function, create a variable `sweden_change` that is the change in life expectancy from 1960 to 2013 in Sweden
sweden_change <- CountryChange("Sweden")

# Define a function `LowestLifeExpInRegion` that takes in a **region** as an argument, and returns 
# the **name of the country** with the lowest life expectancy in 2013 (in that region)
LowestLifeExpInRegion <- function(region_name) {
  filter_region <- life_expectancy[life_expectancy$region==region_name,]
  order_filter_region <- filter_region[order(filter_region$le_2013),]
  min_country <- order_filter_region[1, "country"]
  return(min_country)
}

# Using the function you just wrote, create a variable `lowest_in_south_asia` that is the country with the lowest life expectancy in 2013 in South Asia
lowest_in_south_asia <- LowestLifeExpInRegion("South Asia")

# Write a function `BiggerChange` that takes in two country names as parameters, and returns a sentence that 
# describes which country experienced a larger gain in life expectancy (and by how many years). 
# For example, if you passed the values "China", and "Bolivia" into your function, it would return this:
# "The country with the bigger change in life expectancy was China (gain=31.9), whose life expectancy grew by 7.4 years more than Bolivia's (gain=24.5)."
# Make sure to round your numbers.
BiggerChange <- function(country1, country2) {
  filter_country1 <- life_expectancy[life_expectancy$country==country1,]
  filter_country2 <- life_expectancy[life_expectancy$country==country2,]
  country1_gain <- round(filter_country1[1, "change"], 1)
  country2_gain <- round(filter_country2[1, "change"], 1)
  
  if (country1_gain > country2_gain) {
    diff <- country1_gain - country2_gain
    bigger_country <- country1
    bigger_gain <- country1_gain
    smaller_country <- country2
    smaller_gain <- country2_gain
  } else {
    diff <- country2_gain - country1_gain
    bigger_country <- country2
    bigger_gain <- country2_gain
    smaller_country <- country1
    smaller_gain <- country1_gain
  }
  output <- paste("The country with the bigger change in life expectancy was ", bigger_country, 
                  " (gain=", bigger_gain,"), whose life expectancy grew by ", diff, 
                  " years more than ", smaller_country, "'s (gain=", smaller_gain, ").", sep = "")
  return(output)
}

## Using your `BiggerChange` function, create a variable `usa_or_france` that describes who had a larger gain in life expectancy
##  (the United States or France)
usa_or_france <- BiggerChange("United States", "France")
print(usa_or_france)

## Write your `life_expectancy` data.frame to a new .csv file to your data/ directory with the filename `life_expectancy_with_change.csv`.
## Make sure not to write row names.
write.csv(life_expectancy, file = "data/life_expectancy_with_change.csv", row.names = FALSE)

################################### Challenge (10 points) ###################################

## Create a variable that has the name of the region with the 
## highest average change in life expectancy between the two time points.
## Your are welcome to weight the change by population, but just unweighted average over countries is good as well.
## To do this, you'll need to compute the average change across the countries in each region, and then 
## compare the averages across regions. Feel free to use any library of your choice, or base R functions.
library(dplyr)
region_average <- life_expectancy %>% 
  select(region, change) %>% 
  group_by(region) %>% 
  summarize(average = mean(change)) %>% 
  arrange(desc(average))

highest_average_change <- region_average[1, "region"]

# Create a *well labeled* plot (readable title, x-axis, y-axis) showing
# Life expectancy in 1960 v.s. Change in life expectancy
# Programmatically save (i.e., with code, not using the Export button) your graph as a .png file in your repo 
# Then, in a comment below, provide an *interpretation* of the relationship you observe
# Feel free to use any library of your choice, or base R functions.
png(filename = "data/Life_Expectancy_Plot.png")
plot(life_expectancy$le_1960, life_expectancy$change, main = "Life expentancy in 1960 v.s. Change in life expectancy", 
     xlab = "Life expectancy in 1960", ylab = "Change in life expectancy")
dev.off()

# What is your interpretation of the observed relationship?
print("We can interpret that the higher the life expectancy in 1960, the lower the change in life expectancy.") 