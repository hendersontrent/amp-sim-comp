#-----------------------------------------
# This script sets out to calculate time
# series features
#-----------------------------------------

#-----------------------------------------
# Author: Trent Henderson, 16 January 2026
#-----------------------------------------

# Run function

init_theft("fsc1stdiff")

features <- get_features(paths = "data/raw-signals", feature_set = c("catch22", "tsfel", "quantiles"),
                         catch24 = FALSE, z_score = TRUE, n_jobs = 9,
                         seed = 123, warn = FALSE)

# Save output

save(features, file = "data/features/features.Rda")
