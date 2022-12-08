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

#------------- Produce graphics ------------

# PCA

p <- plot_low_dimension2(feat_mat,
                         is_normalised = FALSE,
                         id_var = "id",
                         group_var = "plugin",
                         low_dim_method = "PCA",
                         method = "z-score",
                         plot = TRUE,
                         show_covariance = FALSE,
                         seed = 123)

print(p)

# t-SNE

p1 <- plot_low_dimension2(feat_mat,
                          is_normalised = FALSE,
                          id_var = "id",
                          group_var = "plugin",
                          low_dim_method = "t-SNE",
                          method = "z-score",
                          perplexity = 5,
                          plot = TRUE,
                          show_covariance = FALSE,
                          seed = 123)

print(p1)

# Save plots

ggsave("output/catch22-low-dim.png", p, units = "in", width = 9, height = 9)
ggsave("report/catch22-low-dim.pdf", p, units = "in", width = 9, height = 9)
ggsave("output/catch22-low-dim-tsne.png", p1, units = "in", width = 9, height = 9)
ggsave("report/catch22-low-dim-tsne.pdf", p1, units = "in", width = 9, height = 9)
