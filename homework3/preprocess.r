require(tidyverse)

# read in data and print problem
raw.data <- read_csv("NYC_Dog_Licensing_Dataset_20240918.csv", show_col_types = F)
pr <- problems(raw.data)
print(pr)

# rename the columns
data <- raw.data %>% 
  rename(
    name=AnimalName,
    gender=AnimalGender,
    birth_year=AnimalBirthYear, 
    breed=BreedName, 
    zipcode=ZipCode, 
    issue_date=LicenseIssuedDate, 
    expiration_date=LicenseExpiredDate,
    extract_year=`Extract Year`
)

# reduce to complete case
sprintf("%d rows before filtering complete cases", nrow(data))
data <- data %>% filter(complete.cases(.))
sprintf("%d rows after filtering complete cases", nrow(data))



distinct.data <- data %>% distinct()
write_csv(distinct.data, "distinct_data.csv")
sprintf("%d distinct rows", nrow(distinct.data))
# extract duplicated rows
duplicated <- data %>% group_by_all() %>% filter(n() > 1) %>% distinct()
print(duplicated)
name.count <- duplicated %>%
  group_by(name) %>%
  summarise(n=n())
print(name.count[1:5,])
print(arrange(name.count, desc(n))[1:5,])