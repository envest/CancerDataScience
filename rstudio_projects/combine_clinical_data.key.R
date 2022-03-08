# You're working with team to learn more about glioblastoma genomics.
# You need to combine data from several sources and then explore patterns
# in the data before reporting back to lab.

# The following script has a structured approach for you to follow, but key parts
# are missing that you need to fill in... good luck! You learned each of these
# skills in the Work With Data and Tidy Your Data primers assigned on Tuesday.
# If you get stuck, please refer back to those primers, ask me, ask your
# neighbors, ask the internet, etc. You have the resources to figure it out!

# You might notice that we worked with similar data last week. That data set is
# very much like the product we are trying to create by combining multiple 
# sources of data here.

# Anywhere you see # Code here: is where you need to add and run code!
# After you run your code, write a short answer to the question as a comment.

# Description of each data set
# File: data/gbm_clinical.tsv -- contains the patient ID (Sample), Age, Sex,
#   information about MGMT methylation, G-CIMP status, IDH1 mutation status,
#   patient subtype, and the type of sample (tumor)
# File: data/gbm_mutations.tsv -- contains the patient ID (tcga_id) and the
#   number of mutations  

################################################################################
# Let's get started!
################################################################################

# load the tidyverse library
# Code here:
library(tidyverse)

# Read in gbm_clinical.tsv from the data folder and save it as a tibble
# called clinical_df. What file type are you reading in?
# Hints: clinical_df <- read_tsv()
# Code here:
clinical_df <- read_tsv("data/gbm_clinical.tsv")

# Now read in the mutations file save it as mutations_df. The _df at the end of
# the variable name is just a reminder that this is a data frame.
# Code here:
mutations_df <- read_tsv("data/gbm_mutations.tsv")

# Let's explore each of the data sets we just read in to our environment.
# Use head(), names(), View(), dim(), etc. to look at each data set. What data
# types are assigned to each column? For each data set, consider whether or not
# the data is "tidy". What are the observations and what are the variables?
# Code here:
head(clinical_df)
head(mutations_df)

names(clinical_df)
names(mutations_df)

View(clinical_df)
View(mutations_df)

# If the data are tidy, we can combine the two data sets to make one
# large data set. Let's try that. Start by figuring out the common piece of
# information across both data sets. We will use that to join data sets.
# Answer: the common piece of information we can join on is the Sample or tcga_id

# What are the column names of that common piece of information that links each
# data set? Starting with data set with the most rows (check with nrow() or dim()),
# join that data together with the other data sets. Use %>% and left_join()
# join clinical_df and mutations_df together.
# Save the combined data as a new variable called combined_df.
# Code here:
combined_df <- clinical_df %>%
  left_join(mutations_df,
            by = c("Sample" = "tcga_id"))

# Then save the new combined_df as a file. Use this pattern when writing a tsv:
# write_tsv(variable_name, file = "path/to_output_file.tsv"). Save combined_df
# at file "data/gbm_combined.tsv".
# Code here:
write_tsv(combined_df, file = "data/gbm_combined.tsv")

# In the Files panel on the right, look at the size of the newly created file.
# Does the file size make sense, given the size of the other files you just
# combined to create the new file? What might explain the new file size?
# Answer: The gbm_combined.tsv file size is 32.9 KB, just slightly more than the
#         size of the gbm_clinical.tsv file size. This makes sense because most
#         of the combined_df data frame comes from clinical_df, and only one
#         new column gets added from mutations_df.

################################################################################
# Now explore!
################################################################################

# Now that we have our combined_df to work with, we can have some fun!

# Q1: How many males and how many females are there in our data set?
# Do these two number add up to the total number of samples? Why not?
# Hints: data %>% filter() %>% nrow()
# Code here:
combined_df %>%
  count(Sex)

# Q2: What is the median age of males? Median age of females?
# Hints: data %>% group_by() %>% summarize(median_age = median(Age))
# Code here:
combined_df %>%
  group_by(Sex) %>%
  summarize(median_age = median(Age))

# Q3: How many patients are missing data from each variable?
# Hints: names(data); data %>% filter(is.na(variable_name)) %>% nrow()
# Code here:
names(clinical_df)
combined_df %>% filter(is.na(Age)) %>% nrow()
combined_df %>% filter(is.na(Sex)) %>% nrow()
combined_df %>% filter(is.na(MGMT_methylation)) %>% nrow()
combined_df %>% filter(is.na(GCIMP)) %>% nrow()
combined_df %>% filter(is.na(IDH1_mutation)) %>% nrow()
combined_df %>% filter(is.na(Subtype)) %>% nrow()
combined_df %>% filter(is.na(n_mutations)) %>% nrow()

# Q4: What do you notice about the relationship between GCIMP and IDH1_mutation?
# Hints: data %>% select(variable1, variable2) %>% table()
# Code here:
clinical_df %>%
  select(GCIMP, IDH1_mutation) %>%
  table()

# Q5: While most patients are wild type (WT), there are three different
# mutations shown for IDH1_mutation. Create a new column called IDH1_mutant that
# indicates either TRUE or FALSE for if IDH1 was mutated or is wild type.
# The data set with the new column should be saved as modified_df.
# Hints: new_variable <- data %>% mutate()
# Code here:
modified_df <- clinical_df %>%
  mutate(IDH1_mutant = IDH1_mutation != "WT")

modified_df %>%
  select(GCIMP, IDH1_mutant) %>%
  table()

# Q6: What's the median number of mutations for each subgroup? You may need to
# filter out NA values from n_mutations, or use an option inside median() to
# remove NAs. Hints: data %>% filter() %>% group_by() %>% summarize()
# Code here:
combined_df %>%
  filter(!is.na(n_mutations)) %>%
  group_by(Subtype) %>%
  summarize(median_n_mutations = median(n_mutations))

combined_df %>%
  group_by(Subtype) %>%
  summarize(median_n_mutations = median(n_mutations, na.rm = TRUE))

# Q7: Calculate the median number of mutations for each subgroup, but this time
# separate out results for younger patients (< 50 years old) vs. older patients.
# Start by removing any patients with missing Age values. What trend do you
# notice between young and old patients within each subtype?
# Hints: data %>% filter() %>% mutate() %>% group_by() %>% summarize()
# Code here:
combined_df %>%
  filter(!is.na(Age), !is.na(n_mutations)) %>%
  mutate(young = Age < 50) %>%
  group_by(Subtype, young) %>%
  summarize(median_n_mutations = median(n_mutations))

# Q8: Keep exploring -- when you finish, dive into any remaining questions you
# want to explore. Write out your question, hypothesis, code, and summarize your
# results here. I will ask for class participation volunteers to share their
# findings in the next class!
# Code here:
combined_df %>%
  group_by(Subtype) %>%
  summarize(median_age = median(Age, na.rm = TRUE)) %>%
  arrange(desc(median_age))
