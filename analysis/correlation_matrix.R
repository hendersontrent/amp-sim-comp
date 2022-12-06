#----------------------------------------
# This script sets out to produce
# correlation matrix plots between plugins
#
# NOTE: This script requires setup.R and
# analysis/catch22.R to have been run
# first
#----------------------------------------

#----------------------------------------
# Author: Trent Henderson, 27 August 2021
#----------------------------------------

# Load data and feature matrix

load("data/raw-signals-numeric/amplifiers.Rda")
load("data/features/feat_mat.Rda")

#-------------------- Pairwise plots ------------------

# Draw time series corr plot

p <- plot_ts_correlations2(amplifiers,
                           id_var = "id",
                           time_var = "timepoint",
                           values_var = "amplitude",
                           cor_method = "pearson",
                           clust_method = "average",
                           interactive = FALSE)

print(p)

# Draw feature vector corr plot

p1 <- plot_vector_corrs(data = feat_mat, clust_method = "average", cor_method = "pearson")
print(p1)

#-------------------- Time series x Feature plot ------------------

p2 <- plot_all_features2(feat_mat,
                        is_normalised = FALSE,
                        id_var = "id",
                        method = "z-score",
                        clust_method = "average",
                        interactive = FALSE)

print(p2)

#-------------------- Save plots ------------------

ggsave("output/correlation-matrix.png", p, units = "in", height = 6, width = 6)
ggsave("report/correlation-matrix.png", p, units = "in", height = 6, width = 6)
ggsave("output/correlation-matrix-feature.png", p1, units = "in", height = 6, width = 6)
ggsave("report/correlation-matrix-feature.png", p1, units = "in", height = 6, width = 6)
ggsave("output/timeseries-by-feature-matrix.png", p2, units = "in", height = 6, width = 6)
ggsave("report/timeseries-by-feature-matrix.png", p2, units = "in", height = 6, width = 6)
