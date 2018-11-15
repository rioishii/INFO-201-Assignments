library(dplyr)
df <- read.csv("data/UFOCoords.csv")

info_function <- function(dataset) {
  ret <- list()
  ret$length <- nrow(dataset)
  ret$time_day <- tail(names(sort(table(dataset$AM.PM))), 1)
  time.of.day <- select(dataset, Time, AM.PM) %>% filter(AM.PM == ret$time_day)
  ret$common_time <- tail(names(sort(table(time.of.day$Time))), 1)
  ret$most_occurances <- tail(names(sort(table(dataset$State))), 1)
  ret$common_shape <- tail(names(sort(table(dataset$Shape))), 1)
  return (ret)
}

summary <- info_function(df)
