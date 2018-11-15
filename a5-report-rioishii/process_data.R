library(dplyr)
library(httr)
library(jsonlite)
library(ggplot2)
source('keys.R')

address <- "Seattle, WA"

google_civic <- function(location) {
  ghBase <- "https://www.googleapis.com/civicinfo/"
  resource <- "v2/representatives?"
  uri <- paste0(ghBase, resource)
  response <-GET(uri, query=list(key=google_key, address=location))
  body <- content(response, "text")
  result <- fromJSON(body)
  officials <- as.data.frame(flatten(result$officials))
  offices <- as.data.frame(flatten(result$offices))
  
  num_to_rep <- unlist(lapply(result$offices$officialIndices, length))
  expanded <- offices[rep(row.names(offices), num_to_rep), ]
  officials <- officials %>% mutate(index = row_number() - 1)
  expanded <- expanded %>% mutate(index = row_number() - 1) %>% rename(position = name)
  
  join_data <- full_join(officials, expanded, by = "index")
  join_data <- join_data %>% replace(.=='NULL', '-')
  new_data <- select(join_data, name, position, party, emails, urls, phones, photoUrl)
  new_data$photoUrl <- paste0("![Alt](", new_data$photoUrl, ")") 
  new_data <- new_data %>% replace(.=='![Alt](NA)', "-")
  new_data$name <- paste0("[",new_data$name, "](", new_data$urls, ")")
  new_data <- select(new_data, name, position, party, emails, phones, photoUrl)
  
  return(new_data)
}

google <- google_civic(address)

colnames(google)[1] <- "Name"
colnames(google)[2] <- "Position"
colnames(google)[3] <- "Party"
colnames(google)[4] <- "Email"
colnames(google)[5] <- "Phone"
colnames(google)[6] <- "Photo"