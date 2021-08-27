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
  mutate(amplifier = gsub("_.*", "\\1", id))

#------------- Produce graphics ------------

#------
# t-SNE
#------

source("R/plot_low_dimension2.R") # As original {theft function only has 8 colours and we want slight different aesthetics}

p <- plot_low_dimension2(featMat_catch22_clean,
                         is_normalised = FALSE,
                         id_var = "id",
                         group_var = "amplifier",
                         low_dim_method = "PCA",
                         method = "z-score",
                         plot = TRUE,
                         show_covariance = FALSE) +
  labs(title = "Low dimensional projection of amplifier head time-series features using PCA",
       subtitle = str_wrap("Each point is the amplitude time series of a 20Hz-20kHz sine sweep passed through each amplifier head with all settings at noon and all effects/cabs/additional EQ turned off. A set of 22 statistical features was then calculated on the time x amplitude vector for each head and passed into a PCA for projection onto a 2-D plot. STL Tonality is Will Putney plugin only.", width = 120),
       caption = "Analysis: Trent Henderson. Source code: https://github.com/hendersontrent/amp-sim-comp")

print(p)

# Save plot

ggsave("output/catch22-low-dim.png", p)
