# a4-data-wrangling

################################### Set up ###################################

# Install (if not installed) + load dplyr package 
library(dplyr)

# Set your working directory to the appropriate project folder
setwd("~/Desktop/INFO 201/Assignments/a4-dplyr-rioishii")

# Read in `any_drinking.csv` data using a relative path
any_drinking <- read.csv("data/any_drinking.csv")

# Read in `binge.drinking.csv` data using a relative path
binge_drinking <- read.csv("data/binge_drinking.csv")

# Create a directory (using R) called "output" in your project directory
# Make sure to suppress any warnings, in case the directory already exists
dir.create("output")

################################### Any drinking in 2012 ###################################

# For this first section, you will work only with the *any drinking* dataset.
# In particular, we'll focus on data from 2012, keeping track of the `state` and `location` variables

# Create a data.frame that has the `state` and `location` columns, and all columns with data from 2012
data_2012 <- select(any_drinking, state, location, both_sexes_2012, females_2012, males_2012)

# Using the 2012 data, create a column that has the difference in male and female drinking patterns
data_2012 <- mutate(data_2012, diff_2012 = males_2012 - females_2012)

# Write your 2012 data to a .csv file in your `output/` directory with an expressive filename
# Make sure to exclude rownames
write.csv(data_2012, file = "data/data_2012_with_diff.csv", row.names = FALSE)

# Are there any locations where females drink more than males?
## Your answer should be a *dataframe* of the locations, states, and differences for all locations (no extra
## columns)
females_drink_more_than_males_2012 <- filter(data_2012, diff_2012 < 0)

## What is the location in which male and female drinking rates are most similar (*absolute* difference is
## smallest)?
## Your answer should be a *dataframe* of the location, state, and value of interest (no extra
## columns)
most_similar_2012 <- data_2012 %>% 
  filter(diff_2012 == min(diff_2012)) %>% 
  select(location)

## As you've (hopefully) noticed, the `location` column includes national, state, and county level
## estimates.
## However, many audiences may only be interested in the *state* level data. Given that, you
## should do the following:
# Create a new variable that is only the state level observations in 2012
# For the sake of this analysis, you should treat Washington D.C. as a *state*
state_level_2012 <- filter(data_2012, location %in% c(state.name)) 

# Which state had the **highest** drinking rate for both sexes combined? 
# Your answer should be a *dataframe* of the state and value of interest (no extra columns)
highest_drinking_state_2012 <- state_level_2012 %>% 
  filter(both_sexes_2012 == max(both_sexes_2012)) %>% 
  select(state)

# Which state had the **lowest** drinking rate for both sexes combined?
# Your answer should be a *dataframe* of the state and value of interest (no extra columns)
lowest_drinking_state_2012 <- state_level_2012 %>% 
  filter(both_sexes_2012 == min(both_sexes_2012)) %>% 
  select(state)

## What was the difference in (any-drinking) prevalence between the state with the highest level of
## consumption,
# and the state with the lowest level of consumption?
# Your answer should be a single value (a dataframe storing one value is fine)
highest_drinking_rate_2012 <- state_level_2012 %>% 
  filter(both_sexes_2012 == max(both_sexes_2012))

lowest_drinking_rate_2012 <- state_level_2012 %>% 
  filter(both_sexes_2012 == min(both_sexes_2012))

diff_drinking_rate_2012 <- highest_drinking_rate_2012[1, "both_sexes_2012"] - lowest_drinking_rate_2012[1, "both_sexes_2012"]

# Write your 2012 state data to an appropriately named file in your `output/` directory
# Make sure to exclude rownames
write.csv(state_level_2012, file = "data/state_level_2012.csv", row.names = FALSE)

## Write a function that allows you to specify a state, then saves a .csv file with only observations from
## that state
# This includes data about the state itself, as well as the counties within the state
# You should use the entire any.drinking dataset for this function
# The file you save in the `output` directory indicates the state name
# Make sure to exclude rownames
state_data <- function(state_name) {
  state_filter_data <- data_2012 %>% 
    filter(state %in% c(state_name))
  filename <- paste0("data/", state_name, ".csv")
  write.csv(state_filter_data, file = filename, row.names = FALSE)
}

# Demonstrate your function works by passing 3 states of your choice to the function
washington_data <- state_data("Washington")
oregon_data <- state_data("Oregon")
california_data <- state_data("California")

################################### Binge drinking Dataset ###################################
# In this section, we'll ask a variety of questions regarding our binge.drinking dataset
# Moreover, we'll be looking at a subset of the observations which is just the counties 
# (i.e., exclude state/national estimates)
# In order to ask these questions, you'll need to first prepare a subset of the data for this section:

# Create a dataframe with only the county level observations from the binge_drinking dataset 
# You should (again) think of Washington D.C. as a state, and therefore *exclude it here*
# This does include "county-like" areas such as parishes and boroughs
county_level <- filter(binge_drinking, !location %in% c(state.name) & !location %in% c("United States")) 

# What is the average level of binge drinking in 2012 for both sexes (across the counties)?
average_binge_2012 <- county_level %>% 
  summarize(mean = mean(both_sexes_2012))

# What is the *minimum* level of binge drinking in each state in 2012 for both sexes (across the counties)? 
## Your answer should contain roughly 50 values (one for each state), unless there are two counties in a
## state with the same value
# Your answer should be a *dataframe* with the 2012 binge drinking rate, location, and state
min_level <- county_level %>% 
  select(state, location, both_sexes_2012) %>% 
  group_by(state) %>% 
  filter(both_sexes_2012 == min(both_sexes_2012))

# What is the *maximum* level of binge drinking in each state in 2012 for both sexes (across the counties)? 
# Your answer should be a *dataframe* with the value of interest, location, and state
max_level <- county_level %>% 
  select(state, location, both_sexes_2012) %>% 
  group_by(state) %>% 
  filter(both_sexes_2012 == max(both_sexes_2012))

# What is the county with the largest increase in male binge drinking between 2002 and 2012?
# Your answer should include the county, state, and value of interest
diff_male_2002_2012 <- county_level$males_2012 - county_level$males_2002 
largest_increase_county <- county_level %>% 
  select(state, location) %>% 
  mutate(diff_male_2002_2012) %>% 
  filter(diff_male_2002_2012 == max(diff_male_2002_2012))

# How many counties experienced an increase in male binge drinking between 2002 and 2012?
# Your answer should be an integer (a dataframe with only one value is fine)
increased_male_binge_county <- county_level %>% 
  mutate(diff_male_2002_2012) %>% 
  filter(diff_male_2002_2012 > 0) %>% 
  nrow()

# What percentage of counties experienced an increase in male binge drinking between 2002 and 2012?
# Your answer should be a fraction or percent (we're not picky)
increased_male_rate <- round(increased_male_binge_county / nrow(county_level), 2)

# How many counties observed an increase in female binge drinking in this time period?
# Your answer should be an integer (a dataframe with only one value is fine)
diff_female_2002_2012 <- county_level$females_2012 - county_level$females_2002
increased_female_binge_county <- county_level %>% 
  mutate(diff_female_2002_2012) %>% 
  filter(diff_female_2002_2012 > 0) %>% 
  nrow()

# What percentage of counties experienced an increase in female binge drinking between 2002 and 2012?
# Your answer should be a fraction or percent (we're not picky)
increased_female_rate <- round(increased_female_binge_county / nrow(county_level), 2)

# How many counties experienced a rise in female binge drinking *and* a decline in male binge drinking?
# Your answer should be an integer (a dataframe with only one value is fine)
increase_female_decrease_male <- county_level %>% 
  mutate(diff_male_2002_2012, diff_female_2002_2012) %>% 
  filter(diff_female_2002_2012 > 0 & diff_male_2002_2012 < 0) %>% 
  nrow()


################################### Joining Data ###################################
## You'll often have to join different datasets together in order to ask more involved questions of your
## dataset.
# In order to join our datasets together, you'll have to rename their columns to differentiate them

# First, rename all prevalence columns in the any.drinking dataset to the have prefix "any."
## Hint: you can get (and set!) column names using the colnames function. This may take multiple lines of
## code.
colnames(any_drinking)[3:ncol(any_drinking)] <- paste0("any.", colnames(any_drinking[,c(3:ncol(any_drinking))]))

# Then, rename all prevalence columns in the binge.drinking dataset to the have prefix "binge."
## Hint: you can get (and set!) column names using the colnames function. This may take multiple lines of
## code.
colnames(binge_drinking)[3:ncol(binge_drinking)] <- paste0("binge.", colnames(binge_drinking[,c(3:ncol(binge_drinking))]))

# Then, create a dataframe with all of the columns from both datasets. 
# Think carefully about the *type* of join you want to do, and what the *identifying columns* are
merged_any_binge <- left_join(any_drinking, binge_drinking, by = c("location", "state"))

# Create a column of difference between `any` and `binge` drinking for both sexes in 2012
merged_any_binge <- mutate(merged_any_binge, diff_any_binge_2012 = any.both_sexes_2012 - binge.both_sexes_2012)

# Which location has the greatest *absolute* difference between `any` and `binge` drinking?
# Your answer should be a one row data frame with the state, location, and value of interest (difference)
greatest_diff_any_binge_2012 <- merged_any_binge %>% 
  select(state, location, diff_any_binge_2012) %>% 
  filter(diff_any_binge_2012 == max(abs(diff_any_binge_2012)))

# Which location has the smallest *absolute* difference between `any` and `binge` drinking?
# Your answer should be a one row data frame with the state, location, and value of interest (difference)
lowest_diff_any_binge_2012 <- merged_any_binge %>% 
  select(state, location, diff_any_binge_2012) %>% 
  filter(diff_any_binge_2012 == min(abs(diff_any_binge_2012)))

################################### Write a function to ask your own question(s) ###################################
## Even in an entry level data analyst role, people are expected to come up with their own questions of
## interest
# (not just answer the questions that other people have). For this section, you should *write a function*
# that allows you to ask the same question on different subsets of data. 
# For example, you may want to ask about the highest/lowest drinking level given a state or year. 
# The purpose of your function should be evident given the input parameters and function name. 
## After writing your function, *demonstrate* that the function works by passing in different parameters to
## your function.
county_level_binge <- filter(binge_drinking, !location %in% state.name & !location %in% c("United States"))
highest_binge_state <- function(state_name, year) {
  both_sexes_year <- paste0("binge.both_sexes_", year)
  max_row <- county_level_binge %>% 
    filter(state %in% state_name) %>% 
    select(contains(year)) %>% 
    arrange_(paste("desc(", both_sexes_year, ")"))
  max_rate <- max_row[1, both_sexes_year]
  paste("In ", year, ", the highest drinking rate in ", state_name, " is ", max_rate, sep = "")
}

florida_highest <- highest_binge_state("Florida", "2010")
print(florida_highest)
colorado_highest <- highest_binge_state("Colorado", "2007")
print(colorado_highest)

################################### Challenge ###################################

# Using your function from part 1 (that wrote a .csv file given a state name), write a separate file 
# for each of the 51 states (including Washington D.C.)
# The challenge is to do this in a *single line of (concise) code*
all_state_data <- lapply(state.name, state_data)

## Using a dataframe of your choice from above, write a function that allows you to specify a *year* and
## *state* of interest,
# that saves a .csv file with observations from that state's counties (and the state itself) 
# It should only write the columns `state`, `location`, and data from the specified year. 
# Before writing the .csv file, you should *sort* the data.frame in descending order
# by the both_sexes drinking rate in the specified year. 
# Again, make sure the file you save in the output directory indicates the year and state. 
# Note, this will force you to confront how dplyr uses *non-standard evaluation*
# Hint: https://cran.r-project.org/web/packages/dplyr/vignettes/nse.html
# Make sure to exclude rownames
both_sexes_rate_data <- function(state_name, year) {
  both_sexes_year <- paste0("desc(any.both_sexes_", year, ")")
  state_filter_data <- any_drinking %>% 
    filter(state %in% state_name) %>% 
    select(state, location, contains(year)) %>% 
    arrange_(both_sexes_year)
  filename <- paste0("data/", year, "_", state_name, ".csv")
  write.csv(state_filter_data, file = filename, row.names = FALSE)
}

# Demonstrate that your function works by passing a year and state of your interest to the function
Texas_2004 <- both_sexes_rate_data("Texas", "2004")