require(tidyverse)

unique.data <- read_csv("unique.csv")

dogs.by.year <- unique.data %>%
  group_by(birth_year) %>%
  summarise(count=n())

dogs.by.year.name <- unique.data %>%
  group_by(birth_year, name) %>%
  summarise(name_count=n(), .groups = "drop")

joined.count <- dogs.by.year %>% 
  right_join(dogs.by.year.name, by=c("birth_year")) %>%
  mutate(rate=name_count/count)

df.1999 <- joined.count[joined.count$birth_year==1999,]
max.rate.1999 <- df.1999$name[df.1999$rate==max(df.1999$rate)]
cat("The most popular dog names in 1999 are/is:", 
    paste(max.rate.1999, collapse = ", "))

df.2023 <- joined.count[joined.count$birth_year==2023,]
max.rate.2023 <- df.2023$name[df.2023$rate==max(df.2023$rate)]
cat("The most popular dog names in 2023 are/is:", 
    paste(max.rate.2023, collapse = ", "))

joined.count %>% 
  filter(name %in% c(max.rate.1999, max.rate.2023)) %>%
  ggplot(aes(x=birth_year, y=rate)) +
  facet_wrap(~name) +
  geom_bar(stat="identity") + 
  labs(x="Birth year", y="Rate")
ggsave("max_name.pdf")