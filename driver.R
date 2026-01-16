#-----------------------------------------
# This script runs the entire project in
# order
#-----------------------------------------

#-----------------------------------------
# Author: Trent Henderson, 16 January 2026
#-----------------------------------------

source("setup.R")

# Run analysis

source("analysis/compute-features.R") # Only run once!
source("analysis/analyse-features.R")
