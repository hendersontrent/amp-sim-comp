#----------------------------------------
# This script sets out to produce a low
# dimensional projection visualisation
# of the time series x feature data
# matrix
#
# NOTE: This script requires setup.R and
# analysis/catch22.R to have been run
# first
#----------------------------------------

#----------------------------------------
# Author: Trent Henderson, 24 August 2021
#----------------------------------------

# Load feature matrix

load("data/features/feat_mat.Rda")

#------------- Preprocessing ---------------

# Fix names and adjust meta-groupings for colours on the plot

feat_mat_clean <- feat_mat %>%
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

# PCA

p <- plot_low_dimension2(feat_mat_clean,
                         is_normalised = FALSE,
                         id_var = "id",
                         group_var = "amplifier",
                         low_dim_method = "PCA",
                         method = "z-score",
                         plot = TRUE,
                         show_covariance = FALSE,
                         seed = 123)

print(p)

# t-SNE

p1 <- plot_low_dimension2(feat_mat_clean,
                          is_normalised = FALSE,
                          id_var = "id",
                          group_var = "amplifier",
                          low_dim_method = "t-SNE",
                          method = "z-score",
                          perplexity = 5,
                          plot = TRUE,
                          show_covariance = FALSE,
                          seed = 123)

print(p1)

# Save plots

ggsave("output/catch22-low-dim.png", p, units = "in", width = 6, height = 6)
ggsave("report/catch22-low-dim.png", p, units = "in", width = 6, height = 6)
ggsave("output/catch22-low-dim-tsne.png", p1, units = "in", width = 6, height = 6)
ggsave("report/catch22-low-dim-tsne.png", p1, units = "in", width = 6, height = 6)
