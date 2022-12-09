#-----------------------------------------
# This script sets out to produce an
# exploratory cluster analysis of the
# amplifiers based on their feature values
#
# NOTE: This script requires setup.R and
# analysis/catch22.R to have been run
# first
#-----------------------------------------

#-----------------------------------------
# Author: Trent Henderson, 7 December 2022
#-----------------------------------------

# Load feature matrix

load("data/features/feat_mat.Rda")

# Make dataframe into wide numerical matrix

wide_data <- feat_mat %>%
  dplyr::select(c(id, names, values)) %>%
  pivot_wider(id_cols = "id", names_from = "names", values_from = "values") %>%
  column_to_rownames(var = "id")

# Convert to matrix and scale values for numerical stability

wide_data <- as.matrix(wide_data)
wide_data <- scale(wide_data, center = TRUE, scale = TRUE)

#------------- Fit Gaussian mixture models --------------

# Fit GMMs over the range of 1 <= k <= 9 as we are unsure what the "right" k is
# NOTE: `mclust` automatically does this for us!

gmm <- Mclust(wide_data)

#------------- Analyse best model --------------

# Print summary

summary(gmm)

# Basic BIC plot

pdf(file = "report/gmm-bic.pdf")
plot(gmm, what = 'BIC', legendArgs = list(x = "bottomright", ncol = 5))
dev.off()

# Find which amps went into each cluster

clusters <- data.frame(cluster = gmm$classification) %>%
  rownames_to_column(var = "id") %>%
  inner_join(metadata, by = c("id" = "id")) %>%
  dplyr::select(-c(brand)) %>%
  arrange(cluster) %>%
  rename(`Amplifier Name` = id,
         Plugin = plugin,
         Cluster = cluster,
         `Gain Structure` = amp_type)

print(xtable::xtable(clusters), include.rownames = FALSE) # For LaTeX report
