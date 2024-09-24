require(tidyverse)

deduplicated <- read_csv("deduplicated.csv")

ggplot(deduplicated, aes(birth_year)) + geom_histogram(stat="count") +
  labs(x="Birth year", y="Dog count", title="All year dog count")
ggsave("dog_count_all.pdf")

nontrivial.years <- deduplicated %>% 
  group_by(birth_year) %>%
  summarise(count=n()) %>%
  filter(count > 20)
deduplicated %>% 
  filter(birth_year %in% nontrivial.years$birth_year) %>%
  ggplot(aes(birth_year)) + geom_histogram(stat="count") + 
  labs(x="Birth year", y="Dog count", title="Nontrivial year dog count")
ggsave("dog_count_nontrivial.pdf")