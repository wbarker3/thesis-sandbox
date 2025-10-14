library(tidyverse)
library(gtrendsR)
library(ggplot2)

search_topic <- "/m/04n7qg" # Postal voting
search_regions <- "" # worldwide
search_time <- "all" # from 2004 to present

trends_results <- gtrends(search_topic, search_regions, search_time)

plot(trends_results)

subset_test <- subset(trends_results$interest_by_country)
print(subset_test)
