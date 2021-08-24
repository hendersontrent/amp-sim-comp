#----------------------------------------
# This script sets out to produce a low
# dimensional projection visualisation
# of the time series x feature data
# matrix
#
# NOTE: This script requires setup.R to
# have been run first
#----------------------------------------

#----------------------------------------
# Author: Trent Henderson, 24 August 2021
#----------------------------------------

# Load feature matrix

load("data/features/dataMatrix.Rda")

#------------- Produce graphics ------------

# PCA

theft::plot_low_dimension(dataMatrix,
                          is_normalised = FALSE,
                          id_var = "id",
                          group_var = "group",
                          method = "z-score",
                          low_dim_method = "PCA",
                          plot = TRUE,
                          show_covariance = TRUE)

# t-SNE

theft::plot_low_dimension(dataMatrix,
                          is_normalised = FALSE,
                          id_var = "id",
                          group_var = "group",
                          method = "z-score",
                          low_dim_method = "t-SNE",
                          perplexity = 30,
                          plot = TRUE,
                          show_covariance = FALSE)
