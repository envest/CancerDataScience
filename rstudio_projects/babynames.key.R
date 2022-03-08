library(tidyverse)
library(babynames)

View(babynames)

# 1. How many entries for female names? Male names?
babynames %>%
  count(sex)

# 2. Filter to list only female names from the 2000s (2000-2009)
babynames %>%
  filter(sex == "F") %>%
  filter(year <= 2009) %>%
  filter(year >= 2000)

babynames %>%
  filter(sex == "F", year <= 2009, year >= 2000)

babynames %>% filter(sex == "F", year %in% 2000:2009)

# 3. What's the most common male name from the 1960s?

babynames %>%
  filter(sex == "M",
         year %in% 1960:1969) %>%
  group_by(name) %>%
  summarize(total = sum(n)) %>%
  arrange(desc(total))

babynames %>%
  filter(sex == "M",
         year %in% 1960:1969) %>%
  group_by(name) %>%
  summarize(mean_prop = mean(prop)) %>%
  arrange(desc(mean_prop))

babynames %>%
  filter(sex == "M", year %in% 1960:1969) %>%
  arrange(desc(prop))

babynames %>%
  filter(sex == "M", year %in% 1960:1969) %>%
  mutate(rank = min_rank(desc(n))) %>%
  filter(rank == 1)
