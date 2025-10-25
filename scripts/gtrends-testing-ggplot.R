library(ggplot2)
library(hablar)
library(ggthemes)
library(readxl)
library(lubridate)
library(dplyr)



trends <- read.csv(r"(Z:\GitHub\thesis-sandbox-r\data\gtrends-download.csv)", header = TRUE, sep = ",")

postal_trends <- subset(trends, keyword == "/m/04n7qg")
postal_trends_convert <- convert(postal_trends, dte(date))
postal_trends_convert$hits[postal_trends_convert$hits == "<1"] <- 0.5
postal_trends_final <- convert(postal_trends_convert, int(hits))

trends_convert <- convert(trends, dte(date))
trends_convert$hits[trends_convert$hits == "<1"] <- 0.5
trends_final <- convert(trends_convert, int(hits))

trends_country <- read.csv(r"(Z:\GitHub\thesis-sandbox-r\data\gtrends-download-country.csv)", header = TRUE, sep = ",")

postal_trends_country <- subset(trends_country, keyword == "/m/04n7qg")
postal_trends_convert_country <- convert(postal_trends_country, dte(date))
postal_trends_convert_country$hits[postal_trends_convert_country$hits == "<1"] <- 0.5
postal_trends_final_country <- convert(postal_trends_convert_country, int(hits))

#ggplot(data = postal_trends, aes(x = date, y = hits))
#qplot(x = date, y = hits, data = postal_trends)
#ggplot(postal_trends_final) + geom_line(mapping = aes(x = date, y = hits))
#ggplot(trends_final) + geom_line(mapping = aes(x = date, y = hits, color = keyword))
ggplot() +
  geom_line(data = postal_trends_final_country, mapping = aes(x = date, y = hits, color = geo)) +
  #geom_line(data = postal_trends_final, mapping = aes(x = date, y = hits)) +
  labs(x = "Year", y = "Relative search interest") +
  ggtitle("Postal Voting Search Interest in Google Trends by Country") +
  scale_color_discrete(labels = c("Australia", "Canada", "Switzerland", "United States")) +
  theme(legend.title = element_blank(), legend.position = c(.085, .85), legend.background = element_rect(fill = "transparent"),
        panel.grid.minor = element_blank())
  #theme_economist() +
  #scale_color_economist(name = NULL)
ggplot() +
  geom_line(data = postal_trends_final_country, mapping = aes(x = date, y = hits)) +
  facet_wrap(~ geo)



trends_countries <- read.csv(r"(Z:\GitHub\thesis-sandbox-r\data\gtrends-download-countries.csv)", header = TRUE, sep = ",")
postal_countries <- subset(trends_countries, keyword == "/m/04n7qg")
postal_convert_countries <- convert(postal_countries, dte(date))
postal_convert_countries$hits[postal_convert_countries$hits == "<1"] <- 0.5
postal_countries_final <- convert(postal_convert_countries, int(hits))

turnout_countries <- read_excel(r"(Z:\GitHub\thesis-sandbox-r\data\idea_turnout_export.xls)", skip = 1)
turnout_countries$Date <- ymd(turnout_countries$Date)
turnout_countries <- turnout_countries %>% rename(date = Date, geo = ISO2)

ggplot() +
  geom_line(data = postal_countries_final, mapping = aes(x = date, y = hits, color = geo)) +
  geom_line(data = turnout_countries, mapping = aes(x = date, y = `Parliamentary>VAP Turnout`)) +
  theme(legend.position = "none") +
  facet_wrap(~ geo, labeller = as_labeller(c(AU = "Australia", CA = "Canada", CH = "Switzerland", US = "United States"))) +
  labs(x = "Year", y = "Proportional search interest", title = "Postal Voting Interest by Country",
       subtitle = "Google Trends search interest for Postal voting topic normalized within countries from 2004 to 2025")

#turnout_and_postal_countries <- postal_countries_final %>%
#  mutate(Date2 = turnout_countries$Date, VAP = turnout_countries$`Parliamentary>VAP Turnout`)
#turnout_and_postal_countries <- cbind(postal_countries_final, turnout_countries)
turnout_and_postal_countries <- merge(x = postal_countries_final, y = turnout_countries, by = c("date","geo"), all = TRUE) %>%
  rename(VAP = `Parliamentary>VAP Turnout`)

ggplot(turnout_and_postal_countries) +
  geom_line(mapping = aes(x = date, y = hits, color = geo)) +
  geom_line(mapping = aes(x = date, y = VAP)) +
  theme(legend.position = "none") +
  facet_wrap(~ geo, labeller = as_labeller(c(AU = "Australia", CA = "Canada", CH = "Switzerland", US = "United States"))) 
  #labs(x = "Year", y = "Proportional search interest", title = "Postal Voting Interest by Country",
  #     subtitle = "Google Trends search interest for Postal voting topic normalized within countries from 2004 to 2025")