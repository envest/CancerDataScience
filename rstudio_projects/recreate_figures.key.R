# Please refer to Farshidfar, F. et al. for plotting inspiration!

# Farshidfar, F. et al. Integrative molecular and clinical profiling of acral 
# melanoma links focal amplification of 22q11.21 to metastasis. 
# Nat. Commun. 13, 898 (2022)
# https://www.nature.com/articles/s41467-022-28566-4

# Grading rubric:
# Show clear effort toward one figure: 80
# Get one figure done: 85
# Get one figure done, and show clear effort toward another figure: 90
# Get two figures done: 95
# Get three figures done: 100

# What does showing clear effort mean?
# 1. You wrote code toward achieving the task (show your work!)
# 2. When you got stuck, you asked for help
# 3. When you got help, you tried again
# Email me: steven.foltz@rutgers.edu

# What does it mean to have a figure done?
# 1. It's a bit subjective.
# 2. When I look at your plot, can I tell what paper figure it corresponds to?
# 3. Making the figure look nice helps, but I'd rather it be accurate.
# 4. Don't worry about the order of samples on the x-axis.
# 5. It will help me tremendously if you put comments in the code to describe
#    what you're working on.

# Figures you can try to tackle:
# 1. Any visual exploration of the clinical data counts as a figure, even if it
#    does not appear in the the paper's Figure 1. But try to push yourself!
# 2. There are at least five things you could do from Figure 1a
#    (any subpanel counts, but show for both acral and sun-exposed)

# Where to find data for figures:
# Figure 1a "No. SNVs/indels (log10)" from "data/supp_data_2a_snvs_indels.tsv"
# Figure 1a "Cohort" from "data/supp_data_1a_clinical.tsv"
# Figure 1a "Age (years)" from "data/supp_data_1a_clinical.tsv"
# Figure 1a "Substitution frequency" from "data/supp_data_3a_acral_maf.tsv" and "data/supp_data_3b_sun_exposed_maf.tsv"
# Figure 1a "Mutational signature frequency" from "data/supp_data_3c_mutational_signatures.tsv"
# Figure 1a "[all the mutations]" (most challenging) from "data/supp_data_3a_acral_maf.tsv" and "data/supp_data_3b_sun_exposed_maf.tsv"

################################################################################
# Start by loading your libraries and reading in the data
################################################################################
library(tidyverse)
clinical <- read_tsv("data/supp_data_1a_clinical.txt")
snvs_indels <- read_tsv("data/supp_data_2a_snvs_indels.txt")
acral_maf <- read_tsv("data/supp_data_3a_acral_maf.txt")
sun_exposed_maf <- read_tsv("data/supp_data_3b_sun_exposed_maf.txt")
mut_sig <- read_tsv("data/supp_data_3c_mutational_signatures.txt")

################################################################################
# Start recreating figures below!
################################################################################

# Use hashtags to start a comment. This will help me navigate through your code.

# Figure 1a "No. SNVs/indels (log10)" from "data/supp_data_2a_snvs_indels.tsv"
medians <- snvs_indels %>%
  group_by(Subtype) %>%
  summarize(med = median(SNV_count_per_sample))

snvs_indels %>%
  ggplot(aes(x = Sample,
             y = SNV_count_per_sample)) +
  geom_col(width = 1) +
  geom_hline(data = medians,
             mapping = aes(yintercept = med),
             lty = 2,
             size = 1,
             color = "gold") +
  geom_text(data = medians,
            mapping = aes(x = Inf, y = Inf,
                          label = str_c("Median = ", med)),
            hjust = 1,
            vjust = 1) +
  facet_wrap(~ Subtype, scales = "free_x") + 
  scale_y_continuous(trans = "log10") +
  labs(x = "Sample", y = "No. SNVs/indels\n(log10)") +
  theme_classic()

# Figure 1a "Cohort" from "data/supp_data_1a_clinical.tsv"
clinical %>%
  ggplot(aes(x = Patient_ID,
             fill = fct_rev(Cohort_center))) +
  geom_bar(width = 1) +
  scale_fill_manual(values = c("#000000", "#C7C7C7")) +
  facet_wrap(~ Subtype, scales = "free_x") +
  labs(fill = "Cohort") +
  theme_classic()

# Figure 1a "Age (years)" from "data/supp_data_1a_clinical.tsv"
clinical %>%
  ggplot(aes(x = Patient_ID,
             fill = `Age_at_diagnosis_(years)`)) +
  geom_bar(width = 1) +
  scale_fill_gradient2(
    low = "#fefefe",
    high = "#407075") +
  facet_wrap(~ Subtype, scales = "free_x") +
  labs(fill = "Age") +
  theme_classic()

# Figure 1a "Substitution frequency" from "data/supp_data_3a_acral_maf.tsv" and "data/supp_data_3b_sun_exposed_maf.tsv"
acral_maf %>%
  mutate(Subtype = "Acral") %>% # add a column for Subtype
  bind_rows(sun_exposed_maf %>% # add a column for Subtype
              mutate(Subtype = "SunExposed")) %>%
  filter(base_substitution %in% c("T>G", "T>A", "T>C", "C>G", "C>A", "C>T")) %>%
  mutate(base_substitution = factor(base_substitution,
                                    levels = c("T>G", "T>A", "T>C", "C>G", "C>A", "C>T"), # these are the levels, and 
                                    ordered = TRUE)) %>% # they must be in this order
  ggplot(aes(x = Tumor_Sample_Barcode,
             fill = base_substitution)) +
  geom_bar(position = "fill", width = 1) +
  scale_fill_manual(values = c("#2e69b2", "#a2509e", "#4eb64a", "#ef3926", "#44bae8", "#f9e445")) +
  facet_wrap(~Subtype, scales = "free_x") +
  theme_classic()

# Figure 1a "Mutational signature frequency" from "data/supp_data_3c_mutational_signatures.tsv"
mut_sig %>%
  pivot_longer(cols = c(-Signature, -Proposed_Etiology),
               names_to = "Patient_ID",
               values_to = "proportion") %>%
  filter(Signature %in% c(1,3,7,10,11,13,15)) %>%
  group_by(Patient_ID) %>%
  mutate(updated_prop = proportion/sum(proportion)) %>%
  left_join(clinical %>%
              select(Patient_ID, Subtype),
            by = "Patient_ID") %>%
  mutate(clean_etiology = case_when(Signature == 1 ~ "Sig. 1 5mC deamination",
                                    Signature == 3 ~ "Sig. 3 BRCA1/BRCA2",
                                    Signature == 7 ~ "Sig. 7 UV light",
                                    Signature == 10 ~ "Sig. 10 POLE",
                                    Signature == 11 ~ "Sig. 11 alkylating agents",
                                    Signature == 13 ~ "Sig. 13 APOBEC",
                                    Signature == 15 ~ "Sig. 15 defective DNA MMR")) %>%
  mutate(clean_etiology = factor(clean_etiology,
                                 levels = c("Sig. 1 5mC deamination",
                                            "Sig. 3 BRCA1/BRCA2",
                                            "Sig. 7 UV light",
                                            "Sig. 10 POLE",
                                            "Sig. 11 alkylating agents",
                                            "Sig. 13 APOBEC",
                                            "Sig. 15 defective DNA MMR"),
                                 ordered = TRUE)) %>%
  ggplot(aes(x = Patient_ID,
             y = updated_prop,
             fill = clean_etiology)) +
  geom_col(position = "stack", width = 1) +
  scale_fill_manual(values = c("#e41d24", "#4aae46", "#317eb4", "#994e9e", "#f1ea3f", "#f4821e", "#a45527")) +
  facet_wrap(~Subtype, scales = "free_x") +
  theme_classic()

# Figure 1a "[all the mutations]" (most challenging) from "data/supp_data_3a_acral_maf.tsv" and "data/supp_data_3b_sun_exposed_maf.tsv"
genes_of_interest <- c("BRAF", "NRAS", "HRAS", "KRAS", "NF1", "CDKN2A", "KIT",
                       "TP53", "ARID2", "PTEN", "IDH1", "RB1", "RAC1", "MAP2K1",
                       "PPP6C", "DDX3X")

acral_maf %>%
  mutate(Subtype = "Acral") %>% # add a column for Subtype
  bind_rows(sun_exposed_maf %>% # add a column for Subtype
              mutate(Subtype = "SunExposed")) %>%
  filter(Hugo_Symbol %in% genes_of_interest) %>%
  mutate(Hugo_Symbol = factor(Hugo_Symbol,
                              levels = genes_of_interest,
                              ordered = TRUE)) %>%
  ggplot(aes(x = Tumor_Sample_Barcode,
             y = fct_rev(Hugo_Symbol),
             fill = Variant_Classification)) +
  geom_tile() +
  facet_wrap(~Subtype, scales = "free_x") +
  theme_classic() # WHAT????? Data does not match figure?????
  


