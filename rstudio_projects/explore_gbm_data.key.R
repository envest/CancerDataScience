# We have some glioblastoma (GBM) data from The Cancer Genome Atlas (TCGA).
# GBM is a type of brain tumor with various subtypes.
# Your goal in this project is to explore different aspects of this data set.

# Here is some background information for reference:
# https://www.cancer.gov/about-nci/organization/ccg/research/structural-genomics/tcga/studied-cancers/glioblastoma
# And the actual publication (see if you can get access through Rutgers Library):
# https://www.cell.com/fulltext/S0092-8674(13)01208-7

# First we need to load up some libraries. I like to use the tidyverse package!
# install.packages("tidyverse") # has already been run
library(tidyverse)

# To read in our data, simply
gbm_df <- read_tsv("gbm_clinical_data.tsv") %>%
  filter(n_mutations < 250) %>% # exclude a few hyper-mutator samples
  rename("GCIMP_methylation" = "G-CIMP_methylation") # clean up this column name

# See what the column names are...
names(gbm_df)

# Take a peek at the structure of the data...
View(gbm_df) # you can leave this tab open while exploring data

# Each patient in TCGA has a unique ID (or barcode) like TCGA-**-****
# See more info here: https://docs.gdc.cancer.gov/Encyclopedia/pages/TCGA_Barcode/

# Let's explore the data a little...
# Use a histogram to show the Age distribution of patients in this data set
ggplot(data = gbm_df) +
  geom_histogram(mapping = aes(x = Age))

# Can we use the fill aesthetic with histogram? What if we copy the histogram 
# code from above and use fill = Sex inside aes()?
# Do you see any difference in Age distribution between FEMALE and MALE?

#ggplot(data = gbm_df) +
gbm_df %>%
  ggplot() +
  geom_histogram(mapping = aes(x = Age, fill = Sex),
                 binwidth = 5, # make the bins 5 years wide
                 boundary = 50) # make the bins go from 50-55, 55-60, etc.

# Is Age related to the number of mutations (n_mutations) observed?
# What is your hypothesis? Use a scatter plot (geom_point) for x and y and
# include different aesthetics (e.g. color, shape) to look at how different 
# genomic features like subtype and Sex may also be related...
ggplot(data = gbm_df) +
  geom_point(mapping = aes(x = Age,
                           y = n_mutations,
                           color = subtype,
                           shape = Sex))

# Let's use a violin plot to show the relationship between a categorical variable
# (on the x-axis) and a continuous variable (on the y-axis). Then add data points
# with geom_jitter(). How are MGMT methylation status and MGMT expression related?
ggplot(data = gbm_df) +
  geom_violin(mapping = aes(x = MGMT_methylation_status,
                            y = MGMT_expression),
              draw_quantiles = 0.5) + # draws a line at the median
  geom_jitter(mapping = aes(x = MGMT_methylation_status, # jitter adds a point for
                            y = MGMT_expression), # each observation
              width = 0.1, # what happens if you redefine width to be 0.5?
              height = 0)

# Does this result make sense?
# How does methylation at a gene impact expression of that gene?
# Answer: Methylation at a gene usually means that gene will have lower expression.
#         So this result makes sense -- the data shows that for samples with methylation
#         at MGMT, the expression of MGMT is lower.

# Keep exploring -- do you see any other patterns emerge from this data?

# If you're done, you're invited to help others!