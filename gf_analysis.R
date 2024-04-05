# Read data

gf_data <- read.csv("gf_data.csv")

# Define country groupings

hbhi_countries <- c("Burkina Faso", "Cameroon", "Congo (Democratic Republic)", "Ghana", 
                    "Mali", "Mozambique", "Niger", "Nigeria", "Uganda", 
                    "Tanzania (United Republic)", "Zanzibar")

other_africa_countries <- c(
  "Africa", "Algeria", "Angola", "Benin", "Botswana", "Burundi", "Cabo Verde", 
  "Central African Republic", "Chad", "Congo", "Comoros", "Djibouti", "Egypt", 
  "Equatorial Guinea", "Eritrea", "Eswatini", "Ethiopia", "Gabon", 
  "Gambia", "Guinea", "Guinea-Bissau", "Côte d'Ivoire", "Kenya", 
  "Lesotho", "Liberia", "Libya", "Madagascar", "Malawi", "Mauritania", 
  "Mauritius", "Morocco", "Namibia", "Rwanda", "Sao Tome and Principe", 
  "Senegal", "Seychelles", "Sierra Leone", "Somalia", "South Africa", 
  "South Sudan", "Sudan", "Togo", "Tunisia", "Zambia", "Zimbabwe"
)

# Categorize rows

library(dplyr)

categorized_data <- gf_data %>%
  mutate(Group = case_when(
    GeographicAreaName %in% hbhi_countries ~ "HBHI",
    GeographicAreaName %in% other_africa_countries ~ "Other Africa",
    TRUE ~ "Rest of World"
  ))

# Filter and summarize data
summarized_data <- categorized_data %>%
  filter(ComponentName == "Malaria", ActivityAreaName == "Vector control") %>%
  group_by(Group, GrantCycleCoveragePeriod) %>%
  summarize(TotalBudget = sum(BudgetAmount, na.rm = TRUE))

# Pivot data

library(tidyr)

wide_data <- summarized_data %>%
  pivot_wider(names_from = GrantCycleCoveragePeriod, values_from = TotalBudget)