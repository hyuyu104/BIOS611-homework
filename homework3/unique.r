require(tidyverse)

distinct.data <- read_csv("distinct_data.csv")

sprintf("%d rows before filtered by name, gender, birth year, breed, and zip code",
        nrow(distinct.data))
unique.data <- distinct.data %>%
  distinct(name, gender, birth_year, breed, zipcode)
sprintf("%d rows after filtered by name, gender, birth year, breed, and zip code",
        nrow(unique.data))
write_csv(unique.data, "unique.csv")