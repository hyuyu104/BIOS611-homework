require(tidyverse)

deduplicated <- read_csv("deduplicated.csv")

sprintf("%d rows before filtered by name, gender, birth year, breed, and zip code",
        nrow(deduplicated))
unique.data <- deduplicated %>%
  distinct(name, gender, birth_year, breed, zipcode)
sprintf("%d rows after filtered by name, gender, birth year, breed, and zip code",
        nrow(unique.data))
write_csv(unique.data, "unique.csv")