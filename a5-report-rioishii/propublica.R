source('keys.R')
library(ggplot2)

propublica <- function(state) {
  ghBase <- "https://api.propublica.org/congress/"
  resource <- paste0("v1/members/house/", state, "/current.json") 
  uri <- paste0(ghBase, resource)
  response <- GET(uri, add_headers("X-API-Key" = propublica_key))
  body <- content(response, "text")
  result <- fromJSON(body)
  representatives <- as.data.frame(flatten(result$results))
  filter_male <- representatives %>% filter(gender == 'M') %>% nrow()
  filter_female <- representatives %>% filter(gender == 'F') %>% nrow()
  filter_Republican <- representatives %>% filter(party == 'R') %>% nrow()
  filter_Democrat <- representatives %>% filter(party == 'D') %>% nrow()
  rep_id <- representatives$id[5]
  info <- list(males=filter_male, females=filter_female, republican=filter_Republican, democrat=filter_Democrat, rep_id=rep_id)
  return(info)
}

state_representatives <- propublica("WA")

df_gender <- data.frame(gender = c("Male", "Female"), 
                        count = c(state_representatives[[1]][[1]], state_representatives[[2]][[1]]))
gender_graph <- ggplot(data = df_gender, aes(x=gender, y=count)) + geom_bar(stat = "identity") + 
  coord_flip() + xlab("gender") + ylab("# of Representatives")

df_party <- data.frame(party = c("Republican", "Democrat"), 
                       count = c(state_representatives[[3]][[1]], state_representatives[[4]][[1]]))
party_graph <- ggplot(df_party, aes(x=party, y=count, fill = c("blue", "red"))) + geom_bar(stat = "identity") + 
  coord_flip() + xlab("party") + ylab("# of Representatives") + guides(fill=FALSE)

id = getElement(state_representatives, "rep_id")

rep_facts <- function(id) {
  ghBase <- "https://api.propublica.org/congress/"
  resource <- paste0("v1/members/", id, ".json") 
  uri <- paste0(ghBase, resource)
  response <- GET(uri, add_headers("X-API-Key" = propublica_key))
  body <- content(response, "text")
  result <- fromJSON(body)
  flatten_result <- flatten(result$results)
  name <- paste0(flatten_result$first_name, " ", flatten_result$last_name)
  party <- flatten_result$current_party
  if (party == 'D') {
    party = "Democrat"
  } else {
    party = "Republican"
  }
  twitter_id <- flatten_result$twitter_account
  twitter_link <- paste0("https://twitter.com/", flatten_result$twitter_account)
  age <- as.integer((as.Date(Sys.Date()) - as.Date(flatten_result$date_of_birth)) / 365.25)
  info <- list(name=name, twitter_id=twitter_id, twitter_link=twitter_link, age=age, party=party)
  return(info)
}

rep_votes <- function(id) {
  ghBase <- "https://api.propublica.org/congress/"
  resource <- paste0("v1/members/", id, "/votes.json") 
  uri <- paste0(ghBase, resource)
  response <- GET(uri, add_headers("X-API-Key" = propublica_key))
  body <- content(response, "text")
  result <- fromJSON(body)
  flatten_result <- flatten(result$results)
  votes <- flatten_result$votes
  return(votes)
}

random_rep_votes <- rep_votes(id)
random_rep_facts <- rep_facts(id)

data_frame_votes <- as.data.frame(random_rep_votes) 
filter_votes <- select(data_frame_votes, result, position)
filter_pass <- filter_votes %>% filter(result=='Passed' & position=='Yes') %>% nrow()
filter_fail <- filter_votes %>% filter(result=='Failed' & position=='No') %>% nrow()
sum <- filter_pass + filter_fail
percent <- as.integer(filter_pass / sum * 100)