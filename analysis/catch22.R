#----------------------------------------
# This script sets out to see what catch22
# can do on the data
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

featMat_catch22 <- calculate_features(data = amplifiers,
                              id_var = "id",
                              time_var = "timepoint",
                              values_var = "amplitude",
                              group_var = "group",
                              feature_set = "catch22")

# Save output

save(featMat_catch22, file = "data/features/featMat_catch22.Rda")
