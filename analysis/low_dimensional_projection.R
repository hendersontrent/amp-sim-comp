#----------------------------------------
# This script sets out to produce a low
# dimensional projection visualisation
# of the time series x feature data
# matrix
#
# NOTE: This script requires setup.R and
# analysis/catch22.R to have been run first
#----------------------------------------

#----------------------------------------
# Author: Trent Henderson, 24 August 2021
#----------------------------------------

# Load feature matrix

load("data/features/featMat_catch22.Rda")

#------------- Preprocessing ---------------

# Fix names and adjust meta-groupings for colours on the plot

featMat_catch22_clean <- featMat_catch22 %>%
  mutate(id = case_when(
          id == "STL_Tonality 1_6L6"  ~ "STL Tonality 1_6L6",
          id == "STL_Tonality 1_KT88" ~ "STL Tonality 1_KT88",
          id == "STL_Tonality 2_6L6"  ~ "STL Tonality 2_6L6",
          id == "STL_Tonality 2_KT88" ~ "STL Tonality 2_KT88",
          id == "STL_Tonality 3_6L6"  ~ "STL Tonality 3_6L6",
          id == "STL_Tonality 3_KT88" ~ "STL Tonality 3_KT88",
          id == "STL_Tonality 4_6L6"  ~ "STL Tonality 4_6L6",
          id == "STL_Tonality 4_KT77" ~ "STL Tonality 4_KT77",
          id == "STL_Tonality 4_KT88" ~ "STL Tonality 4_KT88",
          TRUE                        ~ id)) %>%
  mutate(amplifier = gsub("_.*", "\\1", id)) %>%
  mutate(amplifier = ifelse(grepl("Neural", amplifier), gsub('[[:digit:]]+', '', amplifier), amplifier))

#------------- Produce graphics ------------

source("R/plot_low_dimension2.R") # As original {theft function only has 8 colours and we want slight different aesthetics}

p <- plot_low_dimension2(featMat_catch22_clean,
                         is_normalised = FALSE,
                         id_var = "id",
                         group_var = "amplifier",
                         low_dim_method = "PCA",
                         method = "z-score",
                         plot = TRUE,
                         show_covariance = FALSE,
                         seed = 123)

print(p)

# Save plot

ggsave("output/catch22-low-dim.png", p, units = "in", width = 10, height = 10)
ggsave("report/catch22-low-dim.pdf", p, units = "in", width = 10, height = 10)
