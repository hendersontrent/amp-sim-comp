#----------------------------------------
# This script sets out to calculate time
# series features
#
# NOTE: This script requires setup.R to
# have been run first
#----------------------------------------

#----------------------------------------
# Author: Trent Henderson, 25 August 2021
#----------------------------------------

# Load data

load("data/raw-signals-numeric/amplifiers.Rda")

# Compute features

feat_mat <- calculate_features(data = amplifiers,
                               id_var = "id",
                               time_var = "timepoint",
                               values_var = "amplitude",
                               group_var = "group",
                               feature_set = "catch22",
                               seed = 123)

# Save output

save(feat_mat, file = "data/features/feat_mat.Rda")
